import 'package:crud_mongo/shemas/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void closeSesion(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Navigator.pushAndRemoveUntil(
    // ignore: use_build_context_synchronously
    context,
    MaterialPageRoute(builder: (context) => Login()),
    (route) => false,
  );
}

int calculateAge(DateTime birthDate) {
  DateTime now = DateTime.now();
  int age = now.year - birthDate.year;

  if (now.month < birthDate.month ||
      (now.month == birthDate.month && now.day < birthDate.day)) {
    age--;
  }

  return age;
}
