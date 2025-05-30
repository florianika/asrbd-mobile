import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/auth/decoded_jwt.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserService {
  DecodedJwt? userInfo;
  Future<DecodedJwt?> initialize() async {
    try {
      StorageService storageService = StorageService();
      final token = await storageService.getString(StorageKeys.idhToken);
      if (token == null) return null;

      Map<String, dynamic> decoded = JwtDecoder.decode(token);
      userInfo = DecodedJwt.fromMap(decoded);

      return userInfo;
    } catch (e) {
      // print('Error initializing schemas: $e');
      throw Exception('Failed to initialize schemas: $e');
    }
  }
}
