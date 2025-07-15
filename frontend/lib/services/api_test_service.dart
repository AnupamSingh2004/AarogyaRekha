import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/google_auth_config.dart';

class ApiTestService {
  static String get baseUrl => GoogleAuthConfig.apiBaseUrl;
  
  // Test backend connection
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      print('Testing backend connection to: $baseUrl');
      
      final response = await http.get(
        Uri.parse('$baseUrl/health/'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'status': response.statusCode,
          'data': data,
          'message': 'Backend connection successful'
        };
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'data': response.body,
          'message': 'Backend returned status ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Connection error: $e');
      return {
        'success': false,
        'status': 0,
        'data': null,
        'message': 'Connection failed: $e'
      };
    }
  }
  
  // Test authentication endpoint
  static Future<Map<String, dynamic>> testAuthEndpoint() async {
    try {
      print('Testing auth endpoint: $baseUrl/auth/');
      
      final response = await http.get(
        Uri.parse('$baseUrl/auth/'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      print('Auth endpoint response status: ${response.statusCode}');
      print('Auth endpoint response body: ${response.body}');
      
      return {
        'success': response.statusCode == 200 || response.statusCode == 405, // 405 is method not allowed but endpoint exists
        'status': response.statusCode,
        'data': response.body,
        'message': response.statusCode == 200 
          ? 'Auth endpoint accessible'
          : response.statusCode == 405 
            ? 'Auth endpoint exists (method not allowed is expected)'
            : 'Auth endpoint error'
      };
    } catch (e) {
      print('Auth endpoint error: $e');
      return {
        'success': false,
        'status': 0,
        'data': null,
        'message': 'Auth endpoint failed: $e'
      };
    }
  }
  
  // Test Google login endpoint
  static Future<Map<String, dynamic>> testGoogleLogin(String? idToken) async {
    if (idToken == null) {
      return {
        'success': false,
        'status': 0,
        'data': null,
        'message': 'No ID token provided'
      };
    }
    
    try {
      print('Testing Google login with backend...');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_token': idToken,
        }),
      ).timeout(const Duration(seconds: 15));
      
      print('Google login response status: ${response.statusCode}');
      print('Google login response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'status': response.statusCode,
          'data': data,
          'message': 'Google login successful'
        };
      } else {
        return {
          'success': false,
          'status': response.statusCode,
          'data': response.body,
          'message': 'Google login failed with status ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Google login error: $e');
      return {
        'success': false,
        'status': 0,
        'data': null,
        'message': 'Google login failed: $e'
      };
    }
  }
}
