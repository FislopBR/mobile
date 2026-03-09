import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HumorApp(),
  ));
}

class HumorApp extends StatefulWidget {
  const HumorApp({super.key});

  @override
  _HumorAppState createState() => _HumorAppState();
}

class _HumorAppState extends State<HumorApp> {
  // Lista de estados para facilitar a alternância
  int indiceAtual = 0;

  final List<Map<String, dynamic>> estados = [
    {
      'nome': 'Neutro',
      'cor': Colors.grey[300],
      'icone': Icons.sentiment_neutral,
      'corIcone': Colors.blueGrey
    },
    {
      'nome': 'Feliz',
      'cor': Colors.yellow,
      'icone': Icons.sentiment_very_satisfied,
      'corIcone': Colors.orange[800]
    },
    {
      'nome': 'Bravo',
      'cor': Colors.red,
      'icone': Icons.sentiment_very_dissatisfied,
      'corIcone': Colors.white
    },
  ];

  void mudarHumor() {
    setState(() {
      // O operador % (módulo) faz com que o índice volte a 0 após o 2
      indiceAtual = (indiceAtual + 1) % estados.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final estado = estados[indiceAtual];

    return Scaffold(
      backgroundColor: estado['cor'],
      appBar: AppBar(
        title: const Text("Mood Tracker"),
        centerTitle: true,
        backgroundColor: Colors.white24,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              estado['icone'],
              size: 120,
              color: estado['corIcone'],
            ),
            const SizedBox(height: 10),
            Text(
              estado['nome'],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      // Botão fixado na base (bottomNavigationBar)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: mudarHumor,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            "MUDAR HUMOR",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}