import 'package:rpg_flutter/entities/personagem.dart';
import 'package:rpg_flutter/entities/raca.dart';
import 'package:rpg_flutter/entities/arquetipo.dart';

class Monstro extends Personagem {
  final String _origem;
  final String _tipoCriatura;

  Monstro({
    required String nome,
    required int vida,
    required int velocidade,
    required int escudo,
    required int ataque,
    required Raca raca,
    required Arquetipo arquetipo,
    required String origem,
    required String tipoCriatura,
  })  : _origem = origem,
        _tipoCriatura = tipoCriatura,
        super(
          nome: nome,
          vida: vida,
          velocidade: velocidade,
          escudo: escudo,
          ataque: ataque,
          raca: raca,
          arquetipo: arquetipo,
          
        );

  String get origem => _origem;
  String get tipoCriatura => _tipoCriatura;
}
