import 'package:flutter/material.dart';
import 'package:rpg_flutter/entities/heroi.dart';
import 'package:rpg_flutter/presenter/arena/arena_view.dart';
import 'package:rpg_flutter/presenter/historico/historico_view.dart';
import 'package:rpg_flutter/presenter/personagens/personagens_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _itemSelecionado = 0;
  final List<Heroi> _personagens = [];
  final List<BatalhaRegistro> _historico = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RPG Flutter')),
      body: IndexedStack(
        index: _itemSelecionado,
        children: [
          ArenaView(
            personagens: _personagens,
            onBatalhaRealizada: (registro) {
              setState(() => _historico.add(registro));
            },
          ),
          PersonagensView(
            personagens: _personagens,
            onPersonagemAdicionado: (heroi) {
              setState(() => _personagens.add(heroi));
            },
          ),
          HistoricoView(historico: _historico),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _itemSelecionado,
        onTap: (index) => setState(() => _itemSelecionado = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Arena'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Personagens'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
        ],
      ),
    );
  }
}
