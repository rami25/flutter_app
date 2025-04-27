import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../models/client.dart';

class Api {
  final String apiBaseUrl = 'http://localhost:3000/api/pcd0/client';
  final storage = FlutterSecureStorage();

  Future<bool> signIn(UserCredentials credentials) async {
    final url = Uri.parse('$apiBaseUrl/sign-in');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['jwt']);
      print('Login successful');
      return true;
    } else {
      print('Login failed');
      return false;
    }
  }

  Future<bool> signUp(Client client) async {
    final url = Uri.parse('$apiBaseUrl/sign-up');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      print('sign successful');
      return true;
    } else {
      print('sign failed');
      return false;
    }
  }

  Future<ClientR> getReceipts() async {
    final token = await storage.read(key : 'token');
    final response = await http.get(
      Uri.parse('$apiBaseUrl/get-receipts'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          final clientJson = responseBody['client'];
          if (clientJson == null) {
            throw Exception('Client data not found in response');
          }
          return ClientR.fromJson(clientJson);
    } else {
      throw Exception('Failed to load client data');
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }
}