import 'package:app_cripto/model/desplazamiento/desplazamiento_clave_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DesplazamientoScreen extends StatefulWidget {
  static const name = 'desplazamiento_screen';

  const DesplazamientoScreen({super.key});

  @override
  State<DesplazamientoScreen> createState() => _DesplazamientoScreenState();
}

class _DesplazamientoScreenState extends State<DesplazamientoScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  late TabController _tabController;
  late CifraDesplazamientoClave _cifrador;

  String _resultado = '';
  bool _usarEspanol = true;
  bool _mostrarResultado = false;
  bool _claveValida = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cifrador = CifraDesplazamientoClave(tipoAlfabeto: 'español');

    _claveController.addListener(_validarClave);
  }

  void _validarClave() {
    setState(() {
      _claveValida = _claveController.text.isNotEmpty &&
          _cifrador.esClaveValida(_claveController.text);
    });
  }

  void _procesarTexto() {
    if (_textoController.text.isEmpty || _claveController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El texto y la clave no pueden estar vacíos')),
      );
      return;
    }

    if (!_claveValida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('La clave contiene caracteres no válidos')),
      );
      return;
    }

    setState(() {
      if (_tabController.index == 0) {
        // Cifrar
        _resultado =
            _cifrador.cifrar(_textoController.text, _claveController.text);
      } else {
        // Descifrar
        _resultado =
            _cifrador.descifrar(_textoController.text, _claveController.text);
      }
      _mostrarResultado = true;
    });
  }

  void _cambiarAlfabeto(bool esEspanol) {
    setState(() {
      _usarEspanol = esEspanol;
      _cifrador = CifraDesplazamientoClave(
          tipoAlfabeto: esEspanol ? 'español' : 'estándar');
      _validarClave();
    });
  }

  void _copiarAlPortapapeles() {
    Clipboard.setData(ClipboardData(text: _resultado));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copiado al portapapeles')),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textoController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CIFRADO DE DESPLAZAMIENTO',
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
                  Icons.enhanced_encryption,
                  size: 60,
                  color: Color(0xFF00BCD4),
                ),
              ),
            ),

            // Selector de modo (cifrar/descifrar)
            // TabBar mejorado con división clara y bordes negros
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
                          // Borde derecho negro que divide las opciones
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
                          // Borde izquierdo negro que divide las opciones
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

            // Campo para clave
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Palabra clave:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _claveController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa la clave para el cifrado...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _claveValida ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.key),
                      filled: true,
                      fillColor: Colors.white,
                      helperText:
                          'La clave define cuánto se desplaza cada letra',
                      helperStyle: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),

            // Selector de alfabeto
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
                    'Alfabeto:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _usarEspanol,
                        onChanged: (value) => _cambiarAlfabeto(true),
                        activeColor: const Color(0xFF3D5AFE),
                      ),
                      const Text('Español (A-Z, Ñ)'),
                      const SizedBox(width: 16),
                      Radio<bool>(
                        value: false,
                        groupValue: _usarEspanol,
                        onChanged: (value) => _cambiarAlfabeto(false),
                        activeColor: const Color(0xFF3D5AFE),
                      ),
                      const Text('Estándar (A-Z)'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Alfabeto actual: ${_cifrador.getAlfabeto()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'monospace',
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
                // ignore: deprecated_member_use
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
                        // ignore: deprecated_member_use
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
                          const SizedBox(width: 8),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'El cifrado de desplazamiento con palabra clave (Vigenère)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Este método utiliza una palabra clave para determinar el desplazamiento variable de cada letra del texto. Cada letra de la clave indica cuántas posiciones se debe desplazar la letra correspondiente del texto original en el alfabeto.',
                        style: TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ejemplo:',
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Texto original:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text('HOLA'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Clave:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text('CLAVE'),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text('JZLV'),
                                ),
                              ],
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
