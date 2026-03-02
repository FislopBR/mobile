import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: paginacontador()));
}

class paginacontador extends StatefulWidget {
  @override
  _paginacontadorState createState() => _paginacontadorState();
}

class _paginacontadorState extends State<paginacontador> {
  int contador = 0;

  void increment() {
    setState(() {
      contador++;
    });
  }

  void decrement() {
    setState(() {
      contador--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('meu app interativo')),
      body: Center(
        child: Text("cliques: $contador", style: TextStyle(fontSize: 30)),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(onPressed: decrement, child: Icon(Icons.remove)),
          SizedBox(width: 16),
          FloatingActionButton(onPressed: increment, child: Icon(Icons.add)),
        ],
      ),
    );
  }
}
