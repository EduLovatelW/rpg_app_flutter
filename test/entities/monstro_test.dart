import 'package:test/test.dart';
import 'package:rpg_flutter/entities/monstro.dart';
import 'package:rpg_flutter/entities/personagem.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';

// Mocks para testes
class Orc extends Raca {
  Orc() : super(bonusVida: 2, bonusEscudo: 1, bonusAtaque: 3);
}

class Guerreiro extends Arquetipo {
  Guerreiro()
      : super(
          bonusVida: 4,
          bonusAtaque: 3,
          bonusEscudo: 2,
          bonusVelocidade: 0,
        );

  @override
  String habilidadeEspecial() => "Ataque poderoso";
}

void main() {
  group('Testes para Monstro', () {
    test('Deve criar uma instância(objeto) de Monstro', () {
      final monstro = Monstro(
        nome: 'Grood',
        vida: 20,
        velocidade: 15,
        escudo: 5,
        ataque: 7,
        raca: Orc(),
        arquetipo: Guerreiro(),
        
        origem: 'Floresta',
        tipoCriatura: 'Goblin',
      );

      expect(monstro, isA<Monstro>());
      expect(monstro, isA<Personagem>());
      expect(monstro.origem, equals('Floresta'));
      expect(monstro.tipoCriatura, equals('Goblin'));
    });
  });
}
