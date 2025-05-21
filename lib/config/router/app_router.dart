import 'package:app_cripto/presentation/cifrado-transposicion/screens.dart';
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

    // Rutas para los diferentes tipos de cifrado principales
    GoRoute(
      path: '/cifrado-desplazamiento',
      name: DesplazamientoScreen.name,
      builder: (context, state) => const DesplazamientoScreen(),
    ),

    GoRoute(
      path: '/cifrado-transposicion',
      name: TransposicionScreen.name,
      builder: (context, state) => const TransposicionScreen(),
    ),

    // Variantes de cifrado por transposición
    GoRoute(
      path: '/cifrado-transposicion/grupos',
      name: GruposScreen.name,
      builder: (context, state) => const GruposScreen(),
    ),

    GoRoute(
      path: '/cifrado-transposicion/series',
      name: SeriesScreen.name,
      builder: (context, state) => const SeriesScreen(),
    ),

    GoRoute(
      path: '/cifrado-transposicion/filas',
      name: FilasScreen.name,
      builder: (context, state) => const FilasScreen(),
    ),

    GoRoute(
      path: '/cifrado-transposicion/zigzag',
      name: ZigZagScreen.name,
      builder: (context, state) => const ZigZagScreen(),
    ),

    GoRoute(
      path: '/cifrado-transposicion/columnas',
      name: ColumnasScreen.name,
      builder: (context, state) => const ColumnasScreen(),
    ),

    GoRoute(
      path: '/cifrado-sustitucion',
      name: SustitucionScreen.name,
      builder: (context, state) => const SustitucionScreen(),
    ),

    GoRoute(
      path: '/cifrado-polialfabetico',
      name: PolialfabeticoScreen.name,
      builder: (context, state) => const PolialfabeticoScreen(),
    ),
  ],
);
