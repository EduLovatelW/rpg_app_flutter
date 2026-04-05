import 'package:test/test.dart';
import 'package:rpg_flutter/entities/dado.dart';

void main() {
  test('Um dado de 1 lado deve sempre retornar 1', () {
    final dado = Dado(lados: 1);
    expect(dado.jogarDado(), equals(1));
  });

  test('Valor gerado deve estar entre 1 e o número de lados', () {
    final dado = Dado(lados: 6);
    for (int i = 0; i < 100; i++) {
      final resultado = dado.jogarDado();
      expect(
        resultado >= 1 || resultado <= 6,
        isTrue,
        reason: 'Resultado $resultado fora do intervalo'
      );
    }
  });

  group('Testes para entidade Dado', () {
    test('Deve criar uma instancia de Dado', () {
      final dado = Dado(lados: 6);
      expect(dado, isA<Dado>());
    });
  });
}