// Submenu para las variantes de cifrado por transposición
import 'package:app_cripto/config/menu/menu_items.dart';

const transpositionMenuItems = <MenuItem>[
  MenuItem(
    title: 'Transposición por Grupos',
    subTitle: 'Reordenamiento basado en agrupaciones específicas',
    link: '/cifrado-transposicion/grupos',
    iconImage: 'assets/images/transposicion_images/imag1.png',
  ),
  MenuItem(
    title: 'Transposición por Series',
    subTitle: 'Reorganización secuencial siguiendo un patrón numérico',
    link: '/cifrado-transposicion/series',
    iconImage: 'assets/images/transposicion_images/imag2.png',
  ),
  MenuItem(
    title: 'Transposición por Filas',
    subTitle: 'Lectura horizontal y reescritura del texto en una matriz',
    link: '/cifrado-transposicion/filas',
    iconImage: 'assets/images/transposicion_images/imag3.png',
  ),
  MenuItem(
    title: 'Transposición en Zig-Zag',
    subTitle: 'Reorganización en patrón diagonal alternante',
    link: '/cifrado-transposicion/zigzag',
    iconImage: 'assets/images/transposicion_images/imag4.png',
  ),
  MenuItem(
    title: 'Transposición por Columnas',
    subTitle: 'Reorganización vertical del texto en una matriz',
    link: '/cifrado-transposicion/columnas',
    iconImage: 'assets/images/transposicion_images/imag5.png',
  ),
];
