import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

final _bounds = LatLngBounds(
    const LatLng(41.3272, 19.8195), const LatLng(41.3276, 19.8201));

BuildingEntity _building(String id, {required int review}) => BuildingEntity(
      globalId: id,
      bldReview: review,
      coordinates: [
        [
          const LatLng(41.3273, 19.8196),
          const LatLng(41.3273, 19.8197),
          const LatLng(41.3274, 19.8197),
        ]
      ],
    );

class _FakeBuildingUseCases implements BuildingUseCases {
  @override
  Future<List<BuildingEntity>> getBuildings(
    LatLngBounds? bounds,
    double zoom,
    int municipalityId,
    bool isOffline,
    int? downloadId, {
    double? minZoom,
  }) async =>
      [
        _building('a', review: 6),
        _building('b', review: 1),
        _building('c', review: 1),
        _building('d', review: 6),
        _building('e', review: 1),
      ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAttributesCubit implements AttributesCubit {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDwellingCubit implements DwellingCubit {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeOutputLogsCubit implements OutputLogsCubit {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late BuildingCubit cubit;

  Future<void> loadZone() => cubit.getBuildings(_bounds, 19, 53, true, 1);

  List<String?> shownIds() => cubit.buildings.map((b) => b.globalId).toList();

  setUp(() {
    cubit = BuildingCubit(_FakeBuildingUseCases(), _FakeAttributesCubit(),
        _FakeDwellingCubit(), _FakeOutputLogsCubit());
  });

  tearDown(() => cubit.close());

  test('a legend filter keeps applying while the same map reloads', () async {
    await loadZone();
    expect(shownIds(), hasLength(5));

    // Legend tap on "Kërkohet rishikim" (review 6).
    cubit.filterBuildingsByLegends({'6'}, 'review');
    await loadZone();

    expect(shownIds(), ['a', 'd']);
  });

  test('a legend filter does not carry over to the next map screen', () async {
    await loadZone();
    cubit.filterBuildingsByLegends({'6'}, 'review');

    // What the map screen does when it opens.
    cubit.clearBuildings();
    expect(cubit.state, isA<Buildings>());
    expect(shownIds(), isEmpty);

    await loadZone();

    expect(cubit.state, isA<Buildings>());
    expect(shownIds(), ['a', 'b', 'c', 'd', 'e']);
  });
}
