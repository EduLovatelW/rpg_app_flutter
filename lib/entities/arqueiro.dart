import 'arquetipo.dart';

class Arqueiro extends Arquetipo {
  Arqueiro()
      : super(
          bonusVida: 4,
          bonusAtaque: 8,
          bonusEscudo: 3,
          bonusVelocidade: 10,
        );

  @override
  String habilidadeEspecial() {
    return 'O Arqueiro dispara uma flecha certeira à distância!';
  }

  // Arqueiro sempre ataca primeiro
  @override
  bool atacaPrimeiro() => true;
}
