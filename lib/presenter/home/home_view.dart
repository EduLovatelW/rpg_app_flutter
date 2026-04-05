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

  void _onBatalhaRealizada(BatalhaRegistro registro) {
    setState(() {
      _historico.add(registro);
      for (final heroi in _personagens) {
        if (heroi.nome == registro.vencedor) {
          heroi.ganharXp(50);
        } else if (heroi.nome != registro.vencedor && registro.vencedor != 'Empate') {
          heroi.ganharXp(10);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RPG Flutter')),
      body: IndexedStack(
        index: _itemSelecionado,
        children: [
          ArenaView(
            personagens: _personagens,
            onBatalhaRealizada: _onBatalhaRealizada,
          ),
          PersonagensView(
            personagens: _personagens,
            onPersonagemAdicionado: (heroi) {
              setState(() => _personagens.add(heroi));
            },
            onPersonagemRemovido: (index) {
              setState(() => _personagens.removeAt(index));
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
