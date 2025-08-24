import 'package:dio/dio.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/network/APIs/api_constants.dart';

class ApiService {
  ApiService() {
    sl<Dio>().options.baseUrl = ApiConstants.baseUrl;
    sl<Dio>().interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        error: true,
      ),
    );
  }

  Future<Response> get({required String path}) async {
    try {
      return await sl<Dio>().get(path);
    } on DioException catch (e) {
      throw e.message ?? "Something went wrong";
    }
  }

  Future<Response> post({required String path, required dynamic data}) async {
    try {
      return await sl<Dio>().post(path, data: data);
    } on DioException catch (e) {
      throw e.message ?? "Something went wrong";
    }
  }

  Future<Response> postheader({
    required String path,
    required dynamic data,
    required Map<String, String> headers,
  }) async {
    try {
      return await sl<Dio>().post(path, data: data);
    } on DioException catch (e) {
      throw e.message ?? "Something went wrong";
    }
  }

  Future<Response> update({required String path, required dynamic data}) async {
    try {
      return await sl<Dio>().put(path, data: data);
    } on DioException catch (e) {
      throw e.message ?? "Something went wrong";
    }
  }

  Future<Response> delete({required String path}) async {
    try {
      return await sl<Dio>().delete(path);
    } on DioException catch (e) {
      throw e.message ?? "Something went wrong";
    }
  }
}
