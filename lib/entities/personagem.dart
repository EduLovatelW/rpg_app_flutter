import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';

class Personagem {
  final String _nome;
  int _vida;
  final int _vidaMaxima;
  final int _velocidade;
  final int _escudo;
  final int _ataque;
  final Raca _raca;
  final Arquetipo _arquetipo;

  Personagem({
    required String nome,
    required int vida,
    required int velocidade,
    required int escudo,
    required int ataque,
    required Raca raca,
    required Arquetipo arquetipo,
  })  : _nome = nome,
        _raca = raca,
        _arquetipo = arquetipo,
        _vida = vida + raca.bonusVida + arquetipo.bonusVida,
        _vidaMaxima = vida + raca.bonusVida + arquetipo.bonusVida,
        _escudo = escudo + raca.bonusEscudo + arquetipo.bonusEscudo,
        _velocidade = velocidade + arquetipo.bonusVelocidade,
        _ataque = ataque + raca.bonusAtaque + arquetipo.bonusAtaque;

  String get nome => _nome;
  int get vida => _vida;
  int get vidaMaxima => _vidaMaxima;
  int get velocidade => _velocidade;
  int get escudo => _escudo;
  int get ataque => _ataque;
  Raca get raca => _raca;
  Arquetipo get arquetipo => _arquetipo;

  // Retorna descrição do efeito especial se ativou, ou null
  String? defender(int dano) {
    int danoFinal = dano - _escudo;
    if (danoFinal < 0) danoFinal = 0;
    danoFinal = _arquetipo.aplicarHabilidadeDefesa(danoFinal);
    if (danoFinal == 0) {
      _vida -= 0;
      return '🛡️ ${_nome} bloqueou o ataque!';
    }
    _vida -= danoFinal;
    if (_vida < 0) _vida = 0;
    return null;
  }

  // Retorna dano causado e descrição de habilidade especial
  AttackResult atacar(Personagem oponente, int valorDado) {
    final danoBase = _ataque + valorDado;
    final danoExtra = _arquetipo.aplicarHabilidadeAtaque(danoBase);
    final danoTotal = danoBase + danoExtra;
    final efeito = oponente.defender(danoTotal);
    String? habilidade;
    if (danoExtra > 0) habilidade = '🔥 ${_arquetipo.habilidadeEspecial()}';
    return AttackResult(dano: danoTotal, habilidade: habilidade, efeitoDefesa: efeito);
  }

  bool estaVivo() => _vida > 0;
  bool atacaPrimeiro() => _arquetipo.atacaPrimeiro();

  void exibirStatus() {
    print('Nome: $_nome | Vida: $_vida | Escudo: $_escudo | Velocidade: $_velocidade | Ataque: $_ataque');
  }
}

class AttackResult {
  final int dano;
  final String? habilidade;
  final String? efeitoDefesa;
  AttackResult({required this.dano, this.habilidade, this.efeitoDefesa});
}
