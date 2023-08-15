import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jogo da Memoria'),
        ),
        body: Center(
          child: ChangeNotifierProvider(
            create: (context) => MemoryGame(),
            child: Consumer<MemoryGame>(
              builder: (_, provider, __) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 10,
                  ),
                  itemCount: provider.itens.length,
                  itemBuilder: (context, index) {
                    final card = provider.itens[index];
                    final isSelectedCard =
                        index == provider.indexprimeiracarta ||
                            index == provider.indexsegundacarta ||
                            provider.itensSelecionados.contains(card);

                    return GestureDetector(
                      onTap: () {
                        provider.Virada(card, index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: isSelectedCard ? Colors.amber : Colors.cyan,
                        child: isSelectedCard
                            ? provider.itensSelecionados.contains(card)
                                ? Text(card)
                                : Text(index == provider.indexprimeiracarta
                                    ? provider.primeiraCarta.toString()
                                    : provider.segundaCarta.toString())
                            : Text(index.toString()),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MemoryGame extends ChangeNotifier {
  List<String> itens = ['C', 'B', 'A', 'B', 'A', 'C'];
  List<String> itensSelecionados = [];
  int attempts = 0;

  String? primeiraCarta;
  String? segundaCarta;
  int? indexprimeiracarta;
  int? indexsegundacarta;

  void Virada(card, index) {
    if (primeiraCarta == null) {
      primeiraCarta = card;
      indexprimeiracarta = index;
    } else if (segundaCarta == null) {
      segundaCarta = card;
      indexsegundacarta = index;

      attempts++;

      if (primeiraCarta == segundaCarta) {
        itensSelecionados.add(primeiraCarta!);
      }
    }
    notifyListeners();

    if (segundaCarta != null) {
      if (segundaCarta == primeiraCarta) {
        itensSelecionados.add(segundaCarta!);
      }

      Future.delayed(const Duration(seconds: 2), () {
        primeiraCarta = null;
        segundaCarta = null;
        indexprimeiracarta = null;
        indexsegundacarta = null;
        notifyListeners();
      });
    }
  }
}
