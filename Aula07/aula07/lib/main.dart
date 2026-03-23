import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: Telainicial()),
  );
}

//------------------TELA INICIAL------------------//

class Telainicial extends StatelessWidget {
  const Telainicial({super.key});

  @override
  // Correção 1: Adicionado o nome da variável 'context'
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tela inicial")),
      backgroundColor: Colors.blue,
      body: Center(
        child: ElevatedButton(
          child: const Text("Ir para segunda tela"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SegundaTela()),
            );
          },
        ),
      ),
    );
  }
}

//------------------SEGUNDA TELA------------------//

// Correção 2: O nome da classe foi alterado para SegundaTela
class SegundaTela extends StatelessWidget {
  const SegundaTela({super.key});

  @override
  // Correção 1: Adicionado o nome da variável 'context'
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Correção 3: Removido os dois-pontos após a palavra Text
        title: const Text("Segunda tela"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ElevatedButton(
          // Correção 4: 'text' alterado para 'Text' com 'T' maiúsculo
          // Correção 5: Adicionada a vírgula no final da linha
          child: const Text("voltar"),
          onPressed: () {
            // Correção 6: Adicionado ponto e vírgula no final
            Navigator.pop(context);
          },
        ),
      ),
      // Correção 7: Fechamento do return Scaffold ajustado de '),` para `);`
    );
  }
}
