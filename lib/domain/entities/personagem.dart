import 'package:rpg_flutter/entities/raca.dart';        // Importa a classe base Raca
import 'package:rpg_flutter/entities/arquetipo.dart';   // Importa a classe base Arquetipo

class Personagem {
  // ---------- ATRIBUTOS ----------
  final String _nome;      // Nome do personagem (imutável)
  int _vida;                // Vida atual (mutável, pois diminui com dano)
  final int _velocidade;   // Velocidade base + bônus
  final int _escudo;       // Escudo base + bônus
  final int _ataque;       // Ataque base + bônus

  final Raca _raca;             // A raça escolhida do personagem
  final Arquetipo _arquetipo;   // O arquétipo escolhido do personagem

  // ---------- CONSTRUTOR ----------
  Personagem({
    required String nome,
    required int vida,
    required int velocidade,
    required int escudo,
    required int ataque,
    required Raca raca,
    required Arquetipo arquetipo,
  })  : _nome = nome,
        _raca = raca,
        _arquetipo = arquetipo,
        // Ao criar, soma os bônus da raça e do arquétipo aos atributos base
        _vida = vida + raca.bonusVida + arquetipo.bonusVida,
        _escudo = escudo + raca.bonusEscudo + arquetipo.bonusEscudo,
        _velocidade = velocidade + arquetipo.bonusVelocidade,
        _ataque = ataque + raca.bonusAtaque + arquetipo.bonusAtaque;

  // ---------- GETTERS PÚBLICOS ----------
  String get nome => _nome;
  int get vida => _vida;
  int get velocidade => _velocidade;
  int get escudo => _escudo;
  int get ataque => _ataque;
  Raca get raca => _raca;
  Arquetipo get arquetipo => _arquetipo;

  // ---------- MÉTODOS DE COMBATE ----------

  // Aplica dano recebido levando em conta o escudo do personagem
  void defender(int dano) {
    int danoFinal = dano - _escudo;        // Reduz o dano pelo escudo
    if (danoFinal < 0) danoFinal = 0;      // Garante que não fique negativo
    _vida -= danoFinal;                    // Subtrai da vida atual
    if (_vida < 0) _vida = 0;              // Garante que a vida não fique negativa
  }

  // Ataca outro personagem: calcula o dano e chama o defender do oponente
  void atacar(Personagem oponente, int valorDado) {
    final danoTotal = _ataque + valorDado; // Soma ataque + valor do dado
    oponente.defender(danoTotal);          // Aplica o dano no oponente
  }

  // Verifica se o personagem ainda está vivo
  bool estaVivo() => _vida > 0;

  // Executa a habilidade especial do arquétipo (ex: ataque especial de mago, guerreiro etc.)
  void usarHabilidadeEspecial() => _arquetipo.habilidadeEspecial();

  // Mostra os atributos atuais do personagem no console
  void exibirStatus() {
    print('Nome: $_nome | Vida: $_vida | Escudo: $_escudo | Velocidade: $_velocidade | Ataque: $_ataque');
  }
}
