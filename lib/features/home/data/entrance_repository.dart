import 'package:asrdb/core/services/entrance_service.dart';

class EntranceRepository {
  final EntranceService entranceService;

  EntranceRepository(this.entranceService);

  // Login method
  Future<Map<String, dynamic>> getEntrances() async {
    return await entranceService.getEntrances();
  }
}
