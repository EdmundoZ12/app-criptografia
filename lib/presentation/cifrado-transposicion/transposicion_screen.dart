import 'package:app_cripto/config/menu/menu_transposicion/transposicion_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class TransposicionScreen extends StatefulWidget {
  static const name = 'transposicion_screen';

  const TransposicionScreen({super.key});

  @override
  State<TransposicionScreen> createState() => _TransposicionScreenState();
}

class _TransposicionScreenState extends State<TransposicionScreen>
    with TickerProviderStateMixin {
  // Declaramos las variables sin late
  AnimationController? _backgroundController;
  AnimationController? _cardsController;
  List<Animation<double>> _cardAnimations = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Inicializamos los controladores
    _initControllers();

    _scrollController.addListener(() {
      setState(() {});
    });
  }

  void _initControllers() {
    // Controlador para la animación del fondo
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );

    // Controlador para las tarjetas
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Crear animaciones para cada tarjeta
    _cardAnimations = List.generate(
      transpositionMenuItems.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardsController!,
          curve: Interval(
            0.1 * index,
            0.1 * index + 0.6,
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );

    // Iniciar ambas animaciones
    _backgroundController!.repeat(reverse: false);
    _cardsController!.forward();
  }

  @override
  void dispose() {
    _backgroundController?.dispose();
    _cardsController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Lista de colores para cada método
  final List<List<Color>> _methodColors = [
    [Color(0xFF1A73E8), Color(0xFF4285F4)], // Azul eléctrico
    [Color(0xFF0F9D58), Color(0xFF34A853)], // Verde esmeralda
    [Color(0xFFF4B400), Color(0xFFFBBC05)], // Amarillo ámbar
    [Color(0xFFFA7B17), Color(0xFFF95F2D)], // Naranja coral
    [Color(0xFFDB4437), Color(0xFFEA4335)], // Rojo rubí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Encabezado animado con botón de retroceso
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                context.pop();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, Color(0xFF00BCD4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'TRANSPOSICIÓN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black87, Color(0xFF0D47A1)],
                  ),
                ),
                child: _buildAnimatedBackground(),
              ),
            ),
          ),

          // Contenido principal con tarjetas
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Texto explicativo
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 16),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Selecciona un método ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'de transposición',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0D47A1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tarjetas de métodos
                  ..._buildMethodCards(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Construir todas las tarjetas de método
  List<Widget> _buildMethodCards() {
    return List.generate(
      transpositionMenuItems.length,
      (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildMethodCard(index),
        );
      },
    );
  }

  // Fondo animado con letras en movimiento - Animación infinita
  Widget _buildAnimatedBackground() {
    if (_backgroundController == null) return Container();

    return Stack(
      children: List.generate(20, (index) {
        final random = math.Random();
        final double left = random.nextDouble() * 300;
        final double top = random.nextDouble() * 200;
        final double opacity =
            math.max(0.1, math.min(0.5, random.nextDouble() * 0.4 + 0.1));
        final double size = random.nextDouble() * 14 + 10;

        return Positioned(
          left: left,
          top: top,
          child: AnimatedBuilder(
            animation: _backgroundController!,
            builder: (context, child) {
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(
                    math.sin((_backgroundController!.value * math.pi * 2 +
                                index) %
                            (2 * math.pi)) *
                        15,
                    math.cos((_backgroundController!.value * math.pi * 2 +
                                index) %
                            (2 * math.pi)) *
                        15,
                  ),
                  child: Text(
                    "CRIPTOGRAFIA".split('')[index % 12],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Diseño de tarjeta para cada método - Animación solo una vez
  Widget _buildMethodCard(int index) {
    final menuItem = transpositionMenuItems[index];

    if (_cardsController == null) return Container();

    return AnimatedBuilder(
      animation: _cardAnimations[index],
      builder: (context, child) {
        final opacity =
            math.max(0.0, math.min(1.0, _cardAnimations[index].value));

        return Transform.translate(
          offset: Offset(
            0,
            (1 - opacity) * 50,
          ),
          child: Opacity(
            opacity: opacity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _showMethodDetails(context, index);
                },
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _methodColors[index],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _methodColors[index][0].withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icono del método
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            menuItem.iconImage,
                            // color: Colors.white24,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Información
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                menuItem.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Toca para explorar',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Flecha
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Modal para mostrar detalles del método antes de navegar
  void _showMethodDetails(BuildContext context, int index) {
    final menuItem = transpositionMenuItems[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              spreadRadius: 0,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado con degradado
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _methodColors[index],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  // Botón para cerrar
                  Positioned(
                    top: 20,
                    right: 20,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Título e icono
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            menuItem.iconImage,
                            width: 36,
                            height: 36,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            menuItem.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descripción',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: _methodColors[index][0],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      menuItem.subTitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Botones de acción (fijos en la parte inferior)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _methodColors[index][0]),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Volver',
                        style: TextStyle(
                          color: _methodColors[index][0],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(menuItem.link);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _methodColors[index][0],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                      ),
                      child: Text(
                        'Comenzar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
