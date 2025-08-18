import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EntranceState {}

class EntranceInitial extends EntranceState {}

class EntranceLoading extends EntranceState {}

class Entrances extends EntranceState {
  final List<EntranceEntity> entrances;
  Entrances(this.entrances);
}

class Entrance extends EntranceState {
  final EntranceEntity entrance;
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
  final CheckUseCases checkUseCases;
  final AttributesCubit attributesCubit;
  final DwellingCubit dwellingCubit;

  String? currentGlobalId;
  List<EntranceEntity> _entrances = []; // ✅ Store entrances privately

  EntranceCubit(
    this.entranceUseCases,
    this.checkUseCases,
    this.attributesCubit,
    this.dwellingCubit,
  ) : super(EntranceInitial());

  Future<void> getEntrances(double zoom, List<String> entBldGlobalIDs) async {
    emit(EntranceLoading());
    try {
      final entrances =
          await entranceUseCases.getEntrances(zoom, entBldGlobalIDs);
      _entrances = entrances; // ✅ Store the entrances
      emit(Entrances(entrances));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }


  Future<void> getEntranceDetails(
      String globalId, String? buildingGlobalId) async {
    emit(EntranceLoading());
    try {
      attributesCubit.showAttributes(true);
      await attributesCubit.showEntranceAttributes(globalId, buildingGlobalId);
      currentGlobalId = globalId;
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

  Future<void> deleteEntranceFeature(String objectId) async {
    emit(EntranceLoading());
    try {
      final isDeleted = await entranceUseCases.deleteEntranceFeature(objectId);

      // ✅ Remove from stored entrances if deletion was successful
      if (isDeleted) {
        _entrances.removeWhere(
            (entrance) => entrance.objectId.toString() == objectId);
      }

      emit(EntranceDeleteResponse(isDeleted));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  // ✅ Add new entrance to the stored list
  void addEntrance(EntranceEntity entrance) {
    _entrances.add(entrance);
    emit(Entrances(List.from(_entrances)));
  }

  // ✅ Update an entrance in the stored list
  void updateEntrance(EntranceEntity updatedEntrance) {
    final index =
        _entrances.indexWhere((e) => e.globalId == updatedEntrance.globalId);
    if (index != -1) {
      _entrances[index] = updatedEntrance;
      emit(Entrances(List.from(_entrances)));
    }
  }

  /// Public getter to access the currently active entrance global ID
  String? get selectedEntranceGlobalId => currentGlobalId;

  /// ✅ Public getter to access entrances anytime
  List<EntranceEntity> get entrances => List.unmodifiable(_entrances);

  /// ✅ Check if we have entrances loaded
  bool get hasEntrances => _entrances.isNotEmpty;

  /// ✅ Get specific entrance by globalId
  EntranceEntity? getEntranceByGlobalId(String globalId) {
    try {
      return _entrances.firstWhere((e) => e.globalId == globalId);
    } catch (e) {
      return null;
    }
  }
}
