import 'package:asrdb/core/services/municipality_service.dart';
import 'package:asrdb/domain/entities/municipality_entity.dart';

class MunicipalityRepository {
  final MunicipalityService municipalityService;

  MunicipalityRepository(this.municipalityService);

  Future<MunicipalityEntity> getMunicipality(int municipalityId) async {
    return await municipalityService.getMunicipality(municipalityId);
  }
}
