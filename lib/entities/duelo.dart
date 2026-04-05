import 'personagem.dart';
import 'dado.dart';

class Duelo {
  final Dado _dado;
  final Personagem _jogador1;
  final Personagem _jogador2;

  Duelo({
    required Dado dado,
    required Personagem jogador1,
    required Personagem jogador2,
  })  : _dado = dado,
        _jogador1 = jogador1,
        _jogador2 = jogador2;

  Personagem get primeiroAtacante {
    if (_jogador1.atacaPrimeiro() && !_jogador2.atacaPrimeiro()) return _jogador1;
    if (_jogador2.atacaPrimeiro() && !_jogador1.atacaPrimeiro()) return _jogador2;
    return (_jogador1.velocidade >= _jogador2.velocidade) ? _jogador1 : _jogador2;
  }

  Personagem? iniciar() {
    var atacante = primeiroAtacante;
    var defensor = (atacante == _jogador1) ? _jogador2 : _jogador1;

    while (atacante.estaVivo() && defensor.estaVivo()) {
      final valorDado = _dado.jogarDado();
      atacante.atacar(defensor, valorDado);
      final temp = atacante;
      atacante = defensor;
      defensor = temp;
    }

    if (_jogador1.estaVivo()) return _jogador1;
    if (_jogador2.estaVivo()) return _jogador2;
    return null;
  }
}
