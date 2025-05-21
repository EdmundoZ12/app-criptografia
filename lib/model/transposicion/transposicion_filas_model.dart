class FilasTransposicion {
  /// Método para cifrar texto usando transposición por filas
  /// [texto] es el texto a cifrar
  /// [numFilas] es el número de filas de la matriz
  /// [caracterRelleno] es el carácter usado para rellenar espacios vacíos
  String cifrar(String texto, int numFilas, String caracterRelleno) {
    // Trabajamos con el texto tal cual, incluyendo espacios
    int longitud = texto.length;
    int numColumnas = (longitud / numFilas).ceil();

    // Crear una matriz vacía con el tamaño adecuado
    List<List<String>> matriz = List.generate(
      numFilas,
      (_) => List.generate(numColumnas, (_) => caracterRelleno),
    );

    // Llenar la matriz por columnas con el texto (incluyendo espacios)
    int indice = 0;
    for (
      int columna = 0;
      columna < numColumnas && indice < longitud;
      columna++
    ) {
      for (int fila = 0; fila < numFilas && indice < longitud; fila++) {
        matriz[fila][columna] = texto[indice++];
      }
    }

    // Leer la matriz por filas para obtener el texto cifrado
    StringBuffer cifrado = StringBuffer();

    for (int fila = 0; fila < numFilas; fila++) {
      for (int columna = 0; columna < numColumnas; columna++) {
        cifrado.write(matriz[fila][columna]);
      }
    }

    return cifrado.toString();
  }

  /// Método para descifrar texto usando transposición por filas
  /// [textoCifrado] es el texto cifrado
  /// [numFilas] es el número de filas de la matriz
  /// [eliminarRelleno] indica si se deben eliminar los caracteres de relleno
  /// [caracterRelleno] es el carácter usado como relleno
  String descifrar(
    String textoCifrado,
    int numFilas, {
    bool eliminarRelleno = false,
    String caracterRelleno = 'X',
  }) {
    // Trabajamos con el texto cifrado tal cual
    int longitud = textoCifrado.length;
    int numColumnas = (longitud / numFilas).ceil();

    // Crear una matriz vacía
    List<List<String>> matriz = List.generate(
      numFilas,
      (_) => List.generate(numColumnas, (_) => ''),
    );

    // Llenar la matriz por filas con el texto cifrado
    int indice = 0;
    for (int fila = 0; fila < numFilas; fila++) {
      for (int columna = 0; columna < numColumnas; columna++) {
        if (indice < longitud) {
          matriz[fila][columna] = textoCifrado[indice++];
        }
      }
    }

    // Leer la matriz por columnas para obtener el texto original
    StringBuffer original = StringBuffer();

    for (int columna = 0; columna < numColumnas; columna++) {
      for (int fila = 0; fila < numFilas; fila++) {
        String caracter = matriz[fila][columna];
        // Si está habilitada la eliminación de relleno, no incluir caracteres de relleno
        if (!eliminarRelleno || caracter != caracterRelleno) {
          original.write(caracter);
        }
      }
    }

    return original.toString();
  }
}
