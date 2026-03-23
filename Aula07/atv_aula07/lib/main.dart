import 'package:flutter/material.dart';

void main() {
  runApp(const MeuAppContatos());
}

class MeuAppContatos extends StatelessWidget {
  const MeuAppContatos({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Contatos',
      home: TelaListaContatos(),
    );
  }
}

// ------------------ MODELO DE DADOS ------------------ //
// Classe criada para facilitar o gerenciamento de dados de cada contato
class Contato {
  final String nome;
  final String telefone;
  final Color cor;
  final IconData icone;

  Contato({
    required this.nome,
    required this.telefone,
    required this.cor,
    required this.icone,
  });
}

// ------------------ TELA 1: LISTA DE CONTATOS ------------------ //

class TelaListaContatos extends StatelessWidget {
  const TelaListaContatos({super.key});

  @override
  Widget build(BuildContext context) {
    // Requisito: Lista fixa com pelo menos 3 contatos
    // Desafio Extra: Adicionado cor diferente e ícone para cada contato
    final List<Contato> contatos = [
      Contato(
        nome: "Ayrton Senna",
        telefone: "(11) 98765-4321",
        cor: Colors.pink,
        icone: Icons.person,
      ),
      Contato(
        nome: "Carlos Eduardo",
        telefone: "(21) 91234-5678",
        cor: Colors.blue,
        icone: Icons.work,
      ),
      Contato(
        nome: "Leandro & Leonardo",
        telefone: "(31) 99999-1111",
        cor: Colors.green,
        icone: Icons.favorite,
      ),
      Contato(
        nome: "Takumi Fujiwara",
        telefone: "(11) 9AE86-TRNO",
        cor: Colors.orange,
        icone: Icons.directions_car,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Contatos"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          final contato = contatos[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // Requisito: Cada item deve ser clicável
            child: ListTile(
              // Desafio Extra: Adicionar ícone no contato
              leading: CircleAvatar(
                backgroundColor: contato.cor,
                child: Icon(contato.icone, color: Colors.white),
              ),
              title: Text(
                contato.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(contato.telefone),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Requisito: Passagem de dados para a próxima tela
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalheContato(
                      nome: contato.nome,
                      telefone: contato.telefone,
                      cor: contato.cor,
                      icone: contato.icone,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ------------------ TELA 2: DETALHES ------------------ //

class DetalheContato extends StatelessWidget {
  // Dados recebidos da tela anterior
  final String nome;
  final String telefone;
  final Color cor;
  final IconData icone;

  const DetalheContato({
    super.key,
    required this.nome,
    required this.telefone,
    required this.cor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Contato"),
        backgroundColor: cor, // Cor do AppBar dinâmica de acordo com o contato
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: cor.withOpacity(0.2),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: cor,
                  child: Icon(icone, size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Requisito: Mostrar Nome
              Text(
                nome,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Requisito: Mostrar Telefone
              Text(
                telefone,
                style: const TextStyle(fontSize: 22, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Desafio Extra: Mostrar mensagem "Ligando para..."
              ElevatedButton.icon(
                onPressed: () {
                  // Mostra um alerta (SnackBar) na parte inferior da tela
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Ligando para $nome...",
                        style: const TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.call, color: Colors.white),
                label: const Text(
                  "Ligar",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Requisito: Botão explícito para voltar (além da seta no AppBar)
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Voltar", style: TextStyle(fontSize: 18)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
