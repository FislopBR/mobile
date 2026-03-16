import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TemperaturaApp(),
  ));
}

class TemperaturaApp extends StatefulWidget {
  @override
  _TemperaturaAppState createState() => _TemperaturaAppState();
}

class _TemperaturaAppState extends State<TemperaturaApp> {
  // Estado inicial da temperatura
  int temperatura = 20;

  void aumentar() {
    setState(() {
      temperatura++;
    });
  }

  void diminuir() {
    setState(() {
      temperatura--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Variáveis para a lógica visual
    Color corFundo;
    IconData icone;
    String status;

    // Lógica de Temperatura
    if (temperatura < 15) {
      corFundo = Colors.blue;
      icone = Icons.ac_unit;
      status = "Frio";
    } else if (temperatura < 30) {
      corFundo = Colors.green;
      icone = Icons.wb_sunny;
      status = "Agradável";
    } else {
      corFundo = Colors.red;
      icone = Icons.local_fire_department;
      status = "Quente";
    }

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        title: Text("Controle de Temperatura"),
        backgroundColor: Colors.black12, // Um leve tom escuro na barra para contraste
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone do clima
            Icon(
              icone,
              size: 100,
              color: Colors.white,
            ),
            
            // Texto de Status (Frio, Agradável, Quente)
            Text(
              status,
              style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 20),
            
            // Temperatura atual
            Text(
              "$temperatura °C",
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
            
            SizedBox(height: 40),
            
            // Botões de controle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: diminuir,
                  child: Text("-", style: TextStyle(fontSize: 24)),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: aumentar,
                  child: Text("+", style: TextStyle(fontSize: 24)),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}