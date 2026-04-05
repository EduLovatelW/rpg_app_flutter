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

  // Retorna dano extra (0 = sem efeito)
  int aplicarHabilidadeAtaque(int danoBase) => 0;

  // Retorna dano reduzido pelo efeito defensivo
  int aplicarHabilidadeDefesa(int dano) => dano;

  // Retorna true se o arquétipo deve atacar primeiro independente de velocidade
  bool atacaPrimeiro() => false;
}
