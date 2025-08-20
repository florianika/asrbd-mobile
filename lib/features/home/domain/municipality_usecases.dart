import 'dart:convert';

import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/enums/service_mode.dart';
import 'package:asrdb/domain/entities/municipality_entity.dart';
import 'package:asrdb/features/home/data/municipality_repository.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';

class MunicipalityUseCases {
  final MunicipalityRepository _municipalityRepository;
  final StorageRepository _storageRepository;

  MunicipalityUseCases(this._municipalityRepository, this._storageRepository);

  Future<MunicipalityEntity?> getMunicipality(
      int municipalityId, ServiceMode serviceMode) async {
    if (serviceMode == ServiceMode.online) {
      final municipality =
          await _municipalityRepository.getMunicipality(municipalityId);

      final isCached = await _storageRepository.containsKey(
          boxName: HiveBoxes.municipality, key: municipalityId.toString());

      if (isCached != true) {
        await _storageRepository.saveMap(
            boxName: HiveBoxes.municipality,
            key: municipalityId.toString(),
            value: municipality.toMap());
      }

      return municipality;
    } else {
      final municipality = await _storageRepository.getMap(
        boxName: HiveBoxes.municipality,
        key: municipalityId.toString(),
      );

      return municipality != null
          ? MunicipalityEntity.fromMap(municipality)
          : null;
    }
  }
}
