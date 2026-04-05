import 'package:flutter/material.dart';
import 'package:rpg_flutter/entities/dado.dart';
import 'package:rpg_flutter/entities/heroi.dart';
import 'package:rpg_flutter/entities/monstro.dart';
import 'package:rpg_flutter/entities/monstros_predefinidos.dart';
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
  int _modoSelecionado = 0;

  Heroi? _jogador1;
  Heroi? _jogador2;
  Heroi? _heroiVsMonstro;
  Monstro? _monstroSelecionado;

  String? _resultado;
  Personagem? _vencedor;
  Personagem? _copia1;
  Personagem? _copia2;
  double _vidaAtual1 = 1.0;
  double _vidaAtual2 = 1.0;
  List<String> _logBatalha = [];
  bool _batalhando = false;

  final List<Monstro> _monstros = getMonstrosPredefinidos();

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

  String getImagemHeroi(Heroi heroi) {
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

  Future<void> _batalhar(Personagem p1, Personagem p2) async {
    setState(() {
      _copia1 = p1;
      _copia2 = p2;
      _vidaAtual1 = 1.0;
      _vidaAtual2 = 1.0;
      _logBatalha = [];
      _resultado = null;
      _vencedor = null;
      _batalhando = true;
    });

    var atacante = p1.atacaPrimeiro() && !p2.atacaPrimeiro()
        ? p1 : p2.atacaPrimeiro() && !p1.atacaPrimeiro()
        ? p2 : p1.velocidade >= p2.velocidade ? p1 : p2;
    var defensor = atacante == p1 ? p2 : p1;
    final dado = Dado(lados: 6);

    while (atacante.estaVivo() && defensor.estaVivo()) {
      final valorDado = dado.jogarDado();
      final result = atacante.atacar(defensor, valorDado);

      setState(() {
        if (defensor == p1) {
          _vidaAtual1 = (p1.vida / p1.vidaMaxima).clamp(0.0, 1.0);
        } else {
          _vidaAtual2 = (p2.vida / p2.vidaMaxima).clamp(0.0, 1.0);
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

      if (defensor == p1) _shake1Controller.forward(from: 0);
      else _shake2Controller.forward(from: 0);

      await Future.delayed(const Duration(milliseconds: 600));

      final temp = atacante;
      atacante = defensor;
      defensor = temp;
    }

    final vencedor = p1.estaVivo() ? p1 : p2;

    setState(() {
      _batalhando = false;
      _vencedor = vencedor;
      _resultado = '🏆 ${vencedor.nome} venceu!';
    });

    widget.onBatalhaRealizada(BatalhaRegistro(
      jogador1: p1.nome,
      jogador2: p2.nome,
      vencedor: vencedor.nome,
      data: DateTime.now(),
    ));
  }

  Future<void> _iniciarBatalhaHerois() async {
    if (_jogador1 == null || _jogador2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione dois heróis!')));
      return;
    }
    if (_jogador1 == _jogador2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione heróis diferentes!')));
      return;
    }
    await _batalhar(_jogador1!.copiar(), _jogador2!.copiar());
  }

  Future<void> _iniciarBatalhaMonstro() async {
    if (_heroiVsMonstro == null || _monstroSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um herói e um monstro!')));
      return;
    }
    await _batalhar(_heroiVsMonstro!.copiar(), _monstroSelecionado!.copiar());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFF1E1E2E),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _modoSelecionado = 0;
                    _resultado = null;
                    _logBatalha = [];
                    _copia1 = null;
                    _copia2 = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: _modoSelecionado == 0 ? Colors.amber : Colors.transparent,
                        width: 2,
                      )),
                    ),
                    child: Text('⚔️ Herói vs Herói',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _modoSelecionado == 0 ? Colors.amber : Colors.grey,
                        fontWeight: FontWeight.bold,
                      )),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _modoSelecionado = 1;
                    _resultado = null;
                    _logBatalha = [];
                    _copia1 = null;
                    _copia2 = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: _modoSelecionado == 1 ? Colors.amber : Colors.transparent,
                        width: 2,
                      )),
                    ),
                    child: Text('👹 Herói vs Monstro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _modoSelecionado == 1 ? Colors.amber : Colors.grey,
                        fontWeight: FontWeight.bold,
                      )),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _modoSelecionado == 0 ? _buildHeroiVsHeroi() : _buildHeroiVsMonstro(),
        ),
      ],
    );
  }

  Widget _buildHeroiVsHeroi() {
    if (widget.personagens.length < 2) {
      return const Center(
        child: Text('Crie pelo menos 2 heróis\nna aba Personagens para batalhar!',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16)));
    }
    return _buildArena(
      lado1: _seletorHeroi(1),
      lado2: _seletorHeroi(2),
      onBatalhar: _iniciarBatalhaHerois,
    );
  }

  Widget _buildHeroiVsMonstro() {
    if (widget.personagens.isEmpty) {
      return const Center(
        child: Text('Crie pelo menos 1 herói\nna aba Personagens!',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16)));
    }
    return _buildArena(
      lado1: _seletorHeroiMonstro(),
      lado2: _seletorMonstro(),
      onBatalhar: _iniciarBatalhaMonstro,
    );
  }

  Widget _buildArena({required Widget lado1, required Widget lado2, required VoidCallback onBatalhar}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: lado1),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text('VS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              ),
              Expanded(child: lado2),
            ],
          ),
          const SizedBox(height: 16),
          if (_copia1 != null && _copia2 != null) ...[
            _barraVida(_copia1!.nome, _vidaAtual1, Colors.redAccent),
            const SizedBox(height: 8),
            _barraVida(_copia2!.nome, _vidaAtual2, Colors.blueAccent),
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
              onPressed: _batalhando ? null : onBatalhar,
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
                          ? Colors.amber : Colors.white70,
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
                    if (_vencedor is Heroi)
                      Image.asset(getImagemHeroi(_vencedor as Heroi), height: 100)
                    else if (_vencedor is Monstro)
                      Image.asset((_vencedor as Monstro).imagem, height: 100),
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

  Widget _seletorHeroi(int jogador) {
    final selecionado = jogador == 1 ? _jogador1 : _jogador2;
    return AnimatedBuilder(
      animation: jogador == 1 ? _shake1 : _shake2,
      builder: (context, child) => Transform.translate(
        offset: Offset(jogador == 1 ? _shake1.value : _shake2.value, 0),
        child: child,
      ),
      child: _cardPersonagem(
        nome: selecionado?.nome,
        imagem: selecionado != null ? getImagemHeroi(selecionado) : null,
        raca: selecionado != null ? getRacaNome(selecionado.raca) : null,
        arquetipo: selecionado != null ? getArquetipoNome(selecionado.arquetipo) : null,
        vida: selecionado?.vidaMaxima,
        ataque: selecionado?.ataque,
        label: 'Jogador $jogador',
        dropdown: DropdownButton<Heroi>(
          hint: const Text('Escolher', style: TextStyle(fontSize: 12)),
          value: selecionado,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1E2E),
          items: widget.personagens.map((h) => DropdownMenuItem(value: h, child: Text(h.nome))).toList(),
          onChanged: _batalhando ? null : (h) => setState(() {
            if (jogador == 1) _jogador1 = h;
            else _jogador2 = h;
            _resultado = null;
            _copia1 = null;
            _copia2 = null;
            _logBatalha = [];
          }),
        ),
      ),
    );
  }

  Widget _seletorHeroiMonstro() {
    return AnimatedBuilder(
      animation: _shake1,
      builder: (context, child) => Transform.translate(offset: Offset(_shake1.value, 0), child: child),
      child: _cardPersonagem(
        nome: _heroiVsMonstro?.nome,
        imagem: _heroiVsMonstro != null ? getImagemHeroi(_heroiVsMonstro!) : null,
        raca: _heroiVsMonstro != null ? getRacaNome(_heroiVsMonstro!.raca) : null,
        arquetipo: _heroiVsMonstro != null ? getArquetipoNome(_heroiVsMonstro!.arquetipo) : null,
        vida: _heroiVsMonstro?.vidaMaxima,
        ataque: _heroiVsMonstro?.ataque,
        label: 'Seu Herói',
        dropdown: DropdownButton<Heroi>(
          hint: const Text('Escolher', style: TextStyle(fontSize: 12)),
          value: _heroiVsMonstro,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1E2E),
          items: widget.personagens.map((h) => DropdownMenuItem(value: h, child: Text(h.nome))).toList(),
          onChanged: _batalhando ? null : (h) => setState(() {
            _heroiVsMonstro = h;
            _resultado = null;
            _copia1 = null;
            _copia2 = null;
            _logBatalha = [];
          }),
        ),
      ),
    );
  }

  Widget _seletorMonstro() {
    return AnimatedBuilder(
      animation: _shake2,
      builder: (context, child) => Transform.translate(offset: Offset(_shake2.value, 0), child: child),
      child: _cardPersonagem(
        nome: _monstroSelecionado?.nome,
        imagem: _monstroSelecionado?.imagem,
        raca: _monstroSelecionado != null ? getRacaNome(_monstroSelecionado!.raca) : null,
        arquetipo: _monstroSelecionado != null ? getArquetipoNome(_monstroSelecionado!.arquetipo) : null,
        vida: _monstroSelecionado?.vidaMaxima,
        ataque: _monstroSelecionado?.ataque,
        label: '👹 Monstro',
        dropdown: DropdownButton<Monstro>(
          hint: const Text('Escolher', style: TextStyle(fontSize: 12)),
          value: _monstroSelecionado,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1E2E),
          items: _monstros.map((m) => DropdownMenuItem(value: m, child: Text(m.nome))).toList(),
          onChanged: _batalhando ? null : (m) => setState(() {
            _monstroSelecionado = m;
            _resultado = null;
            _copia1 = null;
            _copia2 = null;
            _logBatalha = [];
          }),
        ),
      ),
    );
  }

  Widget _cardPersonagem({
    String? nome,
    String? imagem,
    String? raca,
    String? arquetipo,
    int? vida,
    int? ataque,
    required String label,
    required Widget dropdown,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: nome != null ? Colors.amber : Colors.grey.shade700),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(height: 8),
          if (nome != null && imagem != null) ...[
            Image.asset(imagem, height: 80),
            Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (raca != null) Text(raca, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            if (arquetipo != null) Text(arquetipo, style: TextStyle(fontSize: 12, color: Colors.amber[300])),
            if (vida != null && ataque != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, size: 12, color: Colors.redAccent),
                  const SizedBox(width: 2),
                  Text('$vida', style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  const Icon(Icons.bolt, size: 12, color: Colors.orangeAccent),
                  const SizedBox(width: 2),
                  Text('$ataque', style: const TextStyle(fontSize: 12)),
                ],
              ),
          ] else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Icon(Icons.person_add, color: Colors.grey, size: 40),
            ),
          dropdown,
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
          child: LinearProgressIndicator(
            value: porcentagem.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade800,
            valueColor: AlwaysStoppedAnimation<Color>(
              porcentagem > 0.5 ? cor : (porcentagem > 0.25 ? Colors.orange : Colors.red),
            ),
            minHeight: 12,
          ),
        ),
      ],
    );
  }
}
