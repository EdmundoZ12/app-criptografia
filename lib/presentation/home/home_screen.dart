import 'package:app_cripto/config/menu/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'ALGORITMOS CRIPTOGRÁFICOS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards por fila
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85, // Ajuste de proporción para las cards
        ),
        itemCount: appMenuItems.length,
        itemBuilder: (context, index) {
          final menuItem = appMenuItems[index];
          return _CryptoCard(menuItem: menuItem);
        },
      ),
    );
  }
}

class _CryptoCard extends StatelessWidget {
  const _CryptoCard({
    required this.menuItem,
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFE6F4FF), // Color azul claro similar a la imagen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          context.push(menuItem.link);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono de código binario similar a la imagen
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset(
                  menuItem.iconImage,
                  width: 50,
                  height: 50,
                  color: const Color(
                      0xFF00BCD4), // Color turquesa similar a la imagen
                ),
              ),
              const SizedBox(height: 12),
              // Título del cifrado
              Text(
                menuItem.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              // Botón VER con icono y efecto splash
              ElevatedButton.icon(
                onPressed: () {
                  // Efecto splash mejorado con una pequeña animación
                  final SnackBar snackBar = SnackBar(
                    content: Text('Accediendo a ${menuItem.title}...'),
                    duration: const Duration(milliseconds: 800),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  // Pequeño retraso para que se vea el efecto antes de navegar
                  Future.delayed(const Duration(milliseconds: 300), () {
                    // ignore: use_build_context_synchronously
                    context.push(menuItem.link);
                  });
                },
                icon: const Icon(
                  Icons.double_arrow, // Icono de "ver"
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  'VER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing:
                        1.0, // Espaciado entre letras para mejor legibilidad
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF3D5AFE), // Color azul del botón
                  foregroundColor: Colors.white,
                  minimumSize: const Size(90,
                      36), // Un poco más ancho y alto para acomodar el icono
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 3, // Sombra para efecto 3D
                  shadowColor:
                      // ignore: deprecated_member_use
                      Colors.blue.withOpacity(0.5), // Color de sombra azul
                  // Efecto splash personalizado
                  splashFactory: InkRipple.splashFactory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
