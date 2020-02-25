import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.brown[400],
      ),
      body: Container(
        child: Text('PERFIL'),
      ),
    );
  }
}