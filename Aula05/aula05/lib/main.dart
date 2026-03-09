import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InterruptorApp(),
  ));
}

class InterruptorApp extends StatefulWidget {
  const InterruptorApp({super.key});

  @override
  _InterruptorAppState createState() => _InterruptorAppState();
}

class _InterruptorAppState extends State<InterruptorApp> {
  bool estaAceso = false;

  void alternarLuz() {
    setState(() {
      estaAceso = !estaAceso;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cores dinâmicas para facilitar a leitura
    final corFundo = estaAceso ? Colors.yellow[100] : Colors.grey[900];
    final corBotao = estaAceso ? Colors.grey[900] : Colors.yellow[700];
    final corTextoBotao = estaAceso ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        title: const Text("Interruptor"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              estaAceso ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 150,
              color: estaAceso ? Colors.orange : Colors.grey,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: alternarLuz,
              style: ElevatedButton.styleFrom(
                backgroundColor: corBotao,
                foregroundColor: corTextoBotao,
              ),
              child: Text(estaAceso ? "APAGAR" : "ACENDER"),
            ),
          ],
        ),
      ),
    );
  }
}