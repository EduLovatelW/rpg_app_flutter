abstract class Arquetipo {
  final int _bonusVida;
  final int _bonusAtaque;
  final int _bonusEscudo;
  final int _bonusVelocidade; // <-- novo

  Arquetipo({
    required int bonusVida,
    required int bonusAtaque,
    required int bonusEscudo,
    required int bonusVelocidade, // <-- novo
  })  : _bonusVida = bonusVida,
        _bonusAtaque = bonusAtaque,
        _bonusEscudo = bonusEscudo,
        _bonusVelocidade = bonusVelocidade; // <-- novo

  int get bonusVida => _bonusVida;
  int get bonusAtaque => _bonusAtaque;
  int get bonusEscudo => _bonusEscudo;
  int get bonusVelocidade => _bonusVelocidade; // <-- novo

  String habilidadeEspecial();
}
