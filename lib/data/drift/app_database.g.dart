// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DownloadsTable extends Downloads
    with TableInfo<$DownloadsTable, Download> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, createdDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloads';
  @override
  VerificationContext validateIntegrity(Insertable<Download> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Download map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Download(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
    );
  }

  @override
  $DownloadsTable createAlias(String alias) {
    return $DownloadsTable(attachedDatabase, alias);
  }
}

class Download extends DataClass implements Insertable<Download> {
  final int id;
  final DateTime createdDate;
  const Download({required this.id, required this.createdDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  DownloadsCompanion toCompanion(bool nullToAbsent) {
    return DownloadsCompanion(
      id: Value(id),
      createdDate: Value(createdDate),
    );
  }

  factory Download.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Download(
      id: serializer.fromJson<int>(json['id']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  Download copyWith({int? id, DateTime? createdDate}) => Download(
        id: id ?? this.id,
        createdDate: createdDate ?? this.createdDate,
      );
  Download copyWithCompanion(DownloadsCompanion data) {
    return Download(
      id: data.id.present ? data.id.value : this.id,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Download(')
          ..write('id: $id, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Download &&
          other.id == this.id &&
          other.createdDate == this.createdDate);
}

class DownloadsCompanion extends UpdateCompanion<Download> {
  final Value<int> id;
  final Value<DateTime> createdDate;
  const DownloadsCompanion({
    this.id = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  DownloadsCompanion.insert({
    this.id = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  static Insertable<Download> custom({
    Expression<int>? id,
    Expression<DateTime>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  DownloadsCompanion copyWith({Value<int>? id, Value<DateTime>? createdDate}) {
    return DownloadsCompanion(
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadsCompanion(')
          ..write('id: $id, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $BuildingsTable extends Buildings
    with TableInfo<$BuildingsTable, Building> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuildingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _objectIdMeta =
      const VerificationMeta('objectId');
  @override
  late final GeneratedColumn<int> objectId = GeneratedColumn<int>(
      'object_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _downloadIdMeta =
      const VerificationMeta('downloadId');
  @override
  late final GeneratedColumn<int> downloadId = GeneratedColumn<int>(
      'download_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES downloads (id)'));
  static const VerificationMeta _globalIdMeta =
      const VerificationMeta('globalId');
  @override
  late final GeneratedColumn<String> globalId = GeneratedColumn<String>(
      'global_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _bldAddressIDMeta =
      const VerificationMeta('bldAddressID');
  @override
  late final GeneratedColumn<String> bldAddressID = GeneratedColumn<String>(
      'bld_address_id', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 38),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _bldQualityMeta =
      const VerificationMeta('bldQuality');
  @override
  late final GeneratedColumn<int> bldQuality = GeneratedColumn<int>(
      'bld_quality', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _bldMunicipalityMeta =
      const VerificationMeta('bldMunicipality');
  @override
  late final GeneratedColumn<int> bldMunicipality = GeneratedColumn<int>(
      'bld_municipality', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
      'bld_latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _bldLongitudeMeta =
      const VerificationMeta('bldLongitude');
  @override
  late final GeneratedColumn<double> bldLongitude = GeneratedColumn<double>(
      'bld_longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
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
      'bld_status', aliasedName, true,
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
  static const VerificationMeta _bldCensus2023Meta =
      const VerificationMeta('bldCensus2023');
  @override
  late final GeneratedColumn<String> bldCensus2023 = GeneratedColumn<String>(
      'bld_census_2023', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bldAreaMeta =
      const VerificationMeta('bldArea');
  @override
  late final GeneratedColumn<double> bldArea = GeneratedColumn<double>(
      'bld_area', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
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
  static const VerificationMeta _bldFloorsAboveMeta =
      const VerificationMeta('bldFloorsAbove');
  @override
  late final GeneratedColumn<int> bldFloorsAbove = GeneratedColumn<int>(
      'bld_floors_above', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bldHeightMeta =
      const VerificationMeta('bldHeight');
  @override
  late final GeneratedColumn<double> bldHeight = GeneratedColumn<double>(
      'bld_height', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
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
      'bld_centroid_status', aliasedName, true,
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
      'bld_review', aliasedName, true,
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
  static const VerificationMeta _geometryTypeMeta =
      const VerificationMeta('geometryType');
  @override
  late final GeneratedColumn<String> geometryType = GeneratedColumn<String>(
      'geometry_type', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _coordinatesMeta =
      const VerificationMeta('coordinates');
  @override
  late final GeneratedColumn<String> coordinates = GeneratedColumn<String>(
      'coordinates', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        objectId,
        downloadId,
        globalId,
        bldAddressID,
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
        bldCensus2023,
        bldArea,
        shapeLength,
        shapeArea,
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
        externalCreator,
        externalEditor,
        bldReview,
        bldWaterSupply,
        externalCreatorDate,
        externalEditorDate,
        geometryType,
        coordinates
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('object_id')) {
      context.handle(_objectIdMeta,
          objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta));
    } else if (isInserting) {
      context.missing(_objectIdMeta);
    }
    if (data.containsKey('download_id')) {
      context.handle(
          _downloadIdMeta,
          downloadId.isAcceptableOrUnknown(
              data['download_id']!, _downloadIdMeta));
    } else if (isInserting) {
      context.missing(_downloadIdMeta);
    }
    if (data.containsKey('global_id')) {
      context.handle(_globalIdMeta,
          globalId.isAcceptableOrUnknown(data['global_id']!, _globalIdMeta));
    } else if (isInserting) {
      context.missing(_globalIdMeta);
    }
    if (data.containsKey('bld_address_id')) {
      context.handle(
          _bldAddressIDMeta,
          bldAddressID.isAcceptableOrUnknown(
              data['bld_address_id']!, _bldAddressIDMeta));
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
    }
    if (data.containsKey('bld_longitude')) {
      context.handle(
          _bldLongitudeMeta,
          bldLongitude.isAcceptableOrUnknown(
              data['bld_longitude']!, _bldLongitudeMeta));
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
    if (data.containsKey('bld_census_2023')) {
      context.handle(
          _bldCensus2023Meta,
          bldCensus2023.isAcceptableOrUnknown(
              data['bld_census_2023']!, _bldCensus2023Meta));
    }
    if (data.containsKey('bld_area')) {
      context.handle(_bldAreaMeta,
          bldArea.isAcceptableOrUnknown(data['bld_area']!, _bldAreaMeta));
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
    if (data.containsKey('geometry_type')) {
      context.handle(
          _geometryTypeMeta,
          geometryType.isAcceptableOrUnknown(
              data['geometry_type']!, _geometryTypeMeta));
    }
    if (data.containsKey('coordinates')) {
      context.handle(
          _coordinatesMeta,
          coordinates.isAcceptableOrUnknown(
              data['coordinates']!, _coordinatesMeta));
    } else if (isInserting) {
      context.missing(_coordinatesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Building map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Building(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      objectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_id'])!,
      downloadId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}download_id'])!,
      globalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}global_id'])!,
      bldAddressID: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bld_address_id']),
      bldQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_quality']),
      bldMunicipality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_municipality']),
      bldEnumArea: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bld_enum_area']),
      bldLatitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bld_latitude']),
      bldLongitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bld_longitude']),
      bldCadastralZone: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_cadastral_zone']),
      bldProperty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bld_property']),
      bldPermitNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}bld_permit_number']),
      bldPermitDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}bld_permit_date']),
      bldStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_status']),
      bldYearConstruction: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}bld_year_construction']),
      bldYearDemolition: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}bld_year_demolition']),
      bldType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_type']),
      bldClass: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_class']),
      bldCensus2023: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bld_census_2023']),
      bldArea: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bld_area']),
      shapeLength: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shape_length']),
      shapeArea: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shape_area']),
      bldFloorsAbove: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_floors_above']),
      bldHeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bld_height']),
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
          DriftSqlType.int, data['${effectivePrefix}bld_centroid_status']),
      bldDwellingRecs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_dwelling_recs']),
      bldEntranceRecs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_entrance_recs']),
      externalCreator: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}external_creator']),
      externalEditor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_editor']),
      bldReview: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_review']),
      bldWaterSupply: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bld_water_supply']),
      externalCreatorDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}external_creator_date']),
      externalEditorDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}external_editor_date']),
      geometryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}geometry_type']),
      coordinates: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coordinates'])!,
    );
  }

  @override
  $BuildingsTable createAlias(String alias) {
    return $BuildingsTable(attachedDatabase, alias);
  }
}

class Building extends DataClass implements Insertable<Building> {
  final int id;
  final int objectId;
  final int downloadId;
  final String globalId;
  final String? bldAddressID;
  final int? bldQuality;
  final int? bldMunicipality;
  final String? bldEnumArea;
  final double? bldLatitude;
  final double? bldLongitude;
  final int? bldCadastralZone;
  final String? bldProperty;
  final String? bldPermitNumber;
  final DateTime? bldPermitDate;
  final int? bldStatus;
  final int? bldYearConstruction;
  final int? bldYearDemolition;
  final int? bldType;
  final int? bldClass;
  final String? bldCensus2023;
  final double? bldArea;
  final double? shapeLength;
  final double? shapeArea;
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
  final int? bldCentroidStatus;
  final int? bldDwellingRecs;
  final int? bldEntranceRecs;
  final String? externalCreator;
  final String? externalEditor;
  final int? bldReview;
  final int? bldWaterSupply;
  final DateTime? externalCreatorDate;
  final DateTime? externalEditorDate;
  final String? geometryType;
  final String coordinates;
  const Building(
      {required this.id,
      required this.objectId,
      required this.downloadId,
      required this.globalId,
      this.bldAddressID,
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
      this.bldCensus2023,
      this.bldArea,
      this.shapeLength,
      this.shapeArea,
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
      this.externalCreator,
      this.externalEditor,
      this.bldReview,
      this.bldWaterSupply,
      this.externalCreatorDate,
      this.externalEditorDate,
      this.geometryType,
      required this.coordinates});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['object_id'] = Variable<int>(objectId);
    map['download_id'] = Variable<int>(downloadId);
    map['global_id'] = Variable<String>(globalId);
    if (!nullToAbsent || bldAddressID != null) {
      map['bld_address_id'] = Variable<String>(bldAddressID);
    }
    if (!nullToAbsent || bldQuality != null) {
      map['bld_quality'] = Variable<int>(bldQuality);
    }
    if (!nullToAbsent || bldMunicipality != null) {
      map['bld_municipality'] = Variable<int>(bldMunicipality);
    }
    if (!nullToAbsent || bldEnumArea != null) {
      map['bld_enum_area'] = Variable<String>(bldEnumArea);
    }
    if (!nullToAbsent || bldLatitude != null) {
      map['bld_latitude'] = Variable<double>(bldLatitude);
    }
    if (!nullToAbsent || bldLongitude != null) {
      map['bld_longitude'] = Variable<double>(bldLongitude);
    }
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
    if (!nullToAbsent || bldStatus != null) {
      map['bld_status'] = Variable<int>(bldStatus);
    }
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
    if (!nullToAbsent || bldCensus2023 != null) {
      map['bld_census_2023'] = Variable<String>(bldCensus2023);
    }
    if (!nullToAbsent || bldArea != null) {
      map['bld_area'] = Variable<double>(bldArea);
    }
    if (!nullToAbsent || shapeLength != null) {
      map['shape_length'] = Variable<double>(shapeLength);
    }
    if (!nullToAbsent || shapeArea != null) {
      map['shape_area'] = Variable<double>(shapeArea);
    }
    if (!nullToAbsent || bldFloorsAbove != null) {
      map['bld_floors_above'] = Variable<int>(bldFloorsAbove);
    }
    if (!nullToAbsent || bldHeight != null) {
      map['bld_height'] = Variable<double>(bldHeight);
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
    if (!nullToAbsent || bldCentroidStatus != null) {
      map['bld_centroid_status'] = Variable<int>(bldCentroidStatus);
    }
    if (!nullToAbsent || bldDwellingRecs != null) {
      map['bld_dwelling_recs'] = Variable<int>(bldDwellingRecs);
    }
    if (!nullToAbsent || bldEntranceRecs != null) {
      map['bld_entrance_recs'] = Variable<int>(bldEntranceRecs);
    }
    if (!nullToAbsent || externalCreator != null) {
      map['external_creator'] = Variable<String>(externalCreator);
    }
    if (!nullToAbsent || externalEditor != null) {
      map['external_editor'] = Variable<String>(externalEditor);
    }
    if (!nullToAbsent || bldReview != null) {
      map['bld_review'] = Variable<int>(bldReview);
    }
    if (!nullToAbsent || bldWaterSupply != null) {
      map['bld_water_supply'] = Variable<int>(bldWaterSupply);
    }
    if (!nullToAbsent || externalCreatorDate != null) {
      map['external_creator_date'] = Variable<DateTime>(externalCreatorDate);
    }
    if (!nullToAbsent || externalEditorDate != null) {
      map['external_editor_date'] = Variable<DateTime>(externalEditorDate);
    }
    if (!nullToAbsent || geometryType != null) {
      map['geometry_type'] = Variable<String>(geometryType);
    }
    map['coordinates'] = Variable<String>(coordinates);
    return map;
  }

  BuildingsCompanion toCompanion(bool nullToAbsent) {
    return BuildingsCompanion(
      id: Value(id),
      objectId: Value(objectId),
      downloadId: Value(downloadId),
      globalId: Value(globalId),
      bldAddressID: bldAddressID == null && nullToAbsent
          ? const Value.absent()
          : Value(bldAddressID),
      bldQuality: bldQuality == null && nullToAbsent
          ? const Value.absent()
          : Value(bldQuality),
      bldMunicipality: bldMunicipality == null && nullToAbsent
          ? const Value.absent()
          : Value(bldMunicipality),
      bldEnumArea: bldEnumArea == null && nullToAbsent
          ? const Value.absent()
          : Value(bldEnumArea),
      bldLatitude: bldLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(bldLatitude),
      bldLongitude: bldLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(bldLongitude),
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
      bldStatus: bldStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(bldStatus),
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
      bldCensus2023: bldCensus2023 == null && nullToAbsent
          ? const Value.absent()
          : Value(bldCensus2023),
      bldArea: bldArea == null && nullToAbsent
          ? const Value.absent()
          : Value(bldArea),
      shapeLength: shapeLength == null && nullToAbsent
          ? const Value.absent()
          : Value(shapeLength),
      shapeArea: shapeArea == null && nullToAbsent
          ? const Value.absent()
          : Value(shapeArea),
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
      bldCentroidStatus: bldCentroidStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(bldCentroidStatus),
      bldDwellingRecs: bldDwellingRecs == null && nullToAbsent
          ? const Value.absent()
          : Value(bldDwellingRecs),
      bldEntranceRecs: bldEntranceRecs == null && nullToAbsent
          ? const Value.absent()
          : Value(bldEntranceRecs),
      externalCreator: externalCreator == null && nullToAbsent
          ? const Value.absent()
          : Value(externalCreator),
      externalEditor: externalEditor == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEditor),
      bldReview: bldReview == null && nullToAbsent
          ? const Value.absent()
          : Value(bldReview),
      bldWaterSupply: bldWaterSupply == null && nullToAbsent
          ? const Value.absent()
          : Value(bldWaterSupply),
      externalCreatorDate: externalCreatorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(externalCreatorDate),
      externalEditorDate: externalEditorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEditorDate),
      geometryType: geometryType == null && nullToAbsent
          ? const Value.absent()
          : Value(geometryType),
      coordinates: Value(coordinates),
    );
  }

  factory Building.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Building(
      id: serializer.fromJson<int>(json['id']),
      objectId: serializer.fromJson<int>(json['objectId']),
      downloadId: serializer.fromJson<int>(json['downloadId']),
      globalId: serializer.fromJson<String>(json['globalId']),
      bldAddressID: serializer.fromJson<String?>(json['bldAddressID']),
      bldQuality: serializer.fromJson<int?>(json['bldQuality']),
      bldMunicipality: serializer.fromJson<int?>(json['bldMunicipality']),
      bldEnumArea: serializer.fromJson<String?>(json['bldEnumArea']),
      bldLatitude: serializer.fromJson<double?>(json['bldLatitude']),
      bldLongitude: serializer.fromJson<double?>(json['bldLongitude']),
      bldCadastralZone: serializer.fromJson<int?>(json['bldCadastralZone']),
      bldProperty: serializer.fromJson<String?>(json['bldProperty']),
      bldPermitNumber: serializer.fromJson<String?>(json['bldPermitNumber']),
      bldPermitDate: serializer.fromJson<DateTime?>(json['bldPermitDate']),
      bldStatus: serializer.fromJson<int?>(json['bldStatus']),
      bldYearConstruction:
          serializer.fromJson<int?>(json['bldYearConstruction']),
      bldYearDemolition: serializer.fromJson<int?>(json['bldYearDemolition']),
      bldType: serializer.fromJson<int?>(json['bldType']),
      bldClass: serializer.fromJson<int?>(json['bldClass']),
      bldCensus2023: serializer.fromJson<String?>(json['bldCensus2023']),
      bldArea: serializer.fromJson<double?>(json['bldArea']),
      shapeLength: serializer.fromJson<double?>(json['shapeLength']),
      shapeArea: serializer.fromJson<double?>(json['shapeArea']),
      bldFloorsAbove: serializer.fromJson<int?>(json['bldFloorsAbove']),
      bldHeight: serializer.fromJson<double?>(json['bldHeight']),
      bldVolume: serializer.fromJson<double?>(json['bldVolume']),
      bldWasteWater: serializer.fromJson<int?>(json['bldWasteWater']),
      bldElectricity: serializer.fromJson<int?>(json['bldElectricity']),
      bldPipedGas: serializer.fromJson<int?>(json['bldPipedGas']),
      bldElevator: serializer.fromJson<int?>(json['bldElevator']),
      createdUser: serializer.fromJson<String?>(json['createdUser']),
      createdDate: serializer.fromJson<DateTime?>(json['createdDate']),
      lastEditedUser: serializer.fromJson<String?>(json['lastEditedUser']),
      lastEditedDate: serializer.fromJson<DateTime?>(json['lastEditedDate']),
      bldCentroidStatus: serializer.fromJson<int?>(json['bldCentroidStatus']),
      bldDwellingRecs: serializer.fromJson<int?>(json['bldDwellingRecs']),
      bldEntranceRecs: serializer.fromJson<int?>(json['bldEntranceRecs']),
      externalCreator: serializer.fromJson<String?>(json['externalCreator']),
      externalEditor: serializer.fromJson<String?>(json['externalEditor']),
      bldReview: serializer.fromJson<int?>(json['bldReview']),
      bldWaterSupply: serializer.fromJson<int?>(json['bldWaterSupply']),
      externalCreatorDate:
          serializer.fromJson<DateTime?>(json['externalCreatorDate']),
      externalEditorDate:
          serializer.fromJson<DateTime?>(json['externalEditorDate']),
      geometryType: serializer.fromJson<String?>(json['geometryType']),
      coordinates: serializer.fromJson<String>(json['coordinates']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'objectId': serializer.toJson<int>(objectId),
      'downloadId': serializer.toJson<int>(downloadId),
      'globalId': serializer.toJson<String>(globalId),
      'bldAddressID': serializer.toJson<String?>(bldAddressID),
      'bldQuality': serializer.toJson<int?>(bldQuality),
      'bldMunicipality': serializer.toJson<int?>(bldMunicipality),
      'bldEnumArea': serializer.toJson<String?>(bldEnumArea),
      'bldLatitude': serializer.toJson<double?>(bldLatitude),
      'bldLongitude': serializer.toJson<double?>(bldLongitude),
      'bldCadastralZone': serializer.toJson<int?>(bldCadastralZone),
      'bldProperty': serializer.toJson<String?>(bldProperty),
      'bldPermitNumber': serializer.toJson<String?>(bldPermitNumber),
      'bldPermitDate': serializer.toJson<DateTime?>(bldPermitDate),
      'bldStatus': serializer.toJson<int?>(bldStatus),
      'bldYearConstruction': serializer.toJson<int?>(bldYearConstruction),
      'bldYearDemolition': serializer.toJson<int?>(bldYearDemolition),
      'bldType': serializer.toJson<int?>(bldType),
      'bldClass': serializer.toJson<int?>(bldClass),
      'bldCensus2023': serializer.toJson<String?>(bldCensus2023),
      'bldArea': serializer.toJson<double?>(bldArea),
      'shapeLength': serializer.toJson<double?>(shapeLength),
      'shapeArea': serializer.toJson<double?>(shapeArea),
      'bldFloorsAbove': serializer.toJson<int?>(bldFloorsAbove),
      'bldHeight': serializer.toJson<double?>(bldHeight),
      'bldVolume': serializer.toJson<double?>(bldVolume),
      'bldWasteWater': serializer.toJson<int?>(bldWasteWater),
      'bldElectricity': serializer.toJson<int?>(bldElectricity),
      'bldPipedGas': serializer.toJson<int?>(bldPipedGas),
      'bldElevator': serializer.toJson<int?>(bldElevator),
      'createdUser': serializer.toJson<String?>(createdUser),
      'createdDate': serializer.toJson<DateTime?>(createdDate),
      'lastEditedUser': serializer.toJson<String?>(lastEditedUser),
      'lastEditedDate': serializer.toJson<DateTime?>(lastEditedDate),
      'bldCentroidStatus': serializer.toJson<int?>(bldCentroidStatus),
      'bldDwellingRecs': serializer.toJson<int?>(bldDwellingRecs),
      'bldEntranceRecs': serializer.toJson<int?>(bldEntranceRecs),
      'externalCreator': serializer.toJson<String?>(externalCreator),
      'externalEditor': serializer.toJson<String?>(externalEditor),
      'bldReview': serializer.toJson<int?>(bldReview),
      'bldWaterSupply': serializer.toJson<int?>(bldWaterSupply),
      'externalCreatorDate': serializer.toJson<DateTime?>(externalCreatorDate),
      'externalEditorDate': serializer.toJson<DateTime?>(externalEditorDate),
      'geometryType': serializer.toJson<String?>(geometryType),
      'coordinates': serializer.toJson<String>(coordinates),
    };
  }

  Building copyWith(
          {int? id,
          int? objectId,
          int? downloadId,
          String? globalId,
          Value<String?> bldAddressID = const Value.absent(),
          Value<int?> bldQuality = const Value.absent(),
          Value<int?> bldMunicipality = const Value.absent(),
          Value<String?> bldEnumArea = const Value.absent(),
          Value<double?> bldLatitude = const Value.absent(),
          Value<double?> bldLongitude = const Value.absent(),
          Value<int?> bldCadastralZone = const Value.absent(),
          Value<String?> bldProperty = const Value.absent(),
          Value<String?> bldPermitNumber = const Value.absent(),
          Value<DateTime?> bldPermitDate = const Value.absent(),
          Value<int?> bldStatus = const Value.absent(),
          Value<int?> bldYearConstruction = const Value.absent(),
          Value<int?> bldYearDemolition = const Value.absent(),
          Value<int?> bldType = const Value.absent(),
          Value<int?> bldClass = const Value.absent(),
          Value<String?> bldCensus2023 = const Value.absent(),
          Value<double?> bldArea = const Value.absent(),
          Value<double?> shapeLength = const Value.absent(),
          Value<double?> shapeArea = const Value.absent(),
          Value<int?> bldFloorsAbove = const Value.absent(),
          Value<double?> bldHeight = const Value.absent(),
          Value<double?> bldVolume = const Value.absent(),
          Value<int?> bldWasteWater = const Value.absent(),
          Value<int?> bldElectricity = const Value.absent(),
          Value<int?> bldPipedGas = const Value.absent(),
          Value<int?> bldElevator = const Value.absent(),
          Value<String?> createdUser = const Value.absent(),
          Value<DateTime?> createdDate = const Value.absent(),
          Value<String?> lastEditedUser = const Value.absent(),
          Value<DateTime?> lastEditedDate = const Value.absent(),
          Value<int?> bldCentroidStatus = const Value.absent(),
          Value<int?> bldDwellingRecs = const Value.absent(),
          Value<int?> bldEntranceRecs = const Value.absent(),
          Value<String?> externalCreator = const Value.absent(),
          Value<String?> externalEditor = const Value.absent(),
          Value<int?> bldReview = const Value.absent(),
          Value<int?> bldWaterSupply = const Value.absent(),
          Value<DateTime?> externalCreatorDate = const Value.absent(),
          Value<DateTime?> externalEditorDate = const Value.absent(),
          Value<String?> geometryType = const Value.absent(),
          String? coordinates}) =>
      Building(
        id: id ?? this.id,
        objectId: objectId ?? this.objectId,
        downloadId: downloadId ?? this.downloadId,
        globalId: globalId ?? this.globalId,
        bldAddressID:
            bldAddressID.present ? bldAddressID.value : this.bldAddressID,
        bldQuality: bldQuality.present ? bldQuality.value : this.bldQuality,
        bldMunicipality: bldMunicipality.present
            ? bldMunicipality.value
            : this.bldMunicipality,
        bldEnumArea: bldEnumArea.present ? bldEnumArea.value : this.bldEnumArea,
        bldLatitude: bldLatitude.present ? bldLatitude.value : this.bldLatitude,
        bldLongitude:
            bldLongitude.present ? bldLongitude.value : this.bldLongitude,
        bldCadastralZone: bldCadastralZone.present
            ? bldCadastralZone.value
            : this.bldCadastralZone,
        bldProperty: bldProperty.present ? bldProperty.value : this.bldProperty,
        bldPermitNumber: bldPermitNumber.present
            ? bldPermitNumber.value
            : this.bldPermitNumber,
        bldPermitDate:
            bldPermitDate.present ? bldPermitDate.value : this.bldPermitDate,
        bldStatus: bldStatus.present ? bldStatus.value : this.bldStatus,
        bldYearConstruction: bldYearConstruction.present
            ? bldYearConstruction.value
            : this.bldYearConstruction,
        bldYearDemolition: bldYearDemolition.present
            ? bldYearDemolition.value
            : this.bldYearDemolition,
        bldType: bldType.present ? bldType.value : this.bldType,
        bldClass: bldClass.present ? bldClass.value : this.bldClass,
        bldCensus2023:
            bldCensus2023.present ? bldCensus2023.value : this.bldCensus2023,
        bldArea: bldArea.present ? bldArea.value : this.bldArea,
        shapeLength: shapeLength.present ? shapeLength.value : this.shapeLength,
        shapeArea: shapeArea.present ? shapeArea.value : this.shapeArea,
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
        bldCentroidStatus: bldCentroidStatus.present
            ? bldCentroidStatus.value
            : this.bldCentroidStatus,
        bldDwellingRecs: bldDwellingRecs.present
            ? bldDwellingRecs.value
            : this.bldDwellingRecs,
        bldEntranceRecs: bldEntranceRecs.present
            ? bldEntranceRecs.value
            : this.bldEntranceRecs,
        externalCreator: externalCreator.present
            ? externalCreator.value
            : this.externalCreator,
        externalEditor:
            externalEditor.present ? externalEditor.value : this.externalEditor,
        bldReview: bldReview.present ? bldReview.value : this.bldReview,
        bldWaterSupply:
            bldWaterSupply.present ? bldWaterSupply.value : this.bldWaterSupply,
        externalCreatorDate: externalCreatorDate.present
            ? externalCreatorDate.value
            : this.externalCreatorDate,
        externalEditorDate: externalEditorDate.present
            ? externalEditorDate.value
            : this.externalEditorDate,
        geometryType:
            geometryType.present ? geometryType.value : this.geometryType,
        coordinates: coordinates ?? this.coordinates,
      );
  Building copyWithCompanion(BuildingsCompanion data) {
    return Building(
      id: data.id.present ? data.id.value : this.id,
      objectId: data.objectId.present ? data.objectId.value : this.objectId,
      downloadId:
          data.downloadId.present ? data.downloadId.value : this.downloadId,
      globalId: data.globalId.present ? data.globalId.value : this.globalId,
      bldAddressID: data.bldAddressID.present
          ? data.bldAddressID.value
          : this.bldAddressID,
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
      bldCensus2023: data.bldCensus2023.present
          ? data.bldCensus2023.value
          : this.bldCensus2023,
      bldArea: data.bldArea.present ? data.bldArea.value : this.bldArea,
      shapeLength:
          data.shapeLength.present ? data.shapeLength.value : this.shapeLength,
      shapeArea: data.shapeArea.present ? data.shapeArea.value : this.shapeArea,
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
      geometryType: data.geometryType.present
          ? data.geometryType.value
          : this.geometryType,
      coordinates:
          data.coordinates.present ? data.coordinates.value : this.coordinates,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Building(')
          ..write('id: $id, ')
          ..write('objectId: $objectId, ')
          ..write('downloadId: $downloadId, ')
          ..write('globalId: $globalId, ')
          ..write('bldAddressID: $bldAddressID, ')
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
          ..write('bldCensus2023: $bldCensus2023, ')
          ..write('bldArea: $bldArea, ')
          ..write('shapeLength: $shapeLength, ')
          ..write('shapeArea: $shapeArea, ')
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
          ..write('externalCreator: $externalCreator, ')
          ..write('externalEditor: $externalEditor, ')
          ..write('bldReview: $bldReview, ')
          ..write('bldWaterSupply: $bldWaterSupply, ')
          ..write('externalCreatorDate: $externalCreatorDate, ')
          ..write('externalEditorDate: $externalEditorDate, ')
          ..write('geometryType: $geometryType, ')
          ..write('coordinates: $coordinates')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        objectId,
        downloadId,
        globalId,
        bldAddressID,
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
        bldCensus2023,
        bldArea,
        shapeLength,
        shapeArea,
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
        externalCreator,
        externalEditor,
        bldReview,
        bldWaterSupply,
        externalCreatorDate,
        externalEditorDate,
        geometryType,
        coordinates
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Building &&
          other.id == this.id &&
          other.objectId == this.objectId &&
          other.downloadId == this.downloadId &&
          other.globalId == this.globalId &&
          other.bldAddressID == this.bldAddressID &&
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
          other.bldCensus2023 == this.bldCensus2023 &&
          other.bldArea == this.bldArea &&
          other.shapeLength == this.shapeLength &&
          other.shapeArea == this.shapeArea &&
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
          other.externalCreator == this.externalCreator &&
          other.externalEditor == this.externalEditor &&
          other.bldReview == this.bldReview &&
          other.bldWaterSupply == this.bldWaterSupply &&
          other.externalCreatorDate == this.externalCreatorDate &&
          other.externalEditorDate == this.externalEditorDate &&
          other.geometryType == this.geometryType &&
          other.coordinates == this.coordinates);
}

class BuildingsCompanion extends UpdateCompanion<Building> {
  final Value<int> id;
  final Value<int> objectId;
  final Value<int> downloadId;
  final Value<String> globalId;
  final Value<String?> bldAddressID;
  final Value<int?> bldQuality;
  final Value<int?> bldMunicipality;
  final Value<String?> bldEnumArea;
  final Value<double?> bldLatitude;
  final Value<double?> bldLongitude;
  final Value<int?> bldCadastralZone;
  final Value<String?> bldProperty;
  final Value<String?> bldPermitNumber;
  final Value<DateTime?> bldPermitDate;
  final Value<int?> bldStatus;
  final Value<int?> bldYearConstruction;
  final Value<int?> bldYearDemolition;
  final Value<int?> bldType;
  final Value<int?> bldClass;
  final Value<String?> bldCensus2023;
  final Value<double?> bldArea;
  final Value<double?> shapeLength;
  final Value<double?> shapeArea;
  final Value<int?> bldFloorsAbove;
  final Value<double?> bldHeight;
  final Value<double?> bldVolume;
  final Value<int?> bldWasteWater;
  final Value<int?> bldElectricity;
  final Value<int?> bldPipedGas;
  final Value<int?> bldElevator;
  final Value<String?> createdUser;
  final Value<DateTime?> createdDate;
  final Value<String?> lastEditedUser;
  final Value<DateTime?> lastEditedDate;
  final Value<int?> bldCentroidStatus;
  final Value<int?> bldDwellingRecs;
  final Value<int?> bldEntranceRecs;
  final Value<String?> externalCreator;
  final Value<String?> externalEditor;
  final Value<int?> bldReview;
  final Value<int?> bldWaterSupply;
  final Value<DateTime?> externalCreatorDate;
  final Value<DateTime?> externalEditorDate;
  final Value<String?> geometryType;
  final Value<String> coordinates;
  const BuildingsCompanion({
    this.id = const Value.absent(),
    this.objectId = const Value.absent(),
    this.downloadId = const Value.absent(),
    this.globalId = const Value.absent(),
    this.bldAddressID = const Value.absent(),
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
    this.bldCensus2023 = const Value.absent(),
    this.bldArea = const Value.absent(),
    this.shapeLength = const Value.absent(),
    this.shapeArea = const Value.absent(),
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
    this.externalCreator = const Value.absent(),
    this.externalEditor = const Value.absent(),
    this.bldReview = const Value.absent(),
    this.bldWaterSupply = const Value.absent(),
    this.externalCreatorDate = const Value.absent(),
    this.externalEditorDate = const Value.absent(),
    this.geometryType = const Value.absent(),
    this.coordinates = const Value.absent(),
  });
  BuildingsCompanion.insert({
    this.id = const Value.absent(),
    required int objectId,
    required int downloadId,
    required String globalId,
    this.bldAddressID = const Value.absent(),
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
    this.bldCensus2023 = const Value.absent(),
    this.bldArea = const Value.absent(),
    this.shapeLength = const Value.absent(),
    this.shapeArea = const Value.absent(),
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
    this.externalCreator = const Value.absent(),
    this.externalEditor = const Value.absent(),
    this.bldReview = const Value.absent(),
    this.bldWaterSupply = const Value.absent(),
    this.externalCreatorDate = const Value.absent(),
    this.externalEditorDate = const Value.absent(),
    this.geometryType = const Value.absent(),
    required String coordinates,
  })  : objectId = Value(objectId),
        downloadId = Value(downloadId),
        globalId = Value(globalId),
        coordinates = Value(coordinates);
  static Insertable<Building> custom({
    Expression<int>? id,
    Expression<int>? objectId,
    Expression<int>? downloadId,
    Expression<String>? globalId,
    Expression<String>? bldAddressID,
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
    Expression<String>? bldCensus2023,
    Expression<double>? bldArea,
    Expression<double>? shapeLength,
    Expression<double>? shapeArea,
    Expression<int>? bldFloorsAbove,
    Expression<double>? bldHeight,
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
    Expression<String>? externalCreator,
    Expression<String>? externalEditor,
    Expression<int>? bldReview,
    Expression<int>? bldWaterSupply,
    Expression<DateTime>? externalCreatorDate,
    Expression<DateTime>? externalEditorDate,
    Expression<String>? geometryType,
    Expression<String>? coordinates,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (objectId != null) 'object_id': objectId,
      if (downloadId != null) 'download_id': downloadId,
      if (globalId != null) 'global_id': globalId,
      if (bldAddressID != null) 'bld_address_id': bldAddressID,
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
      if (bldCensus2023 != null) 'bld_census_2023': bldCensus2023,
      if (bldArea != null) 'bld_area': bldArea,
      if (shapeLength != null) 'shape_length': shapeLength,
      if (shapeArea != null) 'shape_area': shapeArea,
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
      if (externalCreator != null) 'external_creator': externalCreator,
      if (externalEditor != null) 'external_editor': externalEditor,
      if (bldReview != null) 'bld_review': bldReview,
      if (bldWaterSupply != null) 'bld_water_supply': bldWaterSupply,
      if (externalCreatorDate != null)
        'external_creator_date': externalCreatorDate,
      if (externalEditorDate != null)
        'external_editor_date': externalEditorDate,
      if (geometryType != null) 'geometry_type': geometryType,
      if (coordinates != null) 'coordinates': coordinates,
    });
  }

  BuildingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? objectId,
      Value<int>? downloadId,
      Value<String>? globalId,
      Value<String?>? bldAddressID,
      Value<int?>? bldQuality,
      Value<int?>? bldMunicipality,
      Value<String?>? bldEnumArea,
      Value<double?>? bldLatitude,
      Value<double?>? bldLongitude,
      Value<int?>? bldCadastralZone,
      Value<String?>? bldProperty,
      Value<String?>? bldPermitNumber,
      Value<DateTime?>? bldPermitDate,
      Value<int?>? bldStatus,
      Value<int?>? bldYearConstruction,
      Value<int?>? bldYearDemolition,
      Value<int?>? bldType,
      Value<int?>? bldClass,
      Value<String?>? bldCensus2023,
      Value<double?>? bldArea,
      Value<double?>? shapeLength,
      Value<double?>? shapeArea,
      Value<int?>? bldFloorsAbove,
      Value<double?>? bldHeight,
      Value<double?>? bldVolume,
      Value<int?>? bldWasteWater,
      Value<int?>? bldElectricity,
      Value<int?>? bldPipedGas,
      Value<int?>? bldElevator,
      Value<String?>? createdUser,
      Value<DateTime?>? createdDate,
      Value<String?>? lastEditedUser,
      Value<DateTime?>? lastEditedDate,
      Value<int?>? bldCentroidStatus,
      Value<int?>? bldDwellingRecs,
      Value<int?>? bldEntranceRecs,
      Value<String?>? externalCreator,
      Value<String?>? externalEditor,
      Value<int?>? bldReview,
      Value<int?>? bldWaterSupply,
      Value<DateTime?>? externalCreatorDate,
      Value<DateTime?>? externalEditorDate,
      Value<String?>? geometryType,
      Value<String>? coordinates}) {
    return BuildingsCompanion(
      id: id ?? this.id,
      objectId: objectId ?? this.objectId,
      downloadId: downloadId ?? this.downloadId,
      globalId: globalId ?? this.globalId,
      bldAddressID: bldAddressID ?? this.bldAddressID,
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
      bldCensus2023: bldCensus2023 ?? this.bldCensus2023,
      bldArea: bldArea ?? this.bldArea,
      shapeLength: shapeLength ?? this.shapeLength,
      shapeArea: shapeArea ?? this.shapeArea,
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
      externalCreator: externalCreator ?? this.externalCreator,
      externalEditor: externalEditor ?? this.externalEditor,
      bldReview: bldReview ?? this.bldReview,
      bldWaterSupply: bldWaterSupply ?? this.bldWaterSupply,
      externalCreatorDate: externalCreatorDate ?? this.externalCreatorDate,
      externalEditorDate: externalEditorDate ?? this.externalEditorDate,
      geometryType: geometryType ?? this.geometryType,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (objectId.present) {
      map['object_id'] = Variable<int>(objectId.value);
    }
    if (downloadId.present) {
      map['download_id'] = Variable<int>(downloadId.value);
    }
    if (globalId.present) {
      map['global_id'] = Variable<String>(globalId.value);
    }
    if (bldAddressID.present) {
      map['bld_address_id'] = Variable<String>(bldAddressID.value);
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
    if (bldCensus2023.present) {
      map['bld_census_2023'] = Variable<String>(bldCensus2023.value);
    }
    if (bldArea.present) {
      map['bld_area'] = Variable<double>(bldArea.value);
    }
    if (shapeLength.present) {
      map['shape_length'] = Variable<double>(shapeLength.value);
    }
    if (shapeArea.present) {
      map['shape_area'] = Variable<double>(shapeArea.value);
    }
    if (bldFloorsAbove.present) {
      map['bld_floors_above'] = Variable<int>(bldFloorsAbove.value);
    }
    if (bldHeight.present) {
      map['bld_height'] = Variable<double>(bldHeight.value);
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
    if (geometryType.present) {
      map['geometry_type'] = Variable<String>(geometryType.value);
    }
    if (coordinates.present) {
      map['coordinates'] = Variable<String>(coordinates.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuildingsCompanion(')
          ..write('id: $id, ')
          ..write('objectId: $objectId, ')
          ..write('downloadId: $downloadId, ')
          ..write('globalId: $globalId, ')
          ..write('bldAddressID: $bldAddressID, ')
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
          ..write('bldCensus2023: $bldCensus2023, ')
          ..write('bldArea: $bldArea, ')
          ..write('shapeLength: $shapeLength, ')
          ..write('shapeArea: $shapeArea, ')
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
          ..write('externalCreator: $externalCreator, ')
          ..write('externalEditor: $externalEditor, ')
          ..write('bldReview: $bldReview, ')
          ..write('bldWaterSupply: $bldWaterSupply, ')
          ..write('externalCreatorDate: $externalCreatorDate, ')
          ..write('externalEditorDate: $externalEditorDate, ')
          ..write('geometryType: $geometryType, ')
          ..write('coordinates: $coordinates')
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _downloadIdMeta =
      const VerificationMeta('downloadId');
  @override
  late final GeneratedColumn<int> downloadId = GeneratedColumn<int>(
      'download_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES downloads (id)'));
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
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES buildings (global_id)'));
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
  static const VerificationMeta _geometryTypeMeta =
      const VerificationMeta('geometryType');
  @override
  late final GeneratedColumn<String> geometryType = GeneratedColumn<String>(
      'geometry_type', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _coordinatesMeta =
      const VerificationMeta('coordinates');
  @override
  late final GeneratedColumn<String> coordinates = GeneratedColumn<String>(
      'coordinates', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        downloadId,
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
        geometryType,
        coordinates
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('download_id')) {
      context.handle(
          _downloadIdMeta,
          downloadId.isAcceptableOrUnknown(
              data['download_id']!, _downloadIdMeta));
    } else if (isInserting) {
      context.missing(_downloadIdMeta);
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
    } else if (isInserting) {
      context.missing(_entBldGlobalIdMeta);
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
    if (data.containsKey('geometry_type')) {
      context.handle(
          _geometryTypeMeta,
          geometryType.isAcceptableOrUnknown(
              data['geometry_type']!, _geometryTypeMeta));
    }
    if (data.containsKey('coordinates')) {
      context.handle(
          _coordinatesMeta,
          coordinates.isAcceptableOrUnknown(
              data['coordinates']!, _coordinatesMeta));
    } else if (isInserting) {
      context.missing(_coordinatesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entrance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entrance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      downloadId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}download_id'])!,
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
      geometryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}geometry_type']),
      coordinates: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coordinates'])!,
    );
  }

  @override
  $EntrancesTable createAlias(String alias) {
    return $EntrancesTable(attachedDatabase, alias);
  }
}

class Entrance extends DataClass implements Insertable<Entrance> {
  final int id;
  final int downloadId;
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
  final String? geometryType;
  final String coordinates;
  const Entrance(
      {required this.id,
      required this.downloadId,
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
      this.geometryType,
      required this.coordinates});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['download_id'] = Variable<int>(downloadId);
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
    if (!nullToAbsent || geometryType != null) {
      map['geometry_type'] = Variable<String>(geometryType);
    }
    map['coordinates'] = Variable<String>(coordinates);
    return map;
  }

  EntrancesCompanion toCompanion(bool nullToAbsent) {
    return EntrancesCompanion(
      id: Value(id),
      downloadId: Value(downloadId),
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
      geometryType: geometryType == null && nullToAbsent
          ? const Value.absent()
          : Value(geometryType),
      coordinates: Value(coordinates),
    );
  }

  factory Entrance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entrance(
      id: serializer.fromJson<int>(json['id']),
      downloadId: serializer.fromJson<int>(json['downloadId']),
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
      geometryType: serializer.fromJson<String?>(json['geometryType']),
      coordinates: serializer.fromJson<String>(json['coordinates']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'downloadId': serializer.toJson<int>(downloadId),
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
      'geometryType': serializer.toJson<String?>(geometryType),
      'coordinates': serializer.toJson<String>(coordinates),
    };
  }

  Entrance copyWith(
          {int? id,
          int? downloadId,
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
          Value<String?> geometryType = const Value.absent(),
          String? coordinates}) =>
      Entrance(
        id: id ?? this.id,
        downloadId: downloadId ?? this.downloadId,
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
        geometryType:
            geometryType.present ? geometryType.value : this.geometryType,
        coordinates: coordinates ?? this.coordinates,
      );
  Entrance copyWithCompanion(EntrancesCompanion data) {
    return Entrance(
      id: data.id.present ? data.id.value : this.id,
      downloadId:
          data.downloadId.present ? data.downloadId.value : this.downloadId,
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
      geometryType: data.geometryType.present
          ? data.geometryType.value
          : this.geometryType,
      coordinates:
          data.coordinates.present ? data.coordinates.value : this.coordinates,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entrance(')
          ..write('id: $id, ')
          ..write('downloadId: $downloadId, ')
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
          ..write('geometryType: $geometryType, ')
          ..write('coordinates: $coordinates')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      downloadId,
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
      geometryType,
      coordinates);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entrance &&
          other.id == this.id &&
          other.downloadId == this.downloadId &&
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
          other.geometryType == this.geometryType &&
          other.coordinates == this.coordinates);
}

class EntrancesCompanion extends UpdateCompanion<Entrance> {
  final Value<int> id;
  final Value<int> downloadId;
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
  final Value<String?> geometryType;
  final Value<String> coordinates;
  const EntrancesCompanion({
    this.id = const Value.absent(),
    this.downloadId = const Value.absent(),
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
    this.geometryType = const Value.absent(),
    this.coordinates = const Value.absent(),
  });
  EntrancesCompanion.insert({
    this.id = const Value.absent(),
    required int downloadId,
    required String globalId,
    required String entBldGlobalId,
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
    this.geometryType = const Value.absent(),
    required String coordinates,
  })  : downloadId = Value(downloadId),
        globalId = Value(globalId),
        entBldGlobalId = Value(entBldGlobalId),
        entLatitude = Value(entLatitude),
        entLongitude = Value(entLongitude),
        coordinates = Value(coordinates);
  static Insertable<Entrance> custom({
    Expression<int>? id,
    Expression<int>? downloadId,
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
    Expression<String>? geometryType,
    Expression<String>? coordinates,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (downloadId != null) 'download_id': downloadId,
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
      if (geometryType != null) 'geometry_type': geometryType,
      if (coordinates != null) 'coordinates': coordinates,
    });
  }

  EntrancesCompanion copyWith(
      {Value<int>? id,
      Value<int>? downloadId,
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
      Value<String?>? geometryType,
      Value<String>? coordinates}) {
    return EntrancesCompanion(
      id: id ?? this.id,
      downloadId: downloadId ?? this.downloadId,
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
      geometryType: geometryType ?? this.geometryType,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (downloadId.present) {
      map['download_id'] = Variable<int>(downloadId.value);
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
    if (geometryType.present) {
      map['geometry_type'] = Variable<String>(geometryType.value);
    }
    if (coordinates.present) {
      map['coordinates'] = Variable<String>(coordinates.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntrancesCompanion(')
          ..write('id: $id, ')
          ..write('downloadId: $downloadId, ')
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
          ..write('geometryType: $geometryType, ')
          ..write('coordinates: $coordinates')
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _downloadIdMeta =
      const VerificationMeta('downloadId');
  @override
  late final GeneratedColumn<int> downloadId = GeneratedColumn<int>(
      'download_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES downloads (id)'));
  static const VerificationMeta _objectIdMeta =
      const VerificationMeta('objectId');
  @override
  late final GeneratedColumn<int> objectId = GeneratedColumn<int>(
      'object_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES entrances (global_id)'));
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
  static const VerificationMeta _geometryTypeMeta =
      const VerificationMeta('geometryType');
  @override
  late final GeneratedColumn<String> geometryType = GeneratedColumn<String>(
      'geometry_type', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        downloadId,
        objectId,
        globalId,
        dwlEntGlobalId,
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
        geometryType
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('download_id')) {
      context.handle(
          _downloadIdMeta,
          downloadId.isAcceptableOrUnknown(
              data['download_id']!, _downloadIdMeta));
    } else if (isInserting) {
      context.missing(_downloadIdMeta);
    }
    if (data.containsKey('object_id')) {
      context.handle(_objectIdMeta,
          objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta));
    } else if (isInserting) {
      context.missing(_objectIdMeta);
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
    } else if (isInserting) {
      context.missing(_dwlEntGlobalIdMeta);
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
    if (data.containsKey('geometry_type')) {
      context.handle(
          _geometryTypeMeta,
          geometryType.isAcceptableOrUnknown(
              data['geometry_type']!, _geometryTypeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dwelling map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dwelling(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      downloadId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}download_id'])!,
      objectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_id'])!,
      globalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}global_id'])!,
      dwlEntGlobalId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dwl_ent_global_id'])!,
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
      geometryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}geometry_type']),
    );
  }

  @override
  $DwellingsTable createAlias(String alias) {
    return $DwellingsTable(attachedDatabase, alias);
  }
}

class Dwelling extends DataClass implements Insertable<Dwelling> {
  final int id;
  final int downloadId;
  final int objectId;
  final String globalId;
  final String dwlEntGlobalId;
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
  final String? geometryType;
  const Dwelling(
      {required this.id,
      required this.downloadId,
      required this.objectId,
      required this.globalId,
      required this.dwlEntGlobalId,
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
      this.geometryType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['download_id'] = Variable<int>(downloadId);
    map['object_id'] = Variable<int>(objectId);
    map['global_id'] = Variable<String>(globalId);
    map['dwl_ent_global_id'] = Variable<String>(dwlEntGlobalId);
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
    if (!nullToAbsent || geometryType != null) {
      map['geometry_type'] = Variable<String>(geometryType);
    }
    return map;
  }

  DwellingsCompanion toCompanion(bool nullToAbsent) {
    return DwellingsCompanion(
      id: Value(id),
      downloadId: Value(downloadId),
      objectId: Value(objectId),
      globalId: Value(globalId),
      dwlEntGlobalId: Value(dwlEntGlobalId),
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
      geometryType: geometryType == null && nullToAbsent
          ? const Value.absent()
          : Value(geometryType),
    );
  }

  factory Dwelling.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dwelling(
      id: serializer.fromJson<int>(json['id']),
      downloadId: serializer.fromJson<int>(json['downloadId']),
      objectId: serializer.fromJson<int>(json['objectId']),
      globalId: serializer.fromJson<String>(json['globalId']),
      dwlEntGlobalId: serializer.fromJson<String>(json['dwlEntGlobalId']),
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
      geometryType: serializer.fromJson<String?>(json['geometryType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'downloadId': serializer.toJson<int>(downloadId),
      'objectId': serializer.toJson<int>(objectId),
      'globalId': serializer.toJson<String>(globalId),
      'dwlEntGlobalId': serializer.toJson<String>(dwlEntGlobalId),
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
      'geometryType': serializer.toJson<String?>(geometryType),
    };
  }

  Dwelling copyWith(
          {int? id,
          int? downloadId,
          int? objectId,
          String? globalId,
          String? dwlEntGlobalId,
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
          Value<String?> geometryType = const Value.absent()}) =>
      Dwelling(
        id: id ?? this.id,
        downloadId: downloadId ?? this.downloadId,
        objectId: objectId ?? this.objectId,
        globalId: globalId ?? this.globalId,
        dwlEntGlobalId: dwlEntGlobalId ?? this.dwlEntGlobalId,
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
        geometryType:
            geometryType.present ? geometryType.value : this.geometryType,
      );
  Dwelling copyWithCompanion(DwellingsCompanion data) {
    return Dwelling(
      id: data.id.present ? data.id.value : this.id,
      downloadId:
          data.downloadId.present ? data.downloadId.value : this.downloadId,
      objectId: data.objectId.present ? data.objectId.value : this.objectId,
      globalId: data.globalId.present ? data.globalId.value : this.globalId,
      dwlEntGlobalId: data.dwlEntGlobalId.present
          ? data.dwlEntGlobalId.value
          : this.dwlEntGlobalId,
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
      geometryType: data.geometryType.present
          ? data.geometryType.value
          : this.geometryType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dwelling(')
          ..write('id: $id, ')
          ..write('downloadId: $downloadId, ')
          ..write('objectId: $objectId, ')
          ..write('globalId: $globalId, ')
          ..write('dwlEntGlobalId: $dwlEntGlobalId, ')
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
          ..write('geometryType: $geometryType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        downloadId,
        objectId,
        globalId,
        dwlEntGlobalId,
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
        geometryType
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dwelling &&
          other.id == this.id &&
          other.downloadId == this.downloadId &&
          other.objectId == this.objectId &&
          other.globalId == this.globalId &&
          other.dwlEntGlobalId == this.dwlEntGlobalId &&
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
          other.geometryType == this.geometryType);
}

class DwellingsCompanion extends UpdateCompanion<Dwelling> {
  final Value<int> id;
  final Value<int> downloadId;
  final Value<int> objectId;
  final Value<String> globalId;
  final Value<String> dwlEntGlobalId;
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
  final Value<String?> geometryType;
  const DwellingsCompanion({
    this.id = const Value.absent(),
    this.downloadId = const Value.absent(),
    this.objectId = const Value.absent(),
    this.globalId = const Value.absent(),
    this.dwlEntGlobalId = const Value.absent(),
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
    this.geometryType = const Value.absent(),
  });
  DwellingsCompanion.insert({
    this.id = const Value.absent(),
    required int downloadId,
    required int objectId,
    required String globalId,
    required String dwlEntGlobalId,
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
    this.geometryType = const Value.absent(),
  })  : downloadId = Value(downloadId),
        objectId = Value(objectId),
        globalId = Value(globalId),
        dwlEntGlobalId = Value(dwlEntGlobalId);
  static Insertable<Dwelling> custom({
    Expression<int>? id,
    Expression<int>? downloadId,
    Expression<int>? objectId,
    Expression<String>? globalId,
    Expression<String>? dwlEntGlobalId,
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
    Expression<String>? geometryType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (downloadId != null) 'download_id': downloadId,
      if (objectId != null) 'object_id': objectId,
      if (globalId != null) 'global_id': globalId,
      if (dwlEntGlobalId != null) 'dwl_ent_global_id': dwlEntGlobalId,
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
      if (geometryType != null) 'geometry_type': geometryType,
    });
  }

  DwellingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? downloadId,
      Value<int>? objectId,
      Value<String>? globalId,
      Value<String>? dwlEntGlobalId,
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
      Value<String?>? geometryType}) {
    return DwellingsCompanion(
      id: id ?? this.id,
      downloadId: downloadId ?? this.downloadId,
      objectId: objectId ?? this.objectId,
      globalId: globalId ?? this.globalId,
      dwlEntGlobalId: dwlEntGlobalId ?? this.dwlEntGlobalId,
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
      geometryType: geometryType ?? this.geometryType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (downloadId.present) {
      map['download_id'] = Variable<int>(downloadId.value);
    }
    if (objectId.present) {
      map['object_id'] = Variable<int>(objectId.value);
    }
    if (globalId.present) {
      map['global_id'] = Variable<String>(globalId.value);
    }
    if (dwlEntGlobalId.present) {
      map['dwl_ent_global_id'] = Variable<String>(dwlEntGlobalId.value);
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
    if (geometryType.present) {
      map['geometry_type'] = Variable<String>(geometryType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DwellingsCompanion(')
          ..write('id: $id, ')
          ..write('downloadId: $downloadId, ')
          ..write('objectId: $objectId, ')
          ..write('globalId: $globalId, ')
          ..write('dwlEntGlobalId: $dwlEntGlobalId, ')
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
          ..write('geometryType: $geometryType')
          ..write(')'))
        .toString();
  }
}

class $MunicipalitiesTable extends Municipalities
    with TableInfo<$MunicipalitiesTable, Municipality> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MunicipalitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _objectIdMeta =
      const VerificationMeta('objectId');
  @override
  late final GeneratedColumn<int> objectId = GeneratedColumn<int>(
      'object_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _municipalityIdMeta =
      const VerificationMeta('municipalityId');
  @override
  late final GeneratedColumn<String> municipalityId = GeneratedColumn<String>(
      'municipality_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _downloadIdMeta =
      const VerificationMeta('downloadId');
  @override
  late final GeneratedColumn<int> downloadId = GeneratedColumn<int>(
      'download_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES downloads (id)'));
  static const VerificationMeta _municipalityNameMeta =
      const VerificationMeta('municipalityName');
  @override
  late final GeneratedColumn<String> municipalityName = GeneratedColumn<String>(
      'municipality_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coordinatesMeta =
      const VerificationMeta('coordinates');
  @override
  late final GeneratedColumn<String> coordinates = GeneratedColumn<String>(
      'coordinates', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, objectId, municipalityId, downloadId, municipalityName, coordinates];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'municipalities';
  @override
  VerificationContext validateIntegrity(Insertable<Municipality> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('object_id')) {
      context.handle(_objectIdMeta,
          objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta));
    } else if (isInserting) {
      context.missing(_objectIdMeta);
    }
    if (data.containsKey('municipality_id')) {
      context.handle(
          _municipalityIdMeta,
          municipalityId.isAcceptableOrUnknown(
              data['municipality_id']!, _municipalityIdMeta));
    } else if (isInserting) {
      context.missing(_municipalityIdMeta);
    }
    if (data.containsKey('download_id')) {
      context.handle(
          _downloadIdMeta,
          downloadId.isAcceptableOrUnknown(
              data['download_id']!, _downloadIdMeta));
    } else if (isInserting) {
      context.missing(_downloadIdMeta);
    }
    if (data.containsKey('municipality_name')) {
      context.handle(
          _municipalityNameMeta,
          municipalityName.isAcceptableOrUnknown(
              data['municipality_name']!, _municipalityNameMeta));
    }
    if (data.containsKey('coordinates')) {
      context.handle(
          _coordinatesMeta,
          coordinates.isAcceptableOrUnknown(
              data['coordinates']!, _coordinatesMeta));
    } else if (isInserting) {
      context.missing(_coordinatesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Municipality map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Municipality(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      objectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_id'])!,
      municipalityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}municipality_id'])!,
      downloadId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}download_id'])!,
      municipalityName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}municipality_name']),
      coordinates: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coordinates'])!,
    );
  }

  @override
  $MunicipalitiesTable createAlias(String alias) {
    return $MunicipalitiesTable(attachedDatabase, alias);
  }
}

class Municipality extends DataClass implements Insertable<Municipality> {
  final int id;
  final int objectId;
  final String municipalityId;
  final int downloadId;
  final String? municipalityName;
  final String coordinates;
  const Municipality(
      {required this.id,
      required this.objectId,
      required this.municipalityId,
      required this.downloadId,
      this.municipalityName,
      required this.coordinates});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['object_id'] = Variable<int>(objectId);
    map['municipality_id'] = Variable<String>(municipalityId);
    map['download_id'] = Variable<int>(downloadId);
    if (!nullToAbsent || municipalityName != null) {
      map['municipality_name'] = Variable<String>(municipalityName);
    }
    map['coordinates'] = Variable<String>(coordinates);
    return map;
  }

  MunicipalitiesCompanion toCompanion(bool nullToAbsent) {
    return MunicipalitiesCompanion(
      id: Value(id),
      objectId: Value(objectId),
      municipalityId: Value(municipalityId),
      downloadId: Value(downloadId),
      municipalityName: municipalityName == null && nullToAbsent
          ? const Value.absent()
          : Value(municipalityName),
      coordinates: Value(coordinates),
    );
  }

  factory Municipality.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Municipality(
      id: serializer.fromJson<int>(json['id']),
      objectId: serializer.fromJson<int>(json['objectId']),
      municipalityId: serializer.fromJson<String>(json['municipalityId']),
      downloadId: serializer.fromJson<int>(json['downloadId']),
      municipalityName: serializer.fromJson<String?>(json['municipalityName']),
      coordinates: serializer.fromJson<String>(json['coordinates']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'objectId': serializer.toJson<int>(objectId),
      'municipalityId': serializer.toJson<String>(municipalityId),
      'downloadId': serializer.toJson<int>(downloadId),
      'municipalityName': serializer.toJson<String?>(municipalityName),
      'coordinates': serializer.toJson<String>(coordinates),
    };
  }

  Municipality copyWith(
          {int? id,
          int? objectId,
          String? municipalityId,
          int? downloadId,
          Value<String?> municipalityName = const Value.absent(),
          String? coordinates}) =>
      Municipality(
        id: id ?? this.id,
        objectId: objectId ?? this.objectId,
        municipalityId: municipalityId ?? this.municipalityId,
        downloadId: downloadId ?? this.downloadId,
        municipalityName: municipalityName.present
            ? municipalityName.value
            : this.municipalityName,
        coordinates: coordinates ?? this.coordinates,
      );
  Municipality copyWithCompanion(MunicipalitiesCompanion data) {
    return Municipality(
      id: data.id.present ? data.id.value : this.id,
      objectId: data.objectId.present ? data.objectId.value : this.objectId,
      municipalityId: data.municipalityId.present
          ? data.municipalityId.value
          : this.municipalityId,
      downloadId:
          data.downloadId.present ? data.downloadId.value : this.downloadId,
      municipalityName: data.municipalityName.present
          ? data.municipalityName.value
          : this.municipalityName,
      coordinates:
          data.coordinates.present ? data.coordinates.value : this.coordinates,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Municipality(')
          ..write('id: $id, ')
          ..write('objectId: $objectId, ')
          ..write('municipalityId: $municipalityId, ')
          ..write('downloadId: $downloadId, ')
          ..write('municipalityName: $municipalityName, ')
          ..write('coordinates: $coordinates')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, objectId, municipalityId, downloadId, municipalityName, coordinates);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Municipality &&
          other.id == this.id &&
          other.objectId == this.objectId &&
          other.municipalityId == this.municipalityId &&
          other.downloadId == this.downloadId &&
          other.municipalityName == this.municipalityName &&
          other.coordinates == this.coordinates);
}

class MunicipalitiesCompanion extends UpdateCompanion<Municipality> {
  final Value<int> id;
  final Value<int> objectId;
  final Value<String> municipalityId;
  final Value<int> downloadId;
  final Value<String?> municipalityName;
  final Value<String> coordinates;
  const MunicipalitiesCompanion({
    this.id = const Value.absent(),
    this.objectId = const Value.absent(),
    this.municipalityId = const Value.absent(),
    this.downloadId = const Value.absent(),
    this.municipalityName = const Value.absent(),
    this.coordinates = const Value.absent(),
  });
  MunicipalitiesCompanion.insert({
    this.id = const Value.absent(),
    required int objectId,
    required String municipalityId,
    required int downloadId,
    this.municipalityName = const Value.absent(),
    required String coordinates,
  })  : objectId = Value(objectId),
        municipalityId = Value(municipalityId),
        downloadId = Value(downloadId),
        coordinates = Value(coordinates);
  static Insertable<Municipality> custom({
    Expression<int>? id,
    Expression<int>? objectId,
    Expression<String>? municipalityId,
    Expression<int>? downloadId,
    Expression<String>? municipalityName,
    Expression<String>? coordinates,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (objectId != null) 'object_id': objectId,
      if (municipalityId != null) 'municipality_id': municipalityId,
      if (downloadId != null) 'download_id': downloadId,
      if (municipalityName != null) 'municipality_name': municipalityName,
      if (coordinates != null) 'coordinates': coordinates,
    });
  }

  MunicipalitiesCompanion copyWith(
      {Value<int>? id,
      Value<int>? objectId,
      Value<String>? municipalityId,
      Value<int>? downloadId,
      Value<String?>? municipalityName,
      Value<String>? coordinates}) {
    return MunicipalitiesCompanion(
      id: id ?? this.id,
      objectId: objectId ?? this.objectId,
      municipalityId: municipalityId ?? this.municipalityId,
      downloadId: downloadId ?? this.downloadId,
      municipalityName: municipalityName ?? this.municipalityName,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (objectId.present) {
      map['object_id'] = Variable<int>(objectId.value);
    }
    if (municipalityId.present) {
      map['municipality_id'] = Variable<String>(municipalityId.value);
    }
    if (downloadId.present) {
      map['download_id'] = Variable<int>(downloadId.value);
    }
    if (municipalityName.present) {
      map['municipality_name'] = Variable<String>(municipalityName.value);
    }
    if (coordinates.present) {
      map['coordinates'] = Variable<String>(coordinates.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MunicipalitiesCompanion(')
          ..write('id: $id, ')
          ..write('objectId: $objectId, ')
          ..write('municipalityId: $municipalityId, ')
          ..write('downloadId: $downloadId, ')
          ..write('municipalityName: $municipalityName, ')
          ..write('coordinates: $coordinates')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DownloadsTable downloads = $DownloadsTable(this);
  late final $BuildingsTable buildings = $BuildingsTable(this);
  late final $EntrancesTable entrances = $EntrancesTable(this);
  late final $DwellingsTable dwellings = $DwellingsTable(this);
  late final $MunicipalitiesTable municipalities = $MunicipalitiesTable(this);
  late final DownloadsDao downloadsDao = DownloadsDao(this as AppDatabase);
  late final BuildingDao buildingDao = BuildingDao(this as AppDatabase);
  late final EntrancesDao entrancesDao = EntrancesDao(this as AppDatabase);
  late final DwellingsDao dwellingsDao = DwellingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [downloads, buildings, entrances, dwellings, municipalities];
}

typedef $$DownloadsTableCreateCompanionBuilder = DownloadsCompanion Function({
  Value<int> id,
  Value<DateTime> createdDate,
});
typedef $$DownloadsTableUpdateCompanionBuilder = DownloadsCompanion Function({
  Value<int> id,
  Value<DateTime> createdDate,
});

final class $$DownloadsTableReferences
    extends BaseReferences<_$AppDatabase, $DownloadsTable, Download> {
  $$DownloadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BuildingsTable, List<Building>>
      _buildingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.buildings,
          aliasName:
              $_aliasNameGenerator(db.downloads.id, db.buildings.downloadId));

  $$BuildingsTableProcessedTableManager get buildingsRefs {
    final manager = $$BuildingsTableTableManager($_db, $_db.buildings)
        .filter((f) => f.downloadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_buildingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EntrancesTable, List<Entrance>>
      _entrancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.entrances,
          aliasName:
              $_aliasNameGenerator(db.downloads.id, db.entrances.downloadId));

  $$EntrancesTableProcessedTableManager get entrancesRefs {
    final manager = $$EntrancesTableTableManager($_db, $_db.entrances)
        .filter((f) => f.downloadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_entrancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DwellingsTable, List<Dwelling>>
      _dwellingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.dwellings,
          aliasName:
              $_aliasNameGenerator(db.downloads.id, db.dwellings.downloadId));

  $$DwellingsTableProcessedTableManager get dwellingsRefs {
    final manager = $$DwellingsTableTableManager($_db, $_db.dwellings)
        .filter((f) => f.downloadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dwellingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MunicipalitiesTable, List<Municipality>>
      _municipalitiesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.municipalities,
              aliasName: $_aliasNameGenerator(
                  db.downloads.id, db.municipalities.downloadId));

  $$MunicipalitiesTableProcessedTableManager get municipalitiesRefs {
    final manager = $$MunicipalitiesTableTableManager($_db, $_db.municipalities)
        .filter((f) => f.downloadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_municipalitiesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DownloadsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));

  Expression<bool> buildingsRefs(
      Expression<bool> Function($$BuildingsTableFilterComposer f) f) {
    final $$BuildingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.buildings,
        getReferencedColumn: (t) => t.downloadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BuildingsTableFilterComposer(
              $db: $db,
              $table: $db.buildings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> entrancesRefs(
      Expression<bool> Function($$EntrancesTableFilterComposer f) f) {
    final $$EntrancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entrances,
        getReferencedColumn: (t) => t.downloadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntrancesTableFilterComposer(
              $db: $db,
              $table: $db.entrances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> dwellingsRefs(
      Expression<bool> Function($$DwellingsTableFilterComposer f) f) {
    final $$DwellingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dwellings,
        getReferencedColumn: (t) => t.downloadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DwellingsTableFilterComposer(
              $db: $db,
              $table: $db.dwellings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> municipalitiesRefs(
      Expression<bool> Function($$MunicipalitiesTableFilterComposer f) f) {
    final $$MunicipalitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.municipalities,
        getReferencedColumn: (t) => t.downloadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MunicipalitiesTableFilterComposer(
              $db: $db,
              $table: $db.municipalities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DownloadsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));
}

class $$DownloadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);

  Expression<T> buildingsRefs<T extends Object>(
      Expression<T> Function($$BuildingsTableAnnotationComposer a) f) {
    final $$BuildingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.buildings,
        getReferencedColumn: (t) => t.downloadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BuildingsTableAnnotationComposer(
              $db: $db,
              $table: $db.buildings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> entrancesRefs<T extends Object>(
      Expression<T> Function($$EntrancesTableAnnotationComposer a) f) {
    final $$EntrancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entrances,
        getReferencedColumn: (t) => t.downloadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntrancesTableAnnotationComposer(
              $db: $db,
              $table: $db.entrances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> dwellingsRefs<T extends Object>(
      Expression<T> Function($$DwellingsTableAnnotationComposer a) f) {
    final $$DwellingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dwellings,
        getReferencedColumn: (t) => t.downloadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DwellingsTableAnnotationComposer(
              $db: $db,
              $table: $db.dwellings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> municipalitiesRefs<T extends Object>(
      Expression<T> Function($$MunicipalitiesTableAnnotationComposer a) f) {
    final $$MunicipalitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.municipalities,
        getReferencedColumn: (t) => t.downloadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MunicipalitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.municipalities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DownloadsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadsTable,
    Download,
    $$DownloadsTableFilterComposer,
    $$DownloadsTableOrderingComposer,
    $$DownloadsTableAnnotationComposer,
    $$DownloadsTableCreateCompanionBuilder,
    $$DownloadsTableUpdateCompanionBuilder,
    (Download, $$DownloadsTableReferences),
    Download,
    PrefetchHooks Function(
        {bool buildingsRefs,
        bool entrancesRefs,
        bool dwellingsRefs,
        bool municipalitiesRefs})> {
  $$DownloadsTableTableManager(_$AppDatabase db, $DownloadsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              DownloadsCompanion(
            id: id,
            createdDate: createdDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              DownloadsCompanion.insert(
            id: id,
            createdDate: createdDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DownloadsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {buildingsRefs = false,
              entrancesRefs = false,
              dwellingsRefs = false,
              municipalitiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (buildingsRefs) db.buildings,
                if (entrancesRefs) db.entrances,
                if (dwellingsRefs) db.dwellings,
                if (municipalitiesRefs) db.municipalities
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (buildingsRefs)
                    await $_getPrefetchedData<Download, $DownloadsTable,
                            Building>(
                        currentTable: table,
                        referencedTable:
                            $$DownloadsTableReferences._buildingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DownloadsTableReferences(db, table, p0)
                                .buildingsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.downloadId == item.id),
                        typedResults: items),
                  if (entrancesRefs)
                    await $_getPrefetchedData<Download, $DownloadsTable,
                            Entrance>(
                        currentTable: table,
                        referencedTable:
                            $$DownloadsTableReferences._entrancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DownloadsTableReferences(db, table, p0)
                                .entrancesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.downloadId == item.id),
                        typedResults: items),
                  if (dwellingsRefs)
                    await $_getPrefetchedData<Download, $DownloadsTable,
                            Dwelling>(
                        currentTable: table,
                        referencedTable:
                            $$DownloadsTableReferences._dwellingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DownloadsTableReferences(db, table, p0)
                                .dwellingsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.downloadId == item.id),
                        typedResults: items),
                  if (municipalitiesRefs)
                    await $_getPrefetchedData<Download, $DownloadsTable,
                            Municipality>(
                        currentTable: table,
                        referencedTable: $$DownloadsTableReferences
                            ._municipalitiesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DownloadsTableReferences(db, table, p0)
                                .municipalitiesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.downloadId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DownloadsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadsTable,
    Download,
    $$DownloadsTableFilterComposer,
    $$DownloadsTableOrderingComposer,
    $$DownloadsTableAnnotationComposer,
    $$DownloadsTableCreateCompanionBuilder,
    $$DownloadsTableUpdateCompanionBuilder,
    (Download, $$DownloadsTableReferences),
    Download,
    PrefetchHooks Function(
        {bool buildingsRefs,
        bool entrancesRefs,
        bool dwellingsRefs,
        bool municipalitiesRefs})>;
typedef $$BuildingsTableCreateCompanionBuilder = BuildingsCompanion Function({
  Value<int> id,
  required int objectId,
  required int downloadId,
  required String globalId,
  Value<String?> bldAddressID,
  Value<int?> bldQuality,
  Value<int?> bldMunicipality,
  Value<String?> bldEnumArea,
  Value<double?> bldLatitude,
  Value<double?> bldLongitude,
  Value<int?> bldCadastralZone,
  Value<String?> bldProperty,
  Value<String?> bldPermitNumber,
  Value<DateTime?> bldPermitDate,
  Value<int?> bldStatus,
  Value<int?> bldYearConstruction,
  Value<int?> bldYearDemolition,
  Value<int?> bldType,
  Value<int?> bldClass,
  Value<String?> bldCensus2023,
  Value<double?> bldArea,
  Value<double?> shapeLength,
  Value<double?> shapeArea,
  Value<int?> bldFloorsAbove,
  Value<double?> bldHeight,
  Value<double?> bldVolume,
  Value<int?> bldWasteWater,
  Value<int?> bldElectricity,
  Value<int?> bldPipedGas,
  Value<int?> bldElevator,
  Value<String?> createdUser,
  Value<DateTime?> createdDate,
  Value<String?> lastEditedUser,
  Value<DateTime?> lastEditedDate,
  Value<int?> bldCentroidStatus,
  Value<int?> bldDwellingRecs,
  Value<int?> bldEntranceRecs,
  Value<String?> externalCreator,
  Value<String?> externalEditor,
  Value<int?> bldReview,
  Value<int?> bldWaterSupply,
  Value<DateTime?> externalCreatorDate,
  Value<DateTime?> externalEditorDate,
  Value<String?> geometryType,
  required String coordinates,
});
typedef $$BuildingsTableUpdateCompanionBuilder = BuildingsCompanion Function({
  Value<int> id,
  Value<int> objectId,
  Value<int> downloadId,
  Value<String> globalId,
  Value<String?> bldAddressID,
  Value<int?> bldQuality,
  Value<int?> bldMunicipality,
  Value<String?> bldEnumArea,
  Value<double?> bldLatitude,
  Value<double?> bldLongitude,
  Value<int?> bldCadastralZone,
  Value<String?> bldProperty,
  Value<String?> bldPermitNumber,
  Value<DateTime?> bldPermitDate,
  Value<int?> bldStatus,
  Value<int?> bldYearConstruction,
  Value<int?> bldYearDemolition,
  Value<int?> bldType,
  Value<int?> bldClass,
  Value<String?> bldCensus2023,
  Value<double?> bldArea,
  Value<double?> shapeLength,
  Value<double?> shapeArea,
  Value<int?> bldFloorsAbove,
  Value<double?> bldHeight,
  Value<double?> bldVolume,
  Value<int?> bldWasteWater,
  Value<int?> bldElectricity,
  Value<int?> bldPipedGas,
  Value<int?> bldElevator,
  Value<String?> createdUser,
  Value<DateTime?> createdDate,
  Value<String?> lastEditedUser,
  Value<DateTime?> lastEditedDate,
  Value<int?> bldCentroidStatus,
  Value<int?> bldDwellingRecs,
  Value<int?> bldEntranceRecs,
  Value<String?> externalCreator,
  Value<String?> externalEditor,
  Value<int?> bldReview,
  Value<int?> bldWaterSupply,
  Value<DateTime?> externalCreatorDate,
  Value<DateTime?> externalEditorDate,
  Value<String?> geometryType,
  Value<String> coordinates,
});

final class $$BuildingsTableReferences
    extends BaseReferences<_$AppDatabase, $BuildingsTable, Building> {
  $$BuildingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DownloadsTable _downloadIdTable(_$AppDatabase db) =>
      db.downloads.createAlias(
          $_aliasNameGenerator(db.buildings.downloadId, db.downloads.id));

  $$DownloadsTableProcessedTableManager get downloadId {
    final $_column = $_itemColumn<int>('download_id')!;

    final manager = $$DownloadsTableTableManager($_db, $_db.downloads)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_downloadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$EntrancesTable, List<Entrance>>
      _entrancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.entrances,
              aliasName: $_aliasNameGenerator(
                  db.buildings.globalId, db.entrances.entBldGlobalId));

  $$EntrancesTableProcessedTableManager get entrancesRefs {
    final manager = $$EntrancesTableTableManager($_db, $_db.entrances).filter(
        (f) => f.entBldGlobalId.globalId
            .sqlEquals($_itemColumn<String>('global_id')!));

    final cache = $_typedResult.readTableOrNull(_entrancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BuildingsTableFilterComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bldAddressID => $composableBuilder(
      column: $table.bldAddressID, builder: (column) => ColumnFilters(column));

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

  ColumnFilters<String> get bldCensus2023 => $composableBuilder(
      column: $table.bldCensus2023, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bldArea => $composableBuilder(
      column: $table.bldArea, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get shapeLength => $composableBuilder(
      column: $table.shapeLength, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get shapeArea => $composableBuilder(
      column: $table.shapeArea, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bldFloorsAbove => $composableBuilder(
      column: $table.bldFloorsAbove,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bldHeight => $composableBuilder(
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

  ColumnFilters<String> get geometryType => $composableBuilder(
      column: $table.geometryType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coordinates => $composableBuilder(
      column: $table.coordinates, builder: (column) => ColumnFilters(column));

  $$DownloadsTableFilterComposer get downloadId {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableFilterComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> entrancesRefs(
      Expression<bool> Function($$EntrancesTableFilterComposer f) f) {
    final $$EntrancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.globalId,
        referencedTable: $db.entrances,
        getReferencedColumn: (t) => t.entBldGlobalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntrancesTableFilterComposer(
              $db: $db,
              $table: $db.entrances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bldAddressID => $composableBuilder(
      column: $table.bldAddressID,
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

  ColumnOrderings<String> get bldCensus2023 => $composableBuilder(
      column: $table.bldCensus2023,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bldArea => $composableBuilder(
      column: $table.bldArea, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get shapeLength => $composableBuilder(
      column: $table.shapeLength, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get shapeArea => $composableBuilder(
      column: $table.shapeArea, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bldFloorsAbove => $composableBuilder(
      column: $table.bldFloorsAbove,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bldHeight => $composableBuilder(
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

  ColumnOrderings<String> get geometryType => $composableBuilder(
      column: $table.geometryType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coordinates => $composableBuilder(
      column: $table.coordinates, builder: (column) => ColumnOrderings(column));

  $$DownloadsTableOrderingComposer get downloadId {
    final $$DownloadsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableOrderingComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get objectId =>
      $composableBuilder(column: $table.objectId, builder: (column) => column);

  GeneratedColumn<String> get globalId =>
      $composableBuilder(column: $table.globalId, builder: (column) => column);

  GeneratedColumn<String> get bldAddressID => $composableBuilder(
      column: $table.bldAddressID, builder: (column) => column);

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

  GeneratedColumn<String> get bldCensus2023 => $composableBuilder(
      column: $table.bldCensus2023, builder: (column) => column);

  GeneratedColumn<double> get bldArea =>
      $composableBuilder(column: $table.bldArea, builder: (column) => column);

  GeneratedColumn<double> get shapeLength => $composableBuilder(
      column: $table.shapeLength, builder: (column) => column);

  GeneratedColumn<double> get shapeArea =>
      $composableBuilder(column: $table.shapeArea, builder: (column) => column);

  GeneratedColumn<int> get bldFloorsAbove => $composableBuilder(
      column: $table.bldFloorsAbove, builder: (column) => column);

  GeneratedColumn<double> get bldHeight =>
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

  GeneratedColumn<String> get geometryType => $composableBuilder(
      column: $table.geometryType, builder: (column) => column);

  GeneratedColumn<String> get coordinates => $composableBuilder(
      column: $table.coordinates, builder: (column) => column);

  $$DownloadsTableAnnotationComposer get downloadId {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableAnnotationComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> entrancesRefs<T extends Object>(
      Expression<T> Function($$EntrancesTableAnnotationComposer a) f) {
    final $$EntrancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.globalId,
        referencedTable: $db.entrances,
        getReferencedColumn: (t) => t.entBldGlobalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntrancesTableAnnotationComposer(
              $db: $db,
              $table: $db.entrances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
    (Building, $$BuildingsTableReferences),
    Building,
    PrefetchHooks Function({bool downloadId, bool entrancesRefs})> {
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
            Value<int> id = const Value.absent(),
            Value<int> objectId = const Value.absent(),
            Value<int> downloadId = const Value.absent(),
            Value<String> globalId = const Value.absent(),
            Value<String?> bldAddressID = const Value.absent(),
            Value<int?> bldQuality = const Value.absent(),
            Value<int?> bldMunicipality = const Value.absent(),
            Value<String?> bldEnumArea = const Value.absent(),
            Value<double?> bldLatitude = const Value.absent(),
            Value<double?> bldLongitude = const Value.absent(),
            Value<int?> bldCadastralZone = const Value.absent(),
            Value<String?> bldProperty = const Value.absent(),
            Value<String?> bldPermitNumber = const Value.absent(),
            Value<DateTime?> bldPermitDate = const Value.absent(),
            Value<int?> bldStatus = const Value.absent(),
            Value<int?> bldYearConstruction = const Value.absent(),
            Value<int?> bldYearDemolition = const Value.absent(),
            Value<int?> bldType = const Value.absent(),
            Value<int?> bldClass = const Value.absent(),
            Value<String?> bldCensus2023 = const Value.absent(),
            Value<double?> bldArea = const Value.absent(),
            Value<double?> shapeLength = const Value.absent(),
            Value<double?> shapeArea = const Value.absent(),
            Value<int?> bldFloorsAbove = const Value.absent(),
            Value<double?> bldHeight = const Value.absent(),
            Value<double?> bldVolume = const Value.absent(),
            Value<int?> bldWasteWater = const Value.absent(),
            Value<int?> bldElectricity = const Value.absent(),
            Value<int?> bldPipedGas = const Value.absent(),
            Value<int?> bldElevator = const Value.absent(),
            Value<String?> createdUser = const Value.absent(),
            Value<DateTime?> createdDate = const Value.absent(),
            Value<String?> lastEditedUser = const Value.absent(),
            Value<DateTime?> lastEditedDate = const Value.absent(),
            Value<int?> bldCentroidStatus = const Value.absent(),
            Value<int?> bldDwellingRecs = const Value.absent(),
            Value<int?> bldEntranceRecs = const Value.absent(),
            Value<String?> externalCreator = const Value.absent(),
            Value<String?> externalEditor = const Value.absent(),
            Value<int?> bldReview = const Value.absent(),
            Value<int?> bldWaterSupply = const Value.absent(),
            Value<DateTime?> externalCreatorDate = const Value.absent(),
            Value<DateTime?> externalEditorDate = const Value.absent(),
            Value<String?> geometryType = const Value.absent(),
            Value<String> coordinates = const Value.absent(),
          }) =>
              BuildingsCompanion(
            id: id,
            objectId: objectId,
            downloadId: downloadId,
            globalId: globalId,
            bldAddressID: bldAddressID,
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
            bldCensus2023: bldCensus2023,
            bldArea: bldArea,
            shapeLength: shapeLength,
            shapeArea: shapeArea,
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
            externalCreator: externalCreator,
            externalEditor: externalEditor,
            bldReview: bldReview,
            bldWaterSupply: bldWaterSupply,
            externalCreatorDate: externalCreatorDate,
            externalEditorDate: externalEditorDate,
            geometryType: geometryType,
            coordinates: coordinates,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int objectId,
            required int downloadId,
            required String globalId,
            Value<String?> bldAddressID = const Value.absent(),
            Value<int?> bldQuality = const Value.absent(),
            Value<int?> bldMunicipality = const Value.absent(),
            Value<String?> bldEnumArea = const Value.absent(),
            Value<double?> bldLatitude = const Value.absent(),
            Value<double?> bldLongitude = const Value.absent(),
            Value<int?> bldCadastralZone = const Value.absent(),
            Value<String?> bldProperty = const Value.absent(),
            Value<String?> bldPermitNumber = const Value.absent(),
            Value<DateTime?> bldPermitDate = const Value.absent(),
            Value<int?> bldStatus = const Value.absent(),
            Value<int?> bldYearConstruction = const Value.absent(),
            Value<int?> bldYearDemolition = const Value.absent(),
            Value<int?> bldType = const Value.absent(),
            Value<int?> bldClass = const Value.absent(),
            Value<String?> bldCensus2023 = const Value.absent(),
            Value<double?> bldArea = const Value.absent(),
            Value<double?> shapeLength = const Value.absent(),
            Value<double?> shapeArea = const Value.absent(),
            Value<int?> bldFloorsAbove = const Value.absent(),
            Value<double?> bldHeight = const Value.absent(),
            Value<double?> bldVolume = const Value.absent(),
            Value<int?> bldWasteWater = const Value.absent(),
            Value<int?> bldElectricity = const Value.absent(),
            Value<int?> bldPipedGas = const Value.absent(),
            Value<int?> bldElevator = const Value.absent(),
            Value<String?> createdUser = const Value.absent(),
            Value<DateTime?> createdDate = const Value.absent(),
            Value<String?> lastEditedUser = const Value.absent(),
            Value<DateTime?> lastEditedDate = const Value.absent(),
            Value<int?> bldCentroidStatus = const Value.absent(),
            Value<int?> bldDwellingRecs = const Value.absent(),
            Value<int?> bldEntranceRecs = const Value.absent(),
            Value<String?> externalCreator = const Value.absent(),
            Value<String?> externalEditor = const Value.absent(),
            Value<int?> bldReview = const Value.absent(),
            Value<int?> bldWaterSupply = const Value.absent(),
            Value<DateTime?> externalCreatorDate = const Value.absent(),
            Value<DateTime?> externalEditorDate = const Value.absent(),
            Value<String?> geometryType = const Value.absent(),
            required String coordinates,
          }) =>
              BuildingsCompanion.insert(
            id: id,
            objectId: objectId,
            downloadId: downloadId,
            globalId: globalId,
            bldAddressID: bldAddressID,
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
            bldCensus2023: bldCensus2023,
            bldArea: bldArea,
            shapeLength: shapeLength,
            shapeArea: shapeArea,
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
            externalCreator: externalCreator,
            externalEditor: externalEditor,
            bldReview: bldReview,
            bldWaterSupply: bldWaterSupply,
            externalCreatorDate: externalCreatorDate,
            externalEditorDate: externalEditorDate,
            geometryType: geometryType,
            coordinates: coordinates,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BuildingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({downloadId = false, entrancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entrancesRefs) db.entrances],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (downloadId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.downloadId,
                    referencedTable:
                        $$BuildingsTableReferences._downloadIdTable(db),
                    referencedColumn:
                        $$BuildingsTableReferences._downloadIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entrancesRefs)
                    await $_getPrefetchedData<Building, $BuildingsTable,
                            Entrance>(
                        currentTable: table,
                        referencedTable:
                            $$BuildingsTableReferences._entrancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BuildingsTableReferences(db, table, p0)
                                .entrancesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.entBldGlobalId == item.globalId),
                        typedResults: items)
                ];
              },
            );
          },
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
    (Building, $$BuildingsTableReferences),
    Building,
    PrefetchHooks Function({bool downloadId, bool entrancesRefs})>;
typedef $$EntrancesTableCreateCompanionBuilder = EntrancesCompanion Function({
  Value<int> id,
  required int downloadId,
  required String globalId,
  required String entBldGlobalId,
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
  Value<String?> geometryType,
  required String coordinates,
});
typedef $$EntrancesTableUpdateCompanionBuilder = EntrancesCompanion Function({
  Value<int> id,
  Value<int> downloadId,
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
  Value<String?> geometryType,
  Value<String> coordinates,
});

final class $$EntrancesTableReferences
    extends BaseReferences<_$AppDatabase, $EntrancesTable, Entrance> {
  $$EntrancesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DownloadsTable _downloadIdTable(_$AppDatabase db) =>
      db.downloads.createAlias(
          $_aliasNameGenerator(db.entrances.downloadId, db.downloads.id));

  $$DownloadsTableProcessedTableManager get downloadId {
    final $_column = $_itemColumn<int>('download_id')!;

    final manager = $$DownloadsTableTableManager($_db, $_db.downloads)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_downloadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $BuildingsTable _entBldGlobalIdTable(_$AppDatabase db) =>
      db.buildings.createAlias($_aliasNameGenerator(
          db.entrances.entBldGlobalId, db.buildings.globalId));

  $$BuildingsTableProcessedTableManager get entBldGlobalId {
    final $_column = $_itemColumn<String>('ent_bld_global_id')!;

    final manager = $$BuildingsTableTableManager($_db, $_db.buildings)
        .filter((f) => f.globalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entBldGlobalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DwellingsTable, List<Dwelling>>
      _dwellingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dwellings,
              aliasName: $_aliasNameGenerator(
                  db.entrances.globalId, db.dwellings.dwlEntGlobalId));

  $$DwellingsTableProcessedTableManager get dwellingsRefs {
    final manager = $$DwellingsTableTableManager($_db, $_db.dwellings).filter(
        (f) => f.dwlEntGlobalId.globalId
            .sqlEquals($_itemColumn<String>('global_id')!));

    final cache = $_typedResult.readTableOrNull(_dwellingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EntrancesTableFilterComposer
    extends Composer<_$AppDatabase, $EntrancesTable> {
  $$EntrancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnFilters(column));

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

  ColumnFilters<String> get geometryType => $composableBuilder(
      column: $table.geometryType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coordinates => $composableBuilder(
      column: $table.coordinates, builder: (column) => ColumnFilters(column));

  $$DownloadsTableFilterComposer get downloadId {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableFilterComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BuildingsTableFilterComposer get entBldGlobalId {
    final $$BuildingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entBldGlobalId,
        referencedTable: $db.buildings,
        getReferencedColumn: (t) => t.globalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BuildingsTableFilterComposer(
              $db: $db,
              $table: $db.buildings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> dwellingsRefs(
      Expression<bool> Function($$DwellingsTableFilterComposer f) f) {
    final $$DwellingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.globalId,
        referencedTable: $db.dwellings,
        getReferencedColumn: (t) => t.dwlEntGlobalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DwellingsTableFilterComposer(
              $db: $db,
              $table: $db.dwellings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnOrderings(column));

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

  ColumnOrderings<String> get geometryType => $composableBuilder(
      column: $table.geometryType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coordinates => $composableBuilder(
      column: $table.coordinates, builder: (column) => ColumnOrderings(column));

  $$DownloadsTableOrderingComposer get downloadId {
    final $$DownloadsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableOrderingComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BuildingsTableOrderingComposer get entBldGlobalId {
    final $$BuildingsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entBldGlobalId,
        referencedTable: $db.buildings,
        getReferencedColumn: (t) => t.globalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BuildingsTableOrderingComposer(
              $db: $db,
              $table: $db.buildings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get globalId =>
      $composableBuilder(column: $table.globalId, builder: (column) => column);

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

  GeneratedColumn<String> get geometryType => $composableBuilder(
      column: $table.geometryType, builder: (column) => column);

  GeneratedColumn<String> get coordinates => $composableBuilder(
      column: $table.coordinates, builder: (column) => column);

  $$DownloadsTableAnnotationComposer get downloadId {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableAnnotationComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BuildingsTableAnnotationComposer get entBldGlobalId {
    final $$BuildingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entBldGlobalId,
        referencedTable: $db.buildings,
        getReferencedColumn: (t) => t.globalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BuildingsTableAnnotationComposer(
              $db: $db,
              $table: $db.buildings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> dwellingsRefs<T extends Object>(
      Expression<T> Function($$DwellingsTableAnnotationComposer a) f) {
    final $$DwellingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.globalId,
        referencedTable: $db.dwellings,
        getReferencedColumn: (t) => t.dwlEntGlobalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DwellingsTableAnnotationComposer(
              $db: $db,
              $table: $db.dwellings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
    (Entrance, $$EntrancesTableReferences),
    Entrance,
    PrefetchHooks Function(
        {bool downloadId, bool entBldGlobalId, bool dwellingsRefs})> {
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
            Value<int> id = const Value.absent(),
            Value<int> downloadId = const Value.absent(),
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
            Value<String?> geometryType = const Value.absent(),
            Value<String> coordinates = const Value.absent(),
          }) =>
              EntrancesCompanion(
            id: id,
            downloadId: downloadId,
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
            geometryType: geometryType,
            coordinates: coordinates,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int downloadId,
            required String globalId,
            required String entBldGlobalId,
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
            Value<String?> geometryType = const Value.absent(),
            required String coordinates,
          }) =>
              EntrancesCompanion.insert(
            id: id,
            downloadId: downloadId,
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
            geometryType: geometryType,
            coordinates: coordinates,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EntrancesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {downloadId = false,
              entBldGlobalId = false,
              dwellingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (dwellingsRefs) db.dwellings],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (downloadId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.downloadId,
                    referencedTable:
                        $$EntrancesTableReferences._downloadIdTable(db),
                    referencedColumn:
                        $$EntrancesTableReferences._downloadIdTable(db).id,
                  ) as T;
                }
                if (entBldGlobalId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entBldGlobalId,
                    referencedTable:
                        $$EntrancesTableReferences._entBldGlobalIdTable(db),
                    referencedColumn: $$EntrancesTableReferences
                        ._entBldGlobalIdTable(db)
                        .globalId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dwellingsRefs)
                    await $_getPrefetchedData<Entrance, $EntrancesTable,
                            Dwelling>(
                        currentTable: table,
                        referencedTable:
                            $$EntrancesTableReferences._dwellingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntrancesTableReferences(db, table, p0)
                                .dwellingsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.dwlEntGlobalId == item.globalId),
                        typedResults: items)
                ];
              },
            );
          },
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
    (Entrance, $$EntrancesTableReferences),
    Entrance,
    PrefetchHooks Function(
        {bool downloadId, bool entBldGlobalId, bool dwellingsRefs})>;
typedef $$DwellingsTableCreateCompanionBuilder = DwellingsCompanion Function({
  Value<int> id,
  required int downloadId,
  required int objectId,
  required String globalId,
  required String dwlEntGlobalId,
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
  Value<String?> geometryType,
});
typedef $$DwellingsTableUpdateCompanionBuilder = DwellingsCompanion Function({
  Value<int> id,
  Value<int> downloadId,
  Value<int> objectId,
  Value<String> globalId,
  Value<String> dwlEntGlobalId,
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
  Value<String?> geometryType,
});

final class $$DwellingsTableReferences
    extends BaseReferences<_$AppDatabase, $DwellingsTable, Dwelling> {
  $$DwellingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DownloadsTable _downloadIdTable(_$AppDatabase db) =>
      db.downloads.createAlias(
          $_aliasNameGenerator(db.dwellings.downloadId, db.downloads.id));

  $$DownloadsTableProcessedTableManager get downloadId {
    final $_column = $_itemColumn<int>('download_id')!;

    final manager = $$DownloadsTableTableManager($_db, $_db.downloads)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_downloadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $EntrancesTable _dwlEntGlobalIdTable(_$AppDatabase db) =>
      db.entrances.createAlias($_aliasNameGenerator(
          db.dwellings.dwlEntGlobalId, db.entrances.globalId));

  $$EntrancesTableProcessedTableManager get dwlEntGlobalId {
    final $_column = $_itemColumn<String>('dwl_ent_global_id')!;

    final manager = $$EntrancesTableTableManager($_db, $_db.entrances)
        .filter((f) => f.globalId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dwlEntGlobalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DwellingsTableFilterComposer
    extends Composer<_$AppDatabase, $DwellingsTable> {
  $$DwellingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnFilters(column));

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

  ColumnFilters<String> get geometryType => $composableBuilder(
      column: $table.geometryType, builder: (column) => ColumnFilters(column));

  $$DownloadsTableFilterComposer get downloadId {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableFilterComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntrancesTableFilterComposer get dwlEntGlobalId {
    final $$EntrancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dwlEntGlobalId,
        referencedTable: $db.entrances,
        getReferencedColumn: (t) => t.globalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntrancesTableFilterComposer(
              $db: $db,
              $table: $db.entrances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get globalId => $composableBuilder(
      column: $table.globalId, builder: (column) => ColumnOrderings(column));

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

  ColumnOrderings<String> get geometryType => $composableBuilder(
      column: $table.geometryType,
      builder: (column) => ColumnOrderings(column));

  $$DownloadsTableOrderingComposer get downloadId {
    final $$DownloadsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableOrderingComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntrancesTableOrderingComposer get dwlEntGlobalId {
    final $$EntrancesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dwlEntGlobalId,
        referencedTable: $db.entrances,
        getReferencedColumn: (t) => t.globalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntrancesTableOrderingComposer(
              $db: $db,
              $table: $db.entrances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get objectId =>
      $composableBuilder(column: $table.objectId, builder: (column) => column);

  GeneratedColumn<String> get globalId =>
      $composableBuilder(column: $table.globalId, builder: (column) => column);

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

  GeneratedColumn<String> get geometryType => $composableBuilder(
      column: $table.geometryType, builder: (column) => column);

  $$DownloadsTableAnnotationComposer get downloadId {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableAnnotationComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntrancesTableAnnotationComposer get dwlEntGlobalId {
    final $$EntrancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dwlEntGlobalId,
        referencedTable: $db.entrances,
        getReferencedColumn: (t) => t.globalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntrancesTableAnnotationComposer(
              $db: $db,
              $table: $db.entrances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (Dwelling, $$DwellingsTableReferences),
    Dwelling,
    PrefetchHooks Function({bool downloadId, bool dwlEntGlobalId})> {
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
            Value<int> id = const Value.absent(),
            Value<int> downloadId = const Value.absent(),
            Value<int> objectId = const Value.absent(),
            Value<String> globalId = const Value.absent(),
            Value<String> dwlEntGlobalId = const Value.absent(),
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
            Value<String?> geometryType = const Value.absent(),
          }) =>
              DwellingsCompanion(
            id: id,
            downloadId: downloadId,
            objectId: objectId,
            globalId: globalId,
            dwlEntGlobalId: dwlEntGlobalId,
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
            geometryType: geometryType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int downloadId,
            required int objectId,
            required String globalId,
            required String dwlEntGlobalId,
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
            Value<String?> geometryType = const Value.absent(),
          }) =>
              DwellingsCompanion.insert(
            id: id,
            downloadId: downloadId,
            objectId: objectId,
            globalId: globalId,
            dwlEntGlobalId: dwlEntGlobalId,
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
            geometryType: geometryType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DwellingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {downloadId = false, dwlEntGlobalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (downloadId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.downloadId,
                    referencedTable:
                        $$DwellingsTableReferences._downloadIdTable(db),
                    referencedColumn:
                        $$DwellingsTableReferences._downloadIdTable(db).id,
                  ) as T;
                }
                if (dwlEntGlobalId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dwlEntGlobalId,
                    referencedTable:
                        $$DwellingsTableReferences._dwlEntGlobalIdTable(db),
                    referencedColumn: $$DwellingsTableReferences
                        ._dwlEntGlobalIdTable(db)
                        .globalId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
    (Dwelling, $$DwellingsTableReferences),
    Dwelling,
    PrefetchHooks Function({bool downloadId, bool dwlEntGlobalId})>;
typedef $$MunicipalitiesTableCreateCompanionBuilder = MunicipalitiesCompanion
    Function({
  Value<int> id,
  required int objectId,
  required String municipalityId,
  required int downloadId,
  Value<String?> municipalityName,
  required String coordinates,
});
typedef $$MunicipalitiesTableUpdateCompanionBuilder = MunicipalitiesCompanion
    Function({
  Value<int> id,
  Value<int> objectId,
  Value<String> municipalityId,
  Value<int> downloadId,
  Value<String?> municipalityName,
  Value<String> coordinates,
});

final class $$MunicipalitiesTableReferences
    extends BaseReferences<_$AppDatabase, $MunicipalitiesTable, Municipality> {
  $$MunicipalitiesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DownloadsTable _downloadIdTable(_$AppDatabase db) =>
      db.downloads.createAlias(
          $_aliasNameGenerator(db.municipalities.downloadId, db.downloads.id));

  $$DownloadsTableProcessedTableManager get downloadId {
    final $_column = $_itemColumn<int>('download_id')!;

    final manager = $$DownloadsTableTableManager($_db, $_db.downloads)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_downloadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MunicipalitiesTableFilterComposer
    extends Composer<_$AppDatabase, $MunicipalitiesTable> {
  $$MunicipalitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get municipalityId => $composableBuilder(
      column: $table.municipalityId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get municipalityName => $composableBuilder(
      column: $table.municipalityName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coordinates => $composableBuilder(
      column: $table.coordinates, builder: (column) => ColumnFilters(column));

  $$DownloadsTableFilterComposer get downloadId {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableFilterComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MunicipalitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $MunicipalitiesTable> {
  $$MunicipalitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get objectId => $composableBuilder(
      column: $table.objectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get municipalityId => $composableBuilder(
      column: $table.municipalityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get municipalityName => $composableBuilder(
      column: $table.municipalityName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coordinates => $composableBuilder(
      column: $table.coordinates, builder: (column) => ColumnOrderings(column));

  $$DownloadsTableOrderingComposer get downloadId {
    final $$DownloadsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableOrderingComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MunicipalitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MunicipalitiesTable> {
  $$MunicipalitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get objectId =>
      $composableBuilder(column: $table.objectId, builder: (column) => column);

  GeneratedColumn<String> get municipalityId => $composableBuilder(
      column: $table.municipalityId, builder: (column) => column);

  GeneratedColumn<String> get municipalityName => $composableBuilder(
      column: $table.municipalityName, builder: (column) => column);

  GeneratedColumn<String> get coordinates => $composableBuilder(
      column: $table.coordinates, builder: (column) => column);

  $$DownloadsTableAnnotationComposer get downloadId {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.downloadId,
        referencedTable: $db.downloads,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadsTableAnnotationComposer(
              $db: $db,
              $table: $db.downloads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MunicipalitiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MunicipalitiesTable,
    Municipality,
    $$MunicipalitiesTableFilterComposer,
    $$MunicipalitiesTableOrderingComposer,
    $$MunicipalitiesTableAnnotationComposer,
    $$MunicipalitiesTableCreateCompanionBuilder,
    $$MunicipalitiesTableUpdateCompanionBuilder,
    (Municipality, $$MunicipalitiesTableReferences),
    Municipality,
    PrefetchHooks Function({bool downloadId})> {
  $$MunicipalitiesTableTableManager(
      _$AppDatabase db, $MunicipalitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MunicipalitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MunicipalitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MunicipalitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> objectId = const Value.absent(),
            Value<String> municipalityId = const Value.absent(),
            Value<int> downloadId = const Value.absent(),
            Value<String?> municipalityName = const Value.absent(),
            Value<String> coordinates = const Value.absent(),
          }) =>
              MunicipalitiesCompanion(
            id: id,
            objectId: objectId,
            municipalityId: municipalityId,
            downloadId: downloadId,
            municipalityName: municipalityName,
            coordinates: coordinates,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int objectId,
            required String municipalityId,
            required int downloadId,
            Value<String?> municipalityName = const Value.absent(),
            required String coordinates,
          }) =>
              MunicipalitiesCompanion.insert(
            id: id,
            objectId: objectId,
            municipalityId: municipalityId,
            downloadId: downloadId,
            municipalityName: municipalityName,
            coordinates: coordinates,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MunicipalitiesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({downloadId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (downloadId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.downloadId,
                    referencedTable:
                        $$MunicipalitiesTableReferences._downloadIdTable(db),
                    referencedColumn:
                        $$MunicipalitiesTableReferences._downloadIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MunicipalitiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MunicipalitiesTable,
    Municipality,
    $$MunicipalitiesTableFilterComposer,
    $$MunicipalitiesTableOrderingComposer,
    $$MunicipalitiesTableAnnotationComposer,
    $$MunicipalitiesTableCreateCompanionBuilder,
    $$MunicipalitiesTableUpdateCompanionBuilder,
    (Municipality, $$MunicipalitiesTableReferences),
    Municipality,
    PrefetchHooks Function({bool downloadId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DownloadsTableTableManager get downloads =>
      $$DownloadsTableTableManager(_db, _db.downloads);
  $$BuildingsTableTableManager get buildings =>
      $$BuildingsTableTableManager(_db, _db.buildings);
  $$EntrancesTableTableManager get entrances =>
      $$EntrancesTableTableManager(_db, _db.entrances);
  $$DwellingsTableTableManager get dwellings =>
      $$DwellingsTableTableManager(_db, _db.dwellings);
  $$MunicipalitiesTableTableManager get municipalities =>
      $$MunicipalitiesTableTableManager(_db, _db.municipalities);
}
