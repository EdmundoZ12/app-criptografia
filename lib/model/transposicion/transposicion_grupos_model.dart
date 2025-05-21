class GrupoTransposicion {
  /// La permutación utilizada para el cifrado
  final List<int> permutacion;

  /// La permutación inversa (calculada automáticamente)
  late final List<int> _permutacionInversa;

  /// El carácter usado para rellenar grupos incompletos
  final String caracterRelleno;

  /// Constructor con validación y precálculo de la permutación inversa
  ///
  /// [permutacion] - La permutación a usar (ej: [3,1,4,2])
  /// [caracterRelleno] - Carácter para rellenar grupos incompletos (por defecto 'X')
  GrupoTransposicion(this.permutacion, {this.caracterRelleno = 'X'}) {
    // Validar que la permutación sea válida
    _validarPermutacion();

    // Calcular la permutación inversa
    _calcularPermutacionInversa();
  }

  /// Valida que la permutación sea válida (números del 1 al n sin repetir)
  void _validarPermutacion() {
    final Set<int> numeros = {};
    final int n = permutacion.length;

    if (n == 0) {
      throw ArgumentError('La permutación no puede estar vacía');
    }

    for (int i = 0; i < n; i++) {
      if (permutacion[i] < 1 ||
          permutacion[i] > n ||
          numeros.contains(permutacion[i])) {
        throw ArgumentError(
            'Permutación inválida. Debe contener números del 1 al $n sin repetir');
      }
      numeros.add(permutacion[i]);
    }
  }

  /// Calcula la permutación inversa necesaria para el descifrado
  void _calcularPermutacionInversa() {
    final int n = permutacion.length;
    _permutacionInversa = List<int>.filled(n, 0);

    // Para cada posición i en la permutación original, calculamos
    // dónde debe ir ese elemento en la permutación inversa
    for (int i = 0; i < n; i++) {
      _permutacionInversa[permutacion[i] - 1] = i + 1;
    }
  }

  /// Divide un texto en grupos del tamaño de la permutación
  List<String> _dividirEnGrupos(String texto) {
    final int tamGrupo = permutacion.length;
    final List<String> grupos = [];

    for (int i = 0; i < texto.length; i += tamGrupo) {
      final int fin =
          (i + tamGrupo <= texto.length) ? i + tamGrupo : texto.length;
      grupos.add(texto.substring(i, fin));
    }

    return grupos;
  }

  /// Aplica una permutación a un grupo de texto
  String _aplicarPermutacion(String grupo, List<int> perm) {
    // Si el grupo está completo, aplicamos la permutación directamente
    if (grupo.length == perm.length) {
      final List<String> resultado = List<String>.filled(perm.length, '');

      for (int i = 0; i < perm.length; i++) {
        // El caracter en la posición i del grupo original
        // va a la posición perm[i]-1 en el resultado
        resultado[perm[i] - 1] = grupo[i];
      }

      return resultado.join('');
    }
    // Si el grupo está incompleto (último grupo), lo rellenamos primero
    else {
      // Solo rellenamos si el grupo no está completo - esto solo ocurre en el último grupo
      String grupoCompleto = grupo.padRight(perm.length, caracterRelleno);

      final List<String> resultado = List<String>.filled(perm.length, '');

      for (int i = 0; i < perm.length; i++) {
        resultado[perm[i] - 1] = grupoCompleto[i];
      }

      return resultado.join('');
    }
  }

  /// Cifra un texto usando la permutación definida
  ///
  /// [textoPlano] - El texto original a cifrar
  String cifrar(String textoPlano) {
    if (textoPlano.isEmpty) return '';

    // Dividir en grupos
    final List<String> grupos = _dividirEnGrupos(textoPlano);

    // Cifrar cada grupo
    final List<String> gruposCifrados = [];
    for (int i = 0; i < grupos.length; i++) {
      String grupoCifrado = _aplicarPermutacion(grupos[i], permutacion);
      gruposCifrados.add(grupoCifrado);
    }

    // Unir los grupos cifrados (siempre mantenemos todos los caracteres)
    return gruposCifrados.join('');
  }

  /// Descifra un texto usando la permutación inversa
  ///
  /// [textoCifrado] - El texto cifrado a descifrar
  /// [eliminarRelleno] - Si es true, elimina los caracteres de relleno al final
  String descifrar(String textoCifrado, {bool eliminarRelleno = false}) {
    if (textoCifrado.isEmpty) return '';

    final int tamGrupo = permutacion.length;

    // Asegurarse que la longitud del texto sea múltiplo del tamaño del grupo
    // Solo añadimos caracteres de relleno si es necesario
    String textoCompleto = textoCifrado;
    if (textoCompleto.length % tamGrupo != 0) {
      int caracteresAdicionales = tamGrupo - (textoCompleto.length % tamGrupo);
      textoCompleto += caracterRelleno * caracteresAdicionales;
    }

    // Dividir en grupos
    final List<String> grupos = _dividirEnGrupos(textoCompleto);

    // Descifrar cada grupo
    final List<String> gruposDescifrados = [];
    for (final grupo in grupos) {
      String grupoDescifrado = _aplicarPermutacion(grupo, _permutacionInversa);
      gruposDescifrados.add(grupoDescifrado);
    }

    // Unir los grupos descifrados
    String resultado = gruposDescifrados.join('');

    // Eliminar caracteres de relleno si se solicita
    if (eliminarRelleno) {
      // Eliminar caracteres de relleno al final del texto
      resultado = resultado.replaceAll(RegExp('$caracterRelleno*\$'), '');
    }

    return resultado;
  }

  /// Obtiene la permutación inversa calculada
  List<int> get permutacionInversa => List<int>.from(_permutacionInversa);

  /// Obtiene el tamaño del grupo (longitud de la permutación)
  int get tamanoGrupo => permutacion.length;

  @override
  String toString() {
    return 'GrupoTransposicion(permutacion: $permutacion, inversa: $_permutacionInversa)';
  }
}
