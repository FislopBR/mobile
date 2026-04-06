import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: AppBanco()));
}

class AppBanco extends StatefulWidget {
  @override
  AppBancoState createState() => AppBancoState();
}

class AppBancoState extends State<AppBanco> {
  TextEditingController controller = TextEditingController();
  List<Map<String, dynamic>> tarefas = [];

  Future<Database> criarBanco() async {
    final caminho = await getDatabasesPath();
    final Path = join(caminho, banco.db);

    return openDatabase(
      Path,
      onCreate: (db.version){
      return db.excute(
        "CREATE TABLE tarefas(id INTEGER PRIMARY KEY AUTOINCREMENTE, nome TEXT)"
        );
      },
      version: 1,
    ); 
  }
  Future<void> inseririTarefa(String nome) async {
    final db = await criarBanco();

    await db.insert("tarefas", {"nome": nome});

    carregarTarefas();
  }
  Future<void> carregarTarefas() async {
    final db = await
  }
  Future<void> deletarTarefa(int id) async {
    final db = await criarBanco();

    await db.delete("tarefas", wehere: "id = ?", wehereArgs: [id]);

    carregarTarefas();
  }

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    AppBar: AppBar(title: Text("minhas tarefas")),
    body: column(
      children: [
        Padding(
          padding: EdgeInsert.all(10),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "Nova tarefa",
              border: OutlineInputBorder(),
            ),
          )
        )
        ElevatedButton(
          onPressed: () {
            if(controller.text.isNotEmpty) {
              inseririTarefa(controller.text);
              controller.clear();
            }
          },
          child: Text("adicionar"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tarefas[index]["nome"]),
                  trailing: IconButton(
                    icon: Icon(Icon.delete)
                    onPressed: () {
                      deletarTarefa(tarefas[index]["id"]);
                    },
                    ),
                )
              },
              )
              )
      ]
    )
  }
}
