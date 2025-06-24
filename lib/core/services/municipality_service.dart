import 'package:asrdb/core/api/municipality_api.dart';

class MunicipalityService {
  final MunicipalityApi municipalityApi;
  MunicipalityService(this.municipalityApi);

  Future<Map<String, dynamic>> getMunicipality(int municipalityId) async {
    try {
      final response = await municipalityApi.getMunicipality(municipalityId);
      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching municipality: ${mapData['error']['message']}');
        } else {
          return mapData;
        }
      } else {
        throw Exception('Get municipality');
      }
    } catch (e) {
      throw Exception('Get municipality: $e');
    }
  }
}
