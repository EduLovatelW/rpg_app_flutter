import 'package:flutter/material.dart';
import 'package:rpg_flutter/entities/dado.dart';
import 'package:rpg_flutter/entities/heroi.dart';
import 'package:rpg_flutter/entities/anao.dart';
import 'package:rpg_flutter/entities/humano.dart';
import 'package:rpg_flutter/entities/elfo.dart';
import 'package:rpg_flutter/entities/orc.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';
import 'package:rpg_flutter/entities/guerreiro.dart';
import 'package:rpg_flutter/entities/mago.dart';
import 'package:rpg_flutter/entities/personagem.dart';
import 'package:rpg_flutter/presenter/historico/historico_view.dart';

class ArenaView extends StatefulWidget {
  final List<Heroi> personagens;
  final Function(BatalhaRegistro) onBatalhaRealizada;
  const ArenaView({super.key, required this.personagens, required this.onBatalhaRealizada});

  @override
  State<ArenaView> createState() => _ArenaViewState();
}

class _ArenaViewState extends State<ArenaView> with TickerProviderStateMixin {
  Heroi? _jogador1;
  Heroi? _jogador2;
  String? _resultado;
  Heroi? _vencedor;
  Heroi? _copia1;
  Heroi? _copia2;
  double _vidaAtual1 = 1.0;
  double _vidaAtual2 = 1.0;
  List<String> _logBatalha = [];
  bool _batalhando = false;

  late AnimationController _shake1Controller;
  late AnimationController _shake2Controller;
  late Animation<double> _shake1;
  late Animation<double> _shake2;

  @override
  void initState() {
    super.initState();
    _shake1Controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _shake2Controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _shake1 = Tween<double>(begin: 0, end: 8).chain(CurveTween(curve: Curves.elasticIn)).animate(_shake1Controller);
    _shake2 = Tween<double>(begin: 0, end: 8).chain(CurveTween(curve: Curves.elasticIn)).animate(_shake2Controller);
  }

  @override
  void dispose() {
    _shake1Controller.dispose();
    _shake2Controller.dispose();
    super.dispose();
  }

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

  Future<void> _batalhar() async {
    if (_jogador1 == null || _jogador2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione dois heróis para batalhar!')));
      return;
    }
    if (_jogador1 == _jogador2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione heróis diferentes!')));
      return;
    }

    final copia1 = _jogador1!.copiar();
    final copia2 = _jogador2!.copiar();

    setState(() {
      _copia1 = copia1;
      _copia2 = copia2;
      _vidaAtual1 = 1.0;
      _vidaAtual2 = 1.0;
      _logBatalha = [];
      _resultado = null;
      _vencedor = null;
      _batalhando = true;
    });

    var atacante = copia1.atacaPrimeiro() && !copia2.atacaPrimeiro()
        ? copia1
        : copia2.atacaPrimeiro() && !copia1.atacaPrimeiro()
            ? copia2
            : copia1.velocidade >= copia2.velocidade ? copia1 : copia2;
    var defensor = atacante == copia1 ? copia2 : copia1;
    final dado = Dado(lados: 6);

    while (atacante.estaVivo() && defensor.estaVivo()) {
      final valorDado = dado.jogarDado();
      final result = atacante.atacar(defensor, valorDado);

      setState(() {
        if (defensor == copia1) {
          _vidaAtual1 = (copia1.vida / copia1.vidaMaxima).clamp(0.0, 1.0);
        } else {
          _vidaAtual2 = (copia2.vida / copia2.vidaMaxima).clamp(0.0, 1.0);
        }
        if (result.efeitoDefesa != null) {
          _logBatalha.add(result.efeitoDefesa!);
        } else if (result.habilidade != null) {
          _logBatalha.add(result.habilidade!);
          _logBatalha.add('💥 ${atacante.nome} causou ${result.dano} de dano em ${defensor.nome} (❤️ ${defensor.vida})');
        } else {
          _logBatalha.add('⚔️ ${atacante.nome} causou ${result.dano} de dano em ${defensor.nome} (❤️ ${defensor.vida})');
        }
      });

      if (defensor == copia1) {
        _shake1Controller.forward(from: 0);
      } else {
        _shake2Controller.forward(from: 0);
      }

      await Future.delayed(const Duration(milliseconds: 600));

      final temp = atacante;
      atacante = defensor;
      defensor = temp;
    }

    final vencedor = copia1.estaVivo() ? copia1 : copia2;

    setState(() {
      _batalhando = false;
      _vencedor = vencedor.nome == _jogador1!.nome ? _jogador1 : _jogador2;
      _resultado = '🏆 ${vencedor.nome} venceu!';
    });

    widget.onBatalhaRealizada(BatalhaRegistro(
      jogador1: _jogador1!.nome,
      jogador2: _jogador2!.nome,
      vencedor: vencedor.nome,
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          if (_copia1 != null && _copia2 != null) ...[
            _barraVida(_jogador1!.nome, _vidaAtual1, Colors.redAccent),
            const SizedBox(height: 8),
            _barraVida(_jogador2!.nome, _vidaAtual2, Colors.blueAccent),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _batalhando
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.sports_kabaddi),
              label: Text(_batalhando ? 'Batalha em andamento...' : 'BATALHAR!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: _batalhando ? null : _batalhar,
            ),
          ),
          if (_logBatalha.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 180),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade700),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _logBatalha.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(_logBatalha[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: _logBatalha[index].contains('🔥') || _logBatalha[index].contains('🛡️')
                          ? Colors.amber
                          : Colors.white70,
                    )),
                ),
              ),
            ),
          ],
          if (_resultado != null) ...[
            const SizedBox(height: 16),
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
                  Text(_resultado!,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber),
                    textAlign: TextAlign.center),
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

  Widget _barraVida(String nome, double porcentagem, Color cor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(nome, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('${(porcentagem * 100).toInt()}%', style: TextStyle(fontSize: 12, color: cor)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 12,
            child: LinearProgressIndicator(
              value: porcentagem.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(
                porcentagem > 0.5 ? cor : (porcentagem > 0.25 ? Colors.orange : Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seletorPersonagem(int jogador) {
    final selecionado = jogador == 1 ? _jogador1 : _jogador2;
    return AnimatedBuilder(
      animation: jogador == 1 ? _shake1 : _shake2,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(jogador == 1 ? _shake1.value : _shake2.value, 0),
          child: child,
        );
      },
      child: Container(
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
              onChanged: _batalhando ? null : (h) {
                setState(() {
                  if (jogador == 1) _jogador1 = h;
                  else _jogador2 = h;
                  _resultado = null;
                  _copia1 = null;
                  _copia2 = null;
                  _logBatalha = [];
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
