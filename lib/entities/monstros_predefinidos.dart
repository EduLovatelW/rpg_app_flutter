import 'package:rpg_flutter/entities/monstro.dart';
import 'package:rpg_flutter/entities/orc.dart';
import 'package:rpg_flutter/entities/humano.dart';
import 'package:rpg_flutter/entities/elfo.dart';
import 'package:rpg_flutter/entities/anao.dart';
import 'package:rpg_flutter/entities/guerreiro.dart';
import 'package:rpg_flutter/entities/mago.dart';
import 'package:rpg_flutter/entities/arqueiro.dart';

List<Monstro> getMonstrosPredefinidos() {
  return [
    Monstro(
      nome: 'Goblin Selvagem',
      vida: 60,
      velocidade: 12,
      escudo: 5,
      ataque: 8,
      raca: Orc(bonusVida: 10, bonusEscudo: 4, bonusAtaque: 8),
      arquetipo: Arqueiro(),
      origem: 'Floresta Sombria',
      tipoCriatura: 'Goblin',
      imagem: 'assets/personagens/orc/orc_archer.png',
    ),
    Monstro(
      nome: 'Ogro Brutal',
      vida: 120,
      velocidade: 5,
      escudo: 15,
      ataque: 12,
      raca: Orc(bonusVida: 14, bonusEscudo: 6, bonusAtaque: 10),
      arquetipo: Guerreiro(),
      origem: 'Montanhas do Norte',
      tipoCriatura: 'Ogro',
      imagem: 'assets/personagens/orc/orc_warrior.png',
    ),
    Monstro(
      nome: 'Feiticeiro das Sombras',
      vida: 70,
      velocidade: 10,
      escudo: 5,
      ataque: 15,
      raca: Humano(bonusVida: 6, bonusEscudo: 2, bonusAtaque: 12),
      arquetipo: Mago(),
      origem: 'Torre Maldita',
      tipoCriatura: 'Feiticeiro',
      imagem: 'assets/personagens/human/human_mage.png',
    ),
    Monstro(
      nome: 'Elfo Corrompido',
      vida: 80,
      velocidade: 14,
      escudo: 8,
      ataque: 14,
      raca: Elfo(bonusVida: 6, bonusEscudo: 8, bonusAtaque: 16),
      arquetipo: Arqueiro(),
      origem: 'Floresta Amaldiçoada',
      tipoCriatura: 'Elfo das Sombras',
      imagem: 'assets/personagens/elf/elf_archer.png',
    ),
    Monstro(
      nome: 'Anão Renegado',
      vida: 100,
      velocidade: 7,
      escudo: 18,
      ataque: 11,
      raca: Anao(bonusVida: 12, bonusEscudo: 6, bonusAtaque: 12),
      arquetipo: Guerreiro(),
      origem: 'Minas Abandonadas',
      tipoCriatura: 'Anão das Trevas',
      imagem: 'assets/personagens/dwarf/dwarf_warrior.png',
    ),
  ];
}
