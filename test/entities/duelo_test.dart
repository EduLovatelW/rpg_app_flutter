import 'package:test/test.dart';
import 'package:rpg_flutter/entities/duelo.dart';
import 'package:rpg_flutter/entities/personagem.dart';
import 'package:rpg_flutter/entities/dado.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';

// Mocks para teste
class Humano extends Raca {
  Humano() : super(bonusVida: 5, bonusEscudo: 2, bonusAtaque: 1);
}

class Elfo extends Raca {
  Elfo() : super(bonusVida: 2, bonusEscudo: 1, bonusAtaque: 3);
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

class Mago extends Arquetipo {
  Mago()
      : super(
          bonusVida: 4,
          bonusAtaque: 4,
          bonusEscudo: 0,
          bonusVelocidade: 2,
        );

  @override
  String habilidadeEspecial() => "Feitiço mágico";
}

void main() {
  test('O duelo deve terminar com apenas um jogador vivo', () {
    final jogador1 = Personagem(
      nome: 'Herói',
      vida: 10,
      velocidade: 5,
      escudo: 2,
      ataque: 5,
      raca: Humano(),
      arquetipo: Guerreiro(),
     // raca + arquetipo
    );

    final jogador2 = Personagem(
      nome: 'Vilão',
      vida: 10,
      velocidade: 3,
      escudo: 1,
      ataque: 5,
      raca: Elfo(),
      arquetipo: Mago(),
      
    );

    final dado = Dado(lados: 6);
    final duelo = Duelo(dado: dado, jogador1: jogador1, jogador2: jogador2);

    final vencedor = duelo.iniciar();

    expect(
      (jogador1.estaVivo() && !jogador2.estaVivo()) ||
          (!jogador1.estaVivo() && jogador2.estaVivo()),
      isTrue,
    );
    expect(vencedor != null, isTrue);
  });

  test('O personagem com maior velocidade deve começar', () {
    final rapido = Personagem(
      nome: 'Rápido',
      vida: 10,
      velocidade: 8,
      escudo: 2,
      ataque: 5,
      raca: Humano(),
      arquetipo: Guerreiro(),
      
    );

    final lento = Personagem(
      nome: 'Lento',
      vida: 10,
      velocidade: 3,
      escudo: 1,
      ataque: 5,
      raca: Elfo(),
      arquetipo: Mago(),
      
    );

    final dado = Dado(lados: 6);
    final duelo = Duelo(dado: dado, jogador1: rapido, jogador2: lento);

    expect(duelo.primeiroAtacante, equals(rapido));
  });

  test('Deve criar uma instância de Duelo', () {
    final maria = Personagem(
      nome: 'Maria',
      vida: 50,
      velocidade: 30,
      escudo: 10,
      ataque: 10,
      raca: Humano(),
      arquetipo: Guerreiro(),
     
    );

    final joao = Personagem(
      nome: 'Joao',
      vida: 45,
      velocidade: 40,
      escudo: 7,
      ataque: 10,
      raca: Elfo(),
      arquetipo: Mago(),
     
    );

    final dado = Dado(lados: 20);
    final duelo = Duelo(dado: dado, jogador1: maria, jogador2: joao);

    expect(duelo, isA<Duelo>());
  });
}
