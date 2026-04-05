import 'package:flutter/material.dart';
import 'package:rpg_flutter/entities/anao.dart';
import 'package:rpg_flutter/entities/arqueiro.dart';
import 'package:rpg_flutter/entities/elfo.dart';
import 'package:rpg_flutter/entities/guerreiro.dart';
import 'package:rpg_flutter/entities/heroi.dart';
import 'package:rpg_flutter/entities/humano.dart';
import 'package:rpg_flutter/entities/mago.dart';
import 'package:rpg_flutter/entities/orc.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';

class CadastroPersonagemView extends StatefulWidget {
  const CadastroPersonagemView({super.key});

  @override
  State<CadastroPersonagemView> createState() => _CadastroPersonagemViewState();
}

class _CadastroPersonagemViewState extends State<CadastroPersonagemView> {
  final _nomeController = TextEditingController();
  final _reinoController = TextEditingController();
  final _missaoController = TextEditingController();

  final List<Raca> _racas = [
    Humano(bonusVida: 10, bonusEscudo: 10, bonusAtaque: 10),
    Orc(bonusVida: 14, bonusEscudo: 6, bonusAtaque: 10),
    Elfo(bonusVida: 6, bonusEscudo: 8, bonusAtaque: 16),
    Anao(bonusVida: 12, bonusEscudo: 6, bonusAtaque: 12),
  ];

  final List<Arquetipo> _arquetipos = [
    Guerreiro(),
    Mago(),
    Arqueiro(),
  ];

  Raca? _racaSelecionada;
  Arquetipo? _arquetipoSelecionado;

  @override
  void dispose() {
    _nomeController.dispose();
    _reinoController.dispose();
    _missaoController.dispose();
    super.dispose();
  }

  String _getImagem() {
    String racaStr = 'dwarf';
    String arquetipoStr = 'neutral';
    if (_racaSelecionada is Humano) racaStr = 'human';
    else if (_racaSelecionada is Orc) racaStr = 'orc';
    else if (_racaSelecionada is Elfo) racaStr = 'elf';
    else if (_racaSelecionada is Anao) racaStr = 'dwarf';
    if (_arquetipoSelecionado is Guerreiro) arquetipoStr = 'warrior';
    else if (_arquetipoSelecionado is Mago) arquetipoStr = 'mage';
    else if (_arquetipoSelecionado is Arqueiro) arquetipoStr = 'archer';
    else arquetipoStr = 'neutral';
    return 'assets/personagens/$racaStr/${racaStr}_$arquetipoStr.png';
  }

  String _getRacaNome(Raca raca) {
    if (raca is Humano) return 'Humano';
    if (raca is Orc) return 'Orc';
    if (raca is Elfo) return 'Elfo';
    return 'Anão';
  }

  String _getArquetipoNome(Arquetipo arq) {
    if (arq is Guerreiro) return 'Guerreiro';
    if (arq is Mago) return 'Mago';
    return 'Arqueiro';
  }

  void _salvar() {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome do herói!')));
      return;
    }
    if (_racaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma raça!')));
      return;
    }
    if (_arquetipoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um arquétipo!')));
      return;
    }

    final heroi = Heroi(
      nome: _nomeController.text,
      vida: 100,
      velocidade: 10,
      escudo: 10,
      ataque: 10,
      raca: _racaSelecionada!,
      arquetipo: _arquetipoSelecionado!,
      reino: _reinoController.text.isEmpty ? 'Desconhecido' : _reinoController.text,
      missao: _missaoController.text.isEmpty ? 'Sobreviver' : _missaoController.text,
    );

    Navigator.pop(context, heroi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Herói')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber),
              ),
              child: Column(
                children: [
                  Image.asset(_getImagem(), height: 150),
                  const SizedBox(height: 8),
                  Text(
                    _nomeController.text.isEmpty ? 'Seu herói' : _nomeController.text,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Nome do herói',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Raca>(
              decoration: const InputDecoration(
                labelText: 'Raça',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              value: _racaSelecionada,
              items: _racas.map((raca) => DropdownMenuItem(
                value: raca,
                child: Text(_getRacaNome(raca)),
              )).toList(),
              onChanged: (raca) => setState(() => _racaSelecionada = raca),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Arquetipo>(
              decoration: const InputDecoration(
                labelText: 'Arquétipo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.auto_awesome),
              ),
              value: _arquetipoSelecionado,
              items: _arquetipos.map((arq) => DropdownMenuItem(
                value: arq,
                child: Text(_getArquetipoNome(arq)),
              )).toList(),
              onChanged: (arq) => setState(() => _arquetipoSelecionado = arq),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reinoController,
              decoration: const InputDecoration(
                labelText: 'Reino (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.castle),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _missaoController,
              decoration: const InputDecoration(
                labelText: 'Missão (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Criar Herói', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: _salvar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
