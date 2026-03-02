import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // ← Todos os estados devem ficar aqui em cima
  final List<String> todoList = [];
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose(); // evita vazamento de memória
    super.dispose();
  }

  void adicionarTarefa() {
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        todoList.add(controller.text.trim());
      });
      controller.clear();
    }
  }

  void removerTarefa(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo List")),
      body: Column(
        children: [
          // Lista de tarefas (ocupa o espaço restante)
          Expanded(
            child: todoList.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma tarefa ainda!\nDigite abaixo e clique em Adicionar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(todoList[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removerTarefa(index),
                        ),
                      );
                    },
                  ),
          ),

          // Campo de texto + botão (sempre visível embaixo)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma nova tarefa...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) =>
                        adicionarTarefa(), // Enter também adiciona
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: adicionarTarefa,
                  child: const Text("Adicionar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
