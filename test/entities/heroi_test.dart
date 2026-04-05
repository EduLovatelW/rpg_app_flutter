import 'package:test/test.dart';
import 'package:rpg_flutter/entities/heroi.dart';
import 'package:rpg_flutter/entities/personagem.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';

// Mocks para testes
class Humano extends Raca {
  Humano() : super(bonusVida: 5, bonusEscudo: 2, bonusAtaque: 1);
}

class Guerreiro extends Arquetipo {
  Guerreiro()
      : super(
          bonusVida: 4,
          bonusAtaque: 3,
          bonusEscudo: 2,
          bonusVelocidade: 1,
        );

  @override
  String habilidadeEspecial() => "Ataque poderoso";
}

void main() {
  group('Testes para Heroi', () {
    test('Deve criar um objeto(instância) de Heroi', () {
      final humano = Humano();
      final guerreiro = Guerreiro();

      final heroi = Heroi(
        nome: 'Jemerson',
        vida: 10,
        velocidade: 10,
        escudo: 10,
        ataque: 10,
        raca: humano,
        arquetipo: guerreiro,
      
        reino: 'Corole Vivida',
        missao: 'Ir na festa da laranja',
      );

      expect(heroi, isA<Heroi>());
      expect(heroi, isA<Personagem>());
      expect(heroi.reino, equals('Corole Vivida'));
      expect(heroi.missao, equals('Ir na festa da laranja'));
    });

    test('Deve criar um objeto de Personagem através de Heroi', () {
      final humano = Humano();
      final guerreiro = Guerreiro();

      final personagem = Heroi(
        nome: 'João',
        vida: 10,
        velocidade: 10,
        escudo: 10,
        ataque: 20,
        raca: humano,
        arquetipo: guerreiro,
        
        reino: '',
        missao: '',
      );

      expect(personagem, isA<Personagem>());
    });
  });
}
