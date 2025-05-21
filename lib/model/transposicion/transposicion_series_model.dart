import 'dart:math' as Math;

class SerieTransposicion {
  /// Series para clasificar las posiciones
  final List<List<int>> _series = [[], [], []];

  /// Constructor principal
  SerieTransposicion() {
    _inicializarSeries();
  }

  /// Inicializa las tres series según el ejemplo
  void _inicializarSeries() {
    // Serie 1: Números impares que no son múltiplos de 5
    for (int i = 1; i < 1000; i += 2) {
      if (i % 5 != 0) {
        // No es múltiplo de 5
        _series[0].add(i);
      }
    }

    // Serie 2: Números pares que no son múltiplos de 5
    for (int i = 2; i < 1000; i += 2) {
      if (i % 5 != 0) {
        // No es múltiplo de 5
        _series[1].add(i);
      }
    }

    // Serie 3: Múltiplos de 5
    for (int i = 5; i < 1000; i += 5) {
      _series[2].add(i);
    }
  }

  /// Cifra un texto usando las series definidas y el orden según la tabla de ejemplo
  String cifrar(String textoPlano) {
    if (textoPlano.isEmpty) return '';

    // Convertir el texto a una lista de caracteres
    final List<String> caracteres = textoPlano.split('');

    // Longitud del texto original
    final int longitudTexto = caracteres.length;

    // Matrices para almacenar los caracteres por serie
    final List<List<String>> caracteresPorSerie = [[], [], []];

    // Clasificar cada carácter en su serie correspondiente
    for (int i = 0; i < longitudTexto; i++) {
      // La posición en el texto es i+1 (porque empezamos a contar desde 1)
      int posicion = i + 1;
      String caracter = caracteres[i];

      // Determinar a qué serie pertenece esta posición
      int numSerie;
      if (posicion % 5 == 0) {
        // Múltiplo de 5, va a la serie 3
        numSerie = 2;
      } else if (posicion % 2 == 1) {
        // Impar, va a la serie 1
        numSerie = 0;
      } else {
        // Par, va a la serie 2
        numSerie = 1;
      }

      // Agregar el carácter a su serie correspondiente
      caracteresPorSerie[numSerie].add(caracter);
    }

    // Construir el texto cifrado según el orden del ejemplo
    final StringBuffer resultado = StringBuffer();

    // Agregar primero todos los caracteres de la serie 1
    resultado.writeAll(caracteresPorSerie[0]);

    // Luego todos los de la serie 2
    resultado.writeAll(caracteresPorSerie[1]);

    // Finalmente todos los de la serie 3
    resultado.writeAll(caracteresPorSerie[2]);

    return resultado.toString();
  }

  /// Descifra un texto cifrado
  String descifrar(String textoCifrado) {
    if (textoCifrado.isEmpty) return '';

    // Contamos cuántas posiciones de cada serie hay en un texto del tamaño del cifrado
    final int longitudCifrado = textoCifrado.length;
    final List<int> cantidadPorSerie = [0, 0, 0];

    // Determinamos cuántos caracteres tiene cada serie para un texto de esta longitud
    for (int posicion = 1; posicion <= longitudCifrado; posicion++) {
      if (posicion % 5 == 0) {
        cantidadPorSerie[2]++; // Serie 3 (múltiplos de 5)
      } else if (posicion % 2 == 1) {
        cantidadPorSerie[0]++; // Serie 1 (impares no múltiplos de 5)
      } else {
        cantidadPorSerie[1]++; // Serie 2 (pares no múltiplos de 5)
      }
    }

    // Separamos el texto cifrado en sus componentes por serie
    int indiceActual = 0;
    List<List<String>> caracteresPorSerie = [[], [], []];

    // Serie 1
    for (
      int i = 0;
      i < cantidadPorSerie[0] && indiceActual < textoCifrado.length;
      i++
    ) {
      caracteresPorSerie[0].add(textoCifrado[indiceActual++]);
    }

    // Serie 2
    for (
      int i = 0;
      i < cantidadPorSerie[1] && indiceActual < textoCifrado.length;
      i++
    ) {
      caracteresPorSerie[1].add(textoCifrado[indiceActual++]);
    }

    // Serie 3
    for (
      int i = 0;
      i < cantidadPorSerie[2] && indiceActual < textoCifrado.length;
      i++
    ) {
      caracteresPorSerie[2].add(textoCifrado[indiceActual++]);
    }

    // Reconstruimos el texto original
    final List<String> textoOriginal = List.filled(longitudCifrado, '');
    int indice1 = 0, indice2 = 0, indice3 = 0;

    for (int posicion = 1; posicion <= longitudCifrado; posicion++) {
      if (posicion % 5 == 0 && indice3 < caracteresPorSerie[2].length) {
        textoOriginal[posicion - 1] = caracteresPorSerie[2][indice3++];
      } else if (posicion % 2 == 1 && indice1 < caracteresPorSerie[0].length) {
        textoOriginal[posicion - 1] = caracteresPorSerie[0][indice1++];
      } else if (indice2 < caracteresPorSerie[1].length) {
        textoOriginal[posicion - 1] = caracteresPorSerie[1][indice2++];
      }
    }

    return textoOriginal.join('');
  }

  /// Muestra las series actuales (útil para depuración)
  String mostrarSeries() {
    StringBuffer sb = StringBuffer();
    sb.writeln("Series utilizadas:");

    final List<String> nombresSeries = [
      "Serie 1 (Impares excepto múltiplos de 5)",
      "Serie 2 (Pares excepto múltiplos de 5)",
      "Serie 3 (Múltiplos de 5)",
    ];

    for (int i = 0; i < _series.length; i++) {
      String nombre = nombresSeries[i];
      sb.write('$nombre: ');
      // Mostrar solo los primeros 15 elementos o menos
      int numMostrar = _series[i].length < 15 ? _series[i].length : 15;
      sb.write(_series[i].sublist(0, numMostrar).join(', '));
      if (_series[i].length > 15) {
        sb.write(", ...");
      }
      sb.writeln();
    }
    return sb.toString();
  }

  /// Método de depuración para visualizar el proceso de cifrado
  String depurarCifrado(String textoPlano) {
    if (textoPlano.isEmpty) return 'Texto vacío';

    StringBuffer sb = StringBuffer();
    sb.writeln("Proceso de cifrado paso a paso:");
    sb.writeln("Texto original: \"$textoPlano\"");

    // Convertir el texto a una lista de caracteres
    final List<String> caracteres = textoPlano.split('');
    final int longitudTexto = caracteres.length;

    // Tabular las posiciones y caracteres
    sb.writeln("\nClasificación por posiciones:");
    sb.write("Posición: ");
    for (int i = 1; i <= longitudTexto; i++) {
      sb.write("${i.toString().padLeft(3)} ");
    }
    sb.writeln();

    sb.write("Carácter: ");
    for (int i = 0; i < longitudTexto; i++) {
      sb.write("${caracteres[i].padLeft(3)} ");
    }
    sb.writeln();

    sb.write("Serie:    ");
    for (int i = 1; i <= longitudTexto; i++) {
      String numSerie;
      if (i % 5 == 0) {
        numSerie = "S3";
      } else if (i % 2 == 1) {
        numSerie = "S1";
      } else {
        numSerie = "S2";
      }
      sb.write("${numSerie.padLeft(3)} ");
    }
    sb.writeln();

    // Clasificar cada carácter en su serie correspondiente
    List<List<String>> caracteresPorSerie = [[], [], []];

    for (int i = 0; i < longitudTexto; i++) {
      int posicion = i + 1;
      String caracter = caracteres[i];

      int numSerie;
      if (posicion % 5 == 0) {
        numSerie = 2; // Serie 3
      } else if (posicion % 2 == 1) {
        numSerie = 0; // Serie 1
      } else {
        numSerie = 1; // Serie 2
      }

      caracteresPorSerie[numSerie].add(caracter);
    }

    sb.writeln("\nCaracteres agrupados por serie:");
    for (int i = 0; i < 3; i++) {
      sb.writeln("Serie ${i + 1}: ${caracteresPorSerie[i].join(', ')}");
    }

    // Construir el resultado cifrado
    String cifrado =
        caracteresPorSerie[0].join() +
        caracteresPorSerie[1].join() +
        caracteresPorSerie[2].join();

    sb.writeln("\nTexto cifrado: \"$cifrado\"");

    return sb.toString();
  }

  /// Método de depuración para visualizar el proceso de descifrado
  String depurarDescifrado(String textoCifrado) {
    if (textoCifrado.isEmpty) return 'Texto cifrado vacío';

    StringBuffer sb = StringBuffer();
    sb.writeln("Proceso de descifrado paso a paso:");
    sb.writeln("Texto cifrado: \"$textoCifrado\"");

    final int longitudCifrado = textoCifrado.length;
    final List<int> cantidadPorSerie = [0, 0, 0];

    // Calcular cuántos caracteres corresponden a cada serie
    for (int posicion = 1; posicion <= longitudCifrado; posicion++) {
      if (posicion % 5 == 0) {
        cantidadPorSerie[2]++; // Serie 3
      } else if (posicion % 2 == 1) {
        cantidadPorSerie[0]++; // Serie 1
      } else {
        cantidadPorSerie[1]++; // Serie 2
      }
    }

    sb.writeln("\nDistribución de caracteres por serie:");
    sb.writeln(
      "Serie 1 (impares no múltiplos de 5): ${cantidadPorSerie[0]} caracteres",
    );
    sb.writeln(
      "Serie 2 (pares no múltiplos de 5): ${cantidadPorSerie[1]} caracteres",
    );
    sb.writeln("Serie 3 (múltiplos de 5): ${cantidadPorSerie[2]} caracteres");

    // Separar el texto cifrado en sus componentes por serie
    int indiceActual = 0;
    List<List<String>> caracteresPorSerie = [[], [], []];
    String serie1 = "", serie2 = "", serie3 = "";

    // Serie 1
    if (indiceActual < textoCifrado.length) {
      int fin = Math.min(
        indiceActual + cantidadPorSerie[0],
        textoCifrado.length,
      );
      serie1 = textoCifrado.substring(indiceActual, fin);
      for (int i = 0; i < serie1.length; i++) {
        caracteresPorSerie[0].add(serie1[i]);
      }
      indiceActual += serie1.length;
    }

    // Serie 2
    if (indiceActual < textoCifrado.length) {
      int fin = Math.min(
        indiceActual + cantidadPorSerie[1],
        textoCifrado.length,
      );
      serie2 = textoCifrado.substring(indiceActual, fin);
      for (int i = 0; i < serie2.length; i++) {
        caracteresPorSerie[1].add(serie2[i]);
      }
      indiceActual += serie2.length;
    }

    // Serie 3
    if (indiceActual < textoCifrado.length) {
      int fin = Math.min(
        indiceActual + cantidadPorSerie[2],
        textoCifrado.length,
      );
      serie3 = textoCifrado.substring(indiceActual, fin);
      for (int i = 0; i < serie3.length; i++) {
        caracteresPorSerie[2].add(serie3[i]);
      }
    }

    sb.writeln("\nTexto cifrado separado por serie:");
    sb.writeln("Serie 1: \"$serie1\"");
    sb.writeln("Serie 2: \"$serie2\"");
    sb.writeln("Serie 3: \"$serie3\"");

    // Reconstruir el texto original
    final List<String> textoOriginal = List.filled(longitudCifrado, '');
    int indice1 = 0, indice2 = 0, indice3 = 0;

    sb.writeln("\nReconstrucción del texto original:");
    sb.writeln("Posición | Serie | Carácter");
    sb.writeln("---------|-------|----------");

    for (int posicion = 1; posicion <= longitudCifrado; posicion++) {
      String serie, caracter;
      if (posicion % 5 == 0 && indice3 < caracteresPorSerie[2].length) {
        serie = "S3";
        caracter = caracteresPorSerie[2][indice3];
        textoOriginal[posicion - 1] = caracter;
        indice3++;
      } else if (posicion % 2 == 1 && indice1 < caracteresPorSerie[0].length) {
        serie = "S1";
        caracter = caracteresPorSerie[0][indice1];
        textoOriginal[posicion - 1] = caracter;
        indice1++;
      } else if (indice2 < caracteresPorSerie[1].length) {
        serie = "S2";
        caracter = caracteresPorSerie[1][indice2];
        textoOriginal[posicion - 1] = caracter;
        indice2++;
      } else {
        serie = "??";
        caracter = "?";
        textoOriginal[posicion - 1] = caracter;
      }

      sb.writeln(
        "${posicion.toString().padRight(9)} | ${serie.padRight(5)} | $caracter",
      );
    }

    sb.writeln("\nTexto descifrado: \"${textoOriginal.join('')}\"");

    return sb.toString();
  }
}
