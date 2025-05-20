import 'package:flutter/material.dart';

class PantallaExtra extends StatefulWidget {
  const PantallaExtra({super.key});

  @override
  State<PantallaExtra> createState() => _PantallaExtraState();
}

class _PantallaExtraState extends State<PantallaExtra> {
  bool isChecked = false;
  final TextEditingController _textController = TextEditingController();
  
  void _mostrarDialogo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mensaje'),
        content: const Text('¡Hola!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Extra'),
      ),
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/pou_truste.jpg',
                height: 300,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text("Texto 1"),
                Text("Texto 2"),
                Text("Texto 3"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                
              ],
            ),
            const SizedBox(height: 20),
                TextField(
                  controller: _textController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Escribe algo...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _mostrarDialogo,
                    icon: const Icon(Icons.message),
                    label: const Text('Botón 1'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _mostrarDialogo,
                    icon: const Icon(Icons.add),
                    label: const Text('Botón 2'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _mostrarDialogo,
                    icon: const Icon(Icons.access_alarm_rounded),
                    label: const Text('Botón 3'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
