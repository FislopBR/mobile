import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
  Database? _database;

  Future<Database> criarBanco() async {
    if (_database != null) return _database!;

    final caminho = await getDatabasesPath();
    final path = join(caminho, 'banco.db');
    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tarefas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)",
        );
      },
      version: 1,
    );
    return _database!;
  }

  Future<void> inserirTarefa(String nome) async {
    final db = await criarBanco();
    await db.insert("tarefas", {"nome": nome});
    carregarTarefas();
  }

  Future<void> carregarTarefas() async {
    final db = await criarBanco();
    final List<Map<String, dynamic>> lista = await db.query("tarefas");
    setState(() {
      tarefas = lista;
    });
  }

  Future<void> deletarTarefa(int id) async {
    final db = await criarBanco();
    await db.delete("tarefas", where: "id = ?", whereArgs: [id]);
    carregarTarefas();
  }

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Tarefas")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Nova tarefa",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                inserirTarefa(controller.text);
                controller.clear();
              }
            },
            child: const Text("Adicionar"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tarefas[index]["nome"]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deletarTarefa(tarefas[index]["id"]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
