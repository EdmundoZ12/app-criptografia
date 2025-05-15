/// Clase que implementa el cifrado de Vigenère (desplazamiento con palabra clave).
/// Este cifrado utiliza una clave para determinar un desplazamiento variable
/// para cada carácter del texto.
class CifraDesplazamientoClave {
  /// Alfabeto utilizado para el cifrado
  final String alfabeto;

  /// Mapa que asocia cada carácter con su posición en el alfabeto
  late final Map<String, int> mapaCharAIndice;

  /// Lista de caracteres del alfabeto para acceso por índice
  late final List<String> listaAlfabeto;

  /// Constructor que inicializa el cifrador con el alfabeto especificado
  /// [tipoAlfabeto] puede ser 'español' (incluye 'Ñ') u otro valor
  CifraDesplazamientoClave({required String tipoAlfabeto})
      : alfabeto = tipoAlfabeto.toLowerCase() == 'español'
            ? 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ \n'
            : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ \n' {
    listaAlfabeto = alfabeto.split('');
    mapaCharAIndice = {
      for (int i = 0; i < listaAlfabeto.length; i++) listaAlfabeto[i]: i
    };
  }

  /// Convierte un carácter a su índice en el alfabeto
  /// Retorna -1 si el carácter no está en el alfabeto
  int _charToIndex(String c) => mapaCharAIndice[c.toUpperCase()] ?? -1;

  /// Convierte un índice a su carácter correspondiente en el alfabeto
  /// Aplica aritmética modular para manejar índices fuera de rango
  String _indexToChar(int i) => listaAlfabeto[i % listaAlfabeto.length];

  /// Expande la clave para que coincida con la longitud del texto
  /// Solo considera los caracteres del texto que están en el alfabeto
  ///
  /// [texto] - El texto para el que se expandirá la clave
  /// [clave] - La clave a expandir
  /// Lanza [ArgumentError] si la clave está vacía
  String _expandirClave(String texto, String clave) {
    if (clave.isEmpty) {
      throw ArgumentError('La clave no puede estar vacía');
    }

    String claveMayus = clave.toUpperCase();
    StringBuffer sb = StringBuffer();
    int j = 0;

    for (int i = 0; i < texto.length; i++) {
      // Solo añadir clave para caracteres que están en el alfabeto
      if (_charToIndex(texto[i]) != -1) {
        sb.write(claveMayus[j % claveMayus.length]);
        j++;
      } else {
        // Para caracteres fuera del alfabeto, usar un placeholder
        // que no afecte al cifrado (por ejemplo, primer carácter del alfabeto)
        sb.write(listaAlfabeto[0]);
      }
    }
    return sb.toString();
  }

  /// Cifra un texto utilizando el algoritmo de Vigenère
  ///
  /// [texto] - El texto a cifrar
  /// [clave] - La palabra clave para el cifrado
  /// Retorna el texto cifrado
  /// Lanza [ArgumentError] si la clave está vacía
  String cifrar(String texto, String clave) {
    if (texto.isEmpty) return '';
    if (clave.isEmpty) {
      throw ArgumentError('La clave no puede estar vacía');
    }

    String textoMayus = texto.toUpperCase();
    String claveExpandida = _expandirClave(textoMayus, clave);
    StringBuffer resultado = StringBuffer();

    for (int i = 0; i < textoMayus.length; i++) {
      int indiceTexto = _charToIndex(textoMayus[i]);

      if (indiceTexto == -1) {
        // Caracter no en alfabeto, se mantiene igual
        resultado.write(texto[i]);
      } else {
        int indiceClave = _charToIndex(claveExpandida[i]);
        // Suma mod alfabeto
        int indiceCifrado = (indiceTexto + indiceClave) % listaAlfabeto.length;
        resultado.write(_indexToChar(indiceCifrado));
      }
    }
    return resultado.toString();
  }

  /// Descifra un texto cifrado utilizando el algoritmo de Vigenère
  ///
  /// [textoCifrado] - El texto cifrado a descifrar
  /// [clave] - La misma palabra clave utilizada para cifrar
  /// Retorna el texto original descifrado
  /// Lanza [ArgumentError] si la clave está vacía
  String descifrar(String textoCifrado, String clave) {
    if (textoCifrado.isEmpty) return '';
    if (clave.isEmpty) {
      throw ArgumentError('La clave no puede estar vacía');
    }

    String textoMayus = textoCifrado.toUpperCase();
    String claveExpandida = _expandirClave(textoMayus, clave);
    StringBuffer resultado = StringBuffer();

    for (int i = 0; i < textoMayus.length; i++) {
      int indiceTexto = _charToIndex(textoMayus[i]);

      if (indiceTexto == -1) {
        // Mantener caracteres originales si no están en el alfabeto
        resultado.write(textoCifrado[i]);
      } else {
        int indiceClave = _charToIndex(claveExpandida[i]);
        // Resta mod alfabeto
        int indiceDescifrado =
            (indiceTexto - indiceClave) % listaAlfabeto.length;
        // Corregir índice negativo
        if (indiceDescifrado < 0) {
          indiceDescifrado += listaAlfabeto.length;
        }
        resultado.write(_indexToChar(indiceDescifrado));
      }
    }
    return resultado.toString();
  }

  /// Retorna el alfabeto utilizado por el cifrador
  String getAlfabeto() => alfabeto;

  /// Verifica si un texto puede ser cifrado/descifrado completamente
  /// Retorna true si todos los caracteres están en el alfabeto
  bool puedeProcesamientoCompleto(String texto) {
    for (int i = 0; i < texto.length; i++) {
      if (_charToIndex(texto[i]) == -1) {
        return false;
      }
    }
    return true;
  }

  /// Retorna los caracteres del texto que no están en el alfabeto
  /// Útil para informar al usuario qué caracteres no serán cifrados
  List<String> caracteresNoSoportados(String texto) {
    Set<String> noSoportados = {};
    for (int i = 0; i < texto.length; i++) {
      String char = texto[i];
      if (_charToIndex(char) == -1) {
        noSoportados.add(char);
      }
    }
    return noSoportados.toList();
  }

  /// Valida si una clave es aceptable para el cifrado
  /// Retorna true si la clave no está vacía y todos sus caracteres están en el alfabeto
  bool esClaveValida(String clave) {
    if (clave.isEmpty) return false;

    for (int i = 0; i < clave.length; i++) {
      if (_charToIndex(clave[i]) == -1) {
        return false;
      }
    }
    return true;
  }

  /// Obtiene los caracteres no válidos de una clave
  /// Retorna una lista de caracteres que no están en el alfabeto
  List<String> caracteresNoValidosEnClave(String clave) {
    Set<String> noValidos = {};
    for (int i = 0; i < clave.length; i++) {
      String char = clave[i];
      if (_charToIndex(char) == -1) {
        noValidos.add(char);
      }
    }
    return noValidos.toList();
  }

  /// Genera una versión limpia de la clave, eliminando caracteres no válidos
  /// Retorna la clave con solo los caracteres presentes en el alfabeto
  String limpiarClave(String clave) {
    StringBuffer claveLimpia = StringBuffer();
    for (int i = 0; i < clave.length; i++) {
      if (_charToIndex(clave[i]) != -1) {
        claveLimpia.write(clave[i]);
      }
    }
    return claveLimpia.toString();
  }
}
