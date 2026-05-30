import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;

class AuthController extends GetxController {
  final Dio _dio = Dio();

  var message = "".obs;
  var isLoading = false.obs;
  var email = RxnString();
  var password = RxnString();
  var userToken = RxnString();
  var refreshToken = RxnString();
  var userId = RxnString();
  var id = RxnString();
  var role = RxnString();
  var name = RxnString();

  String get isUserid => userId.value ?? "No id";

  final String accounturl = "http://10.0.2.2:3000/api";

  Future<void> login(String email, String password) async {
    message.value = "";
    isLoading.value = true;

    try {
      final response = await _dio.post(
        "$accounturl/login",
        data: {'email': email, 'password': password},
      );

      final data = response.data;

      if (response.statusCode == 200) {
        message.value = data['message'] ?? "Login successful";
        userToken.value = data['token'];
        refreshToken.value = data['refreshtoken'];
        userId.value = data['userid']?.toString();
        role.value = data['role'];
        id.value = data['id']?.toString();
        name.value = data['name'];
        this.email.value = email; // Store email on success
      } else {
        message.value = data['error'] ?? data['message'] ?? "Login failed";
        userToken.value = null;
      }
    } on DioException catch (e) {
      // Check for 'error' field in backend response
      message.value = e.response?.data['error'] ?? 
                      e.response?.data['message'] ?? 
                      "Login failed: ${e.message}";
    } catch (e) {
      message.value = "Login failed: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async{
    final storage = Get.find<FlutterSecureStorage>();
    userToken.value = null;
    refreshToken.value = null;
    userId.value = null;
    id.value = null;
    role.value = null;
    name.value = null;
    email.value = null;
    password.value = null;
    message.value = "";
    // Navigation to login can be handled in the UI or here if Get is used
    await storage.deleteAll();
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
    String position,
  ) async {
    message.value = "";
    isLoading.value = true;

    try {
      final response = await _dio.post(
        "$accounturl/register",
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'position': position,
        },
      );

      final data = response.data;

      if (response.statusCode == 200) {
        message.value = "successfully";
        userId.value = data['userid']?.toString();
      } else {
        message.value = data['error'] ?? data['message'] ?? "Registration failed";
      }
    } on DioException catch (e) {
      message.value = e.response?.data['error'] ?? e.response?.data['message'] ?? e.message;
    } catch (e) {
      message.value = "Network failed: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
