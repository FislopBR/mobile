import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListadeTarefasEmItaliano(),
    ),
  );
}

class ListadeTarefasEmItaliano extends StatefulWidget {
  const ListadeTarefasEmItaliano({Key? key}) : super(key: key);

  @override
  State<ListadeTarefasEmItaliano> createState() => _ListadeTarefasEmItalianoState();
}

class _ListadeTarefasEmItalianoState extends State<ListadeTarefasEmItaliano> {
  List<Map<String, dynamic>> _dados = [];
  bool _carregando = true;
  int? _idParaEditar;

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // Configuração e Conexão com SQLite
  Future<Database> _obterBancoDeDados() async {
    final caminho = await getDatabasesPath();
    return openDatabase(
      join(caminho, 'cadastro_inteligente.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE dados(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            titulo TEXT, 
            descricao TEXT, 
            data TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Operações CRUD
  Future<void> _atualizarLista() async {
    final db = await _obterBancoDeDados();
    final data = await db.query('dados', orderBy: 'titulo ASC');

    setState(() {
      _dados = data;
      _carregando = false;
    });
  }

  Future<void> _adicionarItem() async {
    final db = await _obterBancoDeDados();
    final String dataAtual = DateTime.now().toString().split('.')[0];

    await db.insert('dados', {
      'titulo': _tituloController.text,
      'descricao': _descricaoController.text,
      'data': dataAtual,
    });

    _limparCampos();
    _atualizarLista();
  }

  Future<void> _editarItem(int id) async {
    final db = await _obterBancoDeDados();
    await db.update(
      'dados',
      {
        'titulo': _tituloController.text,
        'descricao': _descricaoController.text,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    _limparCampos();
    _atualizarLista();
  }

  Future<void> _removerItem(int id) async {
    final db = await _obterBancoDeDados();
    await db.delete('dados', where: 'id = ?', whereArgs: [id]);
    _atualizarLista();
  }

  void _prepararEdicao(Map<String, dynamic> item) {
    setState(() {
      _idParaEditar = item['id'];
      _tituloController.text = item['titulo'];
      _descricaoController.text = item['descricao'];
    });
  }

  void _limparCampos() {
    setState(() {
      _idParaEditar = null;
      _tituloController.clear();
      _descricaoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fundo suave e profissional
      appBar: AppBar(
        title: const Text(
          'Gestão de Cadastros',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Painel de Entrada de Dados (Card Moderno)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1E88E5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _idParaEditar == null ? 'Novo Registro' : 'Editar Registro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _idParaEditar == null ? Colors.blueGrey : Colors.orange[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        labelText: 'Título do Item',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descricaoController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Descrição Detalhada',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (_idParaEditar != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextButton.icon(
                                onPressed: _limparCampos,
                                icon: const Icon(Icons.close),
                                label: const Text('Cancelar'),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                              ),
                            ),
                          ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_tituloController.text.isEmpty) return;
                              if (_idParaEditar == null) {
                                _adicionarItem();
                              } else {
                                _editarItem(_idParaEditar!);
                              }
                            },
                            icon: Icon(_idParaEditar == null ? Icons.save : Icons.update),
                            label: Text(_idParaEditar == null ? 'SALVAR' : 'ATUALIZAR'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Lista de Resultados
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _dados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum cadastro encontrado',
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _dados.length,
                        itemBuilder: (ctx, index) {
                          final item = _dados[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _prepararEdicao(item),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.assignment, color: Color(0xFF1E88E5)),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['titulo'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['descricao'],
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "📅 ${item['data']}",
                                            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_note, color: Colors.orange),
                                          onPressed: () => _prepararEdicao(item),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                          onPressed: () => _removerItem(item['id']),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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