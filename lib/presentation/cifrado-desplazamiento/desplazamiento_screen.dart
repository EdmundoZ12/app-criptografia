import 'package:flutter/material.dart';

class DesplazamientoScreen extends StatelessWidget {
  static const name = 'desplazamiento_screen';

  const DesplazamientoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desplazamiento Screen'),
      ),
      body: Placeholder(),
    );
  }
}
