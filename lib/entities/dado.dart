import 'dart:math'; 

class Dado { 
  final int _lados; 

  Dado({required int lados}) : _lados = lados; 

  int jogarDado() { 
    if (_lados == 1) return 1; 
    final random = Random(); 
    return random.nextInt(_lados) + 1; 
  }
}