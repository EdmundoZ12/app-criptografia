import 'package:app_cripto/presentation/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),

    // Rutas para los diferentes tipos de cifrado
    GoRoute(
      path: '/cifrado-desplazamiento',
      name: 'CifradoDesplazamiento',
      builder: (context, state) => const DesplazamientoScreen(),
    ),

    GoRoute(
      path: '/cifrado-transposicion',
      name: 'CifradoTransposicion',
      builder: (context, state) => const TransposicionScreen(),
    ),

    GoRoute(
      path: '/cifrado-sustitucion',
      name: 'CifradoSustitucion',
      builder: (context, state) => const SustitucionScreen(),
    ),

    GoRoute(
      path: '/cifrado-polialfabetico',
      name: 'CifradoPolialfabetico',
      builder: (context, state) => const PolialfabeticoScreen(),
    ),
  ],
);
