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
import 'package:rpg_flutter/presenter/personagens/detalhe_personagem_view.dart';

class PersonagensView extends StatelessWidget {
  final List<Heroi> personagens;
  final Function(Heroi) onPersonagemAdicionado;
  final Function(int) onPersonagemRemovido;

  const PersonagensView({
    super.key,
    required this.personagens,
    required this.onPersonagemAdicionado,
    required this.onPersonagemRemovido,
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
                  const Text('Nenhum herói criado ainda.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Toque em + para criar seu primeiro herói!',
                    style: TextStyle(color: Colors.grey[400])),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: personagens.length,
              itemBuilder: (context, index) {
                final heroi = personagens[index];
                return Dismissible(
                  key: Key(heroi.nome + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF1E1E2E),
                        title: const Text('Deletar herói?'),
                        content: Text('Tem certeza que quer deletar ${heroi.nome}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) => onPersonagemRemovido(index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetalhePersonagemView(heroi: heroi)),
                      ),
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(heroi.nome,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.amber),
                                        ),
                                        child: Text('Nv ${heroi.nivel}',
                                          style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text('${getRacaNome(heroi.raca)} • ${getArquetipoNome(heroi.arquetipo)}',
                                    style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: heroi.xp / heroi.xpParaProximoNivel,
                                      backgroundColor: Colors.grey.shade800,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                                      minHeight: 4,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('XP: ${heroi.xp}/${heroi.xpParaProximoNivel}',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                  const SizedBox(height: 4),
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
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
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
