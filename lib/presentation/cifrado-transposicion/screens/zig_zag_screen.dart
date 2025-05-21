import 'package:app_cripto/model/transposicion/transposicion_zigzag_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZigZagScreen extends StatefulWidget {
  static const name = 'zigzag_screen';

  const ZigZagScreen({super.key});

  @override
  State<ZigZagScreen> createState() => _ZigZagScreenState();
}

class _ZigZagScreenState extends State<ZigZagScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _numRailesController = TextEditingController(
    text: '3',
  );
  late TabController _tabController;
  ZigZagTransposicion? _cifrador;

  String _resultado = '';
  bool _mostrarResultado = false;
  bool _numRailesValido = true;
  int _numRailesActual = 3; // Valor por defecto

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _numRailesController.addListener(_validarNumRailes);
    _actualizarCifrador(); // Inicializar con el valor por defecto
  }

  void _validarNumRailes() {
    final entrada = _numRailesController.text;
    if (entrada.isEmpty) {
      setState(() {
        _numRailesValido = false;
        _cifrador = null;
      });
      return;
    }

    try {
      int numRailes = int.parse(entrada);
      if (numRailes >= 2) {
        // El cifrado Rail Fence requiere al menos 2 raíles
        setState(() {
          _numRailesValido = true;
          _numRailesActual = numRailes;
          _actualizarCifrador();
        });
      } else {
        setState(() {
          _numRailesValido = false;
          _cifrador = null;
        });
      }
    } catch (e) {
      setState(() {
        _numRailesValido = false;
        _cifrador = null;
      });
    }
  }

  void _actualizarCifrador() {
    if (!_numRailesValido || _numRailesActual < 2) return;

    try {
      // Crear el cifrador con el número de raíles actual
      setState(() {
        _cifrador = ZigZagTransposicion();
      });
    } catch (e) {
      setState(() {
        _cifrador = null;
      });
    }
  }

  void _procesarTexto() {
    if (_textoController.text.isEmpty || !_numRailesValido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El texto no puede estar vacío y el número de raíles debe ser válido',
          ),
        ),
      );
      return;
    }

    setState(() {
      if (_tabController.index == 0) {
        // Cifrar
        _resultado = _cifrador!.cifrar(_textoController.text, _numRailesActual);
      } else {
        // Descifrar
        _resultado = _cifrador!.descifrar(
          _textoController.text,
          _numRailesActual,
        );
      }
      _mostrarResultado = true;
    });
  }

  void _copiarAlPortapapeles() {
    Clipboard.setData(ClipboardData(text: _resultado));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copiado al portapapeles')));
  }

  // Método para generar un ejemplo dinámico basado en el número de raíles actual
  Widget _generarEjemploDinamico() {
    if (_numRailesActual < 2) {
      return const Text(
        'Ingresa un número de raíles válido para ver un ejemplo.',
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    }

    // Generar un texto de ejemplo
    String textoOriginal = 'RAILFENCE';

    // Obtener visualización zigzag
    String visualizacion = '';
    if (_cifrador != null) {
      visualizacion = _cifrador!.visualizar(textoOriginal, _numRailesActual);
    }

    // Obtener texto cifrado
    String textoCifrado = '';
    if (_cifrador != null) {
      textoCifrado = _cifrador!.cifrar(textoOriginal, _numRailesActual);
    }

    // Obtener raíles (para mostrar el contenido por raíl)
    List<String> railes = [];
    if (_cifrador != null) {
      railes = _cifrador!.obtenerRailes(textoOriginal, _numRailesActual);
    }

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
            Expanded(flex: 3, child: Text(textoOriginal)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Número de raíles:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(flex: 3, child: Text('$_numRailesActual')),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Distribución en zigzag:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(visualizacion, style: TextStyle(fontFamily: 'monospace')),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Contenido por raíl:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < railes.length; i++)
                    Text(
                      'Raíl $i: "${railes[i]}"',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                ],
              ),
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
            Expanded(flex: 3, child: Text(textoCifrado)),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Proceso de cifrado:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '1. Distribuir los caracteres en patrón zigzag entre $_numRailesActual raíles\n'
          '2. Leer el contenido de cada raíl (fila) de arriba hacia abajo\n'
          '3. Concatenar el contenido de todos los raíles para formar el texto cifrado',
          style: TextStyle(height: 1.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'Nota:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'El cifrado Rail Fence es un método de transposición que no altera los caracteres, solo cambia su posición. La seguridad aumenta con mayor número de raíles, pero sigue siendo un cifrado clásico con limitaciones de seguridad para estándares modernos.',
          style: TextStyle(height: 1.5, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textoController.dispose();
    _numRailesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CIFRADO RAIL FENCE (ZIGZAG)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  Icons.linear_scale,
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
                          color:
                              _tabController.index == 0
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
                              color:
                                  _tabController.index == 0
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
                          color:
                              _tabController.index == 1
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
                              color:
                                  _tabController.index == 1
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
                      hintText:
                          _tabController.index == 0
                              ? 'Ingresa el texto que deseas cifrar...'
                              : 'Ingresa el texto cifrado que deseas descifrar...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFF3D5AFE),
                          width: 2,
                        ),
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

            // Campo para número de raíles
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Número de raíles:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _numRailesController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa el número de raíles (mínimo 2)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _numRailesValido ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.view_week),
                      filled: true,
                      fillColor: Colors.white,
                      helperText:
                          'Define cuántas filas se usarán en el patrón zigzag',
                      helperStyle: TextStyle(fontStyle: FontStyle.italic),
                      suffixIcon:
                          _numRailesValido
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : Icon(Icons.error, color: Colors.red),
                    ),
                    keyboardType: TextInputType.number,
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
                    border: Border.all(
                      color: const Color(0xFF3D5AFE),
                      width: 1,
                    ),
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

            // Información adicional - Ejemplo dinámico
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
                        'Cifrado Rail Fence (Zigzag)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'En este método, las letras del texto se escriben en un patrón zigzag (subiendo y bajando) entre un número específico de filas o "raíles". Luego, el texto cifrado se obtiene leyendo las filas de izquierda a derecha, de arriba hacia abajo.',
                        style: TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ejemplo con $_numRailesActual raíles:',
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
                        child: _generarEjemploDinamico(),
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
                              '⚠️ Dato histórico:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB71C1C),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'El cifrado Rail Fence se utilizó durante la Guerra de Secesión estadounidense debido a su simplicidad. A pesar de no ser un cifrado muy seguro, era fácil de implementar en el campo de batalla sin necesidad de equipos especiales.',
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
