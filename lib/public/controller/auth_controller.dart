import 'package:dio/dio.dart'; // Replaced http with dio
import 'package:get/get.dart' hide FormData;

class AuthController extends GetxController {
  // Initialize Dio instance
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
  double totalPoints = 0;

  String get isUserid => userId.value ?? "No id";

  // String accounturl = "http://localhost:5000/api"; do not remove this line
  final String accounturl = "http://10.0.2.2:3000/api";

  Future<void> login(String userid, String password) async {
    message.value = "";
    isLoading.value = true;

    try {
      final response = await _dio.post(
        "$accounturl/login",
        data: {'email': email, 'password': password},
      );

      // Dio automatically decodes JSON, so no need for json.decode()
      final data = response.data;

      if (response.statusCode == 200) {
        message.value = data['message'];
        userToken.value = data['token'];
        refreshToken.value = data['refreshtoken'];
        userId.value = data['userid']?.toString();
        role.value = data['role'];
        // ignore: avoid_print
        print("userid${userId.value}");
        id.value = data['id']?.toString();
      } else {
        message.value = data['message'];
        userToken.value = null;
      }
    } on DioException catch (e) {
      // Dio catches non-200 status codes as exceptions by default
      message.value =
          e.response?.data['message'] ?? "Login failed: ${e.message}";
    } catch (e) {
      message.value = "Login failed: $e";
    } finally {
      isLoading.value = false;
    }
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
        message.value =
            data['error'] ?? data['message'] ?? "Registration failed";
      }
    } on DioException catch (e) {
      message.value = e.response?.data['error'] ?? e.message;
    } catch (e) {
      message.value = "Network failed: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
