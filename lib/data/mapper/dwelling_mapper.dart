import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';


var uuid = const Uuid();

extension DwellingEntityToDrift on DwellingEntity {
  DwellingsCompanion toDriftDwelling(
      {int downloadId = 0, int recordStatus = RecordStatus.unmodified}) {
    return DwellingsCompanion(
      recordStatus: Value(recordStatus),
      globalId: globalId != null ? Value(globalId!) : Value(uuid.v4()),
      dwlEntGlobalId: dwlEntGlobalID != null
          ? Value(dwlEntGlobalID!)
          : Value('{00000000-0000-0000-0000-000000000000}'),
      objectId: Value(objectId),
      dwlAddressId: Value(dwlAddressID),
      dwlQuality: dwlQuality != null ? Value(dwlQuality!) : Value(9),
      dwlFloor: Value(dwlFloor),
      dwlApartNumber: Value(dwlApartNumber),
      dwlStatus: dwlStatus != null ? Value(dwlStatus!) : Value(4),
      dwlYearConstruction: Value(dwlYearConstruction),
      dwlYearElimination: Value(dwlYearElimination),
      dwlType: Value(dwlType),
      dwlOwnership: Value(dwlOwnership),
      dwlOccupancy: Value(dwlOccupancy),
      dwlSurface: Value(dwlSurface),
      dwlToilet: Value(dwlToilet),
      dwlBath: Value(dwlBath),
      dwlHeatingFacility: Value(dwlHeatingFacility),
      dwlHeatingEnergy: Value(dwlHeatingEnergy),
      dwlAirConditioner: Value(dwlAirConditioner),
      dwlSolarPanel: Value(dwlSolarPanel),
      geometryType: Value(geometryType),
      downloadId: Value(downloadId),
    );
  }
}

// Drift row -> Domain entity
extension DwellingRowToEntity on Dwelling {
  DwellingEntity toEntity() {
    return DwellingEntity(
      objectId: objectId,
      recordStatus: recordStatus,
      geometryType: geometryType,
      globalId: globalId,
      dwlEntGlobalID: dwlEntGlobalId,
      dwlAddressID: dwlAddressId,
      dwlQuality: dwlQuality,
      dwlFloor: dwlFloor,
      dwlApartNumber: dwlApartNumber,
      dwlStatus: dwlStatus,
      dwlYearConstruction: dwlYearConstruction,
      dwlYearElimination: dwlYearElimination,
      dwlType: dwlType,
      dwlOwnership: dwlOwnership,
      dwlOccupancy: dwlOccupancy,
      dwlSurface: dwlSurface,
      dwlToilet: dwlToilet,
      dwlBath: dwlBath,
      dwlHeatingFacility: dwlHeatingFacility,
      dwlHeatingEnergy: dwlHeatingEnergy,
      dwlAirConditioner: dwlAirConditioner,
      dwlSolarPanel: dwlSolarPanel,
    );
  }
}

extension DwellingEntityListToDrift on List<DwellingEntity> {
  List<DwellingsCompanion> toDriftDwellingList(int downloadId) {
    return map((entity) => entity.toDriftDwelling(downloadId: downloadId))
        .toList();
  }
}

extension DwellingListToEntity on List<Dwelling> {
  List<DwellingEntity> toEntityList() => map((e) => e.toEntity()).toList();
}
