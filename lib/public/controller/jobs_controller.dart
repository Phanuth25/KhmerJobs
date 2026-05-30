import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:khmerjobs/public/model/jobs_model.dart';

class JobsController extends GetxController {
  final Dio _dio = Dio();

  var message = "".obs;
  var isLoading = false.obs;
  var jobs = <JobModel>[].obs;
  final String accounturl = "http://10.0.2.2:3000/api";

  Future<void> fetchjob() async {
    message.value = "";
    isLoading.value = true;

    try {
      final response = await _dio.get("$accounturl/jobs");

      final data = response.data;

      if (response.statusCode == 200) {
        message.value = data['message'] ?? "successful";

        // jobs.assignAll(
        //   data['data'].map((job) => JobModel.fromJson(job)).toList(),
        // );
        jobs.assignAll(
          (data['data'] as List).map((job) => JobModel.fromJson(job)).toList(),
        );
        print('Jobs received: ${jobs.length}');
      } else {
        message.value = data['error'] ?? data['message'] ?? "failed";
      }
    } on DioException catch (e) {
      // Check for 'error' field in backend response
      message.value =
          e.response?.data['error'] ??
          e.response?.data['message'] ??
          "failed: ${e.message}";
    } catch (e) {
      message.value = "Login failed: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
