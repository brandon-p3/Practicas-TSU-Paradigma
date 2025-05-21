import 'package:crud_mongo/main.dart';
import 'package:crud_mongo/utils/fuctionGlobals.dart';
import 'package:crud_mongo/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:crud_mongo/service/api.dart';
import 'package:crud_mongo/model/personModel.dart';
import 'package:crud_mongo/widgets/dialog.dart';

class PersonFormScreen extends StatefulWidget {
  final Person? person;
  const PersonFormScreen({super.key, this.person});

  @override
  State<PersonFormScreen> createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _phoneController;
  late TextEditingController _mailController;
  late TextEditingController _passwordController;
  late TextEditingController _ageController;
  late TextEditingController _anotherController;

  bool _isLoading = false;
  bool _showAnother = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.person?.name ?? '');
    _lastnameController = TextEditingController(
      text: widget.person?.lastname ?? '',
    );
    _phoneController = TextEditingController(text: widget.person?.phone ?? '');
    _mailController = TextEditingController(text: widget.person?.mail ?? '');
    _passwordController = TextEditingController(
      text: widget.person?.password ?? '',
    );
    _ageController = TextEditingController(text: widget.person?.age ?? '');
    _anotherController = TextEditingController(text: widget.person?.another ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _mailController.dispose();
    _ageController.dispose();
    _anotherController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final data = {
      'name': _nameController.text.trim(),
      'lastname': _lastnameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'mail': _mailController.text.trim(),
      'pass': _passwordController.text.trim(),
      'age': _ageController.text.trim(),
      'another': _anotherController.text.trim(),
      //if (_anotherController == "true")
        //'another': _anotherController.text.trim(),
    };

    Map<String, dynamic> result;

    if (widget.person == null) {
      // Crear
      result = await Api.addPerson(data);
      print('Datos enviados: $data');
    } else {
      // Editar
      result = await Api.updatePerson(widget.person!.id, data);
    }

    setState(() => _isLoading = false);

    viewAlert(
      context,
      result['status'] ? 'Éxito' : 'Error',
      result['message'],
      () {
        //Solo si el resultado es TRUE regresa a la pagina Home
        if (result['status']) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.person != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Persona' : 'Crear Persona'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Ingrese el nombre'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(labelText: 'Apellido(s)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Ingrese el apellido'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el telefono';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Telefono invalido, debe ser 10 numeros';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _mailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el correo';
                    }
                    if (!RegExp(
                      r"^[^@\s]+@[^@\s]+\.[^@\s]+$",
                    ).hasMatch(value)) {
                      return 'Correo inválido usa el formato: "example@example.com"';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 24),
                CustomCalendar(
                  onDaySelected: (selectedDay) {
                    debugPrint("Día seleccionado: $selectedDay");
                    _ageController.text = calculateAge(selectedDay).toString();
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.visiblePassword,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _showAnother,
                      onChanged: (value) {
                        setState(() {
                          _showAnother = value!;
                        });
                      },
                    ),
                    const Text('Activar campo adicional'),
                    
                  ],
                ),
                if (_showAnother)
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _anotherController,
                        decoration:
                            const InputDecoration(labelText: 'Campo adicional'),
                        validator: (value) {
                          if (_showAnother &&
                              (value == null || value.isEmpty)) {
                            return 'Este campo es obligatorio si está activado';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: Text(
                      _isLoading
                          ? 'Procesando...'
                          : isEditing
                              ? 'Actualizar'
                              : 'Crear',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
