import 'package:rpg_flutter/entities/personagem.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';

class Heroi extends Personagem {
  final String _reino;
  final String _missao;
  int _xp;
  int _nivel;

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
    int xp = 0,
    int nivel = 1,
  })  : _reino = reino,
        _missao = missao,
        _xp = xp,
        _nivel = nivel,
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
  int get xp => _xp;
  int get nivel => _nivel;
  int get xpParaProximoNivel => _nivel * 100;

  void ganharXp(int quantidade) {
    _xp += quantidade;
    while (_xp >= xpParaProximoNivel) {
      _xp -= xpParaProximoNivel;
      _nivel++;
    }
  }

  Heroi copiar() {
    return Heroi(
      nome: nome,
      vida: vidaMaxima + (_nivel - 1) * 10,
      velocidade: velocidade,
      escudo: escudo + (_nivel - 1) * 2,
      ataque: ataque + (_nivel - 1) * 3,
      raca: raca,
      arquetipo: arquetipo,
      reino: _reino,
      missao: _missao,
      xp: _xp,
      nivel: _nivel,
    );
  }
}
