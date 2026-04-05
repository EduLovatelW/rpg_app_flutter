import 'package:flutter/material.dart';
import 'package:rpg_flutter/entities/heroi.dart';

class BatalhaRegistro {
  final String jogador1;
  final String jogador2;
  final String vencedor;
  final DateTime data;

  BatalhaRegistro({
    required this.jogador1,
    required this.jogador2,
    required this.vencedor,
    required this.data,
  });
}

class HistoricoView extends StatelessWidget {
  final List<BatalhaRegistro> historico;
  const HistoricoView({super.key, required this.historico});

  @override
  Widget build(BuildContext context) {
    if (historico.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma batalha registrada ainda.\nVá para a Arena e batalhe!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: historico.length,
      itemBuilder: (context, index) {
        final b = historico[historico.length - 1 - index];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text('⚔️'),
            ),
            title: Text('${b.jogador1} vs ${b.jogador2}'),
            subtitle: Text('🏆 Vencedor: ${b.vencedor}'),
            trailing: Text(
              '${b.data.hour.toString().padLeft(2,'0')}:${b.data.minute.toString().padLeft(2,'0')}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
