import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/dto/dwelling_dto.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

// DTO -> DwellingsCompanion
extension DwellingDtoToDrift on DwellingDto {
  DwellingsCompanion toCompanion() {
    return DwellingsCompanion(
      globalId: Value(globalId ?? const Uuid().v4()),
      dwlEntGlobalId:
          Value(dwlEntGlobalID ?? '{00000000-0000-0000-0000-000000000000}'),
      dwlAddressId: Value.absentIfNull(dwlAddressID),
      dwlQuality: Value(dwlQuality ?? 9),
      dwlFloor: Value.absentIfNull(dwlFloor),
      dwlApartNumber: Value.absentIfNull(dwlApartNumber),
      dwlStatus: Value(dwlStatus ?? 4),
      dwlYearConstruction: Value.absentIfNull(dwlYearConstruction),
      dwlYearElimination: Value.absentIfNull(dwlYearElimination),
      dwlType: Value.absentIfNull(dwlType),
      dwlOwnership: Value.absentIfNull(dwlOwnership),
      dwlOccupancy: Value.absentIfNull(dwlOccupancy),
      dwlSurface: Value.absentIfNull(dwlSurface),
      dwlToilet: Value.absentIfNull(dwlToilet),
      dwlBath: Value.absentIfNull(dwlBath),
      dwlHeatingFacility: Value.absentIfNull(dwlHeatingFacility),
      dwlHeatingEnergy: Value.absentIfNull(dwlHeatingEnergy),
      dwlAirConditioner: Value.absentIfNull(dwlAirConditioner),
      dwlSolarPanel: Value.absentIfNull(dwlSolarPanel),
      geometryType: Value.absentIfNull(geometryType),
    );
  }
}

var uuid = const Uuid();

extension DwellingEntityToDrift on DwellingEntity {
  Dwelling toDriftDwelling(int downloadId) {
    return Dwelling(
      globalId: globalId ?? uuid.v4(),
      dwlEntGlobalId:
          dwlEntGlobalID ?? '{00000000-0000-0000-0000-000000000000}',
      dwlAddressId: dwlAddressID,
      dwlQuality: dwlQuality ?? 9,
      dwlFloor: dwlFloor,
      dwlApartNumber: dwlApartNumber,
      dwlStatus: dwlStatus ?? 4,
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
      geometryType: geometryType,
      downloadId: downloadId,
      id: 0,
    );
  }
}

// Drift row -> Domain entity
extension DwellingRowToEntity on Dwelling {
  DwellingEntity toEntity() {
    return DwellingEntity(
      objectId: id,
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
