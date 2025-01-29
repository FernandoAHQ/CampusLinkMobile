import 'dart:convert';
import 'dart:io';

import 'package:campuslink/models/article.dart';
import 'package:campuslink/models/student.dart';
import 'package:campuslink/services/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class NetworkService {
  final baseUrl = URL;
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http.post(
          Uri.parse('$baseUrl/authentication/login/student'),
          body: {'email': email, 'password': password});
      Map response = jsonDecode(res.body) as Map<String, dynamic>;

      print(response);
      if (res.statusCode == 201) {
        String status = response['status'];
        String message = response['message'];
        String accessToken = response['accessToken'];
        await storage.write(key: 'accessToken', value: accessToken);
        final tkn = await storage.read(key: 'accessToken');
        print('accessToken: $tkn');
        Student student = Student.fromJson(response['user']);
        return {'loginResponse': status == 'successful', 'message': message};
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      print(e);
      return {'loginResponse': false, 'message': 'Unauthorized credentials'};
    }
  }

  Future<Map<String, dynamic>> renewToken() async {
    try {
      final storedToken = await storage.read(key: 'accessToken');

      if (storedToken == null) return {'loginResponse': false};

      final res = await http
          .get(Uri.parse('$baseUrl/authentication/renew/student'), headers: {
        HttpHeaders.authorizationHeader: 'Bearer $storedToken',
      });

      Map response = jsonDecode(res.body) as Map<String, dynamic>;

      print(response);
      if (res.statusCode == 200) {
        String status = response['status'];
        String accessToken = response['accessToken'];
        await storage.write(key: 'accessToken', value: accessToken);
        //Student student = Student.fromJson(response['user']);
        return {'renewResponse': status == 'successful'};
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      print(e);
      return {'renewResponse': false, 'message': 'Unauthorized credentials'};
    }
  }

  Future<List<Article>> fetchArticles() async {
    try {
      final storedToken = await storage.read(key: 'accessToken');

      //if (storedToken == null) return [];

      final res = await http.get(Uri.parse('$baseUrl/articles/all'), headers: {
        HttpHeaders.authorizationHeader: 'Bearer $storedToken',
      });

      Map response = jsonDecode(res.body) as Map<String, dynamic>;

      print(res.statusCode);
      if (res.statusCode == 200) {
        String status = response['status'];
        List<Article> articles =
            (response['data'] as List).map((e) => Article.fromJson(e)).toList();
        return articles;
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
