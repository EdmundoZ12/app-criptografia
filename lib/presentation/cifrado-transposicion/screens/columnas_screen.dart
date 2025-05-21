import 'package:app_cripto/model/transposicion/transposicion_columnas_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColumnasScreen extends StatefulWidget {
  static const name = 'columnas_transposicion_screen';

  const ColumnasScreen({super.key});

  @override
  State<ColumnasScreen> createState() => _ColumnasScreenState();
}

class _ColumnasScreenState extends State<ColumnasScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _numColumnasController = TextEditingController();
  final TextEditingController _rellenoController = TextEditingController();
  late TabController _tabController;
  late ColumnasTransposicion _cifrador;

  String _resultado = '';
  bool _mostrarResultado = false;
  bool _parametrosValidos = false;
  bool _eliminarRelleno = true; // Para eliminar caracteres de relleno

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cifrador = ColumnasTransposicion();

    // Valor predeterminado para el carácter de relleno
    _rellenoController.text = 'X';

    // Validar parámetros cuando cambien
    _numColumnasController.addListener(_validarParametros);
    _rellenoController.addListener(_validarParametros);
  }

  void _validarParametros() {
    setState(() {
      // Verificar que el número de columnas sea válido (entero positivo)
      bool numColumnasValido = false;
      if (_numColumnasController.text.isNotEmpty) {
        try {
          int numColumnas = int.parse(_numColumnasController.text);
          numColumnasValido = numColumnas > 0;
        } catch (e) {
          numColumnasValido = false;
        }
      }

      // Verificar que el relleno sea un solo carácter
      bool rellenoValido = _rellenoController.text.length == 1;

      _parametrosValidos = numColumnasValido && rellenoValido;
    });
  }

  void _procesarTexto() {
    if (_textoController.text.isEmpty || _numColumnasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El texto y el número de columnas no pueden estar vacíos',
          ),
        ),
      );
      return;
    }

    if (!_parametrosValidos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El número de columnas debe ser un entero positivo y el relleno un solo carácter',
          ),
        ),
      );
      return;
    }

    int numColumnas = int.parse(_numColumnasController.text);
    String caracterRelleno = _rellenoController.text;

    setState(() {
      if (_tabController.index == 0) {
        // Cifrar
        _resultado = _cifrador.cifrar(
          _textoController.text,
          numColumnas,
          caracterRelleno,
        );
      } else {
        // Descifrar
        _resultado = _cifrador.descifrar(
          _textoController.text,
          numColumnas,
          eliminarRelleno: _eliminarRelleno,
          caracterRelleno: caracterRelleno,
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

  @override
  void dispose() {
    _tabController.dispose();
    _textoController.dispose();
    _numColumnasController.dispose();
    _rellenoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRANSPOSICIÓN POR COLUMNAS',
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
                  Icons.swap_horiz,
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
                          // Borde derecho negro que divide las opciones
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
                          // Borde izquierdo negro que divide las opciones
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

            // Campo para número de columnas
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Número de columnas:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _numColumnasController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Ingresa el número de columnas (ejemplo: 6)...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _parametrosValidos ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.view_column),
                      filled: true,
                      fillColor: Colors.white,
                      helperText:
                          'Define el número de columnas de la matriz de transposición',
                      helperStyle: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),

            // Campo para carácter de relleno (visible en ambas pestañas)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Carácter de relleno:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _rellenoController,
                    maxLength: 1,
                    decoration: InputDecoration(
                      hintText:
                          'Ingresa un carácter de relleno (por defecto: X)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _parametrosValidos ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.text_format),
                      filled: true,
                      fillColor: Colors.white,
                      helperText:
                          'Carácter para rellenar espacios vacíos en la matriz',
                      helperStyle: TextStyle(fontStyle: FontStyle.italic),
                      counterText: '', // Ocultar contador de caracteres
                    ),
                  ),
                ],
              ),
            ),

            // Opción para eliminar caracteres de relleno (solo en descifrado)
            if (_tabController.index == 1)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _eliminarRelleno,
                      onChanged: (value) {
                        setState(() {
                          _eliminarRelleno = value ?? true;
                        });
                      },
                      activeColor: const Color(0xFF3D5AFE),
                    ),
                    const Expanded(
                      child: Text(
                        'Eliminar caracteres de relleno en el resultado',
                        style: TextStyle(fontSize: 14),
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
                        'Cifrado por Transposición por Columnas',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Este método organiza el texto en una matriz con un número específico de columnas. El texto se escribe horizontalmente (por filas) y se lee verticalmente (por columnas) para obtener el texto cifrado. Para descifrar, se invierte el proceso.',
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text('QUE LA FUERZA TE ACOMPAÑE'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Número de columnas:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 3, child: Text('6')),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Relleno:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 3, child: Text('X')),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Matriz:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Q  U  E  L  A  F\n'
                                    'U  E  R  Z  A  T\n'
                                    'E  A  C  O  M  P\n'
                                    'A  Ñ  E  X  X  X',
                                    style: TextStyle(fontFamily: 'monospace'),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text('QUEAUEAÑERACELMZOAPFTXXX'),
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
