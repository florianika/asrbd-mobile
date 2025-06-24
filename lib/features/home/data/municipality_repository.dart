import 'package:asrdb/core/services/municipality_service.dart';

class MunicipalityRepository {
  final MunicipalityService municipalityService;

  MunicipalityRepository(this.municipalityService);

  Future<Map<String, dynamic>> getMunicipality(int municipalityId) async {
    return await municipalityService.getMunicipality(municipalityId);
  }
}
