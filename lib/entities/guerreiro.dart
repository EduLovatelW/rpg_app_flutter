import 'arquetipo.dart';

class Guerreiro extends Arquetipo {
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
}
