import 'package:asrdb/data/dto/dwelling_dto.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:flutter_test/flutter_test.dart';

// Same path as saving the add-dwelling form: form values -> entity -> DTO ->
// the attributes sent to the feature service.
Map<String, dynamic> _attributesSentFor(Map<String, dynamic> formValues) {
  final dto = DwellingDto.fromEntity(DwellingEntity.fromMap(formValues));
  return dto.toGeoJsonFeature()['attributes'] as Map<String, dynamic>;
}

void main() {
  test('a dwelling saved without a type is sent as unknown, not collective',
      () {
    // The form only holds the fields the user touched.
    final attributes = _attributesSentFor({'DwlFloor': 1});

    // dm domain of DwlType: 9 = "Lloj i banesës i panjohur",
    // 4 = "Banesë kolektive".
    expect(attributes['DwlType'], 9);
  });

  test('a type chosen in the form is kept', () {
    expect(_attributesSentFor({'DwlType': 4})['DwlType'], 4);
    expect(_attributesSentFor({'DwlType': 2})['DwlType'], 2);
  });
}
