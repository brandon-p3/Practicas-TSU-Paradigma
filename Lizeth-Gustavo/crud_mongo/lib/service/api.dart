import 'dart:convert';
import 'package:crud_mongo/model/personModel.dart';
import 'package:crud_mongo/utils/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Api {
  static Future<Map<String, dynamic>> checkBackEnd(Map pdata) async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      return jsonDecode(res.body);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return {
        "status": false,
        "message": "Excepción al conectar con el BackEnd",
      };
    }
  }

  static Future<Map<String, dynamic>> addPerson(Map pdata) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/record'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pdata),
      );

      return jsonDecode(res.body);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return {
        "status": false,
        "message": "Excepción al eliminar: ${e.toString()}",
      };
    }
  }

  static getPerson() async {
    List<Person> people = [];
    try {
      final res = await http.get(Uri.parse('$baseUrl/record'));
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);

        json['records'].forEach(
          (value) => {
            people.add(
              Person(
                id: value["_id"].toString(),
                name: value['name'],
                lastname: value['lastname'],
                mail: value['mail'],
                phone: value['phone'],
                password: value['password'],
                age: value['age'],
              ),
            ),
          },
        );
      }

      return people;
    } catch (e) {
      print(e.toString());
    }
  }

  static getPersonByName(pdata) async {
    List<Person> people = [];
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/record/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pdata),
      );
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);

        json['records'].forEach(
          (value) => {
            people.add(
              Person(
                id: value["_id"].toString(),
                name: value['name'],
                lastname: value['lastname'],
                mail: value['mail'],
                phone: value['phone'],
                password: value['password'],
              ),
            ),
          },
        );
      }

      return people;
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Map<String, dynamic>> updatePerson(id, body) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/record/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return jsonDecode(res.body);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return {
        "status": false,
        "message": "Excepción al eliminar: ${e.toString()}",
      };
    }
  }

  static Future<Map<String, dynamic>> deletePersona(id) async {
    var url = Uri.parse("$baseUrl/record/$id");
    try {
      final res = await http.delete(url);
      return jsonDecode(res.body);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return {
        "status": false,
        "message": "Excepción al eliminar: ${e.toString()}",
      };
    }
  }

  static Future<Map<String, dynamic>> login(body) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      var result = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var token = result['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken', token);
        if (token != null) {
          Map<String, dynamic> payload = Jwt.parseJwt(token);
          print(payload['name']);
          final name = payload['name'];
          await prefs.setString('userName', name);
        }
      }
      return jsonDecode(res.body);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return {
        "status": false,
        "message": "Excepcion al iniciar sesion: ${e.toString()}",
      };
    }
  }
}
