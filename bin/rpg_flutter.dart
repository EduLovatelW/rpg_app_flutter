import 'package:rpg_flutter/entities/dado.dart';
import 'package:rpg_flutter/entities/heroi.dart';
import 'package:rpg_flutter/entities/monstro.dart';

import 'package:rpg_flutter/entities/personagem.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';



class Humano extends Raca {
  Humano() : super(bonusVida: 5, bonusEscudo: 3, bonusAtaque: 2);
}

class Orc extends Raca {
  Orc() : super(bonusVida: 8, bonusEscudo: 2, bonusAtaque: 4);
}


class Guerreiro extends Arquetipo {
  Guerreiro()
      : super(
          bonusVida: 4,
          bonusEscudo: 2,
          bonusAtaque: 3,
          bonusVelocidade: 1,
        );

  @override
  String habilidadeEspecial() => "Ataque poderoso";
}

class Mago extends Arquetipo {
  Mago()
      : super(
          bonusVida: 3,
          bonusEscudo: 1,
          bonusAtaque: 4,
          bonusVelocidade: 2,
        );

  @override
  String habilidadeEspecial() => "Feitiço mágico";
}

void main() {
  final dado = Dado(lados: 20);

  
  final batman = Heroi(
    nome: 'Batman',
    vida: 20,
    velocidade: 10,
    escudo: 15,
    ataque: 8,
    raca: Humano(),
    arquetipo: Guerreiro(),
    reino: 'Gotham',
    missao: 'Matar o Espantalho',
  );

  
  final espantalho = Monstro(
    nome: 'Espantalho',
    vida: 20,
    velocidade: 15,
    escudo: 15,
    ataque: 6,
    raca: Orc(),
    arquetipo: Mago(),
    origem: 'Fazenda',
    tipoCriatura: 'Humano',
  );

  
  Personagem atacante, defensor;
  if (batman.velocidade >= espantalho.velocidade) {
    atacante = batman;
    defensor = espantalho;
  } else {
    atacante = espantalho;
    defensor = batman;
  }

  print("Início do duelo: ${batman.nome} vs ${espantalho.nome}\n");

  
  while (batman.estaVivo() && espantalho.estaVivo()) {
    final valorDado = dado.jogarDado();
    print(
        "${atacante.nome} ataca ${defensor.nome} com valor do dado: $valorDado");
    atacante.atacar(defensor, valorDado);
    print(
        "Status: ${batman.nome} (Vida: ${batman.vida}) | ${espantalho.nome} (Vida: ${espantalho.vida})\n");

    
    final temp = atacante;
    atacante = defensor;
    defensor = temp;
  }

  final vencedor = batman.estaVivo() ? batman : espantalho;
  print("O vencedor foi: ${vencedor.nome}\n");

  
  batman.exibirStatus();
  espantalho.exibirStatus();

  
  print('Habilidade especial do ${batman.nome}: ${batman.arquetipo.habilidadeEspecial()}');
  print('Habilidade especial do ${espantalho.nome}: ${espantalho.arquetipo.habilidadeEspecial()}');
}
