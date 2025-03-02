// import 'package:dio/dio.dart';
// import '../../core/constants/app_constants.dart';

// class ApiClient {
//   late final Dio _dio;

//   ApiClient() {
//     _dio = Dio(BaseOptions(
//       baseUrl: AppConstants.baseUrl,
//       connectTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
//       receiveTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
//     ));
    
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         // Add auth token if available
//         // Add other request modifications
//         return handler.next(options);
//       },
//       onResponse: (response, handler) {
//         // Handle response
//         return handler.next(response);
//       },
//       onError: (error, handler) {
//         // Handle errors
//         return handler.next(error);
//       },
//     ));
//   }

//   Future<Response> get(String path) async {
//     return await _dio.get(path);
//   }

//   Future<Response> post(String path, dynamic data) async {
//     return await _dio.post(path, data: data);
//   }
// }
