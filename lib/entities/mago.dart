import 'arquetipo.dart';

class Mago extends Arquetipo {
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
}
