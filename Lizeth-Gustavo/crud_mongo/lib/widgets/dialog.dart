import 'package:crud_mongo/main.dart';
import 'package:flutter/material.dart';

void viewAlert(
  BuildContext context,
  String title,
  String message,
  VoidCallback onClose,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("Cerrar"),
            onPressed: () {
              Navigator.of(context).pop();
              onClose();
            },
          ),
        ],
      );
    },
  );
}

void viewSnackBar(BuildContext context, String title, String message, bool status) {
  final snackBar = SnackBar(
    content: Text(
      "$title: $message",
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: status ? Colors.green : Colors.red,
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void returnPageFetch(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
    ModalRoute.withName('/'),
  );
}
