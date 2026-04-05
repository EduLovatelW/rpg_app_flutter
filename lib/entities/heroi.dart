import 'package:rpg_flutter/entities/personagem.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';

class Heroi extends Personagem {
  final String _reino;
  final String _missao;

  Heroi({
    required String nome,
    required int vida,
    required int velocidade,
    required int escudo,
    required int ataque,
    required Raca raca,
    required Arquetipo arquetipo,
    required String reino,
    required String missao,
  })  : _reino = reino,
        _missao = missao,
        super(
          nome: nome,
          vida: vida,
          velocidade: velocidade,
          escudo: escudo,
          ataque: ataque,
          raca: raca,
          arquetipo: arquetipo,
        );

  String get reino => _reino;
  String get missao => _missao;

  Heroi copiar() {
    return Heroi(
      nome: nome,
      vida: vidaMaxima,
      velocidade: velocidade,
      escudo: escudo,
      ataque: ataque,
      raca: raca,
      arquetipo: arquetipo,
      reino: _reino,
      missao: _missao,
    );
  }
}
