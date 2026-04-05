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
  String _imgHeroi = 'assets/personagens/dwarf/dwarf_neutral.png';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Herói')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(_imgHeroi, height: 180),
            const SizedBox(height: 16),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do herói',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Raca>(
              decoration: const InputDecoration(
                labelText: 'Raça',
                border: OutlineInputBorder(),
              ),
              value: _racaSelecionada,
              items: _racas.map((raca) => DropdownMenuItem(
                value: raca,
                child: Text(_getRacaNome(raca)),
              )).toList(),
              onChanged: (raca) {
                setState(() {
                  _racaSelecionada = raca;
                  _imgHeroi = _getImagem();
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Arquetipo>(
              decoration: const InputDecoration(
                labelText: 'Arquétipo',
                border: OutlineInputBorder(),
              ),
              value: _arquetipoSelecionado,
              items: _arquetipos.map((arq) => DropdownMenuItem(
                value: arq,
                child: Text(_getArquetipoNome(arq)),
              )).toList(),
              onChanged: (arq) {
                setState(() => _arquetipoSelecionado = arq);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvar,
                child: const Text('Criar Herói'),
              ),
            ),
          ],
        ),
      ),
    );
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

  String _getImagem() {
    if (_racaSelecionada is Humano) return 'assets/personagens/human/human_neutral.png';
    if (_racaSelecionada is Orc) return 'assets/personagens/orc/orc_neutral.png';
    if (_racaSelecionada is Elfo) return 'assets/personagens/elf/elf_neutral.png';
    return 'assets/personagens/dwarf/dwarf_neutral.png';
  }

  void _salvar() {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome do herói!')),
      );
      return;
    }
    if (_racaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma raça!')),
      );
      return;
    }
    if (_arquetipoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um arquétipo!')),
      );
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
      reino: 'Desconhecido',
      missao: 'Sobreviver',
    );

    Navigator.pop(context, heroi);
  }
}
