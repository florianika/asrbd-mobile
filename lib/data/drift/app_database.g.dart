// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BuildingsTable extends Buildings
    with TableInfo<$BuildingsTable, Building> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuildingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _objectIdMeta =
      const VerificationMeta('objectId');
  @override
  late final GeneratedColumn<int> objectId = GeneratedColumn<int>(
      'object_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _shapeLengthMeta =
      const VerificationMeta('shapeLength');
  @override
  late final GeneratedColumn<double> shapeLength = GeneratedColumn<double>(
      'shape_length', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _shapeAreaMeta =
      const VerificationMeta('shapeArea');
  @override
  late final GeneratedColumn<double> shapeArea = GeneratedColumn<double>(
      'shape_area', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _globalIdMeta =
      const VerificationMeta('globalId');
  @override
  late final GeneratedColumn<String> globalId = GeneratedColumn<String>(
      'global_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _bldCensus2023Meta =
      const VerificationMeta('bldCensus2023');
  @override
  late final GeneratedColumn<String> bldCensus2023 = GeneratedColumn<String>(
      'bld_census2023', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 11),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('99999999999'));
  static const VerificationMeta _bldQualityMeta =
      const VerificationMeta('bldQuality');
  @override
  late final GeneratedColumn<int> bldQuality = GeneratedColumn<int>(
      'bld_quality', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _bldMunicipalityMeta =
      const VerificationMeta('bldMunicipality');
  @override
  late final GeneratedColumn<int> bldMunicipality = GeneratedColumn<int>(
      'bld_municipality', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bldEnumAreaMeta =
      const VerificationMeta('bldEnumArea');
  @override
  late final GeneratedColumn<String> bldEnumArea = GeneratedColumn<String>(
      'bld_enum_area', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _bldLatitudeMeta =
      const VerificationMeta('bldLatitude');
  @override
  late final GeneratedColumn<double> bldLatitude = GeneratedColumn<double>(
      'bld_latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _bldLongitudeMeta =
      const VerificationMeta('bldLongitude');
  @override
  late final GeneratedColumn<double> bldLongitude = GeneratedColumn<double>(
      'bld_longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _bldCadastralZoneMeta =
      const VerificationMeta('bldCadastralZone');
  @override
  late final GeneratedColumn<int> bldCadastralZone = GeneratedColumn<int>(
      'bld_cadastral_zone', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bldPropertyMeta =
      const VerificationMeta('bldProperty');
  @override
  late final GeneratedColumn<String> bldProperty = GeneratedColumn<String>(
      'bld_property', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _bldPermitNumberMeta =
      const VerificationMeta('bldPermitNumber');
  @override
  late final GeneratedColumn<String> bldPermitNumber = GeneratedColumn<String>(
      'bld_permit_number', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 25),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _bldPermitDateMeta =
      const VerificationMeta('bldPermitDate');
  @override
  late final GeneratedColumn<DateTime> bldPermitDate =
      GeneratedColumn<DateTime>('bld_permit_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _bldStatusMeta =
      const VerificationMeta('bldStatus');
  @override
  late final GeneratedColumn<int> bldStatus = GeneratedColumn<int>(
      'bld_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _bldYearConstructionMeta =
      const VerificationMeta('bldYearConstruction');
  @override
  late final GeneratedColumn<int> bldYearConstruction = GeneratedColumn<int>(
      'bld_year_construction', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bldYearDemolitionMeta =
      const VerificationMeta('bldYearDemolition');
  @override
  late final GeneratedColumn<int> bldYearDemolition = GeneratedColumn<int>(
      'bld_year_demolition', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bldTypeMeta =
      const VerificationMeta('bldType');
  @override
  late final GeneratedColumn<int> bldType = GeneratedColumn<int>(
      'bld_type', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _bldClassMeta =
      const VerificationMeta('bldClass');
  @override
  late final GeneratedColumn<int> bldClass = GeneratedColumn<int>(
      'bld_class', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(999));
  static const VerificationMeta _bldAreaMeta =
      const VerificationMeta('bldArea');
  @override
  late final GeneratedColumn<double> bldArea = GeneratedColumn<double>(
      'bld_area', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _bldFloorsAboveMeta =
      const VerificationMeta('bldFloorsAbove');
  @override
  late final GeneratedColumn<int> bldFloorsAbove = GeneratedColumn<int>(
      'bld_floors_above', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bldHeightMeta =
      const VerificationMeta('bldHeight');
  @override
  late final GeneratedColumn<int> bldHeight = GeneratedColumn<int>(
      'bld_height', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bldVolumeMeta =
      const VerificationMeta('bldVolume');
  @override
  late final GeneratedColumn<double> bldVolume = GeneratedColumn<double>(
      'bld_volume', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _bldWasteWaterMeta =
      const VerificationMeta('bldWasteWater');
  @override
  late final GeneratedColumn<int> bldWasteWater = GeneratedColumn<int>(
      'bld_waste_water', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _bldElectricityMeta =
      const VerificationMeta('bldElectricity');
  @override
  late final GeneratedColumn<int> bldElectricity = GeneratedColumn<int>(
      'bld_electricity', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _bldPipedGasMeta =
      const VerificationMeta('bldPipedGas');
  @override
  late final GeneratedColumn<int> bldPipedGas = GeneratedColumn<int>(
      'bld_piped_gas', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _bldElevatorMeta =
      const VerificationMeta('bldElevator');
  @override
  late final GeneratedColumn<int> bldElevator = GeneratedColumn<int>(
      'bld_elevator', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _createdUserMeta =
      const VerificationMeta('createdUser');
  @override
  late final GeneratedColumn<String> createdUser = GeneratedColumn<String>(
      'created_user', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastEditedUserMeta =
      const VerificationMeta('lastEditedUser');
  @override
  late final GeneratedColumn<String> lastEditedUser = GeneratedColumn<String>(
      'last_edited_user', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _lastEditedDateMeta =
      const VerificationMeta('lastEditedDate');
  @override
  late final GeneratedColumn<DateTime> lastEditedDate =
      GeneratedColumn<DateTime>('last_edited_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _bldCentroidStatusMeta =
      const VerificationMeta('bldCentroidStatus');
  @override
  late final GeneratedColumn<int> bldCentroidStatus = GeneratedColumn<int>(
      'bld_centroid_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _bldDwellingRecsMeta =
      const VerificationMeta('bldDwellingRecs');
  @override
  late final GeneratedColumn<int> bldDwellingRecs = GeneratedColumn<int>(
      'bld_dwelling_recs', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bldEntranceRecsMeta =
      const VerificationMeta('bldEntranceRecs');
  @override
  late final GeneratedColumn<int> bldEntranceRecs = GeneratedColumn<int>(
      'bld_entrance_recs', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bldAddressIdMeta =
      const VerificationMeta('bldAddressId');
  @override
  late final GeneratedColumn<String> bldAddressId = GeneratedColumn<String>(
      'bld_address_id', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 6),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _externalCreatorMeta =
      const VerificationMeta('externalCreator');
  @override
  late final GeneratedColumn<String> externalCreator = GeneratedColumn<String>(
      'external_creator', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _externalEditorMeta =
      const VerificationMeta('externalEditor');
  @override
  late final GeneratedColumn<String> externalEditor = GeneratedColumn<String>(
      'external_editor', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _bldReviewMeta =
      const VerificationMeta('bldReview');
  @override
  late final GeneratedColumn<int> bldReview = GeneratedColumn<int>(
      'bld_review', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _bldWaterSupplyMeta =
      const VerificationMeta('bldWaterSupply');
  @override
  late final GeneratedColumn<int> bldWaterSupply = GeneratedColumn<int>(
      'bld_water_supply', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(99));
  static const VerificationMeta _externalCreatorDateMeta =
      const VerificationMeta('externalCreatorDate');
  @override
  late final GeneratedColumn<DateTime> externalCreatorDate =
      GeneratedColumn<DateTime>('external_creator_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _externalEditorDateMeta =
      const VerificationMeta('externalEditorDate');
  @override
  late final GeneratedColumn<DateTime> externalEditorDate =
      GeneratedColumn<DateTime>('external_editor_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        objectId,
        shapeLength,
        shapeArea,
        globalId,
        bldCensus2023,
        bldQuality,
        bldMunicipality,
        bldEnumArea,
        bldLatitude,
        bldLongitude,
        bldCadastralZone,
        bldProperty,
        bldPermitNumber,
        bldPermitDate,
        bldStatus,
        bldYearConstruction,
        bldYearDemolition,
        bldType,
        bldClass,
        bldArea,
        bldFloorsAbove,
        bldHeight,
        bldVolume,
        bldWasteWater,
        bldElectricity,
        bldPipedGas,
        bldElevator,
        createdUser,
        createdDate,
        lastEditedUser,
        lastEditedDate,
        bldCentroidStatus,
        bldDwellingRecs,
        bldEntranceRecs,
        bldAddressId,
        externalCreator,
        externalEditor,
        bldReview,
        bldWaterSupply,
        externalCreatorDate,
        externalEditorDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'buildings';
  @override
  VerificationContext validateIntegrity(Insertable<Building> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('object_id')) {
      context.handle(_objectIdMeta,
          objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta));
    }
    if (data.containsKey('shape_length')) {
      context.handle(
          _shapeLengthMeta,
          shapeLength.isAcceptableOrUnknown(
              data['shape_length']!, _shapeLengthMeta));
    }
    if (data.containsKey('shape_area')) {
      context.handle(_shapeAreaMeta,
          shapeArea.isAcceptableOrUnknown(data['shape_area']!, _shapeAreaMeta));
    }
    if (data.containsKey('global_id')) {
      context.handle(_globalIdMeta,
          globalId.isAcceptableOrUnknown(data['global_id']!, _globalIdMeta));
    } else if (isInserting) {
      context.missing(_globalIdMeta);
    }
    if (data.containsKey('bld_census2023')) {
      context.handle(
          _bldCensus2023Meta,
          bldCensus2023.isAcceptableOrUnknown(
              data['bld_census2023']!, _bldCensus2023Meta));
    }
    if (data.containsKey('bld_quality')) {
      context.handle(
          _bldQualityMeta,
          bldQuality.isAcceptableOrUnknown(
              data['bld_quality']!, _bldQualityMeta));
    }
    if (data.containsKey('bld_municipality')) {
      context.handle(
          _bldMunicipalityMeta,
          bldMunicipality.isAcceptableOrUnknown(
              data['bld_municipality']!, _bldMunicipalityMeta));
    } else if (isInserting) {
      context.missing(_bldMunicipalityMeta);
    }
    if (data.containsKey('bld_enum_area')) {
      context.handle(
          _bldEnumAreaMeta,
          bldEnumArea.isAcceptableOrUnknown(
              data['bld_enum_area']!, _bldEnumAreaMeta));
    }
    if (data.containsKey('bld_latitude')) {
      context.handle(
          _bldLatitudeMeta,
          bldLatitude.isAcceptableOrUnknown(
              data['bld_latitude']!, _bldLatitudeMeta));
    } else if (isInserting) {
      context.missing(_bldLatitudeMeta);
    }
    if (data.containsKey('bld_longitude')) {
      context.handle(
          _bldLongitudeMeta,
          bldLongitude.isAcceptableOrUnknown(
              data['bld_longitude']!, _bldLongitudeMeta));
    } else if (isInserting) {
      context.missing(_bldLongitudeMeta);
    }
    if (data.containsKey('bld_cadastral_zone')) {
      context.handle(
          _bldCadastralZoneMeta,
          bldCadastralZone.isAcceptableOrUnknown(
              data['bld_cadastral_zone']!, _bldCadastralZoneMeta));
    }
    if (data.containsKey('bld_property')) {
      context.handle(
          _bldPropertyMeta,
          bldProperty.isAcceptableOrUnknown(
              data['bld_property']!, _bldPropertyMeta));
    }
    if (data.containsKey('bld_permit_number')) {
      context.handle(
          _bldPermitNumberMeta,
          bldPermitNumber.isAcceptableOrUnknown(
              data['bld_permit_number']!, _bldPermitNumberMeta));
    }
    if (data.containsKey('bld_permit_date')) {
      context.handle(
          _bldPermitDateMeta,
          bldPermitDate.isAcceptableOrUnknown(
              data['bld_permit_date']!, _bldPermitDateMeta));
    }
    if (data.containsKey('bld_status')) {
      context.handle(_bldStatusMeta,
          bldStatus.isAcceptableOrUnknown(data['bld_status']!, _bldStatusMeta));
    }
    if (data.containsKey('bld_year_construction')) {
      context.handle(
          _bldYearConstructionMeta,
          bldYearConstruction.isAcceptableOrUnknown(
              data['bld_year_construction']!, _bldYearConstructionMeta));
    }
    if (data.containsKey('bld_year_demolition')) {
      context.handle(
          _bldYearDemolitionMeta,
          bldYearDemolition.isAcceptableOrUnknown(
              data['bld_year_demolition']!, _bldYearDemolitionMeta));
    }
    if (data.containsKey('bld_type')) {
      context.handle(_bldTypeMeta,
          bldType.isAcceptableOrUnknown(data['bld_type']!, _bldTypeMeta));
    }
    if (data.containsKey('bld_class')) {
      context.handle(_bldClassMeta,
          bldClass.isAcceptableOrUnknown(data['bld_class']!, _bldClassMeta));
    }
    if (data.containsKey('bld_area')) {
      context.handle(_bldAreaMeta,
          bldArea.isAcceptableOrUnknown(data['bld_area']!, _bldAreaMeta));
    }
    if (data.containsKey('bld_floors_above')) {
      context.handle(
          _bldFloorsAboveMeta,
          bldFloorsAbove.isAcceptableOrUnknown(
              data['bld_floors_above']!, _bldFloorsAboveMeta));
    }
    if (data.containsKey('bld_height')) {
      context.handle(_bldHeightMeta,
          bldHeight.isAcceptableOrUnknown(data['bld_height']!, _bldHeightMeta));
    }
    if (data.containsKey('bld_volume')) {
      context.handle(_bldVolumeMeta,
          bldVolume.isAcceptableOrUnknown(data['bld_volume']!, _bldVolumeMeta));
    }
    if (data.containsKey('bld_waste_water')) {
      context.handle(
          _bldWasteWaterMeta,
          bldWasteWater.isAcceptableOrUnknown(
              data['bld_waste_water']!, _bldWasteWaterMeta));
    }
    if (data.containsKey('bld_electricity')) {
      context.handle(
          _bldElectricityMeta,
          bldElectricity.isAcceptableOrUnknown(
              data['bld_electricity']!, _bldElectricityMeta));
    }
    if (data.containsKey('bld_piped_gas')) {
      context.handle(
          _bldPipedGasMeta,
          bldPipedGas.isAcceptableOrUnknown(
              data['bld_piped_gas']!, _bldPipedGasMeta));
    }
    if (data.containsKey('bld_elevator')) {
      context.handle(
          _bldElevatorMeta,
          bldElevator.isAcceptableOrUnknown(
              data['bld_elevator']!, _bldElevatorMeta));
    }
    if (data.containsKey('created_user')) {
      context.handle(
          _createdUserMeta,
          createdUser.isAcceptableOrUnknown(
              data['created_user']!, _createdUserMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    if (data.containsKey('last_edited_user')) {
      context.handle(
          _lastEditedUserMeta,
          lastEditedUser.isAcceptableOrUnknown(
              data['last_edited_user']!, _lastEditedUserMeta));
    }
    if (data.containsKey('last_edited_date')) {
      context.handle(
          _lastEditedDateMeta,
          lastEditedDate.isAcceptableOrUnknown(
              data['last_edited_date']!, _lastEditedDateMeta));
    }
    if (data.containsKey('bld_centroid_status')) {
      context.handle(
          _bldCentroidStatusMeta,
          bldCentroidStatus.isAcceptableOrUnknown(
              data['bld_centroid_status']!, _bldCentroidStatusMeta));
    }
    if (data.containsKey('bld_dwelling_recs')) {
      context.handle(
          _bldDwellingRecsMeta,
          bldDwellingRecs.isAcceptableOrUnknown(
              data['bld_dwelling_recs']!, _bldDwellingRecsMeta));
    }
    if (data.containsKey('bld_entrance_recs')) {
      context.handle(
          _bldEntranceRecsMeta,
          bldEntranceRecs.isAcceptableOrUnknown(
              data['bld_entrance_recs']!, _bldEntranceRecsMeta));
    }
    if (data.containsKey('bld_address_id')) {
      context.handle(
          _bldAddressIdMeta,
          bldAddressId.isAcceptableOrUnknown(
              data['bld_address_id']!, _bldAddressIdMeta));
    }
    if (data.containsKey('external_creator')) {
      context.handle(
          _externalCreatorMeta,
          externalCreator.isAcceptableOrUnknown(
              data['external_creator']!, _externalCreatorMeta));
    }
    if (data.containsKey('external_editor')) {
      context.handle(
          _externalEditorMeta,
          externalEditor.isAcceptableOrUnknown(
              data['external_editor']!, _externalEditorMeta));
    }
    if (data.containsKey('bld_review')) {
      context.handle(_bldReviewMeta,
          bldReview.isAcceptableOrUnknown(data['bld_review']!, _bldReviewMeta));
    }
    if (data.containsKey('bld_water_supply')) {
      context.handle(
          _bldWaterSupplyMeta,
          bldWaterSupply.isAcceptableOrUnknown(
              data['bld_water_supply']!, _bldWaterSupplyMeta));
    }
    if (data.containsKey('external_creator_date')) {
      context.handle(
          _externalCreatorDateMeta,
          externalCreatorDate.isAcceptableOrUnknown(
              data['external_creator_date']!, _externalCreatorDateMeta));
    }
    if (data.containsKey('external_editor_date')) {
      context.handle(
          _externalEditorDateMeta,
          externalEditorDate.isAcceptableOrUnknown(
              data['external_editor_date']!, _externalEditorDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {objectId};
  @override
  Building map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Building(
      objectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_id'])!,
      shapeLength: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shape_length']),
      shapeArea: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shape_area']),
      globalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}global_id'])!,
      bldCensus2023: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bld_census2023']),
      bldQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_quality'])!,
      bldMunicipality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_municipality'])!,
      bldEnumArea: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bld_enum_area']),
      bldLatitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bld_latitude'])!,
      bldLongitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bld_longitude'])!,
      bldCadastralZone: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_cadastral_zone']),
      bldProperty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bld_property']),
      bldPermitNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}bld_permit_number']),
      bldPermitDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}bld_permit_date']),
      bldStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_status'])!,
      bldYearConstruction: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}bld_year_construction']),
      bldYearDemolition: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}bld_year_demolition']),
      bldType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_type']),
      bldClass: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_class']),
      bldArea: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bld_area']),
      bldFloorsAbove: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_floors_above']),
      bldHeight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_height']),
      bldVolume: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bld_volume']),
      bldWasteWater: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_waste_water']),
      bldElectricity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_electricity']),
      bldPipedGas: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_piped_gas']),
      bldElevator: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_elevator']),
      createdUser: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_user']),
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date']),
      lastEditedUser: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_edited_user']),
      lastEditedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_edited_date']),
      bldCentroidStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}bld_centroid_status'])!,
      bldDwellingRecs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_dwelling_recs']),
      bldEntranceRecs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_entrance_recs']),
      bldAddressId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bld_address_id']),
      externalCreator: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}external_creator']),
      externalEditor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_editor']),
      bldReview: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_review'])!,
      bldWaterSupply: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_water_supply']),
      externalCreatorDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}external_creator_date']),
      externalEditorDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}external_editor_date']),
    );
  }

  @override
  $BuildingsTable createAlias(String alias) {
    return $BuildingsTable(attachedDatabase, alias);
  }
}

class Building extends DataClass implements Insertable<Building> {
  final int objectId;
  final double? shapeLength;
  final double? shapeArea;
  final String globalId;
  final String? bldCensus2023;
  final int bldQuality;
  final int bldMunicipality;
  final String? bldEnumArea;
  final double bldLatitude;
  final double bldLongitude;
  final int? bldCadastralZone;
  final String? bldProperty;
  final String? bldPermitNumber;
  final DateTime? bldPermitDate;
  final int bldStatus;
  final int? bldYearConstruction;
  final int? bldYearDemolition;
  final int? bldType;
  final int? bldClass;
  final double? bldArea;
  final int? bldFloorsAbove;
  final int? bldHeight;
  final double? bldVolume;
  final int? bldWasteWater;
  final int? bldElectricity;
  final int? bldPipedGas;
  final int? bldElevator;
  final String? createdUser;
  final DateTime? createdDate;
  final String? lastEditedUser;
  final DateTime? lastEditedDate;
  final int bldCentroidStatus;
  final int? bldDwellingRecs;
  final int? bldEntranceRecs;
  final String? bldAddressId;
  final String? externalCreator;
  final String? externalEditor;
  final int bldReview;
  final int? bldWaterSupply;
  final DateTime? externalCreatorDate;
  final DateTime? externalEditorDate;
  const Building(
      {required this.objectId,
      this.shapeLength,
      this.shapeArea,
      required this.globalId,
      this.bldCensus2023,
      required this.bldQuality,
      required this.bldMunicipality,
      this.bldEnumArea,
      required this.bldLatitude,
      required this.bldLongitude,
      this.bldCadastralZone,
      this.bldProperty,
      this.bldPermitNumber,
      this.bldPermitDate,
      required this.bldStatus,
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
      required this.bldCentroidStatus,
      this.bldDwellingRecs,
      this.bldEntranceRecs,
      this.bldAddressId,
      this.externalCreator,
      this.externalEditor,
      required this.bldReview,
      this.bldWaterSupply,
      this.externalCreatorDate,
      this.externalEditorDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['object_id'] = Variable<int>(objectId);
    if (!nullToAbsent || shapeLength != null) {
      map['shape_length'] = Variable<double>(shapeLength);
    }
    if (!nullToAbsent || shapeArea != null) {
      map['shape_area'] = Variable<double>(shapeArea);
    }
    map['global_id'] = Variable<String>(globalId);
    if (!nullToAbsent || bldCensus2023 != null) {
      map['bld_census2023'] = Variable<String>(bldCensus2023);
    }
    map['bld_quality'] = Variable<int>(bldQuality);
    map['bld_municipality'] = Variable<int>(bldMunicipality);
    if (!nullToAbsent || bldEnumArea != null) {
      map['bld_enum_area'] = Variable<String>(bldEnumArea);
    }
    map['bld_latitude'] = Variable<double>(bldLatitude);
    map['bld_longitude'] = Variable<double>(bldLongitude);
    if (!nullToAbsent || bldCadastralZone != null) {
      map['bld_cadastral_zone'] = Variable<int>(bldCadastralZone);
    }
    if (!nullToAbsent || bldProperty != null) {
      map['bld_property'] = Variable<String>(bldProperty);
    }
    if (!nullToAbsent || bldPermitNumber != null) {
      map['bld_permit_number'] = Variable<String>(bldPermitNumber);
    }
    if (!nullToAbsent || bldPermitDate != null) {
      map['bld_permit_date'] = Variable<DateTime>(bldPermitDate);
    }
    map['bld_status'] = Variable<int>(bldStatus);
    if (!nullToAbsent || bldYearConstruction != null) {
      map['bld_year_construction'] = Variable<int>(bldYearConstruction);
    }
    if (!nullToAbsent || bldYearDemolition != null) {
      map['bld_year_demolition'] = Variable<int>(bldYearDemolition);
    }
    if (!nullToAbsent || bldType != null) {
      map['bld_type'] = Variable<int>(bldType);
    }
    if (!nullToAbsent || bldClass != null) {
      map['bld_class'] = Variable<int>(bldClass);
    }
    if (!nullToAbsent || bldArea != null) {
      map['bld_area'] = Variable<double>(bldArea);
    }
    if (!nullToAbsent || bldFloorsAbove != null) {
      map['bld_floors_above'] = Variable<int>(bldFloorsAbove);
    }
    if (!nullToAbsent || bldHeight != null) {
      map['bld_height'] = Variable<int>(bldHeight);
    }
    if (!nullToAbsent || bldVolume != null) {
      map['bld_volume'] = Variable<double>(bldVolume);
    }
    if (!nullToAbsent || bldWasteWater != null) {
      map['bld_waste_water'] = Variable<int>(bldWasteWater);
    }
    if (!nullToAbsent || bldElectricity != null) {
      map['bld_electricity'] = Variable<int>(bldElectricity);
    }
    if (!nullToAbsent || bldPipedGas != null) {
      map['bld_piped_gas'] = Variable<int>(bldPipedGas);
    }
    if (!nullToAbsent || bldElevator != null) {
      map['bld_elevator'] = Variable<int>(bldElevator);
    }
    if (!nullToAbsent || createdUser != null) {
      map['created_user'] = Variable<String>(createdUser);
    }
    if (!nullToAbsent || createdDate != null) {
      map['created_date'] = Variable<DateTime>(createdDate);
    }
    if (!nullToAbsent || lastEditedUser != null) {
      map['last_edited_user'] = Variable<String>(lastEditedUser);
    }
    if (!nullToAbsent || lastEditedDate != null) {
      map['last_edited_date'] = Variable<DateTime>(lastEditedDate);
    }
    map['bld_centroid_status'] = Variable<int>(bldCentroidStatus);
    if (!nullToAbsent || bldDwellingRecs != null) {
      map['bld_dwelling_recs'] = Variable<int>(bldDwellingRecs);
    }
    if (!nullToAbsent || bldEntranceRecs != null) {
      map['bld_entrance_recs'] = Variable<int>(bldEntranceRecs);
    }
    if (!nullToAbsent || bldAddressId != null) {
      map['bld_address_id'] = Variable<String>(bldAddressId);
    }
    if (!nullToAbsent || externalCreator != null) {
      map['external_creator'] = Variable<String>(externalCreator);
    }
    if (!nullToAbsent || externalEditor != null) {
      map['external_editor'] = Variable<String>(externalEditor);
    }
    map['bld_review'] = Variable<int>(bldReview);
    if (!nullToAbsent || bldWaterSupply != null) {
      map['bld_water_supply'] = Variable<int>(bldWaterSupply);
    }
    if (!nullToAbsent || externalCreatorDate != null) {
      map['external_creator_date'] = Variable<DateTime>(externalCreatorDate);
    }
    if (!nullToAbsent || externalEditorDate != null) {
      map['external_editor_date'] = Variable<DateTime>(externalEditorDate);
    }
    return map;
  }

  BuildingsCompanion toCompanion(bool nullToAbsent) {
    return BuildingsCompanion(
      objectId: Value(objectId),
      shapeLength: shapeLength == null && nullToAbsent
          ? const Value.absent()
          : Value(shapeLength),
      shapeArea: shapeArea == null && nullToAbsent
          ? const Value.absent()
          : Value(shapeArea),
      globalId: Value(globalId),
      bldCensus2023: bldCensus2023 == null && nullToAbsent
          ? const Value.absent()
          : Value(bldCensus2023),
      bldQuality: Value(bldQuality),
      bldMunicipality: Value(bldMunicipality),
      bldEnumArea: bldEnumArea == null && nullToAbsent
          ? const Value.absent()
          : Value(bldEnumArea),
      bldLatitude: Value(bldLatitude),
      bldLongitude: Value(bldLongitude),
      bldCadastralZone: bldCadastralZone == null && nullToAbsent
          ? const Value.absent()
          : Value(bldCadastralZone),
      bldProperty: bldProperty == null && nullToAbsent
          ? const Value.absent()
          : Value(bldProperty),
      bldPermitNumber: bldPermitNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(bldPermitNumber),
      bldPermitDate: bldPermitDate == null && nullToAbsent
          ? const Value.absent()
          : Value(bldPermitDate),
      bldStatus: Value(bldStatus),
      bldYearConstruction: bldYearConstruction == null && nullToAbsent
          ? const Value.absent()
          : Value(bldYearConstruction),
      bldYearDemolition: bldYearDemolition == null && nullToAbsent
          ? const Value.absent()
          : Value(bldYearDemolition),
      bldType: bldType == null && nullToAbsent
          ? const Value.absent()
          : Value(bldType),
      bldClass: bldClass == null && nullToAbsent
          ? const Value.absent()
          : Value(bldClass),
      bldArea: bldArea == null && nullToAbsent
          ? const Value.absent()
          : Value(bldArea),
      bldFloorsAbove: bldFloorsAbove == null && nullToAbsent
          ? const Value.absent()
          : Value(bldFloorsAbove),
      bldHeight: bldHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(bldHeight),
      bldVolume: bldVolume == null && nullToAbsent
          ? const Value.absent()
          : Value(bldVolume),
      bldWasteWater: bldWasteWater == null && nullToAbsent
          ? const Value.absent()
          : Value(bldWasteWater),
      bldElectricity: bldElectricity == null && nullToAbsent
          ? const Value.absent()
          : Value(bldElectricity),
      bldPipedGas: bldPipedGas == null && nullToAbsent
          ? const Value.absent()
          : Value(bldPipedGas),
      bldElevator: bldElevator == null && nullToAbsent
          ? const Value.absent()
          : Value(bldElevator),
      createdUser: createdUser == null && nullToAbsent
          ? const Value.absent()
          : Value(createdUser),
      createdDate: createdDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createdDate),
      lastEditedUser: lastEditedUser == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEditedUser),
      lastEditedDate: lastEditedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEditedDate),
      bldCentroidStatus: Value(bldCentroidStatus),
      bldDwellingRecs: bldDwellingRecs == null && nullToAbsent
          ? const Value.absent()
          : Value(bldDwellingRecs),
      bldEntranceRecs: bldEntranceRecs == null && nullToAbsent
          ? const Value.absent()
          : Value(bldEntranceRecs),
      bldAddressId: bldAddressId == null && nullToAbsent
          ? const Value.absent()
          : Value(bldAddressId),
      externalCreator: externalCreator == null && nullToAbsent
          ? const Value.absent()
          : Value(externalCreator),
      externalEditor: externalEditor == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEditor),
      bldReview: Value(bldReview),
      bldWaterSupply: bldWaterSupply == null && nullToAbsent
          ? const Value.absent()
          : Value(bldWaterSupply),
      externalCreatorDate: externalCreatorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(externalCreatorDate),
      externalEditorDate: externalEditorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEditorDate),
    );
  }

  factory Building.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Building(
      objectId: serializer.fromJson<int>(json['objectId']),
      shapeLength: serializer.fromJson<double?>(json['shapeLength']),
      shapeArea: serializer.fromJson<double?>(json['shapeArea']),
      globalId: serializer.fromJson<String>(json['globalId']),
      bldCensus2023: serializer.fromJson<String?>(json['bldCensus2023']),
      bldQuality: serializer.fromJson<int>(json['bldQuality']),
      bldMunicipality: serializer.fromJson<int>(json['bldMunicipality']),
      bldEnumArea: serializer.fromJson<String?>(json['bldEnumArea']),
      bldLatitude: serializer.fromJson<double>(json['bldLatitude']),
      bldLongitude: serializer.fromJson<double>(json['bldLongitude']),
      bldCadastralZone: serializer.fromJson<int?>(json['bldCadastralZone']),
      bldProperty: serializer.fromJson<String?>(json['bldProperty']),
      bldPermitNumber: serializer.fromJson<String?>(json['bldPermitNumber']),
      bldPermitDate: serializer.fromJson<DateTime?>(json['bldPermitDate']),
      bldStatus: serializer.fromJson<int>(json['bldStatus']),
      bldYearConstruction:
          serializer.fromJson<int?>(json['bldYearConstruction']),
      bldYearDemolition: serializer.fromJson<int?>(json['bldYearDemolition']),
      bldType: serializer.fromJson<int?>(json['bldType']),
      bldClass: serializer.fromJson<int?>(json['bldClass']),
      bldArea: serializer.fromJson<double?>(json['bldArea']),
      bldFloorsAbove: serializer.fromJson<int?>(json['bldFloorsAbove']),
      bldHeight: serializer.fromJson<int?>(json['bldHeight']),
      bldVolume: serializer.fromJson<double?>(json['bldVolume']),
      bldWasteWater: serializer.fromJson<int?>(json['bldWasteWater']),
      bldElectricity: serializer.fromJson<int?>(json['bldElectricity']),
      bldPipedGas: serializer.fromJson<int?>(json['bldPipedGas']),
      bldElevator: serializer.fromJson<int?>(json['bldElevator']),
      createdUser: serializer.fromJson<String?>(json['createdUser']),
      createdDate: serializer.fromJson<DateTime?>(json['createdDate']),
      lastEditedUser: serializer.fromJson<String?>(json['lastEditedUser']),
      lastEditedDate: serializer.fromJson<DateTime?>(json['lastEditedDate']),
      bldCentroidStatus: serializer.fromJson<int>(json['bldCentroidStatus']),
      bldDwellingRecs: serializer.fromJson<int?>(json['bldDwellingRecs']),
      bldEntranceRecs: serializer.fromJson<int?>(json['bldEntranceRecs']),
      bldAddressId: serializer.fromJson<String?>(json['bldAddressId']),
      externalCreator: serializer.fromJson<String?>(json['externalCreator']),
      externalEditor: serializer.fromJson<String?>(json['externalEditor']),
      bldReview: serializer.fromJson<int>(json['bldReview']),
      bldWaterSupply: serializer.fromJson<int?>(json['bldWaterSupply']),
      externalCreatorDate:
          serializer.fromJson<DateTime?>(json['externalCreatorDate']),
      externalEditorDate:
          serializer.fromJson<DateTime?>(json['externalEditorDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'objectId': serializer.toJson<int>(objectId),
      'shapeLength': serializer.toJson<double?>(shapeLength),
      'shapeArea': serializer.toJson<double?>(shapeArea),
      'globalId': serializer.toJson<String>(globalId),
      'bldCensus2023': serializer.toJson<String?>(bldCensus2023),
      'bldQuality': serializer.toJson<int>(bldQuality),
      'bldMunicipality': serializer.toJson<int>(bldMunicipality),
      'bldEnumArea': serializer.toJson<String?>(bldEnumArea),
      'bldLatitude': serializer.toJson<double>(bldLatitude),
      'bldLongitude': serializer.toJson<double>(bldLongitude),
      'bldCadastralZone': serializer.toJson<int?>(bldCadastralZone),
      'bldProperty': serializer.toJson<String?>(bldProperty),
      'bldPermitNumber': serializer.toJson<String?>(bldPermitNumber),
      'bldPermitDate': serializer.toJson<DateTime?>(bldPermitDate),
      'bldStatus': serializer.toJson<int>(bldStatus),
      'bldYearConstruction': serializer.toJson<int?>(bldYearConstruction),
      'bldYearDemolition': serializer.toJson<int?>(bldYearDemolition),
      'bldType': serializer.toJson<int?>(bldType),
      'bldClass': serializer.toJson<int?>(bldClass),
      'bldArea': serializer.toJson<double?>(bldArea),
      'bldFloorsAbove': serializer.toJson<int?>(bldFloorsAbove),
      'bldHeight': serializer.toJson<int?>(bldHeight),
      'bldVolume': serializer.toJson<double?>(bldVolume),
      'bldWasteWater': serializer.toJson<int?>(bldWasteWater),
      'bldElectricity': serializer.toJson<int?>(bldElectricity),
      'bldPipedGas': serializer.toJson<int?>(bldPipedGas),
      'bldElevator': serializer.toJson<int?>(bldElevator),
      'createdUser': serializer.toJson<String?>(createdUser),
      'createdDate': serializer.toJson<DateTime?>(createdDate),
      'lastEditedUser': serializer.toJson<String?>(lastEditedUser),
      'lastEditedDate': serializer.toJson<DateTime?>(lastEditedDate),
      'bldCentroidStatus': serializer.toJson<int>(bldCentroidStatus),
      'bldDwellingRecs': serializer.toJson<int?>(bldDwellingRecs),
      'bldEntranceRecs': serializer.toJson<int?>(bldEntranceRecs),
      'bldAddressId': serializer.toJson<String?>(bldAddressId),
      'externalCreator': serializer.toJson<String?>(externalCreator),
      'externalEditor': serializer.toJson<String?>(externalEditor),
      'bldReview': serializer.toJson<int>(bldReview),
      'bldWaterSupply': serializer.toJson<int?>(bldWaterSupply),
      'externalCreatorDate': serializer.toJson<DateTime?>(externalCreatorDate),
      'externalEditorDate': serializer.toJson<DateTime?>(externalEditorDate),
    };
  }

  Building copyWith(
          {int? objectId,
          Value<double?> shapeLength = const Value.absent(),
          Value<double?> shapeArea = const Value.absent(),
          String? globalId,
          Value<String?> bldCensus2023 = const Value.absent(),
          int? bldQuality,
          int? bldMunicipality,
          Value<String?> bldEnumArea = const Value.absent(),
          double? bldLatitude,
          double? bldLongitude,
          Value<int?> bldCadastralZone = const Value.absent(),
          Value<String?> bldProperty = const Value.absent(),
          Value<String?> bldPermitNumber = const Value.absent(),
          Value<DateTime?> bldPermitDate = const Value.absent(),
          int? bldStatus,
          Value<int?> bldYearConstruction = const Value.absent(),
          Value<int?> bldYearDemolition = const Value.absent(),
          Value<int?> bldType = const Value.absent(),
          Value<int?> bldClass = const Value.absent(),
          Value<double?> bldArea = const Value.absent(),
          Value<int?> bldFloorsAbove = const Value.absent(),
          Value<int?> bldHeight = const Value.absent(),
          Value<double?> bldVolume = const Value.absent(),
          Value<int?> bldWasteWater = const Value.absent(),
          Value<int?> bldElectricity = const Value.absent(),
          Value<int?> bldPipedGas = const Value.absent(),
          Value<int?> bldElevator = const Value.absent(),
          Value<String?> createdUser = const Value.absent(),
          Value<DateTime?> createdDate = const Value.absent(),
          Value<String?> lastEditedUser = const Value.absent(),
          Value<DateTime?> lastEditedDate = const Value.absent(),
          int? bldCentroidStatus,
          Value<int?> bldDwellingRecs = const Value.absent(),
          Value<int?> bldEntranceRecs = const Value.absent(),
          Value<String?> bldAddressId = const Value.absent(),
          Value<String?> externalCreator = const Value.absent(),
          Value<String?> externalEditor = const Value.absent(),
          int? bldReview,
          Value<int?> bldWaterSupply = const Value.absent(),
          Value<DateTime?> externalCreatorDate = const Value.absent(),
          Value<DateTime?> externalEditorDate = const Value.absent()}) =>
      Building(
        objectId: objectId ?? this.objectId,
        shapeLength: shapeLength.present ? shapeLength.value : this.shapeLength,
        shapeArea: shapeArea.present ? shapeArea.value : this.shapeArea,
        globalId: globalId ?? this.globalId,
        bldCensus2023:
            bldCensus2023.present ? bldCensus2023.value : this.bldCensus2023,
        bldQuality: bldQuality ?? this.bldQuality,
        bldMunicipality: bldMunicipality ?? this.bldMunicipality,
        bldEnumArea: bldEnumArea.present ? bldEnumArea.value : this.bldEnumArea,
        bldLatitude: bldLatitude ?? this.bldLatitude,
        bldLongitude: bldLongitude ?? this.bldLongitude,
        bldCadastralZone: bldCadastralZone.present
            ? bldCadastralZone.value
            : this.bldCadastralZone,
        bldProperty: bldProperty.present ? bldProperty.value : this.bldProperty,
        bldPermitNumber: bldPermitNumber.present
            ? bldPermitNumber.value
            : this.bldPermitNumber,
        bldPermitDate:
            bldPermitDate.present ? bldPermitDate.value : this.bldPermitDate,
        bldStatus: bldStatus ?? this.bldStatus,
        bldYearConstruction: bldYearConstruction.present
            ? bldYearConstruction.value
            : this.bldYearConstruction,
        bldYearDemolition: bldYearDemolition.present
            ? bldYearDemolition.value
            : this.bldYearDemolition,
        bldType: bldType.present ? bldType.value : this.bldType,
        bldClass: bldClass.present ? bldClass.value : this.bldClass,
        bldArea: bldArea.present ? bldArea.value : this.bldArea,
        bldFloorsAbove:
            bldFloorsAbove.present ? bldFloorsAbove.value : this.bldFloorsAbove,
        bldHeight: bldHeight.present ? bldHeight.value : this.bldHeight,
        bldVolume: bldVolume.present ? bldVolume.value : this.bldVolume,
        bldWasteWater:
            bldWasteWater.present ? bldWasteWater.value : this.bldWasteWater,
        bldElectricity:
            bldElectricity.present ? bldElectricity.value : this.bldElectricity,
        bldPipedGas: bldPipedGas.present ? bldPipedGas.value : this.bldPipedGas,
        bldElevator: bldElevator.present ? bldElevator.value : this.bldElevator,
        createdUser: createdUser.present ? createdUser.value : this.createdUser,
        createdDate: createdDate.present ? createdDate.value : this.createdDate,
        lastEditedUser:
            lastEditedUser.present ? lastEditedUser.value : this.lastEditedUser,
        lastEditedDate:
            lastEditedDate.present ? lastEditedDate.value : this.lastEditedDate,
        bldCentroidStatus: bldCentroidStatus ?? this.bldCentroidStatus,
        bldDwellingRecs: bldDwellingRecs.present
            ? bldDwellingRecs.value
            : this.bldDwellingRecs,
        bldEntranceRecs: bldEntranceRecs.present
            ? bldEntranceRecs.value
            : this.bldEntranceRecs,
        bldAddressId:
            bldAddressId.present ? bldAddressId.value : this.bldAddressId,
        externalCreator: externalCreator.present
            ? externalCreator.value
            : this.externalCreator,
        externalEditor:
            externalEditor.present ? externalEditor.value : this.externalEditor,
        bldReview: bldReview ?? this.bldReview,
        bldWaterSupply:
            bldWaterSupply.present ? bldWaterSupply.value : this.bldWaterSupply,
        externalCreatorDate: externalCreatorDate.present
            ? externalCreatorDate.value
            : this.externalCreatorDate,
        externalEditorDate: externalEditorDate.present
            ? externalEditorDate.value
            : this.externalEditorDate,
      );
  Building copyWithCompanion(BuildingsCompanion data) {
    return Building(
      objectId: data.objectId.present ? data.objectId.value : this.objectId,
      shapeLength:
          data.shapeLength.present ? data.shapeLength.value : this.shapeLength,
      shapeArea: data.shapeArea.present ? data.shapeArea.value : this.shapeArea,
      globalId: data.globalId.present ? data.globalId.value : this.globalId,
      bldCensus2023: data.bldCensus2023.present
          ? data.bldCensus2023.value
          : this.bldCensus2023,
      bldQuality:
          data.bldQuality.present ? data.bldQuality.value : this.bldQuality,
      bldMunicipality: data.bldMunicipality.present
          ? data.bldMunicipality.value
          : this.bldMunicipality,
      bldEnumArea:
          data.bldEnumArea.present ? data.bldEnumArea.value : this.bldEnumArea,
      bldLatitude:
          data.bldLatitude.present ? data.bldLatitude.value : this.bldLatitude,
      bldLongitude: data.bldLongitude.present
          ? data.bldLongitude.value
          : this.bldLongitude,
      bldCadastralZone: data.bldCadastralZone.present
          ? data.bldCadastralZone.value
          : this.bldCadastralZone,
      bldProperty:
          data.bldProperty.present ? data.bldProperty.value : this.bldProperty,
      bldPermitNumber: data.bldPermitNumber.present
          ? data.bldPermitNumber.value
          : this.bldPermitNumber,
      bldPermitDate: data.bldPermitDate.present
          ? data.bldPermitDate.value
          : this.bldPermitDate,
      bldStatus: data.bldStatus.present ? data.bldStatus.value : this.bldStatus,
      bldYearConstruction: data.bldYearConstruction.present
          ? data.bldYearConstruction.value
          : this.bldYearConstruction,
      bldYearDemolition: data.bldYearDemolition.present
          ? data.bldYearDemolition.value
          : this.bldYearDemolition,
      bldType: data.bldType.present ? data.bldType.value : this.bldType,
      bldClass: data.bldClass.present ? data.bldClass.value : this.bldClass,
      bldArea: data.bldArea.present ? data.bldArea.value : this.bldArea,
      bldFloorsAbove: data.bldFloorsAbove.present
          ? data.bldFloorsAbove.value
          : this.bldFloorsAbove,
      bldHeight: data.bldHeight.present ? data.bldHeight.value : this.bldHeight,
      bldVolume: data.bldVolume.present ? data.bldVolume.value : this.bldVolume,
      bldWasteWater: data.bldWasteWater.present
          ? data.bldWasteWater.value
          : this.bldWasteWater,
      bldElectricity: data.bldElectricity.present
          ? data.bldElectricity.value
          : this.bldElectricity,
      bldPipedGas:
          data.bldPipedGas.present ? data.bldPipedGas.value : this.bldPipedGas,
      bldElevator:
          data.bldElevator.present ? data.bldElevator.value : this.bldElevator,
      createdUser:
          data.createdUser.present ? data.createdUser.value : this.createdUser,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      lastEditedUser: data.lastEditedUser.present
          ? data.lastEditedUser.value
          : this.lastEditedUser,
      lastEditedDate: data.lastEditedDate.present
          ? data.lastEditedDate.value
          : this.lastEditedDate,
      bldCentroidStatus: data.bldCentroidStatus.present
          ? data.bldCentroidStatus.value
          : this.bldCentroidStatus,
      bldDwellingRecs: data.bldDwellingRecs.present
          ? data.bldDwellingRecs.value
          : this.bldDwellingRecs,
      bldEntranceRecs: data.bldEntranceRecs.present
          ? data.bldEntranceRecs.value
          : this.bldEntranceRecs,
      bldAddressId: data.bldAddressId.present
          ? data.bldAddressId.value
          : this.bldAddressId,
      externalCreator: data.externalCreator.present
          ? data.externalCreator.value
          : this.externalCreator,
      externalEditor: data.externalEditor.present
          ? data.externalEditor.value
          : this.externalEditor,
      bldReview: data.bldReview.present ? data.bldReview.value : this.bldReview,
      bldWaterSupply: data.bldWaterSupply.present
          ? data.bldWaterSupply.value
          : this.bldWaterSupply,
      externalCreatorDate: data.externalCreatorDate.present
          ? data.externalCreatorDate.value
          : this.externalCreatorDate,
      externalEditorDate: data.externalEditorDate.present
          ? data.externalEditorDate.value
          : this.externalEditorDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Building(')
          ..write('objectId: $objectId, ')
          ..write('shapeLength: $shapeLength, ')
          ..write('shapeArea: $shapeArea, ')
          ..write('globalId: $globalId, ')
          ..write('bldCensus2023: $bldCensus2023, ')
          ..write('bldQuality: $bldQuality, ')
          ..write('bldMunicipality: $bldMunicipality, ')
          ..write('bldEnumArea: $bldEnumArea, ')
          ..write('bldLatitude: $bldLatitude, ')
          ..write('bldLongitude: $bldLongitude, ')
          ..write('bldCadastralZone: $bldCadastralZone, ')
          ..write('bldProperty: $bldProperty, ')
          ..write('bldPermitNumber: $bldPermitNumber, ')
          ..write('bldPermitDate: $bldPermitDate, ')
          ..write('bldStatus: $bldStatus, ')
          ..write('bldYearConstruction: $bldYearConstruction, ')
          ..write('bldYearDemolition: $bldYearDemolition, ')
          ..write('bldType: $bldType, ')
          ..write('bldClass: $bldClass, ')
          ..write('bldArea: $bldArea, ')
          ..write('bldFloorsAbove: $bldFloorsAbove, ')
          ..write('bldHeight: $bldHeight, ')
          ..write('bldVolume: $bldVolume, ')
          ..write('bldWasteWater: $bldWasteWater, ')
          ..write('bldElectricity: $bldElectricity, ')
          ..write('bldPipedGas: $bldPipedGas, ')
          ..write('bldElevator: $bldElevator, ')
          ..write('createdUser: $createdUser, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastEditedUser: $lastEditedUser, ')
          ..write('lastEditedDate: $lastEditedDate, ')
          ..write('bldCentroidStatus: $bldCentroidStatus, ')
          ..write('bldDwellingRecs: $bldDwellingRecs, ')
          ..write('bldEntranceRecs: $bldEntranceRecs, ')
          ..write('bldAddressId: $bldAddressId, ')
          ..write('externalCreator: $externalCreator, ')
          ..write('externalEditor: $externalEditor, ')
          ..write('bldReview: $bldReview, ')
          ..write('bldWaterSupply: $bldWaterSupply, ')
          ..write('externalCreatorDate: $externalCreatorDate, ')
          ..write('externalEditorDate: $externalEditorDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        objectId,
        shapeLength,
        shapeArea,
        globalId,
        bldCensus2023,
        bldQuality,
        bldMunicipality,
        bldEnumArea,
        bldLatitude,
        bldLongitude,
        bldCadastralZone,
        bldProperty,
        bldPermitNumber,
        bldPermitDate,
        bldStatus,
        bldYearConstruction,
        bldYearDemolition,
        bldType,
        bldClass,
        bldArea,
        bldFloorsAbove,
        bldHeight,
        bldVolume,
        bldWasteWater,
        bldElectricity,
        bldPipedGas,
        bldElevator,
        createdUser,
        createdDate,
        lastEditedUser,
        lastEditedDate,
        bldCentroidStatus,
        bldDwellingRecs,
        bldEntranceRecs,
        bldAddressId,
        externalCreator,
        externalEditor,
        bldReview,
        bldWaterSupply,
        externalCreatorDate,
        externalEditorDate
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Building &&
          other.objectId == this.objectId &&
          other.shapeLength == this.shapeLength &&
          other.shapeArea == this.shapeArea &&
          other.globalId == this.globalId &&
          other.bldCensus2023 == this.bldCensus2023 &&
          other.bldQuality == this.bldQuality &&
          other.bldMunicipality == this.bldMunicipality &&
          other.bldEnumArea == this.bldEnumArea &&
          other.bldLatitude == this.bldLatitude &&
          other.bldLongitude == this.bldLongitude &&
          other.bldCadastralZone == this.bldCadastralZone &&
          other.bldProperty == this.bldProperty &&
          other.bldPermitNumber == this.bldPermitNumber &&
          other.bldPermitDate == this.bldPermitDate &&
          other.bldStatus == this.bldStatus &&
          other.bldYearConstruction == this.bldYearConstruction &&
          other.bldYearDemolition == this.bldYearDemolition &&
          other.bldType == this.bldType &&
          other.bldClass == this.bldClass &&
          other.bldArea == this.bldArea &&
          other.bldFloorsAbove == this.bldFloorsAbove &&
          other.bldHeight == this.bldHeight &&
          other.bldVolume == this.bldVolume &&
          other.bldWasteWater == this.bldWasteWater &&
          other.bldElectricity == this.bldElectricity &&
          other.bldPipedGas == this.bldPipedGas &&
          other.bldElevator == this.bldElevator &&
          other.createdUser == this.createdUser &&
          other.createdDate == this.createdDate &&
          other.lastEditedUser == this.lastEditedUser &&
          other.lastEditedDate == this.lastEditedDate &&
          other.bldCentroidStatus == this.bldCentroidStatus &&
          other.bldDwellingRecs == this.bldDwellingRecs &&
          other.bldEntranceRecs == this.bldEntranceRecs &&
          other.bldAddressId == this.bldAddressId &&
          other.externalCreator == this.externalCreator &&
          other.externalEditor == this.externalEditor &&
          other.bldReview == this.bldReview &&
          other.bldWaterSupply == this.bldWaterSupply &&
          other.externalCreatorDate == this.externalCreatorDate &&
          other.externalEditorDate == this.externalEditorDate);
}

class BuildingsCompanion extends UpdateCompanion<Building> {
  final Value<int> objectId;
  final Value<double?> shapeLength;
  final Value<double?> shapeArea;
  final Value<String> globalId;
  final Value<String?> bldCensus2023;
  final Value<int> bldQuality;
  final Value<int> bldMunicipality;
  final Value<String?> bldEnumArea;
  final Value<double> bldLatitude;
  final Value<double> bldLongitude;
  final Value<int?> bldCadastralZone;
  final Value<String?> bldProperty;
  final Value<String?> bldPermitNumber;
  final Value<DateTime?> bldPermitDate;
  final Value<int> bldStatus;
  final Value<int?> bldYearConstruction;
  final Value<int?> bldYearDemolition;
  final Value<int?> bldType;
  final Value<int?> bldClass;
  final Value<double?> bldArea;
  final Value<int?> bldFloorsAbove;
  final Value<int?> bldHeight;
  final Value<double?> bldVolume;
  final Value<int?> bldWasteWater;
  final Value<int?> bldElectricity;
  final Value<int?> bldPipedGas;
  final Value<int?> bldElevator;
  final Value<String?> createdUser;
  final Value<DateTime?> createdDate;
  final Value<String?> lastEditedUser;
  final Value<DateTime?> lastEditedDate;
  final Value<int> bldCentroidStatus;
  final Value<int?> bldDwellingRecs;
  final Value<int?> bldEntranceRecs;
  final Value<String?> bldAddressId;
  final Value<String?> externalCreator;
  final Value<String?> externalEditor;
  final Value<int> bldReview;
  final Value<int?> bldWaterSupply;
  final Value<DateTime?> externalCreatorDate;
  final Value<DateTime?> externalEditorDate;
  const BuildingsCompanion({
    this.objectId = const Value.absent(),
    this.shapeLength = const Value.absent(),
    this.shapeArea = const Value.absent(),
    this.globalId = const Value.absent(),
    this.bldCensus2023 = const Value.absent(),
    this.bldQuality = const Value.absent(),
    this.bldMunicipality = const Value.absent(),
    this.bldEnumArea = const Value.absent(),
    this.bldLatitude = const Value.absent(),
    this.bldLongitude = const Value.absent(),
    this.bldCadastralZone = const Value.absent(),
    this.bldProperty = const Value.absent(),
    this.bldPermitNumber = const Value.absent(),
    this.bldPermitDate = const Value.absent(),
    this.bldStatus = const Value.absent(),
    this.bldYearConstruction = const Value.absent(),
    this.bldYearDemolition = const Value.absent(),
    this.bldType = const Value.absent(),
    this.bldClass = const Value.absent(),
    this.bldArea = const Value.absent(),
    this.bldFloorsAbove = const Value.absent(),
    this.bldHeight = const Value.absent(),
    this.bldVolume = const Value.absent(),
    this.bldWasteWater = const Value.absent(),
    this.bldElectricity = const Value.absent(),
    this.bldPipedGas = const Value.absent(),
    this.bldElevator = const Value.absent(),
    this.createdUser = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastEditedUser = const Value.absent(),
    this.lastEditedDate = const Value.absent(),
    this.bldCentroidStatus = const Value.absent(),
    this.bldDwellingRecs = const Value.absent(),
    this.bldEntranceRecs = const Value.absent(),
    this.bldAddressId = const Value.absent(),
    this.externalCreator = const Value.absent(),
    this.externalEditor = const Value.absent(),
    this.bldReview = const Value.absent(),
    this.bldWaterSupply = const Value.absent(),
    this.externalCreatorDate = const Value.absent(),
    this.externalEditorDate = const Value.absent(),
  });
  BuildingsCompanion.insert({
    this.objectId = const Value.absent(),
    this.shapeLength = const Value.absent(),
    this.shapeArea = const Value.absent(),
    required String globalId,
    this.bldCensus2023 = const Value.absent(),
    this.bldQuality = const Value.absent(),
    required int bldMunicipality,
    this.bldEnumArea = const Value.absent(),
    required double bldLatitude,
    required double bldLongitude,
    this.bldCadastralZone = const Value.absent(),
    this.bldProperty = const Value.absent(),
    this.bldPermitNumber = const Value.absent(),
    this.bldPermitDate = const Value.absent(),
    this.bldStatus = const Value.absent(),
    this.bldYearConstruction = const Value.absent(),
    this.bldYearDemolition = const Value.absent(),
    this.bldType = const Value.absent(),
    this.bldClass = const Value.absent(),
    this.bldArea = const Value.absent(),
    this.bldFloorsAbove = const Value.absent(),
    this.bldHeight = const Value.absent(),
    this.bldVolume = const Value.absent(),
    this.bldWasteWater = const Value.absent(),
    this.bldElectricity = const Value.absent(),
    this.bldPipedGas = const Value.absent(),
    this.bldElevator = const Value.absent(),
    this.createdUser = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastEditedUser = const Value.absent(),
    this.lastEditedDate = const Value.absent(),
    this.bldCentroidStatus = const Value.absent(),
    this.bldDwellingRecs = const Value.absent(),
    this.bldEntranceRecs = const Value.absent(),
    this.bldAddressId = const Value.absent(),
    this.externalCreator = const Value.absent(),
    this.externalEditor = const Value.absent(),
    this.bldReview = const Value.absent(),
    this.bldWaterSupply = const Value.absent(),
    this.externalCreatorDate = const Value.absent(),
    this.externalEditorDate = const Value.absent(),
  })  : globalId = Value(globalId),
        bldMunicipality = Value(bldMunicipality),
        bldLatitude = Value(bldLatitude),
        bldLongitude = Value(bldLongitude);
  static Insertable<Building> custom({
    Expression<int>? objectId,
    Expression<double>? shapeLength,
    Expression<double>? shapeArea,
    Expression<String>? globalId,
    Expression<String>? bldCensus2023,
    Expression<int>? bldQuality,
    Expression<int>? bldMunicipality,
    Expression<String>? bldEnumArea,
    Expression<double>? bldLatitude,
    Expression<double>? bldLongitude,
    Expression<int>? bldCadastralZone,
    Expression<String>? bldProperty,
    Expression<String>? bldPermitNumber,
    Expression<DateTime>? bldPermitDate,
    Expression<int>? bldStatus,
    Expression<int>? bldYearConstruction,
    Expression<int>? bldYearDemolition,
    Expression<int>? bldType,
    Expression<int>? bldClass,
    Expression<double>? bldArea,
    Expression<int>? bldFloorsAbove,
    Expression<int>? bldHeight,
    Expression<double>? bldVolume,
    Expression<int>? bldWasteWater,
    Expression<int>? bldElectricity,
    Expression<int>? bldPipedGas,
    Expression<int>? bldElevator,
    Expression<String>? createdUser,
    Expression<DateTime>? createdDate,
    Expression<String>? lastEditedUser,
    Expression<DateTime>? lastEditedDate,
    Expression<int>? bldCentroidStatus,
    Expression<int>? bldDwellingRecs,
    Expression<int>? bldEntranceRecs,
    Expression<String>? bldAddressId,
    Expression<String>? externalCreator,
    Expression<String>? externalEditor,
    Expression<int>? bldReview,
    Expression<int>? bldWaterSupply,
    Expression<DateTime>? externalCreatorDate,
    Expression<DateTime>? externalEditorDate,
  }) {
    return RawValuesInsertable({
      if (objectId != null) 'object_id': objectId,
      if (shapeLength != null) 'shape_length': shapeLength,
      if (shapeArea != null) 'shape_area': shapeArea,
      if (globalId != null) 'global_id': globalId,
      if (bldCensus2023 != null) 'bld_census2023': bldCensus2023,
      if (bldQuality != null) 'bld_quality': bldQuality,
      if (bldMunicipality != null) 'bld_municipality': bldMunicipality,
      if (bldEnumArea != null) 'bld_enum_area': bldEnumArea,
      if (bldLatitude != null) 'bld_latitude': bldLatitude,
      if (bldLongitude != null) 'bld_longitude': bldLongitude,
      if (bldCadastralZone != null) 'bld_cadastral_zone': bldCadastralZone,
      if (bldProperty != null) 'bld_property': bldProperty,
      if (bldPermitNumber != null) 'bld_permit_number': bldPermitNumber,
      if (bldPermitDate != null) 'bld_permit_date': bldPermitDate,
      if (bldStatus != null) 'bld_status': bldStatus,
      if (bldYearConstruction != null)
        'bld_year_construction': bldYearConstruction,
      if (bldYearDemolition != null) 'bld_year_demolition': bldYearDemolition,
      if (bldType != null) 'bld_type': bldType,
      if (bldClass != null) 'bld_class': bldClass,
      if (bldArea != null) 'bld_area': bldArea,
      if (bldFloorsAbove != null) 'bld_floors_above': bldFloorsAbove,
      if (bldHeight != null) 'bld_height': bldHeight,
      if (bldVolume != null) 'bld_volume': bldVolume,
      if (bldWasteWater != null) 'bld_waste_water': bldWasteWater,
      if (bldElectricity != null) 'bld_electricity': bldElectricity,
      if (bldPipedGas != null) 'bld_piped_gas': bldPipedGas,
      if (bldElevator != null) 'bld_elevator': bldElevator,
      if (createdUser != null) 'created_user': createdUser,
      if (createdDate != null) 'created_date': createdDate,
      if (lastEditedUser != null) 'last_edited_user': lastEditedUser,
      if (lastEditedDate != null) 'last_edited_date': lastEditedDate,
      if (bldCentroidStatus != null) 'bld_centroid_status': bldCentroidStatus,
      if (bldDwellingRecs != null) 'bld_dwelling_recs': bldDwellingRecs,
      if (bldEntranceRecs != null) 'bld_entrance_recs': bldEntranceRecs,
      if (bldAddressId != null) 'bld_address_id': bldAddressId,
      if (externalCreator != null) 'external_creator': externalCreator,
      if (externalEditor != null) 'external_editor': externalEditor,
      if (bldReview != null) 'bld_review': bldReview,
      if (bldWaterSupply != null) 'bld_water_supply': bldWaterSupply,
      if (externalCreatorDate != null)
        'external_creator_date': externalCreatorDate,
      if (externalEditorDate != null)
        'external_editor_date': externalEditorDate,
    });
  }

  BuildingsCompanion copyWith(
      {Value<int>? objectId,
      Value<double?>? shapeLength,
      Value<double?>? shapeArea,
      Value<String>? globalId,
      Value<String?>? bldCensus2023,
      Value<int>? bldQuality,
      Value<int>? bldMunicipality,
      Value<String?>? bldEnumArea,
      Value<double>? bldLatitude,
      Value<double>? bldLongitude,
      Value<int?>? bldCadastralZone,
      Value<String?>? bldProperty,
      Value<String?>? bldPermitNumber,
      Value<DateTime?>? bldPermitDate,
      Value<int>? bldStatus,
      Value<int?>? bldYearConstruction,
      Value<int?>? bldYearDemolition,
      Value<int?>? bldType,
      Value<int?>? bldClass,
      Value<double?>? bldArea,
      Value<int?>? bldFloorsAbove,
      Value<int?>? bldHeight,
      Value<double?>? bldVolume,
      Value<int?>? bldWasteWater,
      Value<int?>? bldElectricity,
      Value<int?>? bldPipedGas,
      Value<int?>? bldElevator,
      Value<String?>? createdUser,
      Value<DateTime?>? createdDate,
      Value<String?>? lastEditedUser,
      Value<DateTime?>? lastEditedDate,
      Value<int>? bldCentroidStatus,
      Value<int?>? bldDwellingRecs,
      Value<int?>? bldEntranceRecs,
      Value<String?>? bldAddressId,
      Value<String?>? externalCreator,
      Value<String?>? externalEditor,
      Value<int>? bldReview,
      Value<int?>? bldWaterSupply,
      Value<DateTime?>? externalCreatorDate,
      Value<DateTime?>? externalEditorDate}) {
    return BuildingsCompanion(
      objectId: objectId ?? this.objectId,
      shapeLength: shapeLength ?? this.shapeLength,
      shapeArea: shapeArea ?? this.shapeArea,
      globalId: globalId ?? this.globalId,
      bldCensus2023: bldCensus2023 ?? this.bldCensus2023,
      bldQuality: bldQuality ?? this.bldQuality,
      bldMunicipality: bldMunicipality ?? this.bldMunicipality,
      bldEnumArea: bldEnumArea ?? this.bldEnumArea,
      bldLatitude: bldLatitude ?? this.bldLatitude,
      bldLongitude: bldLongitude ?? this.bldLongitude,
      bldCadastralZone: bldCadastralZone ?? this.bldCadastralZone,
      bldProperty: bldProperty ?? this.bldProperty,
      bldPermitNumber: bldPermitNumber ?? this.bldPermitNumber,
      bldPermitDate: bldPermitDate ?? this.bldPermitDate,
      bldStatus: bldStatus ?? this.bldStatus,
      bldYearConstruction: bldYearConstruction ?? this.bldYearConstruction,
      bldYearDemolition: bldYearDemolition ?? this.bldYearDemolition,
      bldType: bldType ?? this.bldType,
      bldClass: bldClass ?? this.bldClass,
      bldArea: bldArea ?? this.bldArea,
      bldFloorsAbove: bldFloorsAbove ?? this.bldFloorsAbove,
      bldHeight: bldHeight ?? this.bldHeight,
      bldVolume: bldVolume ?? this.bldVolume,
      bldWasteWater: bldWasteWater ?? this.bldWasteWater,
      bldElectricity: bldElectricity ?? this.bldElectricity,
      bldPipedGas: bldPipedGas ?? this.bldPipedGas,
      bldElevator: bldElevator ?? this.bldElevator,
      createdUser: createdUser ?? this.createdUser,
      createdDate: createdDate ?? this.createdDate,
      lastEditedUser: lastEditedUser ?? this.lastEditedUser,
      lastEditedDate: lastEditedDate ?? this.lastEditedDate,
      bldCentroidStatus: bldCentroidStatus ?? this.bldCentroidStatus,
      bldDwellingRecs: bldDwellingRecs ?? this.bldDwellingRecs,
      bldEntranceRecs: bldEntranceRecs ?? this.bldEntranceRecs,
      bldAddressId: bldAddressId ?? this.bldAddressId,
      externalCreator: externalCreator ?? this.externalCreator,
      externalEditor: externalEditor ?? this.externalEditor,
      bldReview: bldReview ?? this.bldReview,
      bldWaterSupply: bldWaterSupply ?? this.bldWaterSupply,
      externalCreatorDate: externalCreatorDate ?? this.externalCreatorDate,
      externalEditorDate: externalEditorDate ?? this.externalEditorDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (objectId.present) {
      map['object_id'] = Variable<int>(objectId.value);
    }
    if (shapeLength.present) {
      map['shape_length'] = Variable<double>(shapeLength.value);
    }
    if (shapeArea.present) {
      map['shape_area'] = Variable<double>(shapeArea.value);
    }
    if (globalId.present) {
      map['global_id'] = Variable<String>(globalId.value);
    }
    if (bldCensus2023.present) {
      map['bld_census2023'] = Variable<String>(bldCensus2023.value);
    }
    if (bldQuality.present) {
      map['bld_quality'] = Variable<int>(bldQuality.value);
    }
    if (bldMunicipality.present) {
      map['bld_municipality'] = Variable<int>(bldMunicipality.value);
    }
    if (bldEnumArea.present) {
      map['bld_enum_area'] = Variable<String>(bldEnumArea.value);
    }
    if (bldLatitude.present) {
      map['bld_latitude'] = Variable<double>(bldLatitude.value);
    }
    if (bldLongitude.present) {
      map['bld_longitude'] = Variable<double>(bldLongitude.value);
    }
    if (bldCadastralZone.present) {
      map['bld_cadastral_zone'] = Variable<int>(bldCadastralZone.value);
    }
    if (bldProperty.present) {
      map['bld_property'] = Variable<String>(bldProperty.value);
    }
    if (bldPermitNumber.present) {
      map['bld_permit_number'] = Variable<String>(bldPermitNumber.value);
    }
    if (bldPermitDate.present) {
      map['bld_permit_date'] = Variable<DateTime>(bldPermitDate.value);
    }
    if (bldStatus.present) {
      map['bld_status'] = Variable<int>(bldStatus.value);
    }
    if (bldYearConstruction.present) {
      map['bld_year_construction'] = Variable<int>(bldYearConstruction.value);
    }
    if (bldYearDemolition.present) {
      map['bld_year_demolition'] = Variable<int>(bldYearDemolition.value);
    }
    if (bldType.present) {
      map['bld_type'] = Variable<int>(bldType.value);
    }
    if (bldClass.present) {
      map['bld_class'] = Variable<int>(bldClass.value);
    }
    if (bldArea.present) {
      map['bld_area'] = Variable<double>(bldArea.value);
    }
    if (bldFloorsAbove.present) {
      map['bld_floors_above'] = Variable<int>(bldFloorsAbove.value);
    }
    if (bldHeight.present) {
      map['bld_height'] = Variable<int>(bldHeight.value);
    }
    if (bldVolume.present) {
      map['bld_volume'] = Variable<double>(bldVolume.value);
    }
    if (bldWasteWater.present) {
      map['bld_waste_water'] = Variable<int>(bldWasteWater.value);
    }
    if (bldElectricity.present) {
      map['bld_electricity'] = Variable<int>(bldElectricity.value);
    }
    if (bldPipedGas.present) {
      map['bld_piped_gas'] = Variable<int>(bldPipedGas.value);
    }
    if (bldElevator.present) {
      map['bld_elevator'] = Variable<int>(bldElevator.value);
    }
    if (createdUser.present) {
      map['created_user'] = Variable<String>(createdUser.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (lastEditedUser.present) {
      map['last_edited_user'] = Variable<String>(lastEditedUser.value);
    }
    if (lastEditedDate.present) {
      map['last_edited_date'] = Variable<DateTime>(lastEditedDate.value);
    }
    if (bldCentroidStatus.present) {
      map['bld_centroid_status'] = Variable<int>(bldCentroidStatus.value);
    }
    if (bldDwellingRecs.present) {
      map['bld_dwelling_recs'] = Variable<int>(bldDwellingRecs.value);
    }
    if (bldEntranceRecs.present) {
      map['bld_entrance_recs'] = Variable<int>(bldEntranceRecs.value);
    }
    if (bldAddressId.present) {
      map['bld_address_id'] = Variable<String>(bldAddressId.value);
    }
    if (externalCreator.present) {
      map['external_creator'] = Variable<String>(externalCreator.value);
    }
    if (externalEditor.present) {
      map['external_editor'] = Variable<String>(externalEditor.value);
    }
    if (bldReview.present) {
      map['bld_review'] = Variable<int>(bldReview.value);
    }
    if (bldWaterSupply.present) {
      map['bld_water_supply'] = Variable<int>(bldWaterSupply.value);
    }
    if (externalCreatorDate.present) {
      map['external_creator_date'] =
          Variable<DateTime>(externalCreatorDate.value);
    }
    if (externalEditorDate.present) {
      map['external_editor_date'] =
          Variable<DateTime>(externalEditorDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuildingsCompanion(')
          ..write('objectId: $objectId, ')
          ..write('shapeLength: $shapeLength, ')
          ..write('shapeArea: $shapeArea, ')
          ..write('globalId: $globalId, ')
          ..write('bldCensus2023: $bldCensus2023, ')
          ..write('bldQuality: $bldQuality, ')
          ..write('bldMunicipality: $bldMunicipality, ')
          ..write('bldEnumArea: $bldEnumArea, ')
          ..write('bldLatitude: $bldLatitude, ')
          ..write('bldLongitude: $bldLongitude, ')
          ..write('bldCadastralZone: $bldCadastralZone, ')
          ..write('bldProperty: $bldProperty, ')
          ..write('bldPermitNumber: $bldPermitNumber, ')
          ..write('bldPermitDate: $bldPermitDate, ')
          ..write('bldStatus: $bldStatus, ')
          ..write('bldYearConstruction: $bldYearConstruction, ')
          ..write('bldYearDemolition: $bldYearDemolition, ')
          ..write('bldType: $bldType, ')
          ..write('bldClass: $bldClass, ')
          ..write('bldArea: $bldArea, ')
          ..write('bldFloorsAbove: $bldFloorsAbove, ')
          ..write('bldHeight: $bldHeight, ')
          ..write('bldVolume: $bldVolume, ')
          ..write('bldWasteWater: $bldWasteWater, ')
          ..write('bldElectricity: $bldElectricity, ')
          ..write('bldPipedGas: $bldPipedGas, ')
          ..write('bldElevator: $bldElevator, ')
          ..write('createdUser: $createdUser, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastEditedUser: $lastEditedUser, ')
          ..write('lastEditedDate: $lastEditedDate, ')
          ..write('bldCentroidStatus: $bldCentroidStatus, ')
          ..write('bldDwellingRecs: $bldDwellingRecs, ')
          ..write('bldEntranceRecs: $bldEntranceRecs, ')
          ..write('bldAddressId: $bldAddressId, ')
          ..write('externalCreator: $externalCreator, ')
          ..write('externalEditor: $externalEditor, ')
          ..write('bldReview: $bldReview, ')
          ..write('bldWaterSupply: $bldWaterSupply, ')
          ..write('externalCreatorDate: $externalCreatorDate, ')
          ..write('externalEditorDate: $externalEditorDate')
          ..write(')'))
        .toString();
  }
}

class $EntrancesTable extends Entrances
    with TableInfo<$EntrancesTable, Entrance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntrancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _objectIdMeta =
      const VerificationMeta('objectId');
  @override
  late final GeneratedColumn<int> objectId = GeneratedColumn<int>(
      'object_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entCensus2023Meta =
      const VerificationMeta('entCensus2023');
  @override
  late final GeneratedColumn<String> entCensus2023 = GeneratedColumn<String>(
      'ent_census2023', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 13),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('9999999999999'));
  static const VerificationMeta _externalCreatorDateMeta =
      const VerificationMeta('externalCreatorDate');
  @override
  late final GeneratedColumn<DateTime> externalCreatorDate =
      GeneratedColumn<DateTime>('external_creator_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _externalEditorDateMeta =
      const VerificationMeta('externalEditorDate');
  @override
  late final GeneratedColumn<DateTime> externalEditorDate =
      GeneratedColumn<DateTime>('external_editor_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _globalIdMeta =
      const VerificationMeta('globalId');
  @override
  late final GeneratedColumn<String> globalId = GeneratedColumn<String>(
      'global_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entBldGlobalIdMeta =
      const VerificationMeta('entBldGlobalId');
  @override
  late final GeneratedColumn<String> entBldGlobalId = GeneratedColumn<String>(
      'ent_bld_global_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('00000000-0000-0000-0000-000000000000'));
  static const VerificationMeta _entAddressIdMeta =
      const VerificationMeta('entAddressId');
  @override
  late final GeneratedColumn<String> entAddressId = GeneratedColumn<String>(
      'ent_address_id', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _entQualityMeta =
      const VerificationMeta('entQuality');
  @override
  late final GeneratedColumn<int> entQuality = GeneratedColumn<int>(
      'ent_quality', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _entLatitudeMeta =
      const VerificationMeta('entLatitude');
  @override
  late final GeneratedColumn<double> entLatitude = GeneratedColumn<double>(
      'ent_latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _entLongitudeMeta =
      const VerificationMeta('entLongitude');
  @override
  late final GeneratedColumn<double> entLongitude = GeneratedColumn<double>(
      'ent_longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _entPointStatusMeta =
      const VerificationMeta('entPointStatus');
  @override
  late final GeneratedColumn<int> entPointStatus = GeneratedColumn<int>(
      'ent_point_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _entStrGlobalIdMeta =
      const VerificationMeta('entStrGlobalId');
  @override
  late final GeneratedColumn<String> entStrGlobalId = GeneratedColumn<String>(
      'ent_str_global_id', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _entBuildingNumberMeta =
      const VerificationMeta('entBuildingNumber');
  @override
  late final GeneratedColumn<String> entBuildingNumber =
      GeneratedColumn<String>('ent_building_number', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 1, maxTextLength: 5),
          type: DriftSqlType.string,
          requiredDuringInsert: false);
  static const VerificationMeta _entEntranceNumberMeta =
      const VerificationMeta('entEntranceNumber');
  @override
  late final GeneratedColumn<String> entEntranceNumber =
      GeneratedColumn<String>('ent_entrance_number', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 1, maxTextLength: 4),
          type: DriftSqlType.string,
          requiredDuringInsert: false);
  static const VerificationMeta _entTownMeta =
      const VerificationMeta('entTown');
  @override
  late final GeneratedColumn<int> entTown = GeneratedColumn<int>(
      'ent_town', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _entZipCodeMeta =
      const VerificationMeta('entZipCode');
  @override
  late final GeneratedColumn<int> entZipCode = GeneratedColumn<int>(
      'ent_zip_code', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _entDwellingRecsMeta =
      const VerificationMeta('entDwellingRecs');
  @override
  late final GeneratedColumn<int> entDwellingRecs = GeneratedColumn<int>(
      'ent_dwelling_recs', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _entDwellingExpecMeta =
      const VerificationMeta('entDwellingExpec');
  @override
  late final GeneratedColumn<int> entDwellingExpec = GeneratedColumn<int>(
      'ent_dwelling_expec', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdUserMeta =
      const VerificationMeta('createdUser');
  @override
  late final GeneratedColumn<String> createdUser = GeneratedColumn<String>(
      'created_user', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastEditedUserMeta =
      const VerificationMeta('lastEditedUser');
  @override
  late final GeneratedColumn<String> lastEditedUser = GeneratedColumn<String>(
      'last_edited_user', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _lastEditedDateMeta =
      const VerificationMeta('lastEditedDate');
  @override
  late final GeneratedColumn<DateTime> lastEditedDate =
      GeneratedColumn<DateTime>('last_edited_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _externalCreatorMeta =
      const VerificationMeta('externalCreator');
  @override
  late final GeneratedColumn<String> externalCreator = GeneratedColumn<String>(
      'external_creator', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _externalEditorMeta =
      const VerificationMeta('externalEditor');
  @override
  late final GeneratedColumn<String> externalEditor = GeneratedColumn<String>(
      'external_editor', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        objectId,
        entCensus2023,
        externalCreatorDate,
        externalEditorDate,
        globalId,
        entBldGlobalId,
        entAddressId,
        entQuality,
        entLatitude,
        entLongitude,
        entPointStatus,
        entStrGlobalId,
        entBuildingNumber,
        entEntranceNumber,
        entTown,
        entZipCode,
        entDwellingRecs,
        entDwellingExpec,
        createdUser,
        createdDate,
        lastEditedUser,
        lastEditedDate,
        externalCreator,
        externalEditor
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entrances';
  @override
  VerificationContext validateIntegrity(Insertable<Entrance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('object_id')) {
      context.handle(_objectIdMeta,
          objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta));
    }
    if (data.containsKey('ent_census2023')) {
      context.handle(
          _entCensus2023Meta,
          entCensus2023.isAcceptableOrUnknown(
              data['ent_census2023']!, _entCensus2023Meta));
    }
    if (data.containsKey('external_creator_date')) {
      context.handle(
          _externalCreatorDateMeta,
          externalCreatorDate.isAcceptableOrUnknown(
              data['external_creator_date']!, _externalCreatorDateMeta));
    }
    if (data.containsKey('external_editor_date')) {
      context.handle(
          _externalEditorDateMeta,
          externalEditorDate.isAcceptableOrUnknown(
              data['external_editor_date']!, _externalEditorDateMeta));
    }
    if (data.containsKey('global_id')) {
      context.handle(_globalIdMeta,
          globalId.isAcceptableOrUnknown(data['global_id']!, _globalIdMeta));
    } else if (isInserting) {
      context.missing(_globalIdMeta);
    }
    if (data.containsKey('ent_bld_global_id')) {
      context.handle(
          _entBldGlobalIdMeta,
          entBldGlobalId.isAcceptableOrUnknown(
              data['ent_bld_global_id']!, _entBldGlobalIdMeta));
    }
    if (data.containsKey('ent_address_id')) {
      context.handle(
          _entAddressIdMeta,
          entAddressId.isAcceptableOrUnknown(
              data['ent_address_id']!, _entAddressIdMeta));
    }
    if (data.containsKey('ent_quality')) {
      context.handle(
          _entQualityMeta,
          entQuality.isAcceptableOrUnknown(
              data['ent_quality']!, _entQualityMeta));
    }
    if (data.containsKey('ent_latitude')) {
      context.handle(
          _entLatitudeMeta,
          entLatitude.isAcceptableOrUnknown(
              data['ent_latitude']!, _entLatitudeMeta));
    } else if (isInserting) {
      context.missing(_entLatitudeMeta);
    }
    if (data.containsKey('ent_longitude')) {
      context.handle(
          _entLongitudeMeta,
          entLongitude.isAcceptableOrUnknown(
              data['ent_longitude']!, _entLongitudeMeta));
    } else if (isInserting) {
      context.missing(_entLongitudeMeta);
    }
    if (data.containsKey('ent_point_status')) {
      context.handle(
          _entPointStatusMeta,
          entPointStatus.isAcceptableOrUnknown(
              data['ent_point_status']!, _entPointStatusMeta));
    }
    if (data.containsKey('ent_str_global_id')) {
      context.handle(
          _entStrGlobalIdMeta,
          entStrGlobalId.isAcceptableOrUnknown(
              data['ent_str_global_id']!, _entStrGlobalIdMeta));
    }
    if (data.containsKey('ent_building_number')) {
      context.handle(
          _entBuildingNumberMeta,
          entBuildingNumber.isAcceptableOrUnknown(
              data['ent_building_number']!, _entBuildingNumberMeta));
    }
    if (data.containsKey('ent_entrance_number')) {
      context.handle(
          _entEntranceNumberMeta,
          entEntranceNumber.isAcceptableOrUnknown(
              data['ent_entrance_number']!, _entEntranceNumberMeta));
    }
    if (data.containsKey('ent_town')) {
      context.handle(_entTownMeta,
          entTown.isAcceptableOrUnknown(data['ent_town']!, _entTownMeta));
    }
    if (data.containsKey('ent_zip_code')) {
      context.handle(
          _entZipCodeMeta,
          entZipCode.isAcceptableOrUnknown(
              data['ent_zip_code']!, _entZipCodeMeta));
    }
    if (data.containsKey('ent_dwelling_recs')) {
      context.handle(
          _entDwellingRecsMeta,
          entDwellingRecs.isAcceptableOrUnknown(
              data['ent_dwelling_recs']!, _entDwellingRecsMeta));
    }
    if (data.containsKey('ent_dwelling_expec')) {
      context.handle(
          _entDwellingExpecMeta,
          entDwellingExpec.isAcceptableOrUnknown(
              data['ent_dwelling_expec']!, _entDwellingExpecMeta));
    }
    if (data.containsKey('created_user')) {
      context.handle(
          _createdUserMeta,
          createdUser.isAcceptableOrUnknown(
              data['created_user']!, _createdUserMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    if (data.containsKey('last_edited_user')) {
      context.handle(
          _lastEditedUserMeta,
          lastEditedUser.isAcceptableOrUnknown(
              data['last_edited_user']!, _lastEditedUserMeta));
    }
    if (data.containsKey('last_edited_date')) {
      context.handle(
          _lastEditedDateMeta,
          lastEditedDate.isAcceptableOrUnknown(
              data['last_edited_date']!, _lastEditedDateMeta));
    }
    if (data.containsKey('external_creator')) {
      context.handle(
          _externalCreatorMeta,
          externalCreator.isAcceptableOrUnknown(
              data['external_creator']!, _externalCreatorMeta));
    }
    if (data.containsKey('external_editor')) {
      context.handle(
          _externalEditorMeta,
          externalEditor.isAcceptableOrUnknown(
              data['external_editor']!, _externalEditorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {objectId};
  @override
  Entrance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entrance(
      objectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_id'])!,
      entCensus2023: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ent_census2023']),
      externalCreatorDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}external_creator_date']),
      externalEditorDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}external_editor_date']),
      globalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}global_id'])!,
      entBldGlobalId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ent_bld_global_id'])!,
      entAddressId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ent_address_id']),
      entQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ent_quality'])!,
      entLatitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ent_latitude'])!,
      entLongitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ent_longitude'])!,
      entPointStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ent_point_status'])!,
      entStrGlobalId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ent_str_global_id']),
      entBuildingNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ent_building_number']),
      entEntranceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ent_entrance_number']),
      entTown: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ent_town']),
      entZipCode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ent_zip_code']),
      entDwellingRecs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ent_dwelling_recs']),
      entDwellingExpec: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ent_dwelling_expec']),
      createdUser: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_user']),
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date']),
      lastEditedUser: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_edited_user']),
      lastEditedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_edited_date']),
      externalCreator: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}external_creator']),
      externalEditor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_editor']),
    );
  }

  @override
  $EntrancesTable createAlias(String alias) {
    return $EntrancesTable(attachedDatabase, alias);
  }
}

class Entrance extends DataClass implements Insertable<Entrance> {
  final int objectId;
  final String? entCensus2023;
  final DateTime? externalCreatorDate;
  final DateTime? externalEditorDate;
  final String globalId;
  final String entBldGlobalId;
  final String? entAddressId;
  final int entQuality;
  final double entLatitude;
  final double entLongitude;
  final int entPointStatus;
  final String? entStrGlobalId;
  final String? entBuildingNumber;
  final String? entEntranceNumber;
  final int? entTown;
  final int? entZipCode;
  final int? entDwellingRecs;
  final int? entDwellingExpec;
  final String? createdUser;
  final DateTime? createdDate;
  final String? lastEditedUser;
  final DateTime? lastEditedDate;
  final String? externalCreator;
  final String? externalEditor;
  const Entrance(
      {required this.objectId,
      this.entCensus2023,
      this.externalCreatorDate,
      this.externalEditorDate,
      required this.globalId,
      required this.entBldGlobalId,
      this.entAddressId,
      required this.entQuality,
      required this.entLatitude,
      required this.entLongitude,
      required this.entPointStatus,
      this.entStrGlobalId,
      this.entBuildingNumber,
      this.entEntranceNumber,
      this.entTown,
      this.entZipCode,
      this.entDwellingRecs,
      this.entDwellingExpec,
      this.createdUser,
      this.createdDate,
      this.lastEditedUser,
      this.lastEditedDate,
      this.externalCreator,
      this.externalEditor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['object_id'] = Variable<int>(objectId);
    if (!nullToAbsent || entCensus2023 != null) {
      map['ent_census2023'] = Variable<String>(entCensus2023);
    }
    if (!nullToAbsent || externalCreatorDate != null) {
      map['external_creator_date'] = Variable<DateTime>(externalCreatorDate);
    }
    if (!nullToAbsent || externalEditorDate != null) {
      map['external_editor_date'] = Variable<DateTime>(externalEditorDate);
    }
    map['global_id'] = Variable<String>(globalId);
    map['ent_bld_global_id'] = Variable<String>(entBldGlobalId);
    if (!nullToAbsent || entAddressId != null) {
      map['ent_address_id'] = Variable<String>(entAddressId);
    }
    map['ent_quality'] = Variable<int>(entQuality);
    map['ent_latitude'] = Variable<double>(entLatitude);
    map['ent_longitude'] = Variable<double>(entLongitude);
    map['ent_point_status'] = Variable<int>(entPointStatus);
    if (!nullToAbsent || entStrGlobalId != null) {
      map['ent_str_global_id'] = Variable<String>(entStrGlobalId);
    }
    if (!nullToAbsent || entBuildingNumber != null) {
      map['ent_building_number'] = Variable<String>(entBuildingNumber);
    }
    if (!nullToAbsent || entEntranceNumber != null) {
      map['ent_entrance_number'] = Variable<String>(entEntranceNumber);
    }
    if (!nullToAbsent || entTown != null) {
      map['ent_town'] = Variable<int>(entTown);
    }
    if (!nullToAbsent || entZipCode != null) {
      map['ent_zip_code'] = Variable<int>(entZipCode);
    }
    if (!nullToAbsent || entDwellingRecs != null) {
      map['ent_dwelling_recs'] = Variable<int>(entDwellingRecs);
    }
    if (!nullToAbsent || entDwellingExpec != null) {
      map['ent_dwelling_expec'] = Variable<int>(entDwellingExpec);
    }
    if (!nullToAbsent || createdUser != null) {
      map['created_user'] = Variable<String>(createdUser);
    }
    if (!nullToAbsent || createdDate != null) {
      map['created_date'] = Variable<DateTime>(createdDate);
    }
    if (!nullToAbsent || lastEditedUser != null) {
      map['last_edited_user'] = Variable<String>(lastEditedUser);
    }
    if (!nullToAbsent || lastEditedDate != null) {
      map['last_edited_date'] = Variable<DateTime>(lastEditedDate);
    }
    if (!nullToAbsent || externalCreator != null) {
      map['external_creator'] = Variable<String>(externalCreator);
    }
    if (!nullToAbsent || externalEditor != null) {
      map['external_editor'] = Variable<String>(externalEditor);
    }
    return map;
  }

  EntrancesCompanion toCompanion(bool nullToAbsent) {
    return EntrancesCompanion(
      objectId: Value(objectId),
      entCensus2023: entCensus2023 == null && nullToAbsent
          ? const Value.absent()
          : Value(entCensus2023),
      externalCreatorDate: externalCreatorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(externalCreatorDate),
      externalEditorDate: externalEditorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEditorDate),
      globalId: Value(globalId),
      entBldGlobalId: Value(entBldGlobalId),
      entAddressId: entAddressId == null && nullToAbsent
          ? const Value.absent()
          : Value(entAddressId),
      entQuality: Value(entQuality),
      entLatitude: Value(entLatitude),
      entLongitude: Value(entLongitude),
      entPointStatus: Value(entPointStatus),
      entStrGlobalId: entStrGlobalId == null && nullToAbsent
          ? const Value.absent()
          : Value(entStrGlobalId),
      entBuildingNumber: entBuildingNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(entBuildingNumber),
      entEntranceNumber: entEntranceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(entEntranceNumber),
      entTown: entTown == null && nullToAbsent
          ? const Value.absent()
          : Value(entTown),
      entZipCode: entZipCode == null && nullToAbsent
          ? const Value.absent()
          : Value(entZipCode),
      entDwellingRecs: entDwellingRecs == null && nullToAbsent
          ? const Value.absent()
          : Value(entDwellingRecs),
      entDwellingExpec: entDwellingExpec == null && nullToAbsent
          ? const Value.absent()
          : Value(entDwellingExpec),
      createdUser: createdUser == null && nullToAbsent
          ? const Value.absent()
          : Value(createdUser),
      createdDate: createdDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createdDate),
      lastEditedUser: lastEditedUser == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEditedUser),
      lastEditedDate: lastEditedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEditedDate),
      externalCreator: externalCreator == null && nullToAbsent
          ? const Value.absent()
          : Value(externalCreator),
      externalEditor: externalEditor == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEditor),
    );
  }

  factory Entrance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entrance(
      objectId: serializer.fromJson<int>(json['objectId']),
      entCensus2023: serializer.fromJson<String?>(json['entCensus2023']),
      externalCreatorDate:
          serializer.fromJson<DateTime?>(json['externalCreatorDate']),
      externalEditorDate:
          serializer.fromJson<DateTime?>(json['externalEditorDate']),
      globalId: serializer.fromJson<String>(json['globalId']),
      entBldGlobalId: serializer.fromJson<String>(json['entBldGlobalId']),
      entAddressId: serializer.fromJson<String?>(json['entAddressId']),
      entQuality: serializer.fromJson<int>(json['entQuality']),
      entLatitude: serializer.fromJson<double>(json['entLatitude']),
      entLongitude: serializer.fromJson<double>(json['entLongitude']),
      entPointStatus: serializer.fromJson<int>(json['entPointStatus']),
      entStrGlobalId: serializer.fromJson<String?>(json['entStrGlobalId']),
      entBuildingNumber:
          serializer.fromJson<String?>(json['entBuildingNumber']),
      entEntranceNumber:
          serializer.fromJson<String?>(json['entEntranceNumber']),
      entTown: serializer.fromJson<int?>(json['entTown']),
      entZipCode: serializer.fromJson<int?>(json['entZipCode']),
      entDwellingRecs: serializer.fromJson<int?>(json['entDwellingRecs']),
      entDwellingExpec: serializer.fromJson<int?>(json['entDwellingExpec']),
      createdUser: serializer.fromJson<String?>(json['createdUser']),
      createdDate: serializer.fromJson<DateTime?>(json['createdDate']),
      lastEditedUser: serializer.fromJson<String?>(json['lastEditedUser']),
      lastEditedDate: serializer.fromJson<DateTime?>(json['lastEditedDate']),
      externalCreator: serializer.fromJson<String?>(json['externalCreator']),
      externalEditor: serializer.fromJson<String?>(json['externalEditor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'objectId': serializer.toJson<int>(objectId),
      'entCensus2023': serializer.toJson<String?>(entCensus2023),
      'externalCreatorDate': serializer.toJson<DateTime?>(externalCreatorDate),
      'externalEditorDate': serializer.toJson<DateTime?>(externalEditorDate),
      'globalId': serializer.toJson<String>(globalId),
      'entBldGlobalId': serializer.toJson<String>(entBldGlobalId),
      'entAddressId': serializer.toJson<String?>(entAddressId),
      'entQuality': serializer.toJson<int>(entQuality),
      'entLatitude': serializer.toJson<double>(entLatitude),
      'entLongitude': serializer.toJson<double>(entLongitude),
      'entPointStatus': serializer.toJson<int>(entPointStatus),
      'entStrGlobalId': serializer.toJson<String?>(entStrGlobalId),
      'entBuildingNumber': serializer.toJson<String?>(entBuildingNumber),
      'entEntranceNumber': serializer.toJson<String?>(entEntranceNumber),
      'entTown': serializer.toJson<int?>(entTown),
      'entZipCode': serializer.toJson<int?>(entZipCode),
      'entDwellingRecs': serializer.toJson<int?>(entDwellingRecs),
      'entDwellingExpec': serializer.toJson<int?>(entDwellingExpec),
      'createdUser': serializer.toJson<String?>(createdUser),
      'createdDate': serializer.toJson<DateTime?>(createdDate),
      'lastEditedUser': serializer.toJson<String?>(lastEditedUser),
      'lastEditedDate': serializer.toJson<DateTime?>(lastEditedDate),
      'externalCreator': serializer.toJson<String?>(externalCreator),
      'externalEditor': serializer.toJson<String?>(externalEditor),
    };
  }

  Entrance copyWith(
          {int? objectId,
          Value<String?> entCensus2023 = const Value.absent(),
          Value<DateTime?> externalCreatorDate = const Value.absent(),
          Value<DateTime?> externalEditorDate = const Value.absent(),
          String? globalId,
          String? entBldGlobalId,
          Value<String?> entAddressId = const Value.absent(),
          int? entQuality,
          double? entLatitude,
          double? entLongitude,
          int? entPointStatus,
          Value<String?> entStrGlobalId = const Value.absent(),
          Value<String?> entBuildingNumber = const Value.absent(),
          Value<String?> entEntranceNumber = const Value.absent(),
          Value<int?> entTown = const Value.absent(),
          Value<int?> entZipCode = const Value.absent(),
          Value<int?> entDwellingRecs = const Value.absent(),
          Value<int?> entDwellingExpec = const Value.absent(),
          Value<String?> createdUser = const Value.absent(),
          Value<DateTime?> createdDate = const Value.absent(),
          Value<String?> lastEditedUser = const Value.absent(),
          Value<DateTime?> lastEditedDate = const Value.absent(),
          Value<String?> externalCreator = const Value.absent(),
          Value<String?> externalEditor = const Value.absent()}) =>
      Entrance(
        objectId: objectId ?? this.objectId,
        entCensus2023:
            entCensus2023.present ? entCensus2023.value : this.entCensus2023,
        externalCreatorDate: externalCreatorDate.present
            ? externalCreatorDate.value
            : this.externalCreatorDate,
        externalEditorDate: externalEditorDate.present
            ? externalEditorDate.value
            : this.externalEditorDate,
        globalId: globalId ?? this.globalId,
        entBldGlobalId: entBldGlobalId ?? this.entBldGlobalId,
        entAddressId:
            entAddressId.present ? entAddressId.value : this.entAddressId,
        entQuality: entQuality ?? this.entQuality,
        entLatitude: entLatitude ?? this.entLatitude,
        entLongitude: entLongitude ?? this.entLongitude,
        entPointStatus: entPointStatus ?? this.entPointStatus,
        entStrGlobalId:
            entStrGlobalId.present ? entStrGlobalId.value : this.entStrGlobalId,
        entBuildingNumber: entBuildingNumber.present
            ? entBuildingNumber.value
            : this.entBuildingNumber,
        entEntranceNumber: entEntranceNumber.present
            ? entEntranceNumber.value
            : this.entEntranceNumber,
        entTown: entTown.present ? entTown.value : this.entTown,
        entZipCode: entZipCode.present ? entZipCode.value : this.entZipCode,
        entDwellingRecs: entDwellingRecs.present
            ? entDwellingRecs.value
            : this.entDwellingRecs,
        entDwellingExpec: entDwellingExpec.present
            ? entDwellingExpec.value
            : this.entDwellingExpec,
        createdUser: createdUser.present ? createdUser.value : this.createdUser,
        createdDate: createdDate.present ? createdDate.value : this.createdDate,
        lastEditedUser:
            lastEditedUser.present ? lastEditedUser.value : this.lastEditedUser,
        lastEditedDate:
            lastEditedDate.present ? lastEditedDate.value : this.lastEditedDate,
        externalCreator: externalCreator.present
            ? externalCreator.value
            : this.externalCreator,
        externalEditor:
            externalEditor.present ? externalEditor.value : this.externalEditor,
      );
  Entrance copyWithCompanion(EntrancesCompanion data) {
    return Entrance(
      objectId: data.objectId.present ? data.objectId.value : this.objectId,
      entCensus2023: data.entCensus2023.present
          ? data.entCensus2023.value
          : this.entCensus2023,
      externalCreatorDate: data.externalCreatorDate.present
          ? data.externalCreatorDate.value
          : this.externalCreatorDate,
      externalEditorDate: data.externalEditorDate.present
          ? data.externalEditorDate.value
          : this.externalEditorDate,
      globalId: data.globalId.present ? data.globalId.value : this.globalId,
      entBldGlobalId: data.entBldGlobalId.present
          ? data.entBldGlobalId.value
          : this.entBldGlobalId,
      entAddressId: data.entAddressId.present
          ? data.entAddressId.value
          : this.entAddressId,
      entQuality:
          data.entQuality.present ? data.entQuality.value : this.entQuality,
      entLatitude:
          data.entLatitude.present ? data.entLatitude.value : this.entLatitude,
      entLongitude: data.entLongitude.present
          ? data.entLongitude.value
          : this.entLongitude,
      entPointStatus: data.entPointStatus.present
          ? data.entPointStatus.value
          : this.entPointStatus,
      entStrGlobalId: data.entStrGlobalId.present
          ? data.entStrGlobalId.value
          : this.entStrGlobalId,
      entBuildingNumber: data.entBuildingNumber.present
          ? data.entBuildingNumber.value
          : this.entBuildingNumber,
      entEntranceNumber: data.entEntranceNumber.present
          ? data.entEntranceNumber.value
          : this.entEntranceNumber,
      entTown: data.entTown.present ? data.entTown.value : this.entTown,
      entZipCode:
          data.entZipCode.present ? data.entZipCode.value : this.entZipCode,
      entDwellingRecs: data.entDwellingRecs.present
          ? data.entDwellingRecs.value
          : this.entDwellingRecs,
      entDwellingExpec: data.entDwellingExpec.present
          ? data.entDwellingExpec.value
          : this.entDwellingExpec,
      createdUser:
          data.createdUser.present ? data.createdUser.value : this.createdUser,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      lastEditedUser: data.lastEditedUser.present
          ? data.lastEditedUser.value
          : this.lastEditedUser,
      lastEditedDate: data.lastEditedDate.present
          ? data.lastEditedDate.value
          : this.lastEditedDate,
      externalCreator: data.externalCreator.present
          ? data.externalCreator.value
          : this.externalCreator,
      externalEditor: data.externalEditor.present
          ? data.externalEditor.value
          : this.externalEditor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entrance(')
          ..write('objectId: $objectId, ')
          ..write('entCensus2023: $entCensus2023, ')
          ..write('externalCreatorDate: $externalCreatorDate, ')
          ..write('externalEditorDate: $externalEditorDate, ')
          ..write('globalId: $globalId, ')
          ..write('entBldGlobalId: $entBldGlobalId, ')
          ..write('entAddressId: $entAddressId, ')
          ..write('entQuality: $entQuality, ')
          ..write('entLatitude: $entLatitude, ')
          ..write('entLongitude: $entLongitude, ')
          ..write('entPointStatus: $entPointStatus, ')
          ..write('entStrGlobalId: $entStrGlobalId, ')
          ..write('entBuildingNumber: $entBuildingNumber, ')
          ..write('entEntranceNumber: $entEntranceNumber, ')
          ..write('entTown: $entTown, ')
          ..write('entZipCode: $entZipCode, ')
          ..write('entDwellingRecs: $entDwellingRecs, ')
          ..write('entDwellingExpec: $entDwellingExpec, ')
          ..write('createdUser: $createdUser, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastEditedUser: $lastEditedUser, ')
          ..write('lastEditedDate: $lastEditedDate, ')
          ..write('externalCreator: $externalCreator, ')
          ..write('externalEditor: $externalEditor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        objectId,
        entCensus2023,
        externalCreatorDate,
        externalEditorDate,
        globalId,
        entBldGlobalId,
        entAddressId,
        entQuality,
        entLatitude,
        entLongitude,
        entPointStatus,
        entStrGlobalId,
        entBuildingNumber,
        entEntranceNumber,
        entTown,
        entZipCode,
        entDwellingRecs,
        entDwellingExpec,
        createdUser,
        createdDate,
        lastEditedUser,
        lastEditedDate,
        externalCreator,
        externalEditor
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entrance &&
          other.objectId == this.objectId &&
          other.entCensus2023 == this.entCensus2023 &&
          other.externalCreatorDate == this.externalCreatorDate &&
          other.externalEditorDate == this.externalEditorDate &&
          other.globalId == this.globalId &&
          other.entBldGlobalId == this.entBldGlobalId &&
          other.entAddressId == this.entAddressId &&
          other.entQuality == this.entQuality &&
          other.entLatitude == this.entLatitude &&
          other.entLongitude == this.entLongitude &&
          other.entPointStatus == this.entPointStatus &&
          other.entStrGlobalId == this.entStrGlobalId &&
          other.entBuildingNumber == this.entBuildingNumber &&
          other.entEntranceNumber == this.entEntranceNumber &&
          other.entTown == this.entTown &&
          other.entZipCode == this.entZipCode &&
          other.entDwellingRecs == this.entDwellingRecs &&
          other.entDwellingExpec == this.entDwellingExpec &&
          other.createdUser == this.createdUser &&
          other.createdDate == this.createdDate &&
          other.lastEditedUser == this.lastEditedUser &&
          other.lastEditedDate == this.lastEditedDate &&
          other.externalCreator == this.externalCreator &&
          other.externalEditor == this.externalEditor);
}

class EntrancesCompanion extends UpdateCompanion<Entrance> {
  final Value<int> objectId;
  final Value<String?> entCensus2023;
  final Value<DateTime?> externalCreatorDate;
  final Value<DateTime?> externalEditorDate;
  final Value<String> globalId;
  final Value<String> entBldGlobalId;
  final Value<String?> entAddressId;
  final Value<int> entQuality;
  final Value<double> entLatitude;
  final Value<double> entLongitude;
  final Value<int> entPointStatus;
  final Value<String?> entStrGlobalId;
  final Value<String?> entBuildingNumber;
  final Value<String?> entEntranceNumber;
  final Value<int?> entTown;
  final Value<int?> entZipCode;
  final Value<int?> entDwellingRecs;
  final Value<int?> entDwellingExpec;
  final Value<String?> createdUser;
  final Value<DateTime?> createdDate;
  final Value<String?> lastEditedUser;
  final Value<DateTime?> lastEditedDate;
  final Value<String?> externalCreator;
  final Value<String?> externalEditor;
  const EntrancesCompanion({
    this.objectId = const Value.absent(),
    this.entCensus2023 = const Value.absent(),
    this.externalCreatorDate = const Value.absent(),
    this.externalEditorDate = const Value.absent(),
    this.globalId = const Value.absent(),
    this.entBldGlobalId = const Value.absent(),
    this.entAddressId = const Value.absent(),
    this.entQuality = const Value.absent(),
    this.entLatitude = const Value.absent(),
    this.entLongitude = const Value.absent(),
    this.entPointStatus = const Value.absent(),
    this.entStrGlobalId = const Value.absent(),
    this.entBuildingNumber = const Value.absent(),
    this.entEntranceNumber = const Value.absent(),
    this.entTown = const Value.absent(),
    this.entZipCode = const Value.absent(),
    this.entDwellingRecs = const Value.absent(),
    this.entDwellingExpec = const Value.absent(),
    this.createdUser = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastEditedUser = const Value.absent(),
    this.lastEditedDate = const Value.absent(),
    this.externalCreator = const Value.absent(),
    this.externalEditor = const Value.absent(),
  });
  EntrancesCompanion.insert({
    this.objectId = const Value.absent(),
    this.entCensus2023 = const Value.absent(),
    this.externalCreatorDate = const Value.absent(),
    this.externalEditorDate = const Value.absent(),
    required String globalId,
    this.entBldGlobalId = const Value.absent(),
    this.entAddressId = const Value.absent(),
    this.entQuality = const Value.absent(),
    required double entLatitude,
    required double entLongitude,
    this.entPointStatus = const Value.absent(),
    this.entStrGlobalId = const Value.absent(),
    this.entBuildingNumber = const Value.absent(),
    this.entEntranceNumber = const Value.absent(),
    this.entTown = const Value.absent(),
    this.entZipCode = const Value.absent(),
    this.entDwellingRecs = const Value.absent(),
    this.entDwellingExpec = const Value.absent(),
    this.createdUser = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastEditedUser = const Value.absent(),
    this.lastEditedDate = const Value.absent(),
    this.externalCreator = const Value.absent(),
    this.externalEditor = const Value.absent(),
  })  : globalId = Value(globalId),
        entLatitude = Value(entLatitude),
        entLongitude = Value(entLongitude);
  static Insertable<Entrance> custom({
    Expression<int>? objectId,
    Expression<String>? entCensus2023,
    Expression<DateTime>? externalCreatorDate,
    Expression<DateTime>? externalEditorDate,
    Expression<String>? globalId,
    Expression<String>? entBldGlobalId,
    Expression<String>? entAddressId,
    Expression<int>? entQuality,
    Expression<double>? entLatitude,
    Expression<double>? entLongitude,
    Expression<int>? entPointStatus,
    Expression<String>? entStrGlobalId,
    Expression<String>? entBuildingNumber,
    Expression<String>? entEntranceNumber,
    Expression<int>? entTown,
    Expression<int>? entZipCode,
    Expression<int>? entDwellingRecs,
    Expression<int>? entDwellingExpec,
    Expression<String>? createdUser,
    Expression<DateTime>? createdDate,
    Expression<String>? lastEditedUser,
    Expression<DateTime>? lastEditedDate,
    Expression<String>? externalCreator,
    Expression<String>? externalEditor,
  }) {
    return RawValuesInsertable({
      if (objectId != null) 'object_id': objectId,
      if (entCensus2023 != null) 'ent_census2023': entCensus2023,
      if (externalCreatorDate != null)
        'external_creator_date': externalCreatorDate,
      if (externalEditorDate != null)
        'external_editor_date': externalEditorDate,
      if (globalId != null) 'global_id': globalId,
      if (entBldGlobalId != null) 'ent_bld_global_id': entBldGlobalId,
      if (entAddressId != null) 'ent_address_id': entAddressId,
      if (entQuality != null) 'ent_quality': entQuality,
      if (entLatitude != null) 'ent_latitude': entLatitude,
      if (entLongitude != null) 'ent_longitude': entLongitude,
      if (entPointStatus != null) 'ent_point_status': entPointStatus,
      if (entStrGlobalId != null) 'ent_str_global_id': entStrGlobalId,
      if (entBuildingNumber != null) 'ent_building_number': entBuildingNumber,
      if (entEntranceNumber != null) 'ent_entrance_number': entEntranceNumber,
      if (entTown != null) 'ent_town': entTown,
      if (entZipCode != null) 'ent_zip_code': entZipCode,
      if (entDwellingRecs != null) 'ent_dwelling_recs': entDwellingRecs,
      if (entDwellingExpec != null) 'ent_dwelling_expec': entDwellingExpec,
      if (createdUser != null) 'created_user': createdUser,
      if (createdDate != null) 'created_date': createdDate,
      if (lastEditedUser != null) 'last_edited_user': lastEditedUser,
      if (lastEditedDate != null) 'last_edited_date': lastEditedDate,
      if (externalCreator != null) 'external_creator': externalCreator,
      if (externalEditor != null) 'external_editor': externalEditor,
    });
  }

  EntrancesCompanion copyWith(
      {Value<int>? objectId,
      Value<String?>? entCensus2023,
      Value<DateTime?>? externalCreatorDate,
      Value<DateTime?>? externalEditorDate,
      Value<String>? globalId,
      Value<String>? entBldGlobalId,
      Value<String?>? entAddressId,
      Value<int>? entQuality,
      Value<double>? entLatitude,
      Value<double>? entLongitude,
      Value<int>? entPointStatus,
      Value<String?>? entStrGlobalId,
      Value<String?>? entBuildingNumber,
      Value<String?>? entEntranceNumber,
      Value<int?>? entTown,
      Value<int?>? entZipCode,
      Value<int?>? entDwellingRecs,
      Value<int?>? entDwellingExpec,
      Value<String?>? createdUser,
      Value<DateTime?>? createdDate,
      Value<String?>? lastEditedUser,
      Value<DateTime?>? lastEditedDate,
      Value<String?>? externalCreator,
      Value<String?>? externalEditor}) {
    return EntrancesCompanion(
      objectId: objectId ?? this.objectId,
      entCensus2023: entCensus2023 ?? this.entCensus2023,
      externalCreatorDate: externalCreatorDate ?? this.externalCreatorDate,
      externalEditorDate: externalEditorDate ?? this.externalEditorDate,
      globalId: globalId ?? this.globalId,
      entBldGlobalId: entBldGlobalId ?? this.entBldGlobalId,
      entAddressId: entAddressId ?? this.entAddressId,
      entQuality: entQuality ?? this.entQuality,
      entLatitude: entLatitude ?? this.entLatitude,
      entLongitude: entLongitude ?? this.entLongitude,
      entPointStatus: entPointStatus ?? this.entPointStatus,
      entStrGlobalId: entStrGlobalId ?? this.entStrGlobalId,
      entBuildingNumber: entBuildingNumber ?? this.entBuildingNumber,
      entEntranceNumber: entEntranceNumber ?? this.entEntranceNumber,
      entTown: entTown ?? this.entTown,
      entZipCode: entZipCode ?? this.entZipCode,
      entDwellingRecs: entDwellingRecs ?? this.entDwellingRecs,
      entDwellingExpec: entDwellingExpec ?? this.entDwellingExpec,
      createdUser: createdUser ?? this.createdUser,
      createdDate: createdDate ?? this.createdDate,
      lastEditedUser: lastEditedUser ?? this.lastEditedUser,
      lastEditedDate: lastEditedDate ?? this.lastEditedDate,
      externalCreator: externalCreator ?? this.externalCreator,
      externalEditor: externalEditor ?? this.externalEditor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (objectId.present) {
      map['object_id'] = Variable<int>(objectId.value);
    }
    if (entCensus2023.present) {
      map['ent_census2023'] = Variable<String>(entCensus2023.value);
    }
    if (externalCreatorDate.present) {
      map['external_creator_date'] =
          Variable<DateTime>(externalCreatorDate.value);
    }
    if (externalEditorDate.present) {
      map['external_editor_date'] =
          Variable<DateTime>(externalEditorDate.value);
    }
    if (globalId.present) {
      map['global_id'] = Variable<String>(globalId.value);
    }
    if (entBldGlobalId.present) {
      map['ent_bld_global_id'] = Variable<String>(entBldGlobalId.value);
    }
    if (entAddressId.present) {
      map['ent_address_id'] = Variable<String>(entAddressId.value);
    }
    if (entQuality.present) {
      map['ent_quality'] = Variable<int>(entQuality.value);
    }
    if (entLatitude.present) {
      map['ent_latitude'] = Variable<double>(entLatitude.value);
    }
    if (entLongitude.present) {
      map['ent_longitude'] = Variable<double>(entLongitude.value);
    }
    if (entPointStatus.present) {
      map['ent_point_status'] = Variable<int>(entPointStatus.value);
    }
    if (entStrGlobalId.present) {
      map['ent_str_global_id'] = Variable<String>(entStrGlobalId.value);
    }
    if (entBuildingNumber.present) {
      map['ent_building_number'] = Variable<String>(entBuildingNumber.value);
    }
    if (entEntranceNumber.present) {
      map['ent_entrance_number'] = Variable<String>(entEntranceNumber.value);
    }
    if (entTown.present) {
      map['ent_town'] = Variable<int>(entTown.value);
    }
    if (entZipCode.present) {
      map['ent_zip_code'] = Variable<int>(entZipCode.value);
    }
    if (entDwellingRecs.present) {
      map['ent_dwelling_recs'] = Variable<int>(entDwellingRecs.value);
    }
    if (entDwellingExpec.present) {
      map['ent_dwelling_expec'] = Variable<int>(entDwellingExpec.value);
    }
    if (createdUser.present) {
      map['created_user'] = Variable<String>(createdUser.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (lastEditedUser.present) {
      map['last_edited_user'] = Variable<String>(lastEditedUser.value);
    }
    if (lastEditedDate.present) {
      map['last_edited_date'] = Variable<DateTime>(lastEditedDate.value);
    }
    if (externalCreator.present) {
      map['external_creator'] = Variable<String>(externalCreator.value);
    }
    if (externalEditor.present) {
      map['external_editor'] = Variable<String>(externalEditor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntrancesCompanion(')
          ..write('objectId: $objectId, ')
          ..write('entCensus2023: $entCensus2023, ')
          ..write('externalCreatorDate: $externalCreatorDate, ')
          ..write('externalEditorDate: $externalEditorDate, ')
          ..write('globalId: $globalId, ')
          ..write('entBldGlobalId: $entBldGlobalId, ')
          ..write('entAddressId: $entAddressId, ')
          ..write('entQuality: $entQuality, ')
          ..write('entLatitude: $entLatitude, ')
          ..write('entLongitude: $entLongitude, ')
          ..write('entPointStatus: $entPointStatus, ')
          ..write('entStrGlobalId: $entStrGlobalId, ')
          ..write('entBuildingNumber: $entBuildingNumber, ')
          ..write('entEntranceNumber: $entEntranceNumber, ')
          ..write('entTown: $entTown, ')
          ..write('entZipCode: $entZipCode, ')
          ..write('entDwellingRecs: $entDwellingRecs, ')
          ..write('entDwellingExpec: $entDwellingExpec, ')
          ..write('createdUser: $createdUser, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastEditedUser: $lastEditedUser, ')
          ..write('lastEditedDate: $lastEditedDate, ')
          ..write('externalCreator: $externalCreator, ')
          ..write('externalEditor: $externalEditor')
          ..write(')'))
        .toString();
  }
}

class $DwellingsTable extends Dwellings
    with TableInfo<$DwellingsTable, Dwelling> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DwellingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _objectIdMeta =
      const VerificationMeta('objectId');
  @override
  late final GeneratedColumn<int> objectId = GeneratedColumn<int>(
      'object_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _externalCreatorDateMeta =
      const VerificationMeta('externalCreatorDate');
  @override
  late final GeneratedColumn<DateTime> externalCreatorDate =
      GeneratedColumn<DateTime>('external_creator_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _externalEditorDateMeta =
      const VerificationMeta('externalEditorDate');
  @override
  late final GeneratedColumn<DateTime> externalEditorDate =
      GeneratedColumn<DateTime>('external_editor_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _globalIdMeta =
      const VerificationMeta('globalId');
  @override
  late final GeneratedColumn<String> globalId = GeneratedColumn<String>(
      'global_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dwlEntGlobalIdMeta =
      const VerificationMeta('dwlEntGlobalId');
  @override
  late final GeneratedColumn<String> dwlEntGlobalId = GeneratedColumn<String>(
      'dwl_ent_global_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('00000000-0000-0000-0000-000000000000'));
  static const VerificationMeta _dwlCensus2023Meta =
      const VerificationMeta('dwlCensus2023');
  @override
  late final GeneratedColumn<String> dwlCensus2023 = GeneratedColumn<String>(
      'dwl_census2023', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 17),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('99999999999999999'));
  static const VerificationMeta _dwlAddressIdMeta =
      const VerificationMeta('dwlAddressId');
  @override
  late final GeneratedColumn<String> dwlAddressId = GeneratedColumn<String>(
      'dwl_address_id', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _dwlQualityMeta =
      const VerificationMeta('dwlQuality');
  @override
  late final GeneratedColumn<int> dwlQuality = GeneratedColumn<int>(
      'dwl_quality', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _dwlFloorMeta =
      const VerificationMeta('dwlFloor');
  @override
  late final GeneratedColumn<int> dwlFloor = GeneratedColumn<int>(
      'dwl_floor', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dwlApartNumberMeta =
      const VerificationMeta('dwlApartNumber');
  @override
  late final GeneratedColumn<String> dwlApartNumber = GeneratedColumn<String>(
      'dwl_apart_number', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 5),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _dwlStatusMeta =
      const VerificationMeta('dwlStatus');
  @override
  late final GeneratedColumn<int> dwlStatus = GeneratedColumn<int>(
      'dwl_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _dwlYearConstructionMeta =
      const VerificationMeta('dwlYearConstruction');
  @override
  late final GeneratedColumn<int> dwlYearConstruction = GeneratedColumn<int>(
      'dwl_year_construction', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dwlYearEliminationMeta =
      const VerificationMeta('dwlYearElimination');
  @override
  late final GeneratedColumn<int> dwlYearElimination = GeneratedColumn<int>(
      'dwl_year_elimination', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dwlTypeMeta =
      const VerificationMeta('dwlType');
  @override
  late final GeneratedColumn<int> dwlType = GeneratedColumn<int>(
      'dwl_type', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _dwlOwnershipMeta =
      const VerificationMeta('dwlOwnership');
  @override
  late final GeneratedColumn<int> dwlOwnership = GeneratedColumn<int>(
      'dwl_ownership', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(99));
  static const VerificationMeta _dwlOccupancyMeta =
      const VerificationMeta('dwlOccupancy');
  @override
  late final GeneratedColumn<int> dwlOccupancy = GeneratedColumn<int>(
      'dwl_occupancy', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(99));
  static const VerificationMeta _dwlSurfaceMeta =
      const VerificationMeta('dwlSurface');
  @override
  late final GeneratedColumn<int> dwlSurface = GeneratedColumn<int>(
      'dwl_surface', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dwlToiletMeta =
      const VerificationMeta('dwlToilet');
  @override
  late final GeneratedColumn<int> dwlToilet = GeneratedColumn<int>(
      'dwl_toilet', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(99));
  static const VerificationMeta _dwlBathMeta =
      const VerificationMeta('dwlBath');
  @override
  late final GeneratedColumn<int> dwlBath = GeneratedColumn<int>(
      'dwl_bath', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _dwlHeatingFacilityMeta =
      const VerificationMeta('dwlHeatingFacility');
  @override
  late final GeneratedColumn<int> dwlHeatingFacility = GeneratedColumn<int>(
      'dwl_heating_facility', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(99));
  static const VerificationMeta _dwlHeatingEnergyMeta =
      const VerificationMeta('dwlHeatingEnergy');
  @override
  late final GeneratedColumn<int> dwlHeatingEnergy = GeneratedColumn<int>(
      'dwl_heating_energy', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(99));
  static const VerificationMeta _dwlAirConditionerMeta =
      const VerificationMeta('dwlAirConditioner');
  @override
  late final GeneratedColumn<int> dwlAirConditioner = GeneratedColumn<int>(
      'dwl_air_conditioner', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _dwlSolarPanelMeta =
      const VerificationMeta('dwlSolarPanel');
  @override
  late final GeneratedColumn<int> dwlSolarPanel = GeneratedColumn<int>(
      'dwl_solar_panel', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _createdUserMeta =
      const VerificationMeta('createdUser');
  @override
  late final GeneratedColumn<String> createdUser = GeneratedColumn<String>(
      'created_user', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastEditedUserMeta =
      const VerificationMeta('lastEditedUser');
  @override
  late final GeneratedColumn<String> lastEditedUser = GeneratedColumn<String>(
      'last_edited_user', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _lastEditedDateMeta =
      const VerificationMeta('lastEditedDate');
  @override
  late final GeneratedColumn<DateTime> lastEditedDate =
      GeneratedColumn<DateTime>('last_edited_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _externalCreatorMeta =
      const VerificationMeta('externalCreator');
  @override
  late final GeneratedColumn<String> externalCreator = GeneratedColumn<String>(
      'external_creator', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _externalEditorMeta =
      const VerificationMeta('externalEditor');
  @override
  late final GeneratedColumn<String> externalEditor = GeneratedColumn<String>(
      'external_editor', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        objectId,
        externalCreatorDate,
        externalEditorDate,
        globalId,
        dwlEntGlobalId,
        dwlCensus2023,
        dwlAddressId,
        dwlQuality,
        dwlFloor,
        dwlApartNumber,
        dwlStatus,
        dwlYearConstruction,
        dwlYearElimination,
        dwlType,
        dwlOwnership,
        dwlOccupancy,
        dwlSurface,
        dwlToilet,
        dwlBath,
        dwlHeatingFacility,
        dwlHeatingEnergy,
        dwlAirConditioner,
        dwlSolarPanel,
        createdUser,
        createdDate,
        lastEditedUser,
        lastEditedDate,
        externalCreator,
        externalEditor
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dwellings';
  @override
  VerificationContext validateIntegrity(Insertable<Dwelling> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('object_id')) {
      context.handle(_objectIdMeta,
          objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta));
    }
    if (data.containsKey('external_creator_date')) {
      context.handle(
          _externalCreatorDateMeta,
          externalCreatorDate.isAcceptableOrUnknown(
              data['external_creator_date']!, _externalCreatorDateMeta));
    }
    if (data.containsKey('external_editor_date')) {
      context.handle(
          _externalEditorDateMeta,
          externalEditorDate.isAcceptableOrUnknown(
              data['external_editor_date']!, _externalEditorDateMeta));
    }
    if (data.containsKey('global_id')) {
      context.handle(_globalIdMeta,
          globalId.isAcceptableOrUnknown(data['global_id']!, _globalIdMeta));
    } else if (isInserting) {
      context.missing(_globalIdMeta);
    }
    if (data.containsKey('dwl_ent_global_id')) {
      context.handle(
          _dwlEntGlobalIdMeta,
          dwlEntGlobalId.isAcceptableOrUnknown(
              data['dwl_ent_global_id']!, _dwlEntGlobalIdMeta));
    }
    if (data.containsKey('dwl_census2023')) {
      context.handle(
          _dwlCensus2023Meta,
          dwlCensus2023.isAcceptableOrUnknown(
              data['dwl_census2023']!, _dwlCensus2023Meta));
    }
    if (data.containsKey('dwl_address_id')) {
      context.handle(
          _dwlAddressIdMeta,
          dwlAddressId.isAcceptableOrUnknown(
              data['dwl_address_id']!, _dwlAddressIdMeta));
    }
    if (data.containsKey('dwl_quality')) {
      context.handle(
          _dwlQualityMeta,
          dwlQuality.isAcceptableOrUnknown(
              data['dwl_quality']!, _dwlQualityMeta));
    }
    if (data.containsKey('dwl_floor')) {
      context.handle(_dwlFloorMeta,
          dwlFloor.isAcceptableOrUnknown(data['dwl_floor']!, _dwlFloorMeta));
    }
    if (data.containsKey('dwl_apart_number')) {
      context.handle(
          _dwlApartNumberMeta,
          dwlApartNumber.isAcceptableOrUnknown(
              data['dwl_apart_number']!, _dwlApartNumberMeta));
    }
    if (data.containsKey('dwl_status')) {
      context.handle(_dwlStatusMeta,
          dwlStatus.isAcceptableOrUnknown(data['dwl_status']!, _dwlStatusMeta));
    }
    if (data.containsKey('dwl_year_construction')) {
      context.handle(
          _dwlYearConstructionMeta,
          dwlYearConstruction.isAcceptableOrUnknown(
              data['dwl_year_construction']!, _dwlYearConstructionMeta));
    }
    if (data.containsKey('dwl_year_elimination')) {
      context.handle(
          _dwlYearEliminationMeta,
          dwlYearElimination.isAcceptableOrUnknown(
              data['dwl_year_elimination']!, _dwlYearEliminationMeta));
    }
    if (data.containsKey('dwl_type')) {
      context.handle(_dwlTypeMeta,
          dwlType.isAcceptableOrUnknown(data['dwl_type']!, _dwlTypeMeta));
    }
    if (data.containsKey('dwl_ownership')) {
      context.handle(
          _dwlOwnershipMeta,
          dwlOwnership.isAcceptableOrUnknown(
              data['dwl_ownership']!, _dwlOwnershipMeta));
    }
    if (data.containsKey('dwl_occupancy')) {
      context.handle(
          _dwlOccupancyMeta,
          dwlOccupancy.isAcceptableOrUnknown(
              data['dwl_occupancy']!, _dwlOccupancyMeta));
    }
    if (data.containsKey('dwl_surface')) {
      context.handle(
          _dwlSurfaceMeta,
          dwlSurface.isAcceptableOrUnknown(
              data['dwl_surface']!, _dwlSurfaceMeta));
    }
    if (data.containsKey('dwl_toilet')) {
      context.handle(_dwlToiletMeta,
          dwlToilet.isAcceptableOrUnknown(data['dwl_toilet']!, _dwlToiletMeta));
    }
    if (data.containsKey('dwl_bath')) {
      context.handle(_dwlBathMeta,
          dwlBath.isAcceptableOrUnknown(data['dwl_bath']!, _dwlBathMeta));
    }
    if (data.containsKey('dwl_heating_facility')) {
      context.handle(
          _dwlHeatingFacilityMeta,
          dwlHeatingFacility.isAcceptableOrUnknown(
              data['dwl_heating_facility']!, _dwlHeatingFacilityMeta));
    }
    if (data.containsKey('dwl_heating_energy')) {
      context.handle(
          _dwlHeatingEnergyMeta,
          dwlHeatingEnergy.isAcceptableOrUnknown(
              data['dwl_heating_energy']!, _dwlHeatingEnergyMeta));
    }
    if (data.containsKey('dwl_air_conditioner')) {
      context.handle(
          _dwlAirConditionerMeta,
          dwlAirConditioner.isAcceptableOrUnknown(
              data['dwl_air_conditioner']!, _dwlAirConditionerMeta));
    }
    if (data.containsKey('dwl_solar_panel')) {
      context.handle(
          _dwlSolarPanelMeta,
          dwlSolarPanel.isAcceptableOrUnknown(
              data['dwl_solar_panel']!, _dwlSolarPanelMeta));
    }
    if (data.containsKey('created_user')) {
      context.handle(
          _createdUserMeta,
          createdUser.isAcceptableOrUnknown(
              data['created_user']!, _createdUserMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    if (data.containsKey('last_edited_user')) {
      context.handle(
          _lastEditedUserMeta,
          lastEditedUser.isAcceptableOrUnknown(
              data['last_edited_user']!, _lastEditedUserMeta));
    }
    if (data.containsKey('last_edited_date')) {
      context.handle(
          _lastEditedDateMeta,
          lastEditedDate.isAcceptableOrUnknown(
              data['last_edited_date']!, _lastEditedDateMeta));
    }
    if (data.containsKey('external_creator')) {
      context.handle(
          _externalCreatorMeta,
          externalCreator.isAcceptableOrUnknown(
              data['external_creator']!, _externalCreatorMeta));
    }
    if (data.containsKey('external_editor')) {
      context.handle(
          _externalEditorMeta,
          externalEditor.isAcceptableOrUnknown(
              data['external_editor']!, _externalEditorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {objectId};
  @override
  Dwelling map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dwelling(
      objectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_id'])!,
      externalCreatorDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}external_creator_date']),
      externalEditorDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}external_editor_date']),
      globalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}global_id'])!,
      dwlEntGlobalId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dwl_ent_global_id'])!,
      dwlCensus2023: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dwl_census2023']),
      dwlAddressId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dwl_address_id']),
      dwlQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_quality'])!,
      dwlFloor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_floor']),
      dwlApartNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dwl_apart_number']),
      dwlStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_status'])!,
      dwlYearConstruction: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}dwl_year_construction']),
      dwlYearElimination: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}dwl_year_elimination']),
      dwlType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_type']),
      dwlOwnership: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_ownership']),
      dwlOccupancy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_occupancy']),
      dwlSurface: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_surface']),
      dwlToilet: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_toilet']),
      dwlBath: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_bath']),
      dwlHeatingFacility: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}dwl_heating_facility']),
      dwlHeatingEnergy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_heating_energy']),
      dwlAirConditioner: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}dwl_air_conditioner']),
      dwlSolarPanel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dwl_solar_panel']),
      createdUser: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_user']),
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date']),
      lastEditedUser: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_edited_user']),
      lastEditedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_edited_date']),
      externalCreator: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}external_creator']),
      externalEditor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_editor']),
    );
  }

  @override
  $DwellingsTable createAlias(String alias) {
    return $DwellingsTable(attachedDatabase, alias);
  }
}

class Dwelling extends DataClass implements Insertable<Dwelling> {
  final int objectId;
  final DateTime? externalCreatorDate;
  final DateTime? externalEditorDate;
  final String globalId;
  final String dwlEntGlobalId;
  final String? dwlCensus2023;
  final String? dwlAddressId;
  final int dwlQuality;
  final int? dwlFloor;
  final String? dwlApartNumber;
  final int dwlStatus;
  final int? dwlYearConstruction;
  final int? dwlYearElimination;
  final int? dwlType;
  final int? dwlOwnership;
  final int? dwlOccupancy;
  final int? dwlSurface;
  final int? dwlToilet;
  final int? dwlBath;
  final int? dwlHeatingFacility;
  final int? dwlHeatingEnergy;
  final int? dwlAirConditioner;
  final int? dwlSolarPanel;
  final String? createdUser;
  final DateTime? createdDate;
  final String? lastEditedUser;
  final DateTime? lastEditedDate;
  final String? externalCreator;
  final String? externalEditor;
  const Dwelling(
      {required this.objectId,
      this.externalCreatorDate,
      this.externalEditorDate,
      required this.globalId,
      required this.dwlEntGlobalId,
      this.dwlCensus2023,
      this.dwlAddressId,
      required this.dwlQuality,
      this.dwlFloor,
      this.dwlApartNumber,
      required this.dwlStatus,
      this.dwlYearConstruction,
      this.dwlYearElimination,
      this.dwlType,
      this.dwlOwnership,
      this.dwlOccupancy,
      this.dwlSurface,
      this.dwlToilet,
      this.dwlBath,
      this.dwlHeatingFacility,
      this.dwlHeatingEnergy,
      this.dwlAirConditioner,
      this.dwlSolarPanel,
      this.createdUser,
      this.createdDate,
      this.lastEditedUser,
      this.lastEditedDate,
      this.externalCreator,
      this.externalEditor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['object_id'] = Variable<int>(objectId);
    if (!nullToAbsent || externalCreatorDate != null) {
      map['external_creator_date'] = Variable<DateTime>(externalCreatorDate);
    }
    if (!nullToAbsent || externalEditorDate != null) {
      map['external_editor_date'] = Variable<DateTime>(externalEditorDate);
    }
    map['global_id'] = Variable<String>(globalId);
    map['dwl_ent_global_id'] = Variable<String>(dwlEntGlobalId);
    if (!nullToAbsent || dwlCensus2023 != null) {
      map['dwl_census2023'] = Variable<String>(dwlCensus2023);
    }
    if (!nullToAbsent || dwlAddressId != null) {
      map['dwl_address_id'] = Variable<String>(dwlAddressId);
    }
    map['dwl_quality'] = Variable<int>(dwlQuality);
    if (!nullToAbsent || dwlFloor != null) {
      map['dwl_floor'] = Variable<int>(dwlFloor);
    }
    if (!nullToAbsent || dwlApartNumber != null) {
      map['dwl_apart_number'] = Variable<String>(dwlApartNumber);
    }
    map['dwl_status'] = Variable<int>(dwlStatus);
    if (!nullToAbsent || dwlYearConstruction != null) {
      map['dwl_year_construction'] = Variable<int>(dwlYearConstruction);
    }
    if (!nullToAbsent || dwlYearElimination != null) {
      map['dwl_year_elimination'] = Variable<int>(dwlYearElimination);
    }
    if (!nullToAbsent || dwlType != null) {
      map['dwl_type'] = Variable<int>(dwlType);
    }
    if (!nullToAbsent || dwlOwnership != null) {
      map['dwl_ownership'] = Variable<int>(dwlOwnership);
    }
    if (!nullToAbsent || dwlOccupancy != null) {
      map['dwl_occupancy'] = Variable<int>(dwlOccupancy);
    }
    if (!nullToAbsent || dwlSurface != null) {
      map['dwl_surface'] = Variable<int>(dwlSurface);
    }
    if (!nullToAbsent || dwlToilet != null) {
      map['dwl_toilet'] = Variable<int>(dwlToilet);
    }
    if (!nullToAbsent || dwlBath != null) {
      map['dwl_bath'] = Variable<int>(dwlBath);
    }
    if (!nullToAbsent || dwlHeatingFacility != null) {
      map['dwl_heating_facility'] = Variable<int>(dwlHeatingFacility);
    }
    if (!nullToAbsent || dwlHeatingEnergy != null) {
      map['dwl_heating_energy'] = Variable<int>(dwlHeatingEnergy);
    }
    if (!nullToAbsent || dwlAirConditioner != null) {
      map['dwl_air_conditioner'] = Variable<int>(dwlAirConditioner);
    }
    if (!nullToAbsent || dwlSolarPanel != null) {
      map['dwl_solar_panel'] = Variable<int>(dwlSolarPanel);
    }
    if (!nullToAbsent || createdUser != null) {
      map['created_user'] = Variable<String>(createdUser);
    }
    if (!nullToAbsent || createdDate != null) {
      map['created_date'] = Variable<DateTime>(createdDate);
    }
    if (!nullToAbsent || lastEditedUser != null) {
      map['last_edited_user'] = Variable<String>(lastEditedUser);
    }
    if (!nullToAbsent || lastEditedDate != null) {
      map['last_edited_date'] = Variable<DateTime>(lastEditedDate);
    }
    if (!nullToAbsent || externalCreator != null) {
      map['external_creator'] = Variable<String>(externalCreator);
    }
    if (!nullToAbsent || externalEditor != null) {
      map['external_editor'] = Variable<String>(externalEditor);
    }
    return map;
  }

  DwellingsCompanion toCompanion(bool nullToAbsent) {
    return DwellingsCompanion(
      objectId: Value(objectId),
      externalCreatorDate: externalCreatorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(externalCreatorDate),
      externalEditorDate: externalEditorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEditorDate),
      globalId: Value(globalId),
      dwlEntGlobalId: Value(dwlEntGlobalId),
      dwlCensus2023: dwlCensus2023 == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlCensus2023),
      dwlAddressId: dwlAddressId == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlAddressId),
      dwlQuality: Value(dwlQuality),
      dwlFloor: dwlFloor == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlFloor),
      dwlApartNumber: dwlApartNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlApartNumber),
      dwlStatus: Value(dwlStatus),
      dwlYearConstruction: dwlYearConstruction == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlYearConstruction),
      dwlYearElimination: dwlYearElimination == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlYearElimination),
      dwlType: dwlType == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlType),
      dwlOwnership: dwlOwnership == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlOwnership),
      dwlOccupancy: dwlOccupancy == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlOccupancy),
      dwlSurface: dwlSurface == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlSurface),
      dwlToilet: dwlToilet == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlToilet),
      dwlBath: dwlBath == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlBath),
      dwlHeatingFacility: dwlHeatingFacility == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlHeatingFacility),
      dwlHeatingEnergy: dwlHeatingEnergy == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlHeatingEnergy),
      dwlAirConditioner: dwlAirConditioner == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlAirConditioner),
      dwlSolarPanel: dwlSolarPanel == null && nullToAbsent
          ? const Value.absent()
          : Value(dwlSolarPanel),
      createdUser: createdUser == null && nullToAbsent
          ? const Value.absent()
          : Value(createdUser),
      createdDate: createdDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createdDate),
      lastEditedUser: lastEditedUser == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEditedUser),
      lastEditedDate: lastEditedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEditedDate),
      externalCreator: externalCreator == null && nullToAbsent
          ? const Value.absent()
          : Value(externalCreator),
      externalEditor: externalEditor == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEditor),
    );
  }

  factory Dwelling.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dwelling(
      objectId: serializer.fromJson<int>(json['objectId']),
      externalCreatorDate:
          serializer.fromJson<DateTime?>(json['externalCreatorDate']),
      externalEditorDate:
          serializer.fromJson<DateTime?>(json['externalEditorDate']),
      globalId: serializer.fromJson<String>(json['globalId']),
      dwlEntGlobalId: serializer.fromJson<String>(json['dwlEntGlobalId']),
      dwlCensus2023: serializer.fromJson<String?>(json['dwlCensus2023']),
      dwlAddressId: serializer.fromJson<String?>(json['dwlAddressId']),
      dwlQuality: serializer.fromJson<int>(json['dwlQuality']),
      dwlFloor: serializer.fromJson<int?>(json['dwlFloor']),
      dwlApartNumber: serializer.fromJson<String?>(json['dwlApartNumber']),
      dwlStatus: serializer.fromJson<int>(json['dwlStatus']),
      dwlYearConstruction:
          serializer.fromJson<int?>(json['dwlYearConstruction']),
      dwlYearElimination: serializer.fromJson<int?>(json['dwlYearElimination']),
      dwlType: serializer.fromJson<int?>(json['dwlType']),
      dwlOwnership: serializer.fromJson<int?>(json['dwlOwnership']),
      dwlOccupancy: serializer.fromJson<int?>(json['dwlOccupancy']),
      dwlSurface: serializer.fromJson<int?>(json['dwlSurface']),
      dwlToilet: serializer.fromJson<int?>(json['dwlToilet']),
      dwlBath: serializer.fromJson<int?>(json['dwlBath']),
      dwlHeatingFacility: serializer.fromJson<int?>(json['dwlHeatingFacility']),
      dwlHeatingEnergy: serializer.fromJson<int?>(json['dwlHeatingEnergy']),
      dwlAirConditioner: serializer.fromJson<int?>(json['dwlAirConditioner']),
      dwlSolarPanel: serializer.fromJson<int?>(json['dwlSolarPanel']),
      createdUser: serializer.fromJson<String?>(json['createdUser']),
      createdDate: serializer.fromJson<DateTime?>(json['createdDate']),
      lastEditedUser: serializer.fromJson<String?>(json['lastEditedUser']),
      lastEditedDate: serializer.fromJson<DateTime?>(json['lastEditedDate']),
      externalCreator: serializer.fromJson<String?>(json['externalCreator']),
      externalEditor: serializer.fromJson<String?>(json['externalEditor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'objectId': serializer.toJson<int>(objectId),
      'externalCreatorDate': serializer.toJson<DateTime?>(externalCreatorDate),
      'externalEditorDate': serializer.toJson<DateTime?>(externalEditorDate),
      'globalId': serializer.toJson<String>(globalId),
      'dwlEntGlobalId': serializer.toJson<String>(dwlEntGlobalId),
      'dwlCensus2023': serializer.toJson<String?>(dwlCensus2023),
      'dwlAddressId': serializer.toJson<String?>(dwlAddressId),
      'dwlQuality': serializer.toJson<int>(dwlQuality),
      'dwlFloor': serializer.toJson<int?>(dwlFloor),
      'dwlApartNumber': serializer.toJson<String?>(dwlApartNumber),
      'dwlStatus': serializer.toJson<int>(dwlStatus),
      'dwlYearConstruction': serializer.toJson<int?>(dwlYearConstruction),
      'dwlYearElimination': serializer.toJson<int?>(dwlYearElimination),
      'dwlType': serializer.toJson<int?>(dwlType),
      'dwlOwnership': serializer.toJson<int?>(dwlOwnership),
      'dwlOccupancy': serializer.toJson<int?>(dwlOccupancy),
      'dwlSurface': serializer.toJson<int?>(dwlSurface),
      'dwlToilet': serializer.toJson<int?>(dwlToilet),
      'dwlBath': serializer.toJson<int?>(dwlBath),
      'dwlHeatingFacility': serializer.toJson<int?>(dwlHeatingFacility),
      'dwlHeatingEnergy': serializer.toJson<int?>(dwlHeatingEnergy),
      'dwlAirConditioner': serializer.toJson<int?>(dwlAirConditioner),
      'dwlSolarPanel': serializer.toJson<int?>(dwlSolarPanel),
      'createdUser': serializer.toJson<String?>(createdUser),
      'createdDate': serializer.toJson<DateTime?>(createdDate),
      'lastEditedUser': serializer.toJson<String?>(lastEditedUser),
      'lastEditedDate': serializer.toJson<DateTime?>(lastEditedDate),
      'externalCreator': serializer.toJson<String?>(externalCreator),
      'externalEditor': serializer.toJson<String?>(externalEditor),
    };
  }

  Dwelling copyWith(
          {int? objectId,
          Value<DateTime?> externalCreatorDate = const Value.absent(),
          Value<DateTime?> externalEditorDate = const Value.absent(),
          String? globalId,
          String? dwlEntGlobalId,
          Value<String?> dwlCensus2023 = const Value.absent(),
          Value<String?> dwlAddressId = const Value.absent(),
          int? dwlQuality,
          Value<int?> dwlFloor = const Value.absent(),
          Value<String?> dwlApartNumber = const Value.absent(),
          int? dwlStatus,
          Value<int?> dwlYearConstruction = const Value.absent(),
          Value<int?> dwlYearElimination = const Value.absent(),
          Value<int?> dwlType = const Value.absent(),
          Value<int?> dwlOwnership = const Value.absent(),
          Value<int?> dwlOccupancy = const Value.absent(),
          Value<int?> dwlSurface = const Value.absent(),
          Value<int?> dwlToilet = const Value.absent(),
          Value<int?> dwlBath = const Value.absent(),
          Value<int?> dwlHeatingFacility = const Value.absent(),
          Value<int?> dwlHeatingEnergy = const Value.absent(),
          Value<int?> dwlAirConditioner = const Value.absent(),
          Value<int?> dwlSolarPanel = const Value.absent(),
          Value<String?> createdUser = const Value.absent(),
          Value<DateTime?> createdDate = const Value.absent(),
          Value<String?> lastEditedUser = const Value.absent(),
          Value<DateTime?> lastEditedDate = const Value.absent(),
          Value<String?> externalCreator = const Value.absent(),
          Value<String?> externalEditor = const Value.absent()}) =>
      Dwelling(
        objectId: objectId ?? this.objectId,
        externalCreatorDate: externalCreatorDate.present
            ? externalCreatorDate.value
            : this.externalCreatorDate,
        externalEditorDate: externalEditorDate.present
            ? externalEditorDate.value
            : this.externalEditorDate,
        globalId: globalId ?? this.globalId,
        dwlEntGlobalId: dwlEntGlobalId ?? this.dwlEntGlobalId,
        dwlCensus2023:
            dwlCensus2023.present ? dwlCensus2023.value : this.dwlCensus2023,
        dwlAddressId:
            dwlAddressId.present ? dwlAddressId.value : this.dwlAddressId,
        dwlQuality: dwlQuality ?? this.dwlQuality,
        dwlFloor: dwlFloor.present ? dwlFloor.value : this.dwlFloor,
        dwlApartNumber:
            dwlApartNumber.present ? dwlApartNumber.value : this.dwlApartNumber,
        dwlStatus: dwlStatus ?? this.dwlStatus,
        dwlYearConstruction: dwlYearConstruction.present
            ? dwlYearConstruction.value
            : this.dwlYearConstruction,
        dwlYearElimination: dwlYearElimination.present
            ? dwlYearElimination.value
            : this.dwlYearElimination,
        dwlType: dwlType.present ? dwlType.value : this.dwlType,
        dwlOwnership:
            dwlOwnership.present ? dwlOwnership.value : this.dwlOwnership,
        dwlOccupancy:
            dwlOccupancy.present ? dwlOccupancy.value : this.dwlOccupancy,
        dwlSurface: dwlSurface.present ? dwlSurface.value : this.dwlSurface,
        dwlToilet: dwlToilet.present ? dwlToilet.value : this.dwlToilet,
        dwlBath: dwlBath.present ? dwlBath.value : this.dwlBath,
        dwlHeatingFacility: dwlHeatingFacility.present
            ? dwlHeatingFacility.value
            : this.dwlHeatingFacility,
        dwlHeatingEnergy: dwlHeatingEnergy.present
            ? dwlHeatingEnergy.value
            : this.dwlHeatingEnergy,
        dwlAirConditioner: dwlAirConditioner.present
            ? dwlAirConditioner.value
            : this.dwlAirConditioner,
        dwlSolarPanel:
            dwlSolarPanel.present ? dwlSolarPanel.value : this.dwlSolarPanel,
        createdUser: createdUser.present ? createdUser.value : this.createdUser,
        createdDate: createdDate.present ? createdDate.value : this.createdDate,
        lastEditedUser:
            lastEditedUser.present ? lastEditedUser.value : this.lastEditedUser,
        lastEditedDate:
            lastEditedDate.present ? lastEditedDate.value : this.lastEditedDate,
        externalCreator: externalCreator.present
            ? externalCreator.value
            : this.externalCreator,
        externalEditor:
            externalEditor.present ? externalEditor.value : this.externalEditor,
      );
  Dwelling copyWithCompanion(DwellingsCompanion data) {
    return Dwelling(
      objectId: data.objectId.present ? data.objectId.value : this.objectId,
      externalCreatorDate: data.externalCreatorDate.present
          ? data.externalCreatorDate.value
          : this.externalCreatorDate,
      externalEditorDate: data.externalEditorDate.present
          ? data.externalEditorDate.value
          : this.externalEditorDate,
      globalId: data.globalId.present ? data.globalId.value : this.globalId,
      dwlEntGlobalId: data.dwlEntGlobalId.present
          ? data.dwlEntGlobalId.value
          : this.dwlEntGlobalId,
      dwlCensus2023: data.dwlCensus2023.present
          ? data.dwlCensus2023.value
          : this.dwlCensus2023,
      dwlAddressId: data.dwlAddressId.present
          ? data.dwlAddressId.value
          : this.dwlAddressId,
      dwlQuality:
          data.dwlQuality.present ? data.dwlQuality.value : this.dwlQuality,
      dwlFloor: data.dwlFloor.present ? data.dwlFloor.value : this.dwlFloor,
      dwlApartNumber: data.dwlApartNumber.present
          ? data.dwlApartNumber.value
          : this.dwlApartNumber,
      dwlStatus: data.dwlStatus.present ? data.dwlStatus.value : this.dwlStatus,
      dwlYearConstruction: data.dwlYearConstruction.present
          ? data.dwlYearConstruction.value
          : this.dwlYearConstruction,
      dwlYearElimination: data.dwlYearElimination.present
          ? data.dwlYearElimination.value
          : this.dwlYearElimination,
      dwlType: data.dwlType.present ? data.dwlType.value : this.dwlType,
      dwlOwnership: data.dwlOwnership.present
          ? data.dwlOwnership.value
          : this.dwlOwnership,
      dwlOccupancy: data.dwlOccupancy.present
          ? data.dwlOccupancy.value
          : this.dwlOccupancy,
      dwlSurface:
          data.dwlSurface.present ? data.dwlSurface.value : this.dwlSurface,
      dwlToilet: data.dwlToilet.present ? data.dwlToilet.value : this.dwlToilet,
      dwlBath: data.dwlBath.present ? data.dwlBath.value : this.dwlBath,
      dwlHeatingFacility: data.dwlHeatingFacility.present
          ? data.dwlHeatingFacility.value
          : this.dwlHeatingFacility,
      dwlHeatingEnergy: data.dwlHeatingEnergy.present
          ? data.dwlHeatingEnergy.value
          : this.dwlHeatingEnergy,
      dwlAirConditioner: data.dwlAirConditioner.present
          ? data.dwlAirConditioner.value
          : this.dwlAirConditioner,
      dwlSolarPanel: data.dwlSolarPanel.present
          ? data.dwlSolarPanel.value
          : this.dwlSolarPanel,
      createdUser:
          data.createdUser.present ? data.createdUser.value : this.createdUser,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      lastEditedUser: data.lastEditedUser.present
          ? data.lastEditedUser.value
          : this.lastEditedUser,
      lastEditedDate: data.lastEditedDate.present
          ? data.lastEditedDate.value
          : this.lastEditedDate,
      externalCreator: data.externalCreator.present
          ? data.externalCreator.value
          : this.externalCreator,
      externalEditor: data.externalEditor.present
          ? data.externalEditor.value
          : this.externalEditor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dwelling(')
          ..write('objectId: $objectId, ')
          ..write('externalCreatorDate: $externalCreatorDate, ')
          ..write('externalEditorDate: $externalEditorDate, ')
          ..write('globalId: $globalId, ')
          ..write('dwlEntGlobalId: $dwlEntGlobalId, ')
          ..write('dwlCensus2023: $dwlCensus2023, ')
          ..write('dwlAddressId: $dwlAddressId, ')
          ..write('dwlQuality: $dwlQuality, ')
          ..write('dwlFloor: $dwlFloor, ')
          ..write('dwlApartNumber: $dwlApartNumber, ')
          ..write('dwlStatus: $dwlStatus, ')
          ..write('dwlYearConstruction: $dwlYearConstruction, ')
          ..write('dwlYearElimination: $dwlYearElimination, ')
          ..write('dwlType: $dwlType, ')
          ..write('dwlOwnership: $dwlOwnership, ')
          ..write('dwlOccupancy: $dwlOccupancy, ')
          ..write('dwlSurface: $dwlSurface, ')
          ..write('dwlToilet: $dwlToilet, ')
          ..write('dwlBath: $dwlBath, ')
          ..write('dwlHeatingFacility: $dwlHeatingFacility, ')
          ..write('dwlHeatingEnergy: $dwlHeatingEnergy, ')
          ..write('dwlAirConditioner: $dwlAirConditioner, ')
          ..write('dwlSolarPanel: $dwlSolarPanel, ')
          ..write('createdUser: $createdUser, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastEditedUser: $lastEditedUser, ')
          ..write('lastEditedDate: $lastEditedDate, ')
          ..write('externalCreator: $externalCreator, ')
          ..write('externalEditor: $externalEditor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        objectId,
        externalCreatorDate,
        externalEditorDate,
        globalId,
        dwlEntGlobalId,
        dwlCensus2023,
        dwlAddressId,
        dwlQuality,
        dwlFloor,
        dwlApartNumber,
        dwlStatus,
        dwlYearConstruction,
        dwlYearElimination,
        dwlType,
        dwlOwnership,
        dwlOccupancy,
        dwlSurface,
        dwlToilet,
        dwlBath,
        dwlHeatingFacility,
        dwlHeatingEnergy,
        dwlAirConditioner,
        dwlSolarPanel,
        createdUser,
        createdDate,
        lastEditedUser,
        lastEditedDate,
        externalCreator,
        externalEditor
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dwelling &&
          other.objectId == this.objectId &&
          other.externalCreatorDate == this.externalCreatorDate &&
          other.externalEditorDate == this.externalEditorDate &&
          other.globalId == this.globalId &&
          other.dwlEntGlobalId == this.dwlEntGlobalId &&
          other.dwlCensus2023 == this.dwlCensus2023 &&
          other.dwlAddressId == this.dwlAddressId &&
          other.dwlQuality == this.dwlQuality &&
          other.dwlFloor == this.dwlFloor &&
          other.dwlApartNumber == this.dwlApartNumber &&
          other.dwlStatus == this.dwlStatus &&
          other.dwlYearConstruction == this.dwlYearConstruction &&
          other.dwlYearElimination == this.dwlYearElimination &&
          other.dwlType == this.dwlType &&
          other.dwlOwnership == this.dwlOwnership &&
          other.dwlOccupancy == this.dwlOccupancy &&
          other.dwlSurface == this.dwlSurface &&
          other.dwlToilet == this.dwlToilet &&
          other.dwlBath == this.dwlBath &&
          other.dwlHeatingFacility == this.dwlHeatingFacility &&
          other.dwlHeatingEnergy == this.dwlHeatingEnergy &&
          other.dwlAirConditioner == this.dwlAirConditioner &&
          other.dwlSolarPanel == this.dwlSolarPanel &&
          other.createdUser == this.createdUser &&
          other.createdDate == this.createdDate &&
          other.lastEditedUser == this.lastEditedUser &&
          other.lastEditedDate == this.lastEditedDate &&
          other.externalCreator == this.externalCreator &&
          other.externalEditor == this.externalEditor);
}

class DwellingsCompanion extends UpdateCompanion<Dwelling> {
  final Value<int> objectId;
  final Value<DateTime?> externalCreatorDate;
  final Value<DateTime?> externalEditorDate;
  final Value<String> globalId;
  final Value<String> dwlEntGlobalId;
  final Value<String?> dwlCensus2023;
  final Value<String?> dwlAddressId;
  final Value<int> dwlQuality;
  final Value<int?> dwlFloor;
  final Value<String?> dwlApartNumber;
  final Value<int> dwlStatus;
  final Value<int?> dwlYearConstruction;
  final Value<int?> dwlYearElimination;
  final Value<int?> dwlType;
  final Value<int?> dwlOwnership;
  final Value<int?> dwlOccupancy;
  final Value<int?> dwlSurface;
  final Value<int?> dwlToilet;
  final Value<int?> dwlBath;
  final Value<int?> dwlHeatingFacility;
  final Value<int?> dwlHeatingEnergy;
  final Value<int?> dwlAirConditioner;
  final Value<int?> dwlSolarPanel;
  final Value<String?> createdUser;
  final Value<DateTime?> createdDate;
  final Value<String?> lastEditedUser;
  final Value<DateTime?> lastEditedDate;
  final Value<String?> externalCreator;
  final Value<String?> externalEditor;
  const DwellingsCompanion({
    this.objectId = const Value.absent(),
    this.externalCreatorDate = const Value.absent(),
    this.externalEditorDate = const Value.absent(),
    this.globalId = const Value.absent(),
    this.dwlEntGlobalId = const Value.absent(),
    this.dwlCensus2023 = const Value.absent(),
    this.dwlAddressId = const Value.absent(),
    this.dwlQuality = const Value.absent(),
    this.dwlFloor = const Value.absent(),
    this.dwlApartNumber = const Value.absent(),
    this.dwlStatus = const Value.absent(),
    this.dwlYearConstruction = const Value.absent(),
    this.dwlYearElimination = const Value.absent(),
    this.dwlType = const Value.absent(),
    this.dwlOwnership = const Value.absent(),
    this.dwlOccupancy = const Value.absent(),
    this.dwlSurface = const Value.absent(),
    this.dwlToilet = const Value.absent(),
    this.dwlBath = const Value.absent(),
    this.dwlHeatingFacility = const Value.absent(),
    this.dwlHeatingEnergy = const Value.absent(),
    this.dwlAirConditioner = const Value.absent(),
    this.dwlSolarPanel = const Value.absent(),
    this.createdUser = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastEditedUser = const Value.absent(),
    this.lastEditedDate = const Value.absent(),
    this.externalCreator = const Value.absent(),
    this.externalEditor = const Value.absent(),
  });
  DwellingsCompanion.insert({
    this.objectId = const Value.absent(),
    this.externalCreatorDate = const Value.absent(),
    this.externalEditorDate = const Value.absent(),
    required String globalId,
    this.dwlEntGlobalId = const Value.absent(),
    this.dwlCensus2023 = const Value.absent(),
    this.dwlAddressId = const Value.absent(),
    this.dwlQuality = const Value.absent(),
    this.dwlFloor = const Value.absent(),
    this.dwlApartNumber = const Value.absent(),
    this.dwlStatus = const Value.absent(),
    this.dwlYearConstruction = const Value.absent(),
    this.dwlYearElimination = const Value.absent(),
    this.dwlType = const Value.absent(),
    this.dwlOwnership = const Value.absent(),
    this.dwlOccupancy = const Value.absent(),
    this.dwlSurface = const Value.absent(),
    this.dwlToilet = const Value.absent(),
    this.dwlBath = const Value.absent(),
    this.dwlHeatingFacility = const Value.absent(),
    this.dwlHeatingEnergy = const Value.absent(),
    this.dwlAirConditioner = const Value.absent(),
    this.dwlSolarPanel = const Value.absent(),
    this.createdUser = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastEditedUser = const Value.absent(),
    this.lastEditedDate = const Value.absent(),
    this.externalCreator = const Value.absent(),
    this.externalEditor = const Value.absent(),
  }) : globalId = Value(globalId);
  static Insertable<Dwelling> custom({
    Expression<int>? objectId,
    Expression<DateTime>? externalCreatorDate,
    Expression<DateTime>? externalEditorDate,
    Expression<String>? globalId,
    Expression<String>? dwlEntGlobalId,
    Expression<String>? dwlCensus2023,
    Expression<String>? dwlAddressId,
    Expression<int>? dwlQuality,
    Expression<int>? dwlFloor,
    Expression<String>? dwlApartNumber,
    Expression<int>? dwlStatus,
    Expression<int>? dwlYearConstruction,
    Expression<int>? dwlYearElimination,
    Expression<int>? dwlType,
    Expression<int>? dwlOwnership,
    Expression<int>? dwlOccupancy,
    Expression<int>? dwlSurface,
    Expression<int>? dwlToilet,
    Expression<int>? dwlBath,
    Expression<int>? dwlHeatingFacility,
    Expression<int>? dwlHeatingEnergy,
    Expression<int>? dwlAirConditioner,
    Expression<int>? dwlSolarPanel,
    Expression<String>? createdUser,
    Expression<DateTime>? createdDate,
    Expression<String>? lastEditedUser,
    Expression<DateTime>? lastEditedDate,
    Expression<String>? externalCreator,
    Expression<String>? externalEditor,
  }) {
    return RawValuesInsertable({
      if (objectId != null) 'object_id': objectId,
      if (externalCreatorDate != null)
        'external_creator_date': externalCreatorDate,
      if (externalEditorDate != null)
        'external_editor_date': externalEditorDate,
      if (globalId != null) 'global_id': globalId,
      if (dwlEntGlobalId != null) 'dwl_ent_global_id': dwlEntGlobalId,
      if (dwlCensus2023 != null) 'dwl_census2023': dwlCensus2023,
      if (dwlAddressId != null) 'dwl_address_id': dwlAddressId,
      if (dwlQuality != null) 'dwl_quality': dwlQuality,
      if (dwlFloor != null) 'dwl_floor': dwlFloor,
      if (dwlApartNumber != null) 'dwl_apart_number': dwlApartNumber,
      if (dwlStatus != null) 'dwl_status': dwlStatus,
      if (dwlYearConstruction != null)
        'dwl_year_construction': dwlYearConstruction,
      if (dwlYearElimination != null)
        'dwl_year_elimination': dwlYearElimination,
      if (dwlType != null) 'dwl_type': dwlType,
      if (dwlOwnership != null) 'dwl_ownership': dwlOwnership,
      if (dwlOccupancy != null) 'dwl_occupancy': dwlOccupancy,
      if (dwlSurface != null) 'dwl_surface': dwlSurface,
      if (dwlToilet != null) 'dwl_toilet': dwlToilet,
      if (dwlBath != null) 'dwl_bath': dwlBath,
      if (dwlHeatingFacility != null)
        'dwl_heating_facility': dwlHeatingFacility,
      if (dwlHeatingEnergy != null) 'dwl_heating_energy': dwlHeatingEnergy,
      if (dwlAirConditioner != null) 'dwl_air_conditioner': dwlAirConditioner,
      if (dwlSolarPanel != null) 'dwl_solar_panel': dwlSolarPanel,
      if (createdUser != null) 'created_user': createdUser,
      if (createdDate != null) 'created_date': createdDate,
      if (lastEditedUser != null) 'last_edited_user': lastEditedUser,
      if (lastEditedDate != null) 'last_edited_date': lastEditedDate,
      if (externalCreator != null) 'external_creator': externalCreator,
      if (externalEditor != null) 'external_editor': externalEditor,
    });
  }

  DwellingsCompanion copyWith(
      {Value<int>? objectId,
      Value<DateTime?>? externalCreatorDate,
      Value<DateTime?>? externalEditorDate,
      Value<String>? globalId,
      Value<String>? dwlEntGlobalId,
      Value<String?>? dwlCensus2023,
      Value<String?>? dwlAddressId,
      Value<int>? dwlQuality,
      Value<int?>? dwlFloor,
      Value<String?>? dwlApartNumber,
      Value<int>? dwlStatus,
      Value<int?>? dwlYearConstruction,
      Value<int?>? dwlYearElimination,
      Value<int?>? dwlType,
      Value<int?>? dwlOwnership,
      Value<int?>? dwlOccupancy,
      Value<int?>? dwlSurface,
      Value<int?>? dwlToilet,
      Value<int?>? dwlBath,
      Value<int?>? dwlHeatingFacility,
      Value<int?>? dwlHeatingEnergy,
      Value<int?>? dwlAirConditioner,
      Value<int?>? dwlSolarPanel,
      Value<String?>? createdUser,
      Value<DateTime?>? createdDate,
      Value<String?>? lastEditedUser,
      Value<DateTime?>? lastEditedDate,
      Value<String?>? externalCreator,
      Value<String?>? externalEditor}) {
    return DwellingsCompanion(
      objectId: objectId ?? this.objectId,
      externalCreatorDate: externalCreatorDate ?? this.externalCreatorDate,
      externalEditorDate: externalEditorDate ?? this.externalEditorDate,
      globalId: globalId ?? this.globalId,
      dwlEntGlobalId: dwlEntGlobalId ?? this.dwlEntGlobalId,
      dwlCensus2023: dwlCensus2023 ?? this.dwlCensus2023,
      dwlAddressId: dwlAddressId ?? this.dwlAddressId,
      dwlQuality: dwlQuality ?? this.dwlQuality,
      dwlFloor: dwlFloor ?? this.dwlFloor,
      dwlApartNumber: dwlApartNumber ?? this.dwlApartNumber,
      dwlStatus: dwlStatus ?? this.dwlStatus,
      dwlYearConstruction: dwlYearConstruction ?? this.dwlYearConstruction,
      dwlYearElimination: dwlYearElimination ?? this.dwlYearElimination,
      dwlType: dwlType ?? this.dwlType,
      dwlOwnership: dwlOwnership ?? this.dwlOwnership,
      dwlOccupancy: dwlOccupancy ?? this.dwlOccupancy,
      dwlSurface: dwlSurface ?? this.dwlSurface,
      dwlToilet: dwlToilet ?? this.dwlToilet,
      dwlBath: dwlBath ?? this.dwlBath,
      dwlHeatingFacility: dwlHeatingFacility ?? this.dwlHeatingFacility,
      dwlHeatingEnergy: dwlHeatingEnergy ?? this.dwlHeatingEnergy,
      dwlAirConditioner: dwlAirConditioner ?? this.dwlAirConditioner,
      dwlSolarPanel: dwlSolarPanel ?? this.dwlSolarPanel,
      createdUser: createdUser ?? this.createdUser,
      createdDate: createdDate ?? this.createdDate,
      lastEditedUser: lastEditedUser ?? this.lastEditedUser,
      lastEditedDate: lastEditedDate ?? this.lastEditedDate,
      externalCreator: externalCreator ?? this.externalCreator,
      externalEditor: externalEditor ?? this.externalEditor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (objectId.present) {
      map['object_id'] = Variable<int>(objectId.value);
    }
    if (externalCreatorDate.present) {
      map['external_creator_date'] =
          Variable<DateTime>(externalCreatorDate.value);
    }
    if (externalEditorDate.present) {
      map['external_editor_date'] =
          Variable<DateTime>(externalEditorDate.value);
    }
    if (globalId.present) {
      map['global_id'] = Variable<String>(globalId.value);
    }
    if (dwlEntGlobalId.present) {
      map['dwl_ent_global_id'] = Variable<String>(dwlEntGlobalId.value);
    }
    if (dwlCensus2023.present) {
      map['dwl_census2023'] = Variable<String>(dwlCensus2023.value);
    }
    if (dwlAddressId.present) {
      map['dwl_address_id'] = Variable<String>(dwlAddressId.value);
    }
    if (dwlQuality.present) {
      map['dwl_quality'] = Variable<int>(dwlQuality.value);
    }
    if (dwlFloor.present) {
      map['dwl_floor'] = Variable<int>(dwlFloor.value);
    }
    if (dwlApartNumber.present) {
      map['dwl_apart_number'] = Variable<String>(dwlApartNumber.value);
    }
    if (dwlStatus.present) {
      map['dwl_status'] = Variable<int>(dwlStatus.value);
    }
    if (dwlYearConstruction.present) {
      map['dwl_year_construction'] = Variable<int>(dwlYearConstruction.value);
    }
    if (dwlYearElimination.present) {
      map['dwl_year_elimination'] = Variable<int>(dwlYearElimination.value);
    }
    if (dwlType.present) {
      map['dwl_type'] = Variable<int>(dwlType.value);
    }
    if (dwlOwnership.present) {
      map['dwl_ownership'] = Variable<int>(dwlOwnership.value);
    }
    if (dwlOccupancy.present) {
      map['dwl_occupancy'] = Variable<int>(dwlOccupancy.value);
    }
    if (dwlSurface.present) {
      map['dwl_surface'] = Variable<int>(dwlSurface.value);
    }
    if (dwlToilet.present) {
      map['dwl_toilet'] = Variable<int>(dwlToilet.value);
    }
    if (dwlBath.present) {
      map['dwl_bath'] = Variable<int>(dwlBath.value);
    }
    if (dwlHeatingFacility.present) {
      map['dwl_heating_facility'] = Variable<int>(dwlHeatingFacility.value);
    }
    if (dwlHeatingEnergy.present) {
      map['dwl_heating_energy'] = Variable<int>(dwlHeatingEnergy.value);
    }
    if (dwlAirConditioner.present) {
      map['dwl_air_conditioner'] = Variable<int>(dwlAirConditioner.value);
    }
    if (dwlSolarPanel.present) {
      map['dwl_solar_panel'] = Variable<int>(dwlSolarPanel.value);
    }
    if (createdUser.present) {
      map['created_user'] = Variable<String>(createdUser.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (lastEditedUser.present) {
      map['last_edited_user'] = Variable<String>(lastEditedUser.value);
    }
    if (lastEditedDate.present) {
      map['last_edited_date'] = Variable<DateTime>(lastEditedDate.value);
    }
    if (externalCreator.present) {
      map['external_creator'] = Variable<String>(externalCreator.value);
    }
    if (externalEditor.present) {
      map['external_editor'] = Variable<String>(externalEditor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DwellingsCompanion(')
          ..write('objectId: $objectId, ')
          ..write('externalCreatorDate: $externalCreatorDate, ')
          ..write('externalEditorDate: $externalEditorDate, ')
          ..write('globalId: $globalId, ')
          ..write('dwlEntGlobalId: $dwlEntGlobalId, ')
          ..write('dwlCensus2023: $dwlCensus2023, ')
          ..write('dwlAddressId: $dwlAddressId, ')
          ..write('dwlQuality: $dwlQuality, ')
          ..write('dwlFloor: $dwlFloor, ')
          ..write('dwlApartNumber: $dwlApartNumber, ')
          ..write('dwlStatus: $dwlStatus, ')
          ..write('dwlYearConstruction: $dwlYearConstruction, ')
          ..write('dwlYearElimination: $dwlYearElimination, ')
          ..write('dwlType: $dwlType, ')
          ..write('dwlOwnership: $dwlOwnership, ')
          ..write('dwlOccupancy: $dwlOccupancy, ')
          ..write('dwlSurface: $dwlSurface, ')
          ..write('dwlToilet: $dwlToilet, ')
          ..write('dwlBath: $dwlBath, ')
          ..write('dwlHeatingFacility: $dwlHeatingFacility, ')
          ..write('dwlHeatingEnergy: $dwlHeatingEnergy, ')
          ..write('dwlAirConditioner: $dwlAirConditioner, ')
          ..write('dwlSolarPanel: $dwlSolarPanel, ')
          ..write('createdUser: $createdUser, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastEditedUser: $lastEditedUser, ')
          ..write('lastEditedDate: $lastEditedDate, ')
          ..write('externalCreator: $externalCreator, ')
          ..write('externalEditor: $externalEditor')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BuildingsTable buildings = $BuildingsTable(this);
  late final $EntrancesTable entrances = $EntrancesTable(this);
  late final $DwellingsTable dwellings = $DwellingsTable(this);
  late final BuildingDao buildingDao = BuildingDao(this as AppDatabase);
  late final EntrancesDao entrancesDao = EntrancesDao(this as AppDatabase);
  late final DwellingsDao dwellingsDao = DwellingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [buildings, entrances, dwellings];
}

typedef $$BuildingsTableCreateCompanionBuilder = BuildingsCompanion Function({
  Value<int> objectId,
  Value<double?> shapeLength,
  Value<double?> shapeArea,
  required String globalId,
  Value<String?> bldCensus2023,
  Value<int> bldQuality,
  required int bldMunicipality,
  Value<String?> bldEnumArea,
  required double bldLatitude,
  required double bldLongitude,
  Value<int?> bldCadastralZone,
  Value<String?> bldProperty,
  Value<String?> bldPermitNumber,
  Value<DateTime?> bldPermitDate,
  Value<int> bldStatus,
  Value<int?> bldYearConstruction,
  Value<int?> bldYearDemolition,
  Value<int?> bldType,
  Value<int?> bldClass,
  Value<double?> bldArea,
  Value<int?> bldFloorsAbove,
  Value<int?> bldHeight,
  Value<double?> bldVolume,
  Value<int?> bldWasteWater,
  Value<int?> bldElectricity,
  Value<int?> bldPipedGas,
  Value<int?> bldElevator,
  Value<String?> createdUser,
  Value<DateTime?> createdDate,
  Value<String?> lastEditedUser,
  Value<DateTime?> lastEditedDate,
  Value<int> bldCentroidStatus,
  Value<int?> bldDwellingRecs,
  Value<int?> bldEntranceRecs,
  Value<String?> bldAddressId,
  Value<String?> externalCreator,
  Value<String?> externalEditor,
  Value<int> bldReview,
  Value<int?> bldWaterSupply,
  Value<DateTime?> externalCreatorDate,
  Value<DateTime?> externalEditorDate,
});
typedef $$BuildingsTableUpdateCompanionBuilder = BuildingsCompanion Function({
  Value<int> objectId,
  Value<double?> shapeLength,
  Value<double?> shapeArea,
  Value<String> globalId,
  Value<String?> bldCensus2023,
  Value<int> bldQuality,
  Value<int> bldMunicipality,
  Value<String?> bldEnumArea,
  Value<double> bldLatitude,
  Value<double> bldLongitude,
  Value<int?> bldCadastralZone,
  Value<String?> bldProperty,
  Value<String?> bldPermitNumber,
  Value<DateTime?> bldPermitDate,
  Value<int> bldStatus,
  Value<int?> bldYearConstruction,
  Value<int?> bldYearDemolition,
  Value<int?> bldType,
  Value<int?> bldClass,
  Value<double?> bldArea,
  Value<int?> bldFloorsAbove,
  Value<int?> bldHeight,
  Value<double?> bldVolume,
  Value<int?> bldWasteWater,
  Value<int?> bldElectricity,
  Value<int?> bldPipedGas,
  Value<int?> bldElevator,
  Value<String?> createdUser,
  Value<DateTime?> createdDate,
  Value<String?> lastEditedUser,
  Value<DateTime?> lastEditedDate,
  Value<int> bldCentroidStatus,
  Value<int?> bldDwellingRecs,
  Value<int?> bldEntranceRecs,
  Value<String?> bldAddressId,
  Value<String?> externalCreator,
  Value<String?> externalEditor,
  Value<int> bldReview,
  Value<int?> bldWaterSupply,
  Value<DateTime?> externalCreatorDate,
  Value<DateTime?> externalEditorDate,
});

class $$BuildingsTableFilterComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get shapeLength => $composableBuilder(
      column: $table.shapeLength, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get shapeArea => $composableBuilder(
      column: $table.shapeArea, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bldCensus2023 => $composableBuilder(
      column: $table.bldCensus2023, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldQuality => $composableBuilder(
      column: $table.bldQuality, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldMunicipality => $composableBuilder(
      column: $table.bldMunicipality,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bldEnumArea => $composableBuilder(
      column: $table.bldEnumArea, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bldLatitude => $composableBuilder(
      column: $table.bldLatitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bldLongitude => $composableBuilder(
      column: $table.bldLongitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldCadastralZone => $composableBuilder(
      column: $table.bldCadastralZone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bldProperty => $composableBuilder(
      column: $table.bldProperty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bldPermitNumber => $composableBuilder(
      column: $table.bldPermitNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get bldPermitDate => $composableBuilder(
      column: $table.bldPermitDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldStatus => $composableBuilder(
      column: $table.bldStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldYearConstruction => $composableBuilder(
      column: $table.bldYearConstruction,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldYearDemolition => $composableBuilder(
      column: $table.bldYearDemolition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldType => $composableBuilder(
      column: $table.bldType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldClass => $composableBuilder(
      column: $table.bldClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bldArea => $composableBuilder(
      column: $table.bldArea, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldFloorsAbove => $composableBuilder(
      column: $table.bldFloorsAbove,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldHeight => $composableBuilder(
      column: $table.bldHeight, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bldVolume => $composableBuilder(
      column: $table.bldVolume, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldWasteWater => $composableBuilder(
      column: $table.bldWasteWater, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldElectricity => $composableBuilder(
      column: $table.bldElectricity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldPipedGas => $composableBuilder(
      column: $table.bldPipedGas, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldElevator => $composableBuilder(
      column: $table.bldElevator, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdUser => $composableBuilder(
      column: $table.createdUser, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastEditedUser => $composableBuilder(
      column: $table.lastEditedUser,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastEditedDate => $composableBuilder(
      column: $table.lastEditedDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldCentroidStatus => $composableBuilder(
      column: $table.bldCentroidStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldDwellingRecs => $composableBuilder(
      column: $table.bldDwellingRecs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldEntranceRecs => $composableBuilder(
      column: $table.bldEntranceRecs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bldAddressId => $composableBuilder(
      column: $table.bldAddressId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalCreator => $composableBuilder(
      column: $table.externalCreator,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalEditor => $composableBuilder(
      column: $table.externalEditor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldReview => $composableBuilder(
      column: $table.bldReview, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldWaterSupply => $composableBuilder(
      column: $table.bldWaterSupply,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get externalCreatorDate => $composableBuilder(
      column: $table.externalCreatorDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get externalEditorDate => $composableBuilder(
      column: $table.externalEditorDate,
      builder: (column) => ColumnFilters(column));
}

class $$BuildingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get shapeLength => $composableBuilder(
      column: $table.shapeLength, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get shapeArea => $composableBuilder(
      column: $table.shapeArea, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bldCensus2023 => $composableBuilder(
      column: $table.bldCensus2023,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldQuality => $composableBuilder(
      column: $table.bldQuality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldMunicipality => $composableBuilder(
      column: $table.bldMunicipality,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bldEnumArea => $composableBuilder(
      column: $table.bldEnumArea, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bldLatitude => $composableBuilder(
      column: $table.bldLatitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bldLongitude => $composableBuilder(
      column: $table.bldLongitude,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldCadastralZone => $composableBuilder(
      column: $table.bldCadastralZone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bldProperty => $composableBuilder(
      column: $table.bldProperty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bldPermitNumber => $composableBuilder(
      column: $table.bldPermitNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get bldPermitDate => $composableBuilder(
      column: $table.bldPermitDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldStatus => $composableBuilder(
      column: $table.bldStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldYearConstruction => $composableBuilder(
      column: $table.bldYearConstruction,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldYearDemolition => $composableBuilder(
      column: $table.bldYearDemolition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldType => $composableBuilder(
      column: $table.bldType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldClass => $composableBuilder(
      column: $table.bldClass, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bldArea => $composableBuilder(
      column: $table.bldArea, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldFloorsAbove => $composableBuilder(
      column: $table.bldFloorsAbove,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldHeight => $composableBuilder(
      column: $table.bldHeight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bldVolume => $composableBuilder(
      column: $table.bldVolume, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldWasteWater => $composableBuilder(
      column: $table.bldWasteWater,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldElectricity => $composableBuilder(
      column: $table.bldElectricity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldPipedGas => $composableBuilder(
      column: $table.bldPipedGas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldElevator => $composableBuilder(
      column: $table.bldElevator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdUser => $composableBuilder(
      column: $table.createdUser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastEditedUser => $composableBuilder(
      column: $table.lastEditedUser,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastEditedDate => $composableBuilder(
      column: $table.lastEditedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldCentroidStatus => $composableBuilder(
      column: $table.bldCentroidStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldDwellingRecs => $composableBuilder(
      column: $table.bldDwellingRecs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldEntranceRecs => $composableBuilder(
      column: $table.bldEntranceRecs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bldAddressId => $composableBuilder(
      column: $table.bldAddressId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalCreator => $composableBuilder(
      column: $table.externalCreator,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalEditor => $composableBuilder(
      column: $table.externalEditor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldReview => $composableBuilder(
      column: $table.bldReview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldWaterSupply => $composableBuilder(
      column: $table.bldWaterSupply,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get externalCreatorDate => $composableBuilder(
      column: $table.externalCreatorDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get externalEditorDate => $composableBuilder(
      column: $table.externalEditorDate,
      builder: (column) => ColumnOrderings(column));
}

class $$BuildingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get objectId =>
      $composableBuilder(column: $table.objectId, builder: (column) => column);

  GeneratedColumn<double> get shapeLength => $composableBuilder(
      column: $table.shapeLength, builder: (column) => column);

  GeneratedColumn<double> get shapeArea =>
      $composableBuilder(column: $table.shapeArea, builder: (column) => column);

  GeneratedColumn<String> get globalId =>
      $composableBuilder(column: $table.globalId, builder: (column) => column);

  GeneratedColumn<String> get bldCensus2023 => $composableBuilder(
      column: $table.bldCensus2023, builder: (column) => column);

  GeneratedColumn<int> get bldQuality => $composableBuilder(
      column: $table.bldQuality, builder: (column) => column);

  GeneratedColumn<int> get bldMunicipality => $composableBuilder(
      column: $table.bldMunicipality, builder: (column) => column);

  GeneratedColumn<String> get bldEnumArea => $composableBuilder(
      column: $table.bldEnumArea, builder: (column) => column);

  GeneratedColumn<double> get bldLatitude => $composableBuilder(
      column: $table.bldLatitude, builder: (column) => column);

  GeneratedColumn<double> get bldLongitude => $composableBuilder(
      column: $table.bldLongitude, builder: (column) => column);

  GeneratedColumn<int> get bldCadastralZone => $composableBuilder(
      column: $table.bldCadastralZone, builder: (column) => column);

  GeneratedColumn<String> get bldProperty => $composableBuilder(
      column: $table.bldProperty, builder: (column) => column);

  GeneratedColumn<String> get bldPermitNumber => $composableBuilder(
      column: $table.bldPermitNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get bldPermitDate => $composableBuilder(
      column: $table.bldPermitDate, builder: (column) => column);

  GeneratedColumn<int> get bldStatus =>
      $composableBuilder(column: $table.bldStatus, builder: (column) => column);

  GeneratedColumn<int> get bldYearConstruction => $composableBuilder(
      column: $table.bldYearConstruction, builder: (column) => column);

  GeneratedColumn<int> get bldYearDemolition => $composableBuilder(
      column: $table.bldYearDemolition, builder: (column) => column);

  GeneratedColumn<int> get bldType =>
      $composableBuilder(column: $table.bldType, builder: (column) => column);

  GeneratedColumn<int> get bldClass =>
      $composableBuilder(column: $table.bldClass, builder: (column) => column);

  GeneratedColumn<double> get bldArea =>
      $composableBuilder(column: $table.bldArea, builder: (column) => column);

  GeneratedColumn<int> get bldFloorsAbove => $composableBuilder(
      column: $table.bldFloorsAbove, builder: (column) => column);

  GeneratedColumn<int> get bldHeight =>
      $composableBuilder(column: $table.bldHeight, builder: (column) => column);

  GeneratedColumn<double> get bldVolume =>
      $composableBuilder(column: $table.bldVolume, builder: (column) => column);

  GeneratedColumn<int> get bldWasteWater => $composableBuilder(
      column: $table.bldWasteWater, builder: (column) => column);

  GeneratedColumn<int> get bldElectricity => $composableBuilder(
      column: $table.bldElectricity, builder: (column) => column);

  GeneratedColumn<int> get bldPipedGas => $composableBuilder(
      column: $table.bldPipedGas, builder: (column) => column);

  GeneratedColumn<int> get bldElevator => $composableBuilder(
      column: $table.bldElevator, builder: (column) => column);

  GeneratedColumn<String> get createdUser => $composableBuilder(
      column: $table.createdUser, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);

  GeneratedColumn<String> get lastEditedUser => $composableBuilder(
      column: $table.lastEditedUser, builder: (column) => column);

  GeneratedColumn<DateTime> get lastEditedDate => $composableBuilder(
      column: $table.lastEditedDate, builder: (column) => column);

  GeneratedColumn<int> get bldCentroidStatus => $composableBuilder(
      column: $table.bldCentroidStatus, builder: (column) => column);

  GeneratedColumn<int> get bldDwellingRecs => $composableBuilder(
      column: $table.bldDwellingRecs, builder: (column) => column);

  GeneratedColumn<int> get bldEntranceRecs => $composableBuilder(
      column: $table.bldEntranceRecs, builder: (column) => column);

  GeneratedColumn<String> get bldAddressId => $composableBuilder(
      column: $table.bldAddressId, builder: (column) => column);

  GeneratedColumn<String> get externalCreator => $composableBuilder(
      column: $table.externalCreator, builder: (column) => column);

  GeneratedColumn<String> get externalEditor => $composableBuilder(
      column: $table.externalEditor, builder: (column) => column);

  GeneratedColumn<int> get bldReview =>
      $composableBuilder(column: $table.bldReview, builder: (column) => column);

  GeneratedColumn<int> get bldWaterSupply => $composableBuilder(
      column: $table.bldWaterSupply, builder: (column) => column);

  GeneratedColumn<DateTime> get externalCreatorDate => $composableBuilder(
      column: $table.externalCreatorDate, builder: (column) => column);

  GeneratedColumn<DateTime> get externalEditorDate => $composableBuilder(
      column: $table.externalEditorDate, builder: (column) => column);
}

class $$BuildingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BuildingsTable,
    Building,
    $$BuildingsTableFilterComposer,
    $$BuildingsTableOrderingComposer,
    $$BuildingsTableAnnotationComposer,
    $$BuildingsTableCreateCompanionBuilder,
    $$BuildingsTableUpdateCompanionBuilder,
    (Building, BaseReferences<_$AppDatabase, $BuildingsTable, Building>),
    Building,
    PrefetchHooks Function()> {
  $$BuildingsTableTableManager(_$AppDatabase db, $BuildingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BuildingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BuildingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BuildingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> objectId = const Value.absent(),
            Value<double?> shapeLength = const Value.absent(),
            Value<double?> shapeArea = const Value.absent(),
            Value<String> globalId = const Value.absent(),
            Value<String?> bldCensus2023 = const Value.absent(),
            Value<int> bldQuality = const Value.absent(),
            Value<int> bldMunicipality = const Value.absent(),
            Value<String?> bldEnumArea = const Value.absent(),
            Value<double> bldLatitude = const Value.absent(),
            Value<double> bldLongitude = const Value.absent(),
            Value<int?> bldCadastralZone = const Value.absent(),
            Value<String?> bldProperty = const Value.absent(),
            Value<String?> bldPermitNumber = const Value.absent(),
            Value<DateTime?> bldPermitDate = const Value.absent(),
            Value<int> bldStatus = const Value.absent(),
            Value<int?> bldYearConstruction = const Value.absent(),
            Value<int?> bldYearDemolition = const Value.absent(),
            Value<int?> bldType = const Value.absent(),
            Value<int?> bldClass = const Value.absent(),
            Value<double?> bldArea = const Value.absent(),
            Value<int?> bldFloorsAbove = const Value.absent(),
            Value<int?> bldHeight = const Value.absent(),
            Value<double?> bldVolume = const Value.absent(),
            Value<int?> bldWasteWater = const Value.absent(),
            Value<int?> bldElectricity = const Value.absent(),
            Value<int?> bldPipedGas = const Value.absent(),
            Value<int?> bldElevator = const Value.absent(),
            Value<String?> createdUser = const Value.absent(),
            Value<DateTime?> createdDate = const Value.absent(),
            Value<String?> lastEditedUser = const Value.absent(),
            Value<DateTime?> lastEditedDate = const Value.absent(),
            Value<int> bldCentroidStatus = const Value.absent(),
            Value<int?> bldDwellingRecs = const Value.absent(),
            Value<int?> bldEntranceRecs = const Value.absent(),
            Value<String?> bldAddressId = const Value.absent(),
            Value<String?> externalCreator = const Value.absent(),
            Value<String?> externalEditor = const Value.absent(),
            Value<int> bldReview = const Value.absent(),
            Value<int?> bldWaterSupply = const Value.absent(),
            Value<DateTime?> externalCreatorDate = const Value.absent(),
            Value<DateTime?> externalEditorDate = const Value.absent(),
          }) =>
              BuildingsCompanion(
            objectId: objectId,
            shapeLength: shapeLength,
            shapeArea: shapeArea,
            globalId: globalId,
            bldCensus2023: bldCensus2023,
            bldQuality: bldQuality,
            bldMunicipality: bldMunicipality,
            bldEnumArea: bldEnumArea,
            bldLatitude: bldLatitude,
            bldLongitude: bldLongitude,
            bldCadastralZone: bldCadastralZone,
            bldProperty: bldProperty,
            bldPermitNumber: bldPermitNumber,
            bldPermitDate: bldPermitDate,
            bldStatus: bldStatus,
            bldYearConstruction: bldYearConstruction,
            bldYearDemolition: bldYearDemolition,
            bldType: bldType,
            bldClass: bldClass,
            bldArea: bldArea,
            bldFloorsAbove: bldFloorsAbove,
            bldHeight: bldHeight,
            bldVolume: bldVolume,
            bldWasteWater: bldWasteWater,
            bldElectricity: bldElectricity,
            bldPipedGas: bldPipedGas,
            bldElevator: bldElevator,
            createdUser: createdUser,
            createdDate: createdDate,
            lastEditedUser: lastEditedUser,
            lastEditedDate: lastEditedDate,
            bldCentroidStatus: bldCentroidStatus,
            bldDwellingRecs: bldDwellingRecs,
            bldEntranceRecs: bldEntranceRecs,
            bldAddressId: bldAddressId,
            externalCreator: externalCreator,
            externalEditor: externalEditor,
            bldReview: bldReview,
            bldWaterSupply: bldWaterSupply,
            externalCreatorDate: externalCreatorDate,
            externalEditorDate: externalEditorDate,
          ),
          createCompanionCallback: ({
            Value<int> objectId = const Value.absent(),
            Value<double?> shapeLength = const Value.absent(),
            Value<double?> shapeArea = const Value.absent(),
            required String globalId,
            Value<String?> bldCensus2023 = const Value.absent(),
            Value<int> bldQuality = const Value.absent(),
            required int bldMunicipality,
            Value<String?> bldEnumArea = const Value.absent(),
            required double bldLatitude,
            required double bldLongitude,
            Value<int?> bldCadastralZone = const Value.absent(),
            Value<String?> bldProperty = const Value.absent(),
            Value<String?> bldPermitNumber = const Value.absent(),
            Value<DateTime?> bldPermitDate = const Value.absent(),
            Value<int> bldStatus = const Value.absent(),
            Value<int?> bldYearConstruction = const Value.absent(),
            Value<int?> bldYearDemolition = const Value.absent(),
            Value<int?> bldType = const Value.absent(),
            Value<int?> bldClass = const Value.absent(),
            Value<double?> bldArea = const Value.absent(),
            Value<int?> bldFloorsAbove = const Value.absent(),
            Value<int?> bldHeight = const Value.absent(),
            Value<double?> bldVolume = const Value.absent(),
            Value<int?> bldWasteWater = const Value.absent(),
            Value<int?> bldElectricity = const Value.absent(),
            Value<int?> bldPipedGas = const Value.absent(),
            Value<int?> bldElevator = const Value.absent(),
            Value<String?> createdUser = const Value.absent(),
            Value<DateTime?> createdDate = const Value.absent(),
            Value<String?> lastEditedUser = const Value.absent(),
            Value<DateTime?> lastEditedDate = const Value.absent(),
            Value<int> bldCentroidStatus = const Value.absent(),
            Value<int?> bldDwellingRecs = const Value.absent(),
            Value<int?> bldEntranceRecs = const Value.absent(),
            Value<String?> bldAddressId = const Value.absent(),
            Value<String?> externalCreator = const Value.absent(),
            Value<String?> externalEditor = const Value.absent(),
            Value<int> bldReview = const Value.absent(),
            Value<int?> bldWaterSupply = const Value.absent(),
            Value<DateTime?> externalCreatorDate = const Value.absent(),
            Value<DateTime?> externalEditorDate = const Value.absent(),
          }) =>
              BuildingsCompanion.insert(
            objectId: objectId,
            shapeLength: shapeLength,
            shapeArea: shapeArea,
            globalId: globalId,
            bldCensus2023: bldCensus2023,
            bldQuality: bldQuality,
            bldMunicipality: bldMunicipality,
            bldEnumArea: bldEnumArea,
            bldLatitude: bldLatitude,
            bldLongitude: bldLongitude,
            bldCadastralZone: bldCadastralZone,
            bldProperty: bldProperty,
            bldPermitNumber: bldPermitNumber,
            bldPermitDate: bldPermitDate,
            bldStatus: bldStatus,
            bldYearConstruction: bldYearConstruction,
            bldYearDemolition: bldYearDemolition,
            bldType: bldType,
            bldClass: bldClass,
            bldArea: bldArea,
            bldFloorsAbove: bldFloorsAbove,
            bldHeight: bldHeight,
            bldVolume: bldVolume,
            bldWasteWater: bldWasteWater,
            bldElectricity: bldElectricity,
            bldPipedGas: bldPipedGas,
            bldElevator: bldElevator,
            createdUser: createdUser,
            createdDate: createdDate,
            lastEditedUser: lastEditedUser,
            lastEditedDate: lastEditedDate,
            bldCentroidStatus: bldCentroidStatus,
            bldDwellingRecs: bldDwellingRecs,
            bldEntranceRecs: bldEntranceRecs,
            bldAddressId: bldAddressId,
            externalCreator: externalCreator,
            externalEditor: externalEditor,
            bldReview: bldReview,
            bldWaterSupply: bldWaterSupply,
            externalCreatorDate: externalCreatorDate,
            externalEditorDate: externalEditorDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BuildingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BuildingsTable,
    Building,
    $$BuildingsTableFilterComposer,
    $$BuildingsTableOrderingComposer,
    $$BuildingsTableAnnotationComposer,
    $$BuildingsTableCreateCompanionBuilder,
    $$BuildingsTableUpdateCompanionBuilder,
    (Building, BaseReferences<_$AppDatabase, $BuildingsTable, Building>),
    Building,
    PrefetchHooks Function()>;
typedef $$EntrancesTableCreateCompanionBuilder = EntrancesCompanion Function({
  Value<int> objectId,
  Value<String?> entCensus2023,
  Value<DateTime?> externalCreatorDate,
  Value<DateTime?> externalEditorDate,
  required String globalId,
  Value<String> entBldGlobalId,
  Value<String?> entAddressId,
  Value<int> entQuality,
  required double entLatitude,
  required double entLongitude,
  Value<int> entPointStatus,
  Value<String?> entStrGlobalId,
  Value<String?> entBuildingNumber,
  Value<String?> entEntranceNumber,
  Value<int?> entTown,
  Value<int?> entZipCode,
  Value<int?> entDwellingRecs,
  Value<int?> entDwellingExpec,
  Value<String?> createdUser,
  Value<DateTime?> createdDate,
  Value<String?> lastEditedUser,
  Value<DateTime?> lastEditedDate,
  Value<String?> externalCreator,
  Value<String?> externalEditor,
});
typedef $$EntrancesTableUpdateCompanionBuilder = EntrancesCompanion Function({
  Value<int> objectId,
  Value<String?> entCensus2023,
  Value<DateTime?> externalCreatorDate,
  Value<DateTime?> externalEditorDate,
  Value<String> globalId,
  Value<String> entBldGlobalId,
  Value<String?> entAddressId,
  Value<int> entQuality,
  Value<double> entLatitude,
  Value<double> entLongitude,
  Value<int> entPointStatus,
  Value<String?> entStrGlobalId,
  Value<String?> entBuildingNumber,
  Value<String?> entEntranceNumber,
  Value<int?> entTown,
  Value<int?> entZipCode,
  Value<int?> entDwellingRecs,
  Value<int?> entDwellingExpec,
  Value<String?> createdUser,
  Value<DateTime?> createdDate,
  Value<String?> lastEditedUser,
  Value<DateTime?> lastEditedDate,
  Value<String?> externalCreator,
  Value<String?> externalEditor,
});

class $$EntrancesTableFilterComposer
    extends Composer<_$AppDatabase, $EntrancesTable> {
  $$EntrancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entCensus2023 => $composableBuilder(
      column: $table.entCensus2023, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get externalCreatorDate => $composableBuilder(
      column: $table.externalCreatorDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get externalEditorDate => $composableBuilder(
      column: $table.externalEditorDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entBldGlobalId => $composableBuilder(
      column: $table.entBldGlobalId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entAddressId => $composableBuilder(
      column: $table.entAddressId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entQuality => $composableBuilder(
      column: $table.entQuality, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get entLatitude => $composableBuilder(
      column: $table.entLatitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get entLongitude => $composableBuilder(
      column: $table.entLongitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entPointStatus => $composableBuilder(
      column: $table.entPointStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entStrGlobalId => $composableBuilder(
      column: $table.entStrGlobalId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entBuildingNumber => $composableBuilder(
      column: $table.entBuildingNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entEntranceNumber => $composableBuilder(
      column: $table.entEntranceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entTown => $composableBuilder(
      column: $table.entTown, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entZipCode => $composableBuilder(
      column: $table.entZipCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entDwellingRecs => $composableBuilder(
      column: $table.entDwellingRecs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entDwellingExpec => $composableBuilder(
      column: $table.entDwellingExpec,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdUser => $composableBuilder(
      column: $table.createdUser, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastEditedUser => $composableBuilder(
      column: $table.lastEditedUser,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastEditedDate => $composableBuilder(
      column: $table.lastEditedDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalCreator => $composableBuilder(
      column: $table.externalCreator,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalEditor => $composableBuilder(
      column: $table.externalEditor,
      builder: (column) => ColumnFilters(column));
}

class $$EntrancesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntrancesTable> {
  $$EntrancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entCensus2023 => $composableBuilder(
      column: $table.entCensus2023,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get externalCreatorDate => $composableBuilder(
      column: $table.externalCreatorDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get externalEditorDate => $composableBuilder(
      column: $table.externalEditorDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entBldGlobalId => $composableBuilder(
      column: $table.entBldGlobalId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entAddressId => $composableBuilder(
      column: $table.entAddressId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entQuality => $composableBuilder(
      column: $table.entQuality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get entLatitude => $composableBuilder(
      column: $table.entLatitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get entLongitude => $composableBuilder(
      column: $table.entLongitude,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entPointStatus => $composableBuilder(
      column: $table.entPointStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entStrGlobalId => $composableBuilder(
      column: $table.entStrGlobalId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entBuildingNumber => $composableBuilder(
      column: $table.entBuildingNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entEntranceNumber => $composableBuilder(
      column: $table.entEntranceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entTown => $composableBuilder(
      column: $table.entTown, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entZipCode => $composableBuilder(
      column: $table.entZipCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entDwellingRecs => $composableBuilder(
      column: $table.entDwellingRecs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entDwellingExpec => $composableBuilder(
      column: $table.entDwellingExpec,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdUser => $composableBuilder(
      column: $table.createdUser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastEditedUser => $composableBuilder(
      column: $table.lastEditedUser,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastEditedDate => $composableBuilder(
      column: $table.lastEditedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalCreator => $composableBuilder(
      column: $table.externalCreator,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalEditor => $composableBuilder(
      column: $table.externalEditor,
      builder: (column) => ColumnOrderings(column));
}

class $$EntrancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntrancesTable> {
  $$EntrancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get objectId =>
      $composableBuilder(column: $table.objectId, builder: (column) => column);

  GeneratedColumn<String> get entCensus2023 => $composableBuilder(
      column: $table.entCensus2023, builder: (column) => column);

  GeneratedColumn<DateTime> get externalCreatorDate => $composableBuilder(
      column: $table.externalCreatorDate, builder: (column) => column);

  GeneratedColumn<DateTime> get externalEditorDate => $composableBuilder(
      column: $table.externalEditorDate, builder: (column) => column);

  GeneratedColumn<String> get globalId =>
      $composableBuilder(column: $table.globalId, builder: (column) => column);

  GeneratedColumn<String> get entBldGlobalId => $composableBuilder(
      column: $table.entBldGlobalId, builder: (column) => column);

  GeneratedColumn<String> get entAddressId => $composableBuilder(
      column: $table.entAddressId, builder: (column) => column);

  GeneratedColumn<int> get entQuality => $composableBuilder(
      column: $table.entQuality, builder: (column) => column);

  GeneratedColumn<double> get entLatitude => $composableBuilder(
      column: $table.entLatitude, builder: (column) => column);

  GeneratedColumn<double> get entLongitude => $composableBuilder(
      column: $table.entLongitude, builder: (column) => column);

  GeneratedColumn<int> get entPointStatus => $composableBuilder(
      column: $table.entPointStatus, builder: (column) => column);

  GeneratedColumn<String> get entStrGlobalId => $composableBuilder(
      column: $table.entStrGlobalId, builder: (column) => column);

  GeneratedColumn<String> get entBuildingNumber => $composableBuilder(
      column: $table.entBuildingNumber, builder: (column) => column);

  GeneratedColumn<String> get entEntranceNumber => $composableBuilder(
      column: $table.entEntranceNumber, builder: (column) => column);

  GeneratedColumn<int> get entTown =>
      $composableBuilder(column: $table.entTown, builder: (column) => column);

  GeneratedColumn<int> get entZipCode => $composableBuilder(
      column: $table.entZipCode, builder: (column) => column);

  GeneratedColumn<int> get entDwellingRecs => $composableBuilder(
      column: $table.entDwellingRecs, builder: (column) => column);

  GeneratedColumn<int> get entDwellingExpec => $composableBuilder(
      column: $table.entDwellingExpec, builder: (column) => column);

  GeneratedColumn<String> get createdUser => $composableBuilder(
      column: $table.createdUser, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);

  GeneratedColumn<String> get lastEditedUser => $composableBuilder(
      column: $table.lastEditedUser, builder: (column) => column);

  GeneratedColumn<DateTime> get lastEditedDate => $composableBuilder(
      column: $table.lastEditedDate, builder: (column) => column);

  GeneratedColumn<String> get externalCreator => $composableBuilder(
      column: $table.externalCreator, builder: (column) => column);

  GeneratedColumn<String> get externalEditor => $composableBuilder(
      column: $table.externalEditor, builder: (column) => column);
}

class $$EntrancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntrancesTable,
    Entrance,
    $$EntrancesTableFilterComposer,
    $$EntrancesTableOrderingComposer,
    $$EntrancesTableAnnotationComposer,
    $$EntrancesTableCreateCompanionBuilder,
    $$EntrancesTableUpdateCompanionBuilder,
    (Entrance, BaseReferences<_$AppDatabase, $EntrancesTable, Entrance>),
    Entrance,
    PrefetchHooks Function()> {
  $$EntrancesTableTableManager(_$AppDatabase db, $EntrancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntrancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntrancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntrancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> objectId = const Value.absent(),
            Value<String?> entCensus2023 = const Value.absent(),
            Value<DateTime?> externalCreatorDate = const Value.absent(),
            Value<DateTime?> externalEditorDate = const Value.absent(),
            Value<String> globalId = const Value.absent(),
            Value<String> entBldGlobalId = const Value.absent(),
            Value<String?> entAddressId = const Value.absent(),
            Value<int> entQuality = const Value.absent(),
            Value<double> entLatitude = const Value.absent(),
            Value<double> entLongitude = const Value.absent(),
            Value<int> entPointStatus = const Value.absent(),
            Value<String?> entStrGlobalId = const Value.absent(),
            Value<String?> entBuildingNumber = const Value.absent(),
            Value<String?> entEntranceNumber = const Value.absent(),
            Value<int?> entTown = const Value.absent(),
            Value<int?> entZipCode = const Value.absent(),
            Value<int?> entDwellingRecs = const Value.absent(),
            Value<int?> entDwellingExpec = const Value.absent(),
            Value<String?> createdUser = const Value.absent(),
            Value<DateTime?> createdDate = const Value.absent(),
            Value<String?> lastEditedUser = const Value.absent(),
            Value<DateTime?> lastEditedDate = const Value.absent(),
            Value<String?> externalCreator = const Value.absent(),
            Value<String?> externalEditor = const Value.absent(),
          }) =>
              EntrancesCompanion(
            objectId: objectId,
            entCensus2023: entCensus2023,
            externalCreatorDate: externalCreatorDate,
            externalEditorDate: externalEditorDate,
            globalId: globalId,
            entBldGlobalId: entBldGlobalId,
            entAddressId: entAddressId,
            entQuality: entQuality,
            entLatitude: entLatitude,
            entLongitude: entLongitude,
            entPointStatus: entPointStatus,
            entStrGlobalId: entStrGlobalId,
            entBuildingNumber: entBuildingNumber,
            entEntranceNumber: entEntranceNumber,
            entTown: entTown,
            entZipCode: entZipCode,
            entDwellingRecs: entDwellingRecs,
            entDwellingExpec: entDwellingExpec,
            createdUser: createdUser,
            createdDate: createdDate,
            lastEditedUser: lastEditedUser,
            lastEditedDate: lastEditedDate,
            externalCreator: externalCreator,
            externalEditor: externalEditor,
          ),
          createCompanionCallback: ({
            Value<int> objectId = const Value.absent(),
            Value<String?> entCensus2023 = const Value.absent(),
            Value<DateTime?> externalCreatorDate = const Value.absent(),
            Value<DateTime?> externalEditorDate = const Value.absent(),
            required String globalId,
            Value<String> entBldGlobalId = const Value.absent(),
            Value<String?> entAddressId = const Value.absent(),
            Value<int> entQuality = const Value.absent(),
            required double entLatitude,
            required double entLongitude,
            Value<int> entPointStatus = const Value.absent(),
            Value<String?> entStrGlobalId = const Value.absent(),
            Value<String?> entBuildingNumber = const Value.absent(),
            Value<String?> entEntranceNumber = const Value.absent(),
            Value<int?> entTown = const Value.absent(),
            Value<int?> entZipCode = const Value.absent(),
            Value<int?> entDwellingRecs = const Value.absent(),
            Value<int?> entDwellingExpec = const Value.absent(),
            Value<String?> createdUser = const Value.absent(),
            Value<DateTime?> createdDate = const Value.absent(),
            Value<String?> lastEditedUser = const Value.absent(),
            Value<DateTime?> lastEditedDate = const Value.absent(),
            Value<String?> externalCreator = const Value.absent(),
            Value<String?> externalEditor = const Value.absent(),
          }) =>
              EntrancesCompanion.insert(
            objectId: objectId,
            entCensus2023: entCensus2023,
            externalCreatorDate: externalCreatorDate,
            externalEditorDate: externalEditorDate,
            globalId: globalId,
            entBldGlobalId: entBldGlobalId,
            entAddressId: entAddressId,
            entQuality: entQuality,
            entLatitude: entLatitude,
            entLongitude: entLongitude,
            entPointStatus: entPointStatus,
            entStrGlobalId: entStrGlobalId,
            entBuildingNumber: entBuildingNumber,
            entEntranceNumber: entEntranceNumber,
            entTown: entTown,
            entZipCode: entZipCode,
            entDwellingRecs: entDwellingRecs,
            entDwellingExpec: entDwellingExpec,
            createdUser: createdUser,
            createdDate: createdDate,
            lastEditedUser: lastEditedUser,
            lastEditedDate: lastEditedDate,
            externalCreator: externalCreator,
            externalEditor: externalEditor,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EntrancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntrancesTable,
    Entrance,
    $$EntrancesTableFilterComposer,
    $$EntrancesTableOrderingComposer,
    $$EntrancesTableAnnotationComposer,
    $$EntrancesTableCreateCompanionBuilder,
    $$EntrancesTableUpdateCompanionBuilder,
    (Entrance, BaseReferences<_$AppDatabase, $EntrancesTable, Entrance>),
    Entrance,
    PrefetchHooks Function()>;
typedef $$DwellingsTableCreateCompanionBuilder = DwellingsCompanion Function({
  Value<int> objectId,
  Value<DateTime?> externalCreatorDate,
  Value<DateTime?> externalEditorDate,
  required String globalId,
  Value<String> dwlEntGlobalId,
  Value<String?> dwlCensus2023,
  Value<String?> dwlAddressId,
  Value<int> dwlQuality,
  Value<int?> dwlFloor,
  Value<String?> dwlApartNumber,
  Value<int> dwlStatus,
  Value<int?> dwlYearConstruction,
  Value<int?> dwlYearElimination,
  Value<int?> dwlType,
  Value<int?> dwlOwnership,
  Value<int?> dwlOccupancy,
  Value<int?> dwlSurface,
  Value<int?> dwlToilet,
  Value<int?> dwlBath,
  Value<int?> dwlHeatingFacility,
  Value<int?> dwlHeatingEnergy,
  Value<int?> dwlAirConditioner,
  Value<int?> dwlSolarPanel,
  Value<String?> createdUser,
  Value<DateTime?> createdDate,
  Value<String?> lastEditedUser,
  Value<DateTime?> lastEditedDate,
  Value<String?> externalCreator,
  Value<String?> externalEditor,
});
typedef $$DwellingsTableUpdateCompanionBuilder = DwellingsCompanion Function({
  Value<int> objectId,
  Value<DateTime?> externalCreatorDate,
  Value<DateTime?> externalEditorDate,
  Value<String> globalId,
  Value<String> dwlEntGlobalId,
  Value<String?> dwlCensus2023,
  Value<String?> dwlAddressId,
  Value<int> dwlQuality,
  Value<int?> dwlFloor,
  Value<String?> dwlApartNumber,
  Value<int> dwlStatus,
  Value<int?> dwlYearConstruction,
  Value<int?> dwlYearElimination,
  Value<int?> dwlType,
  Value<int?> dwlOwnership,
  Value<int?> dwlOccupancy,
  Value<int?> dwlSurface,
  Value<int?> dwlToilet,
  Value<int?> dwlBath,
  Value<int?> dwlHeatingFacility,
  Value<int?> dwlHeatingEnergy,
  Value<int?> dwlAirConditioner,
  Value<int?> dwlSolarPanel,
  Value<String?> createdUser,
  Value<DateTime?> createdDate,
  Value<String?> lastEditedUser,
  Value<DateTime?> lastEditedDate,
  Value<String?> externalCreator,
  Value<String?> externalEditor,
});

class $$DwellingsTableFilterComposer
    extends Composer<_$AppDatabase, $DwellingsTable> {
  $$DwellingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get externalCreatorDate => $composableBuilder(
      column: $table.externalCreatorDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get externalEditorDate => $composableBuilder(
      column: $table.externalEditorDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dwlEntGlobalId => $composableBuilder(
      column: $table.dwlEntGlobalId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dwlCensus2023 => $composableBuilder(
      column: $table.dwlCensus2023, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dwlAddressId => $composableBuilder(
      column: $table.dwlAddressId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlQuality => $composableBuilder(
      column: $table.dwlQuality, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlFloor => $composableBuilder(
      column: $table.dwlFloor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dwlApartNumber => $composableBuilder(
      column: $table.dwlApartNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlStatus => $composableBuilder(
      column: $table.dwlStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlYearConstruction => $composableBuilder(
      column: $table.dwlYearConstruction,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlYearElimination => $composableBuilder(
      column: $table.dwlYearElimination,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlType => $composableBuilder(
      column: $table.dwlType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlOwnership => $composableBuilder(
      column: $table.dwlOwnership, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlOccupancy => $composableBuilder(
      column: $table.dwlOccupancy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlSurface => $composableBuilder(
      column: $table.dwlSurface, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlToilet => $composableBuilder(
      column: $table.dwlToilet, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlBath => $composableBuilder(
      column: $table.dwlBath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlHeatingFacility => $composableBuilder(
      column: $table.dwlHeatingFacility,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlHeatingEnergy => $composableBuilder(
      column: $table.dwlHeatingEnergy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlAirConditioner => $composableBuilder(
      column: $table.dwlAirConditioner,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dwlSolarPanel => $composableBuilder(
      column: $table.dwlSolarPanel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdUser => $composableBuilder(
      column: $table.createdUser, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastEditedUser => $composableBuilder(
      column: $table.lastEditedUser,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastEditedDate => $composableBuilder(
      column: $table.lastEditedDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalCreator => $composableBuilder(
      column: $table.externalCreator,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalEditor => $composableBuilder(
      column: $table.externalEditor,
      builder: (column) => ColumnFilters(column));
}

class $$DwellingsTableOrderingComposer
    extends Composer<_$AppDatabase, $DwellingsTable> {
  $$DwellingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get externalCreatorDate => $composableBuilder(
      column: $table.externalCreatorDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get externalEditorDate => $composableBuilder(
      column: $table.externalEditorDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dwlEntGlobalId => $composableBuilder(
      column: $table.dwlEntGlobalId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dwlCensus2023 => $composableBuilder(
      column: $table.dwlCensus2023,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dwlAddressId => $composableBuilder(
      column: $table.dwlAddressId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlQuality => $composableBuilder(
      column: $table.dwlQuality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlFloor => $composableBuilder(
      column: $table.dwlFloor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dwlApartNumber => $composableBuilder(
      column: $table.dwlApartNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlStatus => $composableBuilder(
      column: $table.dwlStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlYearConstruction => $composableBuilder(
      column: $table.dwlYearConstruction,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlYearElimination => $composableBuilder(
      column: $table.dwlYearElimination,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlType => $composableBuilder(
      column: $table.dwlType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlOwnership => $composableBuilder(
      column: $table.dwlOwnership,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlOccupancy => $composableBuilder(
      column: $table.dwlOccupancy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlSurface => $composableBuilder(
      column: $table.dwlSurface, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlToilet => $composableBuilder(
      column: $table.dwlToilet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlBath => $composableBuilder(
      column: $table.dwlBath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlHeatingFacility => $composableBuilder(
      column: $table.dwlHeatingFacility,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlHeatingEnergy => $composableBuilder(
      column: $table.dwlHeatingEnergy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlAirConditioner => $composableBuilder(
      column: $table.dwlAirConditioner,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dwlSolarPanel => $composableBuilder(
      column: $table.dwlSolarPanel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdUser => $composableBuilder(
      column: $table.createdUser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastEditedUser => $composableBuilder(
      column: $table.lastEditedUser,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastEditedDate => $composableBuilder(
      column: $table.lastEditedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalCreator => $composableBuilder(
      column: $table.externalCreator,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalEditor => $composableBuilder(
      column: $table.externalEditor,
      builder: (column) => ColumnOrderings(column));
}

class $$DwellingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DwellingsTable> {
  $$DwellingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get objectId =>
      $composableBuilder(column: $table.objectId, builder: (column) => column);

  GeneratedColumn<DateTime> get externalCreatorDate => $composableBuilder(
      column: $table.externalCreatorDate, builder: (column) => column);

  GeneratedColumn<DateTime> get externalEditorDate => $composableBuilder(
      column: $table.externalEditorDate, builder: (column) => column);

  GeneratedColumn<String> get globalId =>
      $composableBuilder(column: $table.globalId, builder: (column) => column);

  GeneratedColumn<String> get dwlEntGlobalId => $composableBuilder(
      column: $table.dwlEntGlobalId, builder: (column) => column);

  GeneratedColumn<String> get dwlCensus2023 => $composableBuilder(
      column: $table.dwlCensus2023, builder: (column) => column);

  GeneratedColumn<String> get dwlAddressId => $composableBuilder(
      column: $table.dwlAddressId, builder: (column) => column);

  GeneratedColumn<int> get dwlQuality => $composableBuilder(
      column: $table.dwlQuality, builder: (column) => column);

  GeneratedColumn<int> get dwlFloor =>
      $composableBuilder(column: $table.dwlFloor, builder: (column) => column);

  GeneratedColumn<String> get dwlApartNumber => $composableBuilder(
      column: $table.dwlApartNumber, builder: (column) => column);

  GeneratedColumn<int> get dwlStatus =>
      $composableBuilder(column: $table.dwlStatus, builder: (column) => column);

  GeneratedColumn<int> get dwlYearConstruction => $composableBuilder(
      column: $table.dwlYearConstruction, builder: (column) => column);

  GeneratedColumn<int> get dwlYearElimination => $composableBuilder(
      column: $table.dwlYearElimination, builder: (column) => column);

  GeneratedColumn<int> get dwlType =>
      $composableBuilder(column: $table.dwlType, builder: (column) => column);

  GeneratedColumn<int> get dwlOwnership => $composableBuilder(
      column: $table.dwlOwnership, builder: (column) => column);

  GeneratedColumn<int> get dwlOccupancy => $composableBuilder(
      column: $table.dwlOccupancy, builder: (column) => column);

  GeneratedColumn<int> get dwlSurface => $composableBuilder(
      column: $table.dwlSurface, builder: (column) => column);

  GeneratedColumn<int> get dwlToilet =>
      $composableBuilder(column: $table.dwlToilet, builder: (column) => column);

  GeneratedColumn<int> get dwlBath =>
      $composableBuilder(column: $table.dwlBath, builder: (column) => column);

  GeneratedColumn<int> get dwlHeatingFacility => $composableBuilder(
      column: $table.dwlHeatingFacility, builder: (column) => column);

  GeneratedColumn<int> get dwlHeatingEnergy => $composableBuilder(
      column: $table.dwlHeatingEnergy, builder: (column) => column);

  GeneratedColumn<int> get dwlAirConditioner => $composableBuilder(
      column: $table.dwlAirConditioner, builder: (column) => column);

  GeneratedColumn<int> get dwlSolarPanel => $composableBuilder(
      column: $table.dwlSolarPanel, builder: (column) => column);

  GeneratedColumn<String> get createdUser => $composableBuilder(
      column: $table.createdUser, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);

  GeneratedColumn<String> get lastEditedUser => $composableBuilder(
      column: $table.lastEditedUser, builder: (column) => column);

  GeneratedColumn<DateTime> get lastEditedDate => $composableBuilder(
      column: $table.lastEditedDate, builder: (column) => column);

  GeneratedColumn<String> get externalCreator => $composableBuilder(
      column: $table.externalCreator, builder: (column) => column);

  GeneratedColumn<String> get externalEditor => $composableBuilder(
      column: $table.externalEditor, builder: (column) => column);
}

class $$DwellingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DwellingsTable,
    Dwelling,
    $$DwellingsTableFilterComposer,
    $$DwellingsTableOrderingComposer,
    $$DwellingsTableAnnotationComposer,
    $$DwellingsTableCreateCompanionBuilder,
    $$DwellingsTableUpdateCompanionBuilder,
    (Dwelling, BaseReferences<_$AppDatabase, $DwellingsTable, Dwelling>),
    Dwelling,
    PrefetchHooks Function()> {
  $$DwellingsTableTableManager(_$AppDatabase db, $DwellingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DwellingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DwellingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DwellingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> objectId = const Value.absent(),
            Value<DateTime?> externalCreatorDate = const Value.absent(),
            Value<DateTime?> externalEditorDate = const Value.absent(),
            Value<String> globalId = const Value.absent(),
            Value<String> dwlEntGlobalId = const Value.absent(),
            Value<String?> dwlCensus2023 = const Value.absent(),
            Value<String?> dwlAddressId = const Value.absent(),
            Value<int> dwlQuality = const Value.absent(),
            Value<int?> dwlFloor = const Value.absent(),
            Value<String?> dwlApartNumber = const Value.absent(),
            Value<int> dwlStatus = const Value.absent(),
            Value<int?> dwlYearConstruction = const Value.absent(),
            Value<int?> dwlYearElimination = const Value.absent(),
            Value<int?> dwlType = const Value.absent(),
            Value<int?> dwlOwnership = const Value.absent(),
            Value<int?> dwlOccupancy = const Value.absent(),
            Value<int?> dwlSurface = const Value.absent(),
            Value<int?> dwlToilet = const Value.absent(),
            Value<int?> dwlBath = const Value.absent(),
            Value<int?> dwlHeatingFacility = const Value.absent(),
            Value<int?> dwlHeatingEnergy = const Value.absent(),
            Value<int?> dwlAirConditioner = const Value.absent(),
            Value<int?> dwlSolarPanel = const Value.absent(),
            Value<String?> createdUser = const Value.absent(),
            Value<DateTime?> createdDate = const Value.absent(),
            Value<String?> lastEditedUser = const Value.absent(),
            Value<DateTime?> lastEditedDate = const Value.absent(),
            Value<String?> externalCreator = const Value.absent(),
            Value<String?> externalEditor = const Value.absent(),
          }) =>
              DwellingsCompanion(
            objectId: objectId,
            externalCreatorDate: externalCreatorDate,
            externalEditorDate: externalEditorDate,
            globalId: globalId,
            dwlEntGlobalId: dwlEntGlobalId,
            dwlCensus2023: dwlCensus2023,
            dwlAddressId: dwlAddressId,
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
            createdUser: createdUser,
            createdDate: createdDate,
            lastEditedUser: lastEditedUser,
            lastEditedDate: lastEditedDate,
            externalCreator: externalCreator,
            externalEditor: externalEditor,
          ),
          createCompanionCallback: ({
            Value<int> objectId = const Value.absent(),
            Value<DateTime?> externalCreatorDate = const Value.absent(),
            Value<DateTime?> externalEditorDate = const Value.absent(),
            required String globalId,
            Value<String> dwlEntGlobalId = const Value.absent(),
            Value<String?> dwlCensus2023 = const Value.absent(),
            Value<String?> dwlAddressId = const Value.absent(),
            Value<int> dwlQuality = const Value.absent(),
            Value<int?> dwlFloor = const Value.absent(),
            Value<String?> dwlApartNumber = const Value.absent(),
            Value<int> dwlStatus = const Value.absent(),
            Value<int?> dwlYearConstruction = const Value.absent(),
            Value<int?> dwlYearElimination = const Value.absent(),
            Value<int?> dwlType = const Value.absent(),
            Value<int?> dwlOwnership = const Value.absent(),
            Value<int?> dwlOccupancy = const Value.absent(),
            Value<int?> dwlSurface = const Value.absent(),
            Value<int?> dwlToilet = const Value.absent(),
            Value<int?> dwlBath = const Value.absent(),
            Value<int?> dwlHeatingFacility = const Value.absent(),
            Value<int?> dwlHeatingEnergy = const Value.absent(),
            Value<int?> dwlAirConditioner = const Value.absent(),
            Value<int?> dwlSolarPanel = const Value.absent(),
            Value<String?> createdUser = const Value.absent(),
            Value<DateTime?> createdDate = const Value.absent(),
            Value<String?> lastEditedUser = const Value.absent(),
            Value<DateTime?> lastEditedDate = const Value.absent(),
            Value<String?> externalCreator = const Value.absent(),
            Value<String?> externalEditor = const Value.absent(),
          }) =>
              DwellingsCompanion.insert(
            objectId: objectId,
            externalCreatorDate: externalCreatorDate,
            externalEditorDate: externalEditorDate,
            globalId: globalId,
            dwlEntGlobalId: dwlEntGlobalId,
            dwlCensus2023: dwlCensus2023,
            dwlAddressId: dwlAddressId,
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
            createdUser: createdUser,
            createdDate: createdDate,
            lastEditedUser: lastEditedUser,
            lastEditedDate: lastEditedDate,
            externalCreator: externalCreator,
            externalEditor: externalEditor,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DwellingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DwellingsTable,
    Dwelling,
    $$DwellingsTableFilterComposer,
    $$DwellingsTableOrderingComposer,
    $$DwellingsTableAnnotationComposer,
    $$DwellingsTableCreateCompanionBuilder,
    $$DwellingsTableUpdateCompanionBuilder,
    (Dwelling, BaseReferences<_$AppDatabase, $DwellingsTable, Dwelling>),
    Dwelling,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BuildingsTableTableManager get buildings =>
      $$BuildingsTableTableManager(_db, _db.buildings);
  $$EntrancesTableTableManager get entrances =>
      $$EntrancesTableTableManager(_db, _db.entrances);
  $$DwellingsTableTableManager get dwellings =>
      $$DwellingsTableTableManager(_db, _db.dwellings);
}
