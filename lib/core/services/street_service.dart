import 'package:asrdb/core/api/street_api.dart';
import 'package:asrdb/core/db/street_database.dart';
import 'package:asrdb/core/models/street/street.dart';
import 'package:asrdb/core/models/street/street_api_response.dart';

class StreetService {
  final StreetApi streetApi;
  StreetService(this.streetApi);

  Future<List<Street>> getStreets(int municipalityId) async {
    try {
      final response = await streetApi.getStreets(municipalityId);

      if (response.statusCode == 200) {
        return StreetApiResponse.fromJson(response.data).streets;
      } else {
        throw Exception('Get streets');
      }
    } catch (e) {
      throw Exception('Get streets: $e');
    }
  }

  void saveStreets(List<Street> streets) async {
    await StreetDatabase.insertStreetsBatch(streets);
  }

  Future<Street?> getStreetByGlobalId(String globalId) async {
    return await StreetDatabase.getStreetByGlobalId(globalId);
  }

  Future<void> clearAllStreets() async {
    await StreetDatabase.clearAllStreets();
  }
}
