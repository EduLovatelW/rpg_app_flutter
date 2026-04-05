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

class DetalhePersonagemView extends StatelessWidget {
  final Heroi heroi;
  const DetalhePersonagemView({super.key, required this.heroi});

  String getImagem() {
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

  String getHabilidade(Arquetipo arq) {
    return arq.habilidadeEspecial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(heroi.nome)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar grande
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: Column(
                children: [
                  Image.asset(getImagem(), height: 150),
                  const SizedBox(height: 12),
                  Text(heroi.nome, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tag(getRacaNome(heroi.raca), Colors.blueAccent),
                      const SizedBox(width: 8),
                      _tag(getArquetipoNome(heroi.arquetipo), Colors.amber),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Stats
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Atributos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
            ),
            const SizedBox(height: 10),
            _statRow(Icons.favorite, 'Vida', '${heroi.vidaMaxima}', Colors.redAccent),
            _statRow(Icons.shield, 'Escudo', '${heroi.escudo}', Colors.blueAccent),
            _statRow(Icons.bolt, 'Ataque', '${heroi.ataque}', Colors.orangeAccent),
            _statRow(Icons.speed, 'Velocidade', '${heroi.velocidade}', Colors.greenAccent),
            const SizedBox(height: 20),
            // Habilidade especial
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Habilidade Especial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade700),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(getHabilidade(heroi.arquetipo),
                      style: const TextStyle(fontSize: 14, color: Colors.white70)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Reino e missão
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Lore', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
            ),
            const SizedBox(height: 10),
            _loreRow(Icons.castle, 'Reino', heroi.reino),
            _loreRow(Icons.flag, 'Missão', heroi.missao),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _statRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _loreRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
