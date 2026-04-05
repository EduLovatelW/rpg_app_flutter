import 'package:flutter/material.dart';
import 'package:rpg_flutter/entities/dado.dart';
import 'package:rpg_flutter/entities/duelo.dart';
import 'package:rpg_flutter/entities/heroi.dart';
import 'package:rpg_flutter/entities/anao.dart';
import 'package:rpg_flutter/entities/humano.dart';
import 'package:rpg_flutter/entities/elfo.dart';
import 'package:rpg_flutter/entities/orc.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';
import 'package:rpg_flutter/entities/guerreiro.dart';
import 'package:rpg_flutter/entities/mago.dart';
import 'package:rpg_flutter/presenter/historico/historico_view.dart';

class ArenaView extends StatefulWidget {
  final List<Heroi> personagens;
  final Function(BatalhaRegistro) onBatalhaRealizada;
  const ArenaView({super.key, required this.personagens, required this.onBatalhaRealizada});

  @override
  State<ArenaView> createState() => _ArenaViewState();
}

class _ArenaViewState extends State<ArenaView> {
  Heroi? _jogador1;
  Heroi? _jogador2;
  String? _resultado;
  Heroi? _vencedor;

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

  void _batalhar() {
    if (_jogador1 == null || _jogador2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione dois heróis para batalhar!')),
      );
      return;
    }
    if (_jogador1 == _jogador2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione heróis diferentes!')),
      );
      return;
    }
    final copia1 = _jogador1!.copiar();
    final copia2 = _jogador2!.copiar();
    final dado = Dado(lados: 6);
    final duelo = Duelo(dado: dado, jogador1: copia1, jogador2: copia2);
    final vencedor = duelo.iniciar();
    final nomeVencedor = vencedor?.nome ?? 'Empate';
    setState(() {
      _vencedor = vencedor?.nome == _jogador1!.nome ? _jogador1 : _jogador2;
      _resultado = vencedor != null ? '🏆 ${vencedor.nome} venceu!' : 'Empate!';
    });
    widget.onBatalhaRealizada(BatalhaRegistro(
      jogador1: _jogador1!.nome,
      jogador2: _jogador2!.nome,
      vencedor: nomeVencedor,
      data: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.personagens.length < 2) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            const Text('Arena', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
            const SizedBox(height: 8),
            Text('Crie pelo menos 2 heróis\nna aba Personagens para batalhar!',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('⚔️ Arena', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _seletorPersonagem(1)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text('VS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              ),
              Expanded(child: _seletorPersonagem(2)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.sports_kabaddi),
              label: const Text('BATALHAR!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: _batalhar,
            ),
          ),
          if (_resultado != null) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: Column(
                children: [
                  Text(_resultado!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber), textAlign: TextAlign.center),
                  if (_vencedor != null) ...[
                    const SizedBox(height: 12),
                    Image.asset(getImagem(_vencedor!), height: 100),
                    const SizedBox(height: 8),
                    Text(getArquetipoNome(_vencedor!.arquetipo), style: TextStyle(color: Colors.grey[400])),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _seletorPersonagem(int jogador) {
    final selecionado = jogador == 1 ? _jogador1 : _jogador2;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selecionado != null ? Colors.amber : Colors.grey.shade700),
      ),
      child: Column(
        children: [
          Text('Jogador $jogador', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(height: 8),
          if (selecionado != null) ...[
            Image.asset(getImagem(selecionado), height: 80),
            Text(selecionado.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(getRacaNome(selecionado.raca), style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            Text(getArquetipoNome(selecionado.arquetipo), style: TextStyle(fontSize: 12, color: Colors.amber[300])),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, size: 12, color: Colors.redAccent),
                const SizedBox(width: 2),
                Text('${selecionado.vidaMaxima}', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                const Icon(Icons.bolt, size: 12, color: Colors.orangeAccent),
                const SizedBox(width: 2),
                Text('${selecionado.ataque}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ] else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Icon(Icons.person_add, color: Colors.grey, size: 40),
            ),
          DropdownButton<Heroi>(
            hint: const Text('Escolher', style: TextStyle(fontSize: 12)),
            value: selecionado,
            isExpanded: true,
            dropdownColor: const Color(0xFF1E1E2E),
            items: widget.personagens.map((h) => DropdownMenuItem(
              value: h,
              child: Text(h.nome),
            )).toList(),
            onChanged: (h) {
              setState(() {
                if (jogador == 1) _jogador1 = h;
                else _jogador2 = h;
                _resultado = null;
              });
            },
          ),
        ],
      ),
    );
  }
}
