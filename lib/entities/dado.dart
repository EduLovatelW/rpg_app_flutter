import 'dart:math'; // Importa a biblioteca para gerar números aleatórios

class Dado { // Declara a classe Dado
  final int _lados; // Atributo agora é privado

  Dado({required int lados}) : _lados = lados; // Construtor inicializa o atributo privado

  int jogarDado() { // Método para "jogar" o dado
    if (_lados == 1) return 1; // Se o dado tem 1 lado, sempre retorna 1
    final random = Random(); // Cria um gerador de números aleatórios
    return random.nextInt(_lados) + 1; // Sorteia um número entre 1 e o número de lados
  }
}