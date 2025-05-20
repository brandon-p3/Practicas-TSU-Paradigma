import 'package:crud_mongo/service/api.dart';
import 'package:crud_mongo/shemas/bottomnavbar.dart';
import 'package:crud_mongo/widgets/dialog.dart';
import 'package:flutter/material.dart';

// Asegúrate de tener esta clase definida en otro archivo o en este mismo archivo.
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  Login({super.key});

  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  void clearFields() {
    mailController.clear();
    passwordController.clear();
  }

  Future<void> accessLogin(BuildContext context) async {
    final data = {
      'mail': mailController.text,
      'password': passwordController.text,
    };

    try {
      final result = await Api.login(data);

      if (result['status'] == true) {
        viewAlert(
          context,
          result['status'] ? 'Éxito' : 'Error',
          result['message'],
          () {
            if (result['status']) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()),
                (route) => false,
              );
            }
          },
        );
      } else {
        viewSnackBar(
          context,
          result['status'] ? 'Éxito' : 'Error',
          result['message'],
          result['status'],
        );
      }
    } catch (e) {
      viewAlert(context, 'Error', 'Error al conectar con el servidor', () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 245, 233),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                Image.asset(
                  //Imagen
                  'assets/images/pou_truste.jpg',
                  height: 100,
                ),
                const SizedBox(height: 20),

                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 25),

                Text(
                  'Bienvenido',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                MyTextField(
                  controller: mailController,
                  hintText: 'Correo',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => accessLogin(context),
                        child: const Text('Iniciar Sesión'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          clearFields();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300],
                        ),
                        child: const Text('Limpiar'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
