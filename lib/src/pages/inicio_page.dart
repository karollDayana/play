import 'package:flutter/material.dart';

class InicioPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        backgroundColor: Colors.brown[400],
      ),
      body: Container(
        child: Text('INICIO'),
      ),
    );
  }
}