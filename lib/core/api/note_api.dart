import 'package:asrdb/core/api/api_client.dart';
import 'package:asrdb/core/api/api_endpoints.dart';
import 'package:asrdb/core/config/app_config.dart';
import 'package:dio/dio.dart';

class NoteApi {
  final ApiClient _apiClient = ApiClient(baseUrl: AppConfig.apiBaseUrl);

  
   Future<Response> getNotes(String authToken, String buildingGlobalId) async {
      Map<String, String> authHeader = <String, String>{
        "Authorization": 'Bearer $authToken',
      };
      _apiClient.setHeaders(authHeader);
      final fullUrl = '${ApiEndpoints.getNotes}$buildingGlobalId';

      return await _apiClient.get(fullUrl);
    }

Future<Response> postNote(String authToken, String buildingGlobalId, String noteText, String createdUser) async {
  _apiClient.setHeaders({
    "Authorization": 'Bearer $authToken',
  });

  return await _apiClient.post(
    ApiEndpoints.postNotes,
    data: {
      'bldId': buildingGlobalId,
      'noteText': noteText,
      'createdUser': createdUser,
    },
  );
 }
}
