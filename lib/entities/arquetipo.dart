import 'dart:math';

abstract class Arquetipo {
  final int _bonusVida;
  final int _bonusAtaque;
  final int _bonusEscudo;
  final int _bonusVelocidade;

  Arquetipo({
    required int bonusVida,
    required int bonusAtaque,
    required int bonusEscudo,
    required int bonusVelocidade,
  })  : _bonusVida = bonusVida,
        _bonusAtaque = bonusAtaque,
        _bonusEscudo = bonusEscudo,
        _bonusVelocidade = bonusVelocidade;

  int get bonusVida => _bonusVida;
  int get bonusAtaque => _bonusAtaque;
  int get bonusEscudo => _bonusEscudo;
  int get bonusVelocidade => _bonusVelocidade;

  String habilidadeEspecial();

  
  int aplicarHabilidadeAtaque(int danoBase) => 0;

  
  int aplicarHabilidadeDefesa(int dano) => dano;

  
  bool atacaPrimeiro() => false;
}
