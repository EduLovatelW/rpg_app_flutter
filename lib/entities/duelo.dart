import 'personagem.dart';  // Importa para poder usar Personagem
import 'dado.dart';        // Importa para gerar valores aleatórios do dado

class Duelo {
  // ---------- ATRIBUTOS ----------
  final Dado _dado;               // Dado usado para rolar valores aleatórios
  final Personagem _jogador1;     // Primeiro personagem do duelo
  final Personagem _jogador2;     // Segundo personagem do duelo

  // ---------- CONSTRUTOR ----------
  Duelo({
    required Dado dado,
    required Personagem jogador1,
    required Personagem jogador2,
  })  : _dado = dado,
        _jogador1 = jogador1,
        _jogador2 = jogador2;

  // ---------- LÓGICA DO DUELO ----------

  // Decide quem começa baseado na maior velocidade
  Personagem get primeiroAtacante =>
      (_jogador1.velocidade >= _jogador2.velocidade) ? _jogador1 : _jogador2;

  // Inicia o duelo e retorna quem venceu no final
  Personagem? iniciar() {
    // Define quem começa e quem defende
    var atacante = primeiroAtacante;
    var defensor = (atacante == _jogador1) ? _jogador2 : _jogador1;

    // Loop enquanto os dois ainda estão vivos
    while (atacante.estaVivo() && defensor.estaVivo()) {
      final valorDado = _dado.jogarDado();               // 1) Rola o dado
      final danoTotal = atacante.ataque + valorDado;     // 2) Calcula dano
      defensor.defender(danoTotal);                      // 3) Aplica o dano no defensor

      // 4) Alterna os papéis (quem atacou vira defensor e vice-versa)
      final temp = atacante;
      atacante = defensor;
      defensor = temp;
    }

    // Quando um morrer, retorna quem está vivo
    if (_jogador1.estaVivo()) return _jogador1;
    if (_jogador2.estaVivo()) return _jogador2;
    return null;  // Caso extremo (empate)
  }
}
