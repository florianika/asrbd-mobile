import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/general_fields.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';

abstract class AttributesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttributesInitial extends AttributesState {}

class AttributesLoading extends AttributesState {}

class Attributes extends AttributesState {
  final List<FieldSchema> schema;
  final Map<String, dynamic> initialData;
  final ShapeType shapeType;
  final bool viewDwelling;
  final bool showAttributes;
  final String? buildingGlobalId;
  final String? entranceGlobalId;
  final int? dwellingObjectId;

  Attributes(
    this.schema,
    this.initialData,
    this.shapeType,
    this.buildingGlobalId,
    this.entranceGlobalId,
    this.dwellingObjectId, {
    this.viewDwelling = false,
    this.showAttributes = false,
  });

  @override
  List<Object?> get props => [
        schema,
        initialData,
        shapeType,
        buildingGlobalId,
        entranceGlobalId,
        dwellingObjectId,
        viewDwelling,
        showAttributes,
      ];

  Attributes copyWith({
    List<FieldSchema>? schema,
    Map<String, dynamic>? initialData,
    ShapeType? shapeType,
    String? buildingGlobalId,
    String? entranceGlobalId,
    int? dwellingObjectId,
    bool? viewDwelling,
    bool? showAttributes,
  }) {
    return Attributes(
      schema ?? this.schema,
      initialData ?? this.initialData,
      shapeType ?? this.shapeType,
      buildingGlobalId ?? this.buildingGlobalId,
      entranceGlobalId ?? this.entranceGlobalId,
      dwellingObjectId ?? this.dwellingObjectId,
      viewDwelling: viewDwelling ?? this.viewDwelling,
      showAttributes: showAttributes ?? this.showAttributes,
    );
  }
}

class AttributesError extends AttributesState {
  final String message;
  AttributesError(this.message);

  @override
  List<Object?> get props => [message];
}

class AttributesCubit extends Cubit<AttributesState> {
  final EntranceUseCases entranceUseCases;
  final BuildingUseCases buildingUseCases;
  final DwellingUseCases dwellingUseCases;

  bool showLoading = true;

  AttributesCubit(
    this.entranceUseCases,
    this.buildingUseCases,
    this.dwellingUseCases,
  ) : super(Attributes(const [], const {}, ShapeType.point, null, null, null));

  void setShowLoading(bool value) {
    showLoading = value;
  }

  void toggleAttributesVisibility(bool showAttributes) {
    final currentState = state;
    if (currentState is Attributes) {
      emit(currentState.copyWith(showAttributes: showAttributes));
    } else {
      emit(Attributes(
        const [],
        const {},
        ShapeType.point,
        null,
        null,
        null,
        showAttributes: showAttributes,
      ));
    }
  }

  void showAttributes(bool show) {
    toggleAttributesVisibility(show);
  }

  Future<void> showDwellingAttributes(int? dwellingObjectID) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await dwellingUseCases.getDwellingAttibutes();
      if (dwellingObjectID == null) {
        emit(Attributes(
          schema,
          const {},
          ShapeType.noShape,
          null,
          null,
          null,
          viewDwelling: true,
          showAttributes: true,
        ));
        return;
      }

      final data = await dwellingUseCases.getDwellingDetails(dwellingObjectID);
      final features = data[GeneralFields.features] ?? [];
      final props =
          features.isNotEmpty ? features[0][GeneralFields.properties] : {};
      emit(Attributes(
        schema,
        props,
        ShapeType.noShape,
        null,
        null,
        dwellingObjectID,
        viewDwelling: true,
        showAttributes: true,
      ));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> showEntranceAttributes(
      String? entranceGlobalID, String? buildingGlobalID) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await entranceUseCases.getEntranceAttributes();
      if (entranceGlobalID == null) {
        emit(Attributes(
          schema,
          {EntranceFields.entBldGlobalID: buildingGlobalID},
          ShapeType.point,
          buildingGlobalID,
          entranceGlobalID,
          null,
          showAttributes: true,
        ));
        return;
      }

      final data = await entranceUseCases.getEntranceDetails(entranceGlobalID);
      final features = data[GeneralFields.features] ?? [];
      final props =
          features.isNotEmpty ? features[0][GeneralFields.properties] : {};
      emit(Attributes(
        schema,
        props,
        ShapeType.point,
        props[EntranceFields.entBldGlobalID] ?? buildingGlobalID,
        entranceGlobalID,
        null,
        showAttributes: true,
      ));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> showBuildingAttributes(String? buildingGlobalID) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await buildingUseCases.getBuildingAttibutes();
      if (buildingGlobalID == null) {
        emit(Attributes(
          schema,
          const {},
          ShapeType.polygon,
          null,
          null,
          null,
          showAttributes: true,
        ));
        return;
      }

      final building =
          await buildingUseCases.getBuildingDetails(buildingGlobalID);

      emit(Attributes(
        schema,
        building.toMap(),
        ShapeType.polygon,
        buildingGlobalID,
        null,
        null,
        showAttributes: true,
      ));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  String? get currentBuildingGlobalId =>
      state is Attributes ? (state as Attributes).buildingGlobalId : null;

  String? get currentEntranceGlobalId =>
      state is Attributes ? (state as Attributes).entranceGlobalId : null;

  int? get currentDwellingObjectId =>
      state is Attributes ? (state as Attributes).dwellingObjectId : null;

  ShapeType get shapeType =>
      state is Attributes ? (state as Attributes).shapeType : ShapeType.point;

  bool get isShowingAttributes =>
      state is Attributes ? (state as Attributes).showAttributes : false;

  void clearSelections() {
    toggleAttributesVisibility(false);
  }
}

// import 'package:asrdb/core/models/entrance/entrance_fields.dart';
// import 'package:asrdb/core/models/general_fields.dart';
// import 'package:asrdb/domain/entities/building_entity.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:asrdb/core/enums/shape_type.dart';
// import 'package:asrdb/core/models/attributes/field_schema.dart';
// import 'package:asrdb/features/home/domain/building_usecases.dart';
// import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
// import 'package:asrdb/features/home/domain/entrance_usecases.dart';

// abstract class AttributesState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class AttributesInitial extends AttributesState {}

// class AttributesLoading extends AttributesState {}

// class Attributes extends AttributesState {
//   final List<FieldSchema> schema;
//   final Map<String, dynamic> initialData;
//   final ShapeType shapeType;
//   final bool viewDwelling;
//   final String? buildingGlobalId;
//   final String? entranceGlobalId;
//   final int? dwellingObjectId;

//   Attributes(
//     this.schema,
//     this.initialData,
//     this.shapeType,
//     this.buildingGlobalId,
//     this.entranceGlobalId,
//     this.dwellingObjectId, {
//     this.viewDwelling = false,
//   });

//   @override
//   List<Object?> get props => [
//         schema,
//         initialData,
//         shapeType,
//         buildingGlobalId,
//         entranceGlobalId,
//         dwellingObjectId,
//         viewDwelling,
//       ];
// }

// class AttributesError extends AttributesState {
//   final String message;
//   AttributesError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class AttributesVisibility extends AttributesState {
//   final bool showAttributes;
//   AttributesVisibility(this.showAttributes);

//   @override
//   List<Object?> get props => [showAttributes];
// }

// class AttributesCubit extends Cubit<AttributesState> {
//   final EntranceUseCases entranceUseCases;
//   final BuildingUseCases buildingUseCases;
//   final DwellingUseCases dwellingUseCases;

//   bool showLoading = true;

//   AttributesCubit(
//     this.entranceUseCases,
//     this.buildingUseCases,
//     this.dwellingUseCases,
//   ) : super(AttributesVisibility(false));

//   void setShowLoading(bool value) {
//     showLoading = value;
//   }

//   void showAttributes(bool showAttributes) {
//     if (!showAttributes) {
//       emit(Attributes(const [], const {}, ShapeType.point, null, null, null));
//     }
//     emit(AttributesVisibility(showAttributes));
//   }

//   Future<void> showDwellingAttributes(int? dwellingObjectID) async {
//     if (showLoading) emit(AttributesLoading());
//     try {
//       final schema = await dwellingUseCases.getDwellingAttibutes();
//       if (dwellingObjectID == null) {
//         emit(Attributes(schema, const {}, ShapeType.noShape, null, null, null,
//             viewDwelling: true));
//         return;
//       }

//       final data = await dwellingUseCases.getDwellingDetails(dwellingObjectID);
//       final features = data[GeneralFields.features] ?? [];
//       final props =
//           features.isNotEmpty ? features[0][GeneralFields.properties] : {};
//       emit(Attributes(
//         schema,
//         props,
//         ShapeType.noShape,
//         null,
//         null,
//         dwellingObjectID,
//         viewDwelling: true,
//       ));
//     } catch (e) {
//       emit(AttributesError(e.toString()));
//     }
//   }

//   Future<void> showEntranceAttributes(
//       String? entranceGlobalID, String? buildingGlobalID) async {
//     if (showLoading) emit(AttributesLoading());
//     try {
//       final schema = await entranceUseCases.getEntranceAttributes();
//       if (entranceGlobalID == null) {
//         emit(Attributes(
//             schema,
//             {EntranceFields.entBldGlobalID: buildingGlobalID},
//             ShapeType.point,
//             buildingGlobalID,
//             entranceGlobalID,
//             null));
//         return;
//       }

//       final data = await entranceUseCases.getEntranceDetails(entranceGlobalID);
//       final features = data[GeneralFields.features] ?? [];
//       final props =
//           features.isNotEmpty ? features[0][GeneralFields.properties] : {};
//       emit(Attributes(
//         schema,
//         props,
//         ShapeType.point,
//         props[EntranceFields.entBldGlobalID] ?? buildingGlobalID,
//         entranceGlobalID,
//         null,
//       ));
//     } catch (e) {
//       emit(AttributesError(e.toString()));
//     }
//   }

//   Future<void> showBuildingAttributes(String? buildingGlobalID) async {
//     if (showLoading) emit(AttributesLoading());
//     try {
//       final schema = await buildingUseCases.getBuildingAttibutes();
//       if (buildingGlobalID == null) {
//         emit(Attributes(schema, const {}, ShapeType.polygon, null, null, null));
//         return;
//       }

//       final building =
//           await buildingUseCases.getBuildingDetails(buildingGlobalID);

//       emit(Attributes(
//         schema,
//         building.toMap(),
//         ShapeType.polygon,
//         buildingGlobalID,
//         null,
//         null,
//       ));
//     } catch (e) {
//       emit(AttributesError(e.toString()));
//     }
//   }

//   String? get currentBuildingGlobalId =>
//       state is Attributes ? (state as Attributes).buildingGlobalId : null;

//   String? get currentEntranceGlobalId =>
//       state is Attributes ? (state as Attributes).entranceGlobalId : null;

//   int? get currentDwellingObjectId =>
//       state is Attributes ? (state as Attributes).dwellingObjectId : null;

//   ShapeType get shapeType =>
//       state is Attributes ? (state as Attributes).shapeType : ShapeType.point;

//   void clearSelections() {
//     emit(AttributesVisibility(false));
//   }
// }
