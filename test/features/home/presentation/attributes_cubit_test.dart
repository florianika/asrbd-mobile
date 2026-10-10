import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

const buildingId = '{71174217-2989-4A72-AEA0-4C5C4918A1A8}';
const entranceId = '{AA3FC17B-9889-446F-AFA6-0B3ADDB27391}';

class _FakeBuildingUseCases implements BuildingUseCases {
  @override
  Future<List<FieldSchema>> getBuildingAttibutes() async => [];

  @override
  Future<BuildingEntity> getBuildingDetails(
          String globalId, bool isOffline, int? downloadId) async =>
      BuildingEntity(
        globalId: globalId,
        coordinates: [
          [const LatLng(0, 0), const LatLng(0, 1), const LatLng(1, 1)]
        ],
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeEntranceUseCases implements EntranceUseCases {
  @override
  Future<List<FieldSchema>> getEntranceAttributes() async => [];

  @override
  Future<EntranceEntity> getEntranceDetails(
          String globalId, bool isOffline, int? downloadId) async =>
      EntranceEntity(
        globalId: globalId,
        entBldGlobalID: buildingId,
        coordinates: const LatLng(0.5, 0.5),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDwellingUseCases implements DwellingUseCases {
  @override
  Future<List<FieldSchema>> getDwellingAttibutes() async => [];

  @override
  Future<DwellingEntity> getDwellingDetails(
          int objectId, bool isOffline, int? downloadId) async =>
      DwellingEntity(objectId: objectId, dwlEntGlobalID: entranceId);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late AttributesCubit cubit;

  setUp(() {
    cubit = AttributesCubit(_FakeEntranceUseCases(), _FakeBuildingUseCases(),
        _FakeDwellingUseCases());
  });

  tearDown(() => cubit.close());

  // Leaves the building known only from the state, as happens when the
  // persistent building is cleared after the entrance form was opened.
  Future<void> selectEntranceWithoutPersistentBuilding() async {
    await cubit.showBuildingAttributes(buildingId, false, null);
    cubit.setPersistentBuilding(null);
    await cubit.showEntranceAttributes(entranceId, null, false, null,
        isNewlyCreated: true);

    expect(cubit.currentBuilding, isNull);
    expect(cubit.currentBuildingGlobalId, buildingId);
  }

  group('building and entrance survive opening the dwellings', () {
    test('when listing dwellings and adding a new one', () async {
      await selectEntranceWithoutPersistentBuilding();

      await cubit.showDwellingAttributes2(true);
      expect(cubit.currentBuildingGlobalId, buildingId);
      expect(cubit.currentEntranceGlobalId, entranceId);

      await cubit.showDwellingAttributes2(false);
      await cubit.showDwellingAttributes(null, false, null);
      expect(cubit.currentBuildingGlobalId, buildingId);
      expect(cubit.currentEntranceGlobalId, entranceId);
    });

    test('when opening an existing dwelling', () async {
      await selectEntranceWithoutPersistentBuilding();

      await cubit.showDwellingAttributes2(true);
      await cubit.showDwellingAttributes2(false);
      await cubit.showDwellingAttributes(1, false, null);
      expect(cubit.currentBuildingGlobalId, buildingId);
      expect(cubit.currentEntranceGlobalId, entranceId);
    });

    test('when the building is still persisted', () async {
      await cubit.showBuildingAttributes(buildingId, false, null);
      await cubit.showEntranceAttributes(entranceId, null, false, null);

      await cubit.showDwellingAttributes2(true);
      await cubit.showDwellingAttributes2(false);
      await cubit.showDwellingAttributes(null, false, null);
      expect(cubit.currentBuildingGlobalId, buildingId);
      expect(cubit.currentEntranceGlobalId, entranceId);
    });
  });
}
