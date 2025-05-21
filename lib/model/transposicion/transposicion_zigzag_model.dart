class ZigZagTransposicion {
  /// Método para cifrar un texto usando el algoritmo Rail Fence
  /// [texto] es el texto a cifrar
  /// [numRailes] es el número de raíles o filas a utilizar
  /// Retorna el texto cifrado
  String cifrar(String texto, int numRailes) {
    // Validaciones básicas
    if (texto.isEmpty) return "";
    if (numRailes <= 1) return texto; // Con 1 raíl no hay cambios
    if (numRailes >= texto.length)
      return texto; // Si hay más raíles que caracteres, no hay cambios

    // Inicializar matriz para las filas
    List<StringBuffer> railes = List.generate(numRailes, (_) => StringBuffer());

    // Variables para controlar dirección del zigzag
    int fila = 0;
    int direccion = 1; // 1: bajando, -1: subiendo

    // Distribuir caracteres en patrón zigzag
    for (int i = 0; i < texto.length; i++) {
      railes[fila].write(texto[i]);

      // Cambiar dirección si alcanzamos el primer o último raíl
      if (fila == 0) {
        direccion = 1;
      } else if (fila == numRailes - 1) {
        direccion = -1;
      }

      // Movernos a la siguiente fila
      fila += direccion;
    }

    // Concatenar todos los raíles para obtener el texto cifrado
    StringBuffer resultado = StringBuffer();
    for (var rail in railes) {
      resultado.write(rail.toString());
    }

    return resultado.toString();
  }

  /// Método para descifrar un texto cifrado con el algoritmo Rail Fence
  /// [textoCifrado] es el texto cifrado a descifrar
  /// [numRailes] es el número de raíles o filas utilizados en el cifrado
  /// Retorna el texto original descifrado
  String descifrar(String textoCifrado, int numRailes) {
    // Validaciones básicas
    if (textoCifrado.isEmpty) return "";
    if (numRailes <= 1) return textoCifrado;
    if (numRailes >= textoCifrado.length) return textoCifrado;

    // Crear una matriz para representar el zigzag
    List<List<int>> matriz = List.generate(
      numRailes,
      (_) => List.filled(textoCifrado.length, -1),
    );

    // Llenar la matriz con índices siguiendo el patrón zigzag
    int fila = 0;
    int direccion = 1;

    // Marcamos las posiciones donde irán los caracteres
    for (int i = 0; i < textoCifrado.length; i++) {
      matriz[fila][i] =
          0; // Marcamos con 0 las posiciones que tendrán caracteres

      if (fila == 0) {
        direccion = 1;
      } else if (fila == numRailes - 1) {
        direccion = -1;
      }

      fila += direccion;
    }

    // Contamos cuántos caracteres hay en cada fila
    List<int> caracteresEnFila = List.filled(numRailes, 0);
    for (int i = 0; i < numRailes; i++) {
      caracteresEnFila[i] = matriz[i].where((pos) => pos == 0).length;
    }

    // Distribuir los caracteres del texto cifrado en la matriz
    int indice = 0;
    for (int i = 0; i < numRailes; i++) {
      for (int j = 0; j < textoCifrado.length; j++) {
        if (matriz[i][j] == 0) {
          if (indice < textoCifrado.length) {
            matriz[i][j] = textoCifrado.codeUnitAt(indice++);
          }
        }
      }
    }

    // Reconstruir el mensaje original siguiendo el patrón zigzag
    StringBuffer resultado = StringBuffer();
    fila = 0;
    direccion = 1;

    for (int j = 0; j < textoCifrado.length; j++) {
      if (matriz[fila][j] > 0) {
        // Si hay un carácter válido
        resultado.writeCharCode(matriz[fila][j]);
      }

      if (fila == 0) {
        direccion = 1;
      } else if (fila == numRailes - 1) {
        direccion = -1;
      }

      fila += direccion;
    }

    return resultado.toString();
  }

  /// Método para visualizar cómo se distribuyen los caracteres en los raíles
  /// [texto] es el texto a visualizar
  /// [numRailes] es el número de raíles
  /// Retorna una representación visual de la matriz zigzag
  String visualizar(String texto, int numRailes) {
    if (texto.isEmpty) return "";
    if (numRailes <= 1) return texto;

    // Crear matriz para representar el zigzag
    List<List<String>> matriz = List.generate(
      numRailes,
      (_) => List.filled(texto.length, '.'),
    );

    // Llenar la matriz con los caracteres siguiendo el patrón zigzag
    int fila = 0;
    int direccion = 1;

    for (int i = 0; i < texto.length; i++) {
      matriz[fila][i] = texto[i];

      if (fila == 0) {
        direccion = 1;
      } else if (fila == numRailes - 1) {
        direccion = -1;
      }

      fila += direccion;
    }

    // Construir representación visual
    StringBuffer visual = StringBuffer();
    for (int i = 0; i < numRailes; i++) {
      visual.write('Raíl $i: ');
      for (int j = 0; j < texto.length; j++) {
        visual.write(matriz[i][j]);
      }
      visual.writeln();
    }

    // Añadir el texto cifrado resultante
    visual.writeln('\nTexto cifrado: ${cifrar(texto, numRailes)}');

    return visual.toString();
  }

  /// Método adicional para obtener la distribución de caracteres por raíl
  /// Útil para entender y depurar el proceso de cifrado
  /// [texto] es el texto a analizar
  /// [numRailes] es el número de raíles a utilizar
  /// Retorna una lista con los caracteres en cada raíl
  List<String> obtenerRailes(String texto, int numRailes) {
    if (texto.isEmpty) return List.filled(numRailes, '');
    if (numRailes <= 1) return [texto];

    // Inicializar raíles
    List<StringBuffer> railes = List.generate(numRailes, (_) => StringBuffer());

    // Variables para controlar dirección
    int fila = 0;
    int direccion = 1;

    // Distribuir caracteres en patrón zigzag
    for (int i = 0; i < texto.length; i++) {
      railes[fila].write(texto[i]);

      if (fila == 0) {
        direccion = 1;
      } else if (fila == numRailes - 1) {
        direccion = -1;
      }

      fila += direccion;
    }

    // Convertir StringBuffers a Strings
    return railes.map((sb) => sb.toString()).toList();
  }
}
