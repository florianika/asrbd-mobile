import 'package:asrdb/core/api/municipality_api.dart';
import 'package:asrdb/data/dto/municipality_dto.dart';
import 'package:asrdb/domain/entities/municipality_entity.dart';

class MunicipalityService {
  final MunicipalityApi municipalityApi;
  MunicipalityService(this.municipalityApi);

  Future<MunicipalityEntity> getMunicipality(int municipalityId) async {
    try {
      final response = await municipalityApi.getMunicipality(municipalityId);

      if (response.statusCode == 200) {
        var mapData = response.data as Map<String, dynamic>;
        if (mapData.keys.contains('error')) {
          throw Exception(
              'Error fetching entrance details: ${mapData['error']['message']}');
        } else {
          final features = mapData['features'] as List<dynamic>? ?? [];
          if (features.isEmpty) throw Exception('No municipality area found!');

          final municipalityDto = MunicipalityDto.fromGeoJsonFeature(
              features[0] as Map<String, dynamic>);

          return municipalityDto.toEntity();
        }
      } else {
        throw Exception('Get municipality details error');
      }
      // if (response.statusCode == 200) {
      //   var mapData = response.data as Map<String, dynamic>;
      //   if (mapData.keys.contains('error')) {
      //     throw Exception(
      //         'Error fetching municipality: ${mapData['error']['message']}');
      //   } else {
      //     return mapData;
      //   }
      // } else {
      //   throw Exception('Get municipality');
      // }
    } catch (e) {
      throw Exception('Get municipality: $e');
    }
  }
}
