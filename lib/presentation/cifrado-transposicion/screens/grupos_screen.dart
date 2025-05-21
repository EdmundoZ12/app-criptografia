import 'package:app_cripto/model/transposicion/transposicion_grupos_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GruposScreen extends StatefulWidget {
  static const name = 'grupos_screen';

  const GruposScreen({super.key});

  @override
  State<GruposScreen> createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _permutacionController = TextEditingController();
  final TextEditingController _caracterRellenoController =
      TextEditingController(text: 'X');
  late TabController _tabController;
  GrupoTransposicion? _cifrador;

  String _resultado = '';
  bool _mostrarResultado = false;
  bool _permutacionValida = false;
  bool _eliminarRelleno = false;
  List<int> _permutacionActual =
      []; // Lista para almacenar la permutación actual

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _permutacionController.addListener(_validarPermutacion);
    _caracterRellenoController.addListener(_actualizarCifrador);
  }

  void _validarPermutacion() {
    final entrada = _permutacionController.text;
    if (entrada.isEmpty) {
      setState(() {
        _permutacionValida = false;
        _cifrador = null;
        _permutacionActual = []; // Limpiar la permutación actual
      });
      return;
    }

    // Convertir entrada de texto a lista de enteros
    try {
      // Permitir varios formatos: "3,1,4,2" o "3142" o "3 1 4 2"
      final numeros = entrada
          .replaceAll(' ', ',')
          .replaceAll('-', ',')
          .split(',')
          .where((s) => s.isNotEmpty)
          .map((s) => int.parse(s))
          .toList();

      // Verificar si los números están en el rango correcto
      final n = numeros.length;
      final conjuntoNumeros = Set<int>.from(numeros);

      if (conjuntoNumeros.length == n && // No hay repetidos
          conjuntoNumeros.every((num) => num >= 1 && num <= n)) {
        // Rango correcto
        setState(() {
          _permutacionValida = true;
          _permutacionActual = numeros; // Guardar la permutación actual
          _actualizarCifrador();
        });
      } else {
        setState(() {
          _permutacionValida = false;
          _cifrador = null;
          _permutacionActual = []; // Limpiar la permutación actual
        });
      }
    } catch (e) {
      setState(() {
        _permutacionValida = false;
        _cifrador = null;
        _permutacionActual = []; // Limpiar la permutación actual
      });
    }
  }

  void _actualizarCifrador() {
    if (!_permutacionValida || _permutacionActual.isEmpty) return;

    try {
      // Crear el cifrador con la permutación actual
      setState(() {
        _cifrador = GrupoTransposicion(_permutacionActual,
            caracterRelleno: _caracterRellenoController.text.isEmpty
                ? 'X'
                : _caracterRellenoController.text[0]);
      });
    } catch (e) {
      setState(() {
        _cifrador = null;
      });
    }
  }

  void _procesarTexto() {
    if (_textoController.text.isEmpty || _permutacionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El texto y la permutación no pueden estar vacíos')),
      );
      return;
    }

    if (!_permutacionValida || _cifrador == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La permutación no es válida')),
      );
      return;
    }

    setState(() {
      if (_tabController.index == 0) {
        // Cifrar
        _resultado = _cifrador!.cifrar(_textoController.text);
      } else {
        // Descifrar
        _resultado = _cifrador!.descifrar(_textoController.text,
            eliminarRelleno: _eliminarRelleno);
      }
      _mostrarResultado = true;
    });
  }

  void _copiarAlPortapapeles() {
    Clipboard.setData(ClipboardData(text: _resultado));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copiado al portapapeles')),
    );
  }

  String _getInversa() {
    if (_cifrador == null || !_permutacionValida) {
      return 'N/A';
    }
    return _cifrador!.permutacionInversa.join(', ');
  }

  // Método para generar un ejemplo dinámico basado en la permutación actual
  Widget _generarEjemploDinamico() {
    if (_permutacionActual.isEmpty) {
      return const Text('Ingresa una permutación válida para ver un ejemplo.',
          style: TextStyle(fontStyle: FontStyle.italic));
    }

    // Tamaño del grupo basado en la permutación actual
    final tamGrupo = _permutacionActual.length;

    // Generar un texto de ejemplo de longitud suficiente para mostrar varios grupos
    String textoOriginal = 'EJEMPLO';
    // Añadir letras adicionales para completar al menos 3 grupos
    while (textoOriginal.length < tamGrupo * 3) {
      textoOriginal +=
          String.fromCharCode(65 + (textoOriginal.length % 26)); // A-Z
    }

    // Dividir en grupos
    List<String> grupos = [];
    for (int i = 0; i < textoOriginal.length; i += tamGrupo) {
      if (i + tamGrupo <= textoOriginal.length) {
        grupos.add(textoOriginal.substring(i, i + tamGrupo));
      } else {
        // Último grupo incompleto
        String grupo = textoOriginal.substring(i);
        grupo = grupo.padRight(tamGrupo, 'X'); // Rellenar con X
        grupos.add(grupo);
      }
    }

    // Aplicar la permutación a cada grupo
    List<String> gruposCifrados = [];
    for (String grupo in grupos) {
      StringBuffer nuevoGrupo = StringBuffer();
      for (int j = 0; j < tamGrupo; j++) {
        nuevoGrupo.write(grupo[_permutacionActual[j] - 1]);
      }
      gruposCifrados.add(nuevoGrupo.toString());
    }

    // Construir el texto cifrado
    String textoCifrado = gruposCifrados.join('');

    // Generamos la explicación paso a paso
    String pasosDivision = grupos.join(' - ');
    List<String> pasosPermutacion = [];

    for (int i = 0; i < grupos.length; i++) {
      String paso = '   - ${grupos[i]} → ${gruposCifrados[i]} (';
      paso += _permutacionActual.map((p) => '$p°').join(',');
      paso += ')';
      pasosPermutacion.add(paso);
    }

    String pasosUnion = gruposCifrados.join(' + ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Texto original:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(textoOriginal),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Tamaño de grupo:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text('$tamGrupo (longitud de la permutación)'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Permutación:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(_permutacionActual.join(', ')),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Texto cifrado:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(textoCifrado),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Proceso detallado:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '1. Dividir en grupos: $pasosDivision\n'
          '2. Aplicar permutación ${_permutacionActual.join('')} a cada grupo:\n'
          '${pasosPermutacion.join('\n')}\n'
          '3. Unir los grupos resultantes: $pasosUnion',
          style: TextStyle(height: 1.5, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Nota importante:',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
        const SizedBox(height: 8),
        const Text(
          'El cifrado siempre mantiene todos los caracteres necesarios para el descifrado correcto, '
          'incluyendo los caracteres de relleno cuando el último grupo está incompleto. '
          'Esto es esencial para garantizar que el descifrado funcione correctamente.',
          style: TextStyle(height: 1.5, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textoController.dispose();
    _permutacionController.dispose();
    _caracterRellenoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRANSPOSICIÓN POR GRUPOS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen decorativa
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4FF),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.swap_vert,
                  size: 60,
                  color: Color(0xFF00BCD4),
                ),
              ),
            ),

            // Selector de modo (cifrar/descifrar)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  // Pestaña CIFRAR
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(0);
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 0
                              ? const Color(0xFF2979FF)
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                          ),
                          border: const Border(
                            right: BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'CIFRAR',
                            style: TextStyle(
                              color: _tabController.index == 0
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Pestaña DESCIFRAR
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(1);
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 1
                              ? const Color(0xFF2979FF)
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            bottomLeft: Radius.zero,
                            topRight: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          border: const Border(
                            left: BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'DESCIFRAR',
                            style: TextStyle(
                              color: _tabController.index == 1
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Campo para texto
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      _tabController.index == 0
                          ? 'Texto a cifrar:'
                          : 'Texto a descifrar:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _textoController,
                    decoration: InputDecoration(
                      hintText: _tabController.index == 0
                          ? 'Ingresa el texto que deseas cifrar...'
                          : 'Ingresa el texto cifrado que deseas descifrar...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Color(0xFF3D5AFE), width: 2),
                      ),
                      prefixIcon: const Icon(Icons.text_fields),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),

            // Campo para permutación
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Permutación:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _permutacionController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa la permutación (ej: 3,1,4,2)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _permutacionValida ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.swap_horiz),
                      filled: true,
                      fillColor: Colors.white,
                      helperText:
                          'Define cómo se reordenan los caracteres en cada grupo',
                      helperStyle: TextStyle(fontStyle: FontStyle.italic),
                      suffixIcon: _permutacionValida
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.error, color: Colors.red),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),

            // Opciones adicionales
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configuración:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Carácter de relleno
                  Row(
                    children: [
                      const Text('Carácter de relleno:'),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _caracterRellenoController,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(),
                          ),
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          buildCounter: (context,
                                  {required currentLength,
                                  required isFocused,
                                  maxLength}) =>
                              null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Opciones para el modo descifrado
                  if (_tabController.index == 1) // Solo en modo descifrado
                    Row(
                      children: [
                        Checkbox(
                          value: _eliminarRelleno,
                          onChanged: (value) {
                            setState(() {
                              _eliminarRelleno = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF3D5AFE),
                        ),
                        const Text('Eliminar caracteres de relleno'),
                        Tooltip(
                          message:
                              'Si está activado, se intentará eliminar los caracteres de relleno del resultado.',
                          child: Icon(Icons.info_outline,
                              size: 16, color: Colors.grey),
                        ),
                      ],
                    ),

                  const SizedBox(height: 12),

                  // Permutación inversa (útil para descifrado)
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Permutación inversa:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getInversa(),
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: _permutacionValida
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Botón de acción
            ElevatedButton.icon(
              onPressed: _procesarTexto,
              icon: Icon(
                _tabController.index == 0 ? Icons.lock : Icons.lock_open,
                color: Colors.white,
              ),
              label: Text(
                _tabController.index == 0 ? 'CIFRAR TEXTO' : 'DESCIFRAR TEXTO',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D5AFE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                shadowColor: const Color(0xFF3D5AFE).withOpacity(0.5),
              ),
            ),

            // Área de resultado
            if (_mostrarResultado) ...[
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: _mostrarResultado ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4FF),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFF3D5AFE), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tabController.index == 0
                            ? 'TEXTO CIFRADO:'
                            : 'TEXTO DESCIFRADO:',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D5AFE),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _resultado,
                          style: const TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.2,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.copy),
                            label: const Text('Copiar'),
                            onPressed: _copiarAlPortapapeles,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF3D5AFE),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Información adicional - Ahora con ejemplo dinámico
            const SizedBox(height: 32),
            ExpansionTile(
              title: const Text(
                'INFORMACIÓN DEL CIFRADO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              collapsedBackgroundColor: Colors.grey[100],
              backgroundColor: Colors.grey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cifrado por Transposición por Grupos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'En este método, el texto se divide en grupos de tamaño igual a la longitud de la permutación y luego cada grupo se reordena siguiendo el patrón especificado. No altera los caracteres originales, solo cambia su posición.',
                        style: TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ejemplo con la permutación actual:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child:
                            _generarEjemploDinamico(), // Método que genera el ejemplo dinámico
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9C4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFBC02D)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '⚠️ Nota importante:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB71C1C),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Siempre se mantienen todos los caracteres necesarios para el descifrado correcto, incluyendo los caracteres de relleno cuando el último grupo está incompleto. El texto cifrado podría ser más largo que el original cuando el tamaño del texto no es múltiplo del tamaño del grupo.',
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
