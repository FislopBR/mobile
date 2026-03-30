import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListaComprasApp(),
    ),
  );
}

class ListaComprasApp extends StatefulWidget {
  const ListaComprasApp({super.key});

  @override
  _ListaComprasAppState createState() => _ListaComprasAppState();
}

class _ListaComprasAppState extends State<ListaComprasApp> {
  // Controller para o campo de texto
  final TextEditingController _controller = TextEditingController();

  // Estrutura sugerida no PDF (Estado Duplo)
  List<String> _itens = [];
  List<bool> _comprado = [];

  @override
  void initState() {
    super.initState();
    _carregarDados(); // Carrega os dados ao iniciar
  }

  // PASSO 4: Carregar dados
  void _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _itens = prefs.getStringList("itens") ?? [];

      // Recupera a lista de strings (true/false) e converte de volta para bool
      List<String> listaBool = prefs.getStringList("comprado") ?? [];
      _comprado = listaBool.map((e) => e == "true").toList();

      // Tratamento de segurança caso as listas fiquem com tamanhos diferentes por algum erro
      if (_itens.length != _comprado.length) {
        _comprado = List<bool>.filled(_itens.length, false);
      }
    });
  }

  // PASSO 3: Salvar dados
  void _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList("itens", _itens);

    // Converte a lista de booleanos para lista de strings para poder salvar
    List<String> listaBoolStrings = _comprado.map((e) => e.toString()).toList();
    await prefs.setStringList("comprado", listaBoolStrings);
  }

  // PASSO 1: Adicionar item
  void _adicionarItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _itens.add(_controller.text);
        _comprado.add(false); // Item novo começa como NÃO comprado
        _controller.clear();
      });
      _salvarDados(); // Salva sempre que houver alteração
    }
  }

  // PASSO 2: Alternar comprado
  void _alternarComprado(int index) {
    setState(() {
      _comprado[index] = !_comprado[index];
    });
    _salvarDados();
  }

  // Função para remover item individual (X)
  void _removerItem(int index) {
    setState(() {
      _itens.removeAt(index);
      _comprado.removeAt(index); // Importante remover das duas listas!
    });
    _salvarDados();
  }

  // DESAFIO EXTRA: Botão "Limpar lista"
  void _limparLista() {
    setState(() {
      _itens.clear();
      _comprado.clear();
    });
    _salvarDados();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // DESAFIO EXTRA: Contador de itens (calculando itens comprados)
    int compradosCount = _comprado.where((c) => c == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Compras"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto e botão de adicionar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Novo item",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) =>
                        _adicionarItem(), // Permite dar 'Enter' no teclado
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: _adicionarItem,
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // DESAFIO EXTRA: Contador na tela
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ${_itens.length}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Comprados: $compradosCount",
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(),

            // Lista de Itens
            Expanded(
              child: _itens.isEmpty
                  ? const Center(
                      child: Text(
                        "Sua lista está vazia.",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _itens.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            // Checkbox para alternar o status
                            leading: Checkbox(
                              value: _comprado[index],
                              onChanged: (bool? value) {
                                _alternarComprado(index);
                              },
                              activeColor: Colors.teal,
                            ),
                            // Texto do item com DESAFIO VISUAL E EXTRA (Cor e Risco)
                            title: Text(
                              _itens[index],
                              style: TextStyle(
                                fontSize: 18,
                                color: _comprado[index]
                                    ? Colors.grey
                                    : Colors.black,
                                decoration: _comprado[index]
                                    ? TextDecoration
                                          .lineThrough // Riscado se comprado
                                    : TextDecoration
                                          .none, // Normal se não comprado
                              ),
                            ),
                            // Botão de remover (X)
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removerItem(index),
                            ),
                            // Permite clicar na linha toda para marcar como comprado
                            onTap: () => _alternarComprado(index),
                          ),
                        );
                      },
                    ),
            ),

            // DESAFIO EXTRA: Botão Limpar Tudo
            if (_itens.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _limparLista,
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    label: const Text(
                      "Limpar Lista Completa",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
