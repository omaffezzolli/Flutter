import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import 'package:diacritic/diacritic.dart';

Future<void> main() async {
  final gerador = await TermoGenerator.instance();

  final palavraGerada = gerador.palavraAleatoria;
  print('PALAVRA ALEATORIA $palavraGerada');

  var palavras = <String>[];

  for (int tentativa = 0; tentativa < 5; tentativa++) {
    final palavraInput = stdin.readLineSync();
    var palavraFormatada = removeDiacritics(palavraGerada);

    if (palavraInput?.length != 5) {
      print("Não contem 5 letras");
      return;
    }

    var palavra = '';
    palavraFormatada = palavraFormatada.toUpperCase();

    for (int index = 0; index < 5; index++) {
      // palavraInput = VIOLA
      // palavraGerada = VELAR
      // caracter = A
      // caracterGerado = L

      final caracter = palavraInput![index].toUpperCase();
      final caracterGerado = palavraFormatada[index].toUpperCase();

      if (caracterGerado == caracter) {
        palavra += ColorPrint.green(caracter);
        continue;
      }

      if (palavraFormatada.contains(caracter)) {
        palavra += ColorPrint.yellow(caracter);
        continue;
      }

      palavra += ColorPrint.red(caracter);
    }

    for (int index = 0; index < 5; index++) {
      // palavraInput = VIOLA
      // palavraGerada = VELAR
      // caracter = A
      // caracterGerado = L

      final caracter = palavraInput![index].toUpperCase();
      final caracterGerado = palavraFormatada[index].toUpperCase();

      if (caracterGerado == caracter) {
        palavra += ColorPrint.green(caracter);
        continue;
      }

      if (palavraFormatada.contains(caracter)) {
        palavra += ColorPrint.yellow(caracter);
        continue;
      }

      palavra += ColorPrint.red(caracter);
    }
    palavras.add(palavra);

    for (final item in palavras) {
      print(item);
    }
    if (palavraGerada == palavraInput) {
      break;
    }
  }
}

class ColorPrint {
  static String black(String text) => '\x1B[30m$text\x1B[0m ';

  static String red(String text) => '\x1B[31m$text\x1B[0m ';

  static String green(String text) => '\x1B[32m$text\x1B[0m ';

  static String yellow(String text) => '\x1B[33m$text\x1B[0m ';

  static String blue(String text) => '\x1B[34m$text\x1B[0m ';

  static String magenta(String text) => '\x1B[35m$text\x1B[0m ';

  static String cyan(String text) => '\x1B[36m$text\x1B[0m ';

  static String white(String text) => '\x1B[37m$text\x1B[0m ';
}

class TermoGenerator {
  TermoGenerator._();

  static TermoGenerator? _instance;
  final _termos = <String>[];
  final _random = Random();

  static Future<TermoGenerator> instance() async {
    if (_instance == null) {
      TermoGenerator._instance = TermoGenerator._();
      await _instance!._inicializar();
    }
    return _instance!;
  }

  Future<void> _inicializar() async {
    final url =
        "https://raw.githubusercontent.com/LinceTech/dart-workshops/main/dart-desafio-3/de_1/termos.json";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonList = convert.jsonDecode(response.body);
        for (final termo in jsonList['termos']) {
          _termos.add(termo);
        }
      } else {
        throw Exception(
          'Erro na requisicao: [${response.statusCode}] ${response.body}',
        );
      }
    } catch (error, stack) {
      print('Error: $error\n$stack');
    }
  }

  String get palavraAleatoria {
    return _termos[_random.nextInt(_termos.length)];
  }
}
