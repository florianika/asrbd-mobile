import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

abstract class EntranceState {}

class EntranceInitial extends EntranceState {}

class EntranceLoading extends EntranceState {}

class Entrances extends EntranceState {
  final Map<String, dynamic> entrances;
  Entrances(this.entrances);
}

class Entrance extends EntranceState {
  final Map<String, dynamic> entrance;
  Entrance(this.entrance);
}

class EntranceGlobalId extends EntranceState {
  final String globalId;
  EntranceGlobalId(this.globalId);
}

class EntranceAttributes extends EntranceState {
  final List<FieldSchema> attributes;
  EntranceAttributes(this.attributes);
}

class EntranceAddResponse extends EntranceState {
  final bool isAdded;
  final String buildingGlboalId;
  EntranceAddResponse(this.isAdded, this.buildingGlboalId);
}

class EntranceUpdateResponse extends EntranceState {
  final bool isAdded;
  final String buildingGlobalId;
  EntranceUpdateResponse(this.isAdded, this.buildingGlobalId);
}

class EntranceDeleteResponse extends EntranceState {
  final bool isAdded;
  EntranceDeleteResponse(this.isAdded);
}

class EntranceError extends EntranceState {
  final String message;
  EntranceError(this.message);
}

class EntranceCubit extends Cubit<EntranceState> {
  final EntranceUseCases entranceUseCases;
  final AttributesCubit attributesCubit;
  final DwellingCubit dwellingCubit;

  String? currentGlobalId; // ✅ Store current globalId

  EntranceCubit(
    this.entranceUseCases,
    this.attributesCubit,
    this.dwellingCubit,
  ) : super(EntranceInitial());

  Future<void> getEntrances(double zoom, List<String> entBldGlobalIDs) async {
    emit(EntranceLoading());
    try {
      emit(Entrances(
          await entranceUseCases.getEntrances(zoom, entBldGlobalIDs)));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  Future<void> getEntranceDetails(String globalId) async {
    emit(EntranceLoading());
    try {
      attributesCubit.showAttributes(true);
      await attributesCubit.showEntranceAttributes(globalId, null);
      currentGlobalId = globalId; // ✅ Save the globalId for later access
      emit(EntranceGlobalId(globalId));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  Future<void> getEntranceAttributes() async {
    emit(EntranceLoading());
    try {
      emit(EntranceAttributes(await entranceUseCases.getEntranceAttributes()));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  Future<void> addEntranceFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    emit(EntranceLoading());
    try {
      final success =
          await entranceUseCases.addEntranceFeature(attributes, points);
      emit(EntranceAddResponse(success, attributes['EntBldGlobalID']));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  Future<void> updateEntranceFeature(Map<String, dynamic> attributes) async {
    emit(EntranceLoading());
    try {
      final success = await entranceUseCases.updateEntranceFeature(attributes);
      emit(EntranceUpdateResponse(success, attributes['EntBldGlobalID']));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  Future<void> deleteEntranceFeature(String objectId) async {
    emit(EntranceLoading());
    try {
      emit(EntranceDeleteResponse(
          await entranceUseCases.deleteEntranceFeature(objectId)));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  /// ✅ Public getter to access the currently active entrance global ID
  String? get selectedEntranceGlobalId => currentGlobalId;
}
