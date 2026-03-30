import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: SalvarTexto()),
  );
}

class SalvarTexto extends StatefulWidget {
  const SalvarTexto({super.key});

  @override
  _SalvarTextoState createState() => _SalvarTextoState();
}

class _SalvarTextoState extends State<SalvarTexto> {
  // Controller para capturar o texto do campo de entrada
  final TextEditingController _controller = TextEditingController();
  // Variável para exibir o texto recuperado do banco local
  String _textoSalvo = "";

  // Função para salvar o texto no SharedPreferences
  void _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    // Salva o valor atual do controller na chave "Text"
    await prefs.setString("Text", _controller.text);

    setState(() {
      _textoSalvo = _controller.text;
    });

    // Limpa o campo após salvar (opcional, mas boa prática)
    _controller.clear();
  }

  // Função para carregar o texto ao iniciar o app
  void _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Tenta buscar a string; se for nula, define como vazio ""
      _textoSalvo = prefs.getString("Text") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _controller.dispose(); // Importante para liberar memória
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Salvar Dados"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Corrigido de EdgeInsetsGeometry
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Digite algo para salvar",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarDados,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text("Salvar Texto"),
            ),
            const SizedBox(height: 30),
            const Text(
              "Texto Recuperado:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              _textoSalvo.isEmpty ? "Nada salvo ainda." : _textoSalvo,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
