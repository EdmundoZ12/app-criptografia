import 'package:app_cripto/model/transposicion/transposicion_series_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeriesScreen extends StatefulWidget {
  static const name = 'series_screen';

  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textoController = TextEditingController();
  late TabController _tabController;
  late SerieTransposicion _cifrador;

  String _resultado = '';
  bool _mostrarResultado = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cifrador = SerieTransposicion();
  }

  void _procesarTexto() {
    if (_textoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El texto no puede estar vacío')),
      );
      return;
    }

    setState(() {
      if (_tabController.index == 0) {
        // Cifrar
        _resultado = _cifrador.cifrar(_textoController.text);
      } else {
        // Descifrar
        try {
          _resultado = _cifrador.descifrar(_textoController.text);

          // Si estamos en modo de depuración, mostrar información adicional
          // (comentar esta línea para la versión final)
          // _resultado = _cifrador.depurarDescifrado(_textoController.text) + "\n\nTexto descifrado: " + _resultado;
        } catch (e) {
          _resultado = "Error al descifrar: $e";
        }
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

  // Método para generar un ejemplo según la configuración actual
  Widget _generarEjemploDinamico() {
    // Texto de ejemplo
    String textoOriginal = "HOLA MUNDO";

    // Cifrar el texto de ejemplo
    String textoCifrado = _cifrador.cifrar(textoOriginal);

    // Descifrar de vuelta como prueba
    String textoDescifrado = _cifrador.descifrar(textoCifrado);

    // Mostrar series utilizadas
    String seriesUtilizadas = _cifrador.mostrarSeries();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Este cifrado reordena los caracteres agrupándolos primero por series según su posición '
          'en el texto original. Luego se concatenan los caracteres en el siguiente orden: '
          'primero los de la Serie 1, luego los de la Serie 2, y finalmente los de la Serie 3.',
          style: TextStyle(height: 1.5),
        ),
        const SizedBox(height: 16),
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
                'Texto cifrado:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(flex: 3, child: Text(textoCifrado)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Descifrado:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                textoDescifrado,
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Series utilizadas:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            seriesUtilizadas,
            style: TextStyle(fontFamily: 'monospace'),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F4FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '📌 Procedimiento correcto:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Pasos para el cifrado:\n'
                '1. Eliminar los espacios del texto original\n'
                '2. Clasificar caracteres según la posición que ocupan:\n'
                '   - Serie 1: Posiciones impares no múltiplos de 5 (1, 3, 7, 9, ...)\n'
                '   - Serie 2: Posiciones pares no múltiplos de 5 (2, 4, 6, 8, ...)\n'
                '   - Serie 3: Posiciones múltiplos de 5 (5, 10, 15, ...)\n'
                '3. Concatenar los caracteres en este orden: Serie 1 + Serie 2 + Serie 3',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Nota importante:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Para descifrar correctamente, es fundamental conocer las series exactas y el orden en que se concatenan. '
          'Primero se extraen los caracteres de la Serie 1 (impares no múltiplos de 5), '
          'luego los de la Serie 2 (pares no múltiplos de 5), '
          'y finalmente los de la Serie 3 (múltiplos de 5).',
          style: TextStyle(
            height: 1.5,
            fontStyle: FontStyle.italic,
            color: Color(0xFF616161),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRANSPOSICIÓN POR SERIES',
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
                  Icons.functions,
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

            // Configuración básica
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Información de series utilizadas
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFBBDEFB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Series utilizadas (en orden de concatenación):',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '1. Serie 1: Posiciones impares no múltiplos de 5 (1, 3, 7, 9, ...)\n'
                          '2. Serie 2: Posiciones pares no múltiplos de 5 (2, 4, 6, 8, ...)\n'
                          '3. Serie 3: Posiciones múltiplos de 5 (5, 10, 15, 20, ...)',
                          style: TextStyle(height: 1.5),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Nota: Los caracteres se extraen y concatenan en este orden específico.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF616161),
                            fontSize: 12,
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

            // Información adicional
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
                  child: _generarEjemploDinamico(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
