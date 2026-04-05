import 'package:flutter/material.dart';
import 'package:rpg_flutter/entities/heroi.dart';
import 'package:rpg_flutter/entities/anao.dart';
import 'package:rpg_flutter/entities/humano.dart';
import 'package:rpg_flutter/entities/elfo.dart';
import 'package:rpg_flutter/entities/orc.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';
import 'package:rpg_flutter/entities/guerreiro.dart';
import 'package:rpg_flutter/entities/mago.dart';
import 'package:rpg_flutter/presenter/personagens/cadastro_personagem_view.dart';

class PersonagensView extends StatelessWidget {
  final List<Heroi> personagens;
  final Function(Heroi) onPersonagemAdicionado;

  const PersonagensView({
    super.key,
    required this.personagens,
    required this.onPersonagemAdicionado,
  });

  String getImagem(Heroi heroi) {
    final raca = heroi.raca;
    final arq = heroi.arquetipo;
    String racaStr;
    String arquetipoStr;
    if (raca is Humano) racaStr = 'human';
    else if (raca is Orc) racaStr = 'orc';
    else if (raca is Elfo) racaStr = 'elf';
    else racaStr = 'dwarf';
    if (arq is Guerreiro) arquetipoStr = 'warrior';
    else if (arq is Mago) arquetipoStr = 'mage';
    else arquetipoStr = 'archer';
    return 'assets/personagens/$racaStr/${racaStr}_$arquetipoStr.png';
  }

  String getRacaNome(Raca raca) {
    if (raca is Humano) return 'Humano';
    if (raca is Orc) return 'Orc';
    if (raca is Elfo) return 'Elfo';
    return 'Anão';
  }

  String getArquetipoNome(Arquetipo arq) {
    if (arq is Guerreiro) return 'Guerreiro';
    if (arq is Mago) return 'Mago';
    return 'Arqueiro';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: personagens.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add, size: 64, color: Colors.amber),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum herói criado ainda.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque em + para criar seu primeiro herói!',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: personagens.length,
              itemBuilder: (context, index) {
                final heroi = personagens[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(getImagem(heroi), width: 60, height: 60, fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(heroi.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                              const SizedBox(height: 4),
                              Text('${getRacaNome(heroi.raca)} • ${getArquetipoNome(heroi.arquetipo)}', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _statChip(Icons.favorite, '${heroi.vidaMaxima}', Colors.redAccent),
                                  const SizedBox(width: 8),
                                  _statChip(Icons.shield, '${heroi.escudo}', Colors.blueAccent),
                                  const SizedBox(width: 8),
                                  _statChip(Icons.bolt, '${heroi.ataque}', Colors.orangeAccent),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          final heroi = await Navigator.push<Heroi>(
            context,
            MaterialPageRoute(builder: (context) => const CadastroPersonagemView()),
          );
          if (heroi != null) onPersonagemAdicionado(heroi);
        },
      ),
    );
  }

  Widget _statChip(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(value, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
