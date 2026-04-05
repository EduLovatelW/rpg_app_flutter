import 'package:flutter/material.dart';

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

  Map<String, int> _calcularPlacar() {
    final placar = <String, int>{};
    for (final b in historico) {
      if (b.vencedor != 'Empate') {
        placar[b.vencedor] = (placar[b.vencedor] ?? 0) + 1;
      }
    }
    final sorted = Map.fromEntries(
      placar.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
    return sorted;
  }

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

    final placar = _calcularPlacar();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placar
          const Text('🏆 Placar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(height: 8),
          ...placar.entries.toList().asMap().entries.map((entry) {
            final pos = entry.key;
            final nome = entry.value.key;
            final vitorias = entry.value.value;
            final medalha = pos == 0 ? '🥇' : pos == 1 ? '🥈' : '🥉';
            return Card(
              margin: const EdgeInsets.only(bottom: 6),
              child: ListTile(
                leading: Text(medalha, style: const TextStyle(fontSize: 24)),
                title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Text('$vitorias vitória${vitorias > 1 ? 's' : ''}',
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          // Histórico
          const Text('📜 Batalhas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(height: 8),
          ...historico.reversed.map((b) => Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.shield, color: Colors.white, size: 18),
              ),
              title: Text('${b.jogador1} vs ${b.jogador2}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('🏆 Vencedor: ${b.vencedor}'),
              trailing: Text(
                '${b.data.hour.toString().padLeft(2, '0')}:${b.data.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
