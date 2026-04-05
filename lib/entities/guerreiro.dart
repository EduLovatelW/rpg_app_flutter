import 'dart:math';
import 'arquetipo.dart';

class Guerreiro extends Arquetipo {
  final _random = Random();

  Guerreiro()
      : super(
          bonusVida: 5,
          bonusAtaque: 7,
          bonusEscudo: 8,
          bonusVelocidade: 3,
        );

  @override
  String habilidadeEspecial() {
    return 'O Guerreiro usa um golpe poderoso com sua espada!';
  }

  
  @override
  int aplicarHabilidadeDefesa(int dano) {
    if (_random.nextInt(100) < 25) return 0;
    return dano;
  }
}
