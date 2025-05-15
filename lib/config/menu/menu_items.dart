class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final String iconImage;

  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.iconImage,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Cifrado de Desplazamiento',
    subTitle: 'Algoritmo de cifrado César y variantes',
    link: '/cifrado-desplazamiento',
    iconImage: 'assets/images/imag1.png',
  ),
  MenuItem(
    title: 'Cifrado por Transposición',
    subTitle: 'Reordenamiento de caracteres sin alterarlos',
    link: '/cifrado-transposicion',
    iconImage: 'assets/images/imag2.png',
  ),
  MenuItem(
    title: 'Cifrado por Sustitución',
    subTitle: 'Reemplazo sistemático de caracteres del texto',
    link: '/cifrado-sustitucion',
    iconImage: 'assets/images/imag3.png',
  ),
  MenuItem(
    title: 'Cifrado por Sustitución Monográmica Polialfabética',
    subTitle: 'Sistema Vigenère y cifrados polialfabéticos',
    link: '/cifrado-polialfabetico',
    iconImage: 'assets/images/imag4.png',
  ),
];
