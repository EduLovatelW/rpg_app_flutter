import 'dart:math';
import 'arquetipo.dart';

class Mago extends Arquetipo {
  final _random = Random();

  Mago()
      : super(
          bonusVida: 3,
          bonusAtaque: 10,
          bonusEscudo: 2,
          bonusVelocidade: 6,
        );

  @override
  String habilidadeEspecial() {
    return 'O Mago lança uma bola de fogo mágica!';
  }

  
  @override
  int aplicarHabilidadeAtaque(int danoBase) {
    if (_random.nextInt(100) < 30) return danoBase;
    return 0;
  }
}
