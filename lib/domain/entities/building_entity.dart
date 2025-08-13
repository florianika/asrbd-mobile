// lib/domain/entities/building_entity.dart
import 'package:latlong2/latlong.dart';

class BuildingEntity {
  final int objectId;
  final int? featureId;
  final String? geometryType;
  final List<List<LatLng>> coordinates;

  final double? shapeLength;
  final double? shapeArea;
  final String? globalId;
  final String? bldCensus2023;
  final int? bldQuality;
  int? bldMunicipality;
  final String? bldEnumArea;
  double? bldLatitude;
  double? bldLongitude;
  final int? bldCadastralZone;
  final String? bldProperty;
  final String? bldPermitNumber;
  final DateTime? bldPermitDate;
  final int? bldStatus;
  final int? bldYearConstruction;
  final int? bldYearDemolition;
  final int? bldType;
  final int? bldClass;
  final double? bldArea;
  final int? bldFloorsAbove;
  final double? bldHeight;
  final double? bldVolume;
  final int? bldWasteWater;
  final int? bldElectricity;
  final int? bldPipedGas;
  final int? bldElevator;
  final String? createdUser;
  final DateTime? createdDate;
  final String? lastEditedUser;
  final DateTime? lastEditedDate;
  int? bldCentroidStatus;
  final int? bldDwellingRecs;
  final int? bldEntranceRecs;
  final String? bldAddressID;
  String? externalCreator;
  final String? externalEditor;
  int? bldReview;
  final int? bldWaterSupply;
  DateTime? externalCreatorDate;
  final DateTime? externalEditorDate;

  BuildingEntity({
    required this.objectId,
    this.featureId,
    this.geometryType,
    required this.coordinates,
    this.shapeLength,
    this.shapeArea,
    this.globalId,
    this.bldCensus2023,
    this.bldQuality,
    this.bldMunicipality,
    this.bldEnumArea,
    this.bldLatitude,
    this.bldLongitude,
    this.bldCadastralZone,
    this.bldProperty,
    this.bldPermitNumber,
    this.bldPermitDate,
    this.bldStatus,
    this.bldYearConstruction,
    this.bldYearDemolition,
    this.bldType,
    this.bldClass,
    this.bldArea,
    this.bldFloorsAbove,
    this.bldHeight,
    this.bldVolume,
    this.bldWasteWater,
    this.bldElectricity,
    this.bldPipedGas,
    this.bldElevator,
    this.createdUser,
    this.createdDate,
    this.lastEditedUser,
    this.lastEditedDate,
    this.bldCentroidStatus,
    this.bldDwellingRecs,
    this.bldEntranceRecs,
    this.bldAddressID,
    this.externalCreator,
    this.externalEditor,
    this.bldReview,
    this.bldWaterSupply,
    this.externalCreatorDate,
    this.externalEditorDate,
  });
}

extension BuildingEntityMapper on BuildingEntity {
  Map<String, dynamic> toMap() {
    return {
      'GlobalID': globalId,
      'OBJECTID': objectId,
      'featureId': featureId,
      'geometryType': geometryType,
      'coordinates': coordinates
          .map((ring) =>
              ring.map((point) => [point.longitude, point.latitude]).toList())
          .toList(),
      'Shape__Length': shapeLength,
      'Shape__Area': shapeArea,      
      'BldCensus2023': bldCensus2023,
      'BldQuality': bldQuality,
      'BldMunicipality': bldMunicipality,
      'BldEnumArea': bldEnumArea,
      'BldLatitude': bldLatitude,
      'BldLongitude': bldLongitude,
      'BldCadastralZone': bldCadastralZone,
      'BldProperty': bldProperty,
      'BldPermitNumber': bldPermitNumber,
      'BldPermitDate': bldPermitDate?.millisecondsSinceEpoch,
      'BldStatus': bldStatus,
      'BldYearConstruction': bldYearConstruction,
      'BldYearDemolition': bldYearDemolition,
      'BldType': bldType,
      'BldClass': bldClass,
      'BldArea': bldArea,
      'BldFloorsAbove': bldFloorsAbove,
      'BldHeight': bldHeight,
      'BldVolume': bldVolume,
      'BldWasteWater': bldWasteWater,
      'BldElectricity': bldElectricity,
      'BldPipedGas': bldPipedGas,
      'BldElevator': bldElevator,
      'created_user': createdUser,
      'created_date': createdDate?.millisecondsSinceEpoch,
      'last_edited_user': lastEditedUser,
      'last_edited_date': lastEditedDate?.millisecondsSinceEpoch,
      'BldCentroidStatus': bldCentroidStatus,
      'BldDwellingRecs': bldDwellingRecs,
      'BldEntranceRecs': bldEntranceRecs,
      'BldAddressID': bldAddressID,
      'external_creator': externalCreator,
      'external_editor': externalEditor,
      'BldReview': bldReview,
      'BldWaterSupply': bldWaterSupply,
      'external_creator_date': externalCreatorDate?.millisecondsSinceEpoch,
      'external_editor_date': externalEditorDate?.millisecondsSinceEpoch,
    };
  }
}
