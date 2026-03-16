import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: JogoApp()));
}

class JogoApp extends StatefulWidget {
  @override
  _JogoAppState createState() => _JogoAppState();
}

class _JogoAppState extends State<JogoApp> {
  // Variáveis do Jogo
  IconData iconeComputador = Icons.help;
  String resultado = "Escolha uma opção";
  int pontosJogador = 0;
  int pontosComputador = 0;
  List opcoes = ["pedra", "papel", "tesoura"];

  // Função principal do jogo
  void jogar(String escolhaUsuario) {
    var numero = Random().nextInt(3);
    var escolhaComputador = opcoes[numero];

    setState(() {
      // 1. Mostrar Escolha do Computador
      if (escolhaComputador == "pedra") {
        iconeComputador = Icons.landscape;
      } else if (escolhaComputador == "papel") {
        iconeComputador = Icons.pan_tool;
      } else if (escolhaComputador == "tesoura") {
        iconeComputador = Icons.content_cut;
      }

      // 2. Lógica de quem venceu a rodada
      if (escolhaUsuario == escolhaComputador) {
        resultado = "Empate";
      } else if ((escolhaUsuario == "pedra" &&
              escolhaComputador == "tesoura") ||
          (escolhaUsuario == "papel" && escolhaComputador == "pedra") ||
          (escolhaUsuario == "tesoura" && escolhaComputador == "papel")) {
        pontosJogador++;
        resultado = "Você venceu!";
      } else {
        pontosComputador++;
        resultado = "Computador venceu!";
      }

      // 3. Regra do Campeonato (Melhor de 5)
      if (pontosJogador == 5) {
        resultado = "Você ganhou o campeonato! 🏆";
        pontosJogador = 0;
        pontosComputador = 0;
      } else if (pontosComputador == 5) {
        resultado = "O PC ganhou o campeonato! 🤖";
        pontosJogador = 0;
        pontosComputador = 0;
      }
    });
  }

  // Função para zerar tudo manualmente
  void resetarPlacar() {
    setState(() {
      pontosJogador = 0;
      pontosComputador = 0;
      resultado = "Escolha uma opção";
      iconeComputador = Icons.help;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedra Papel Tesoura"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Computador",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Icon(iconeComputador, size: 100, color: Colors.blueGrey),

            SizedBox(height: 30),

            Text(
              resultado,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            Text(
              "Você: $pontosJogador | PC: $pontosComputador",
              style: TextStyle(fontSize: 22),
            ),

            SizedBox(height: 40),

            // Botões de escolha do jogador
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.landscape),
                  iconSize: 60,
                  color: Colors.brown,
                  onPressed: () => jogar("pedra"),
                ),
                IconButton(
                  icon: Icon(Icons.pan_tool),
                  iconSize: 60,
                  color: Colors.amber,
                  onPressed: () => jogar("papel"),
                ),
                IconButton(
                  icon: Icon(Icons.content_cut),
                  iconSize: 60,
                  color: Colors.red,
                  onPressed: () => jogar("tesoura"),
                ),
              ],
            ),

            SizedBox(height: 50),

            // Botão de Reset
            ElevatedButton.icon(
              onPressed: resetarPlacar,
              icon: Icon(Icons.refresh),
              label: Text("Resetar Placar"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
