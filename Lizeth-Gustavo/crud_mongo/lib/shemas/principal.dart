import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreen();
}

class _PrincipalScreen extends State<PrincipalScreen> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    cargarNombreUsuario();
  }

  void cargarNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? 'Invitado';
    setState(() {
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Bienvenido: $userName"),
    );
  }
}
