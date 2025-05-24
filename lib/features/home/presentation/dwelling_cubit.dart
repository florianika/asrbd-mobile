import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DwellingState {}

class DwellingInitial extends DwellingState {}

class DwellingLoading extends DwellingState {}

class Dwellings extends DwellingState {
  final Map<String, dynamic> dwellings;
  Dwellings(this.dwellings);
}

class Dwelling extends DwellingState {
  final Map<String, dynamic> dwelling;
  Dwelling(this.dwelling);
}

class DwellingUpdateResponse extends DwellingState {
  final bool isAdded;
  DwellingUpdateResponse(this.isAdded);
}
class DwellingAddResponse extends DwellingState {
  final bool isAdded;
  DwellingAddResponse(this.isAdded);
}

class DwellingAttributes extends DwellingState {
  final List<FieldSchema> attributes;
  DwellingAttributes(this.attributes);
}

class DwellingError extends DwellingState {
  final String message;
  DwellingError(this.message);
}

class DwellingCubit extends Cubit<DwellingState> {
  final DwellingUseCases dwellingUseCases;

  DwellingCubit(this.dwellingUseCases) : super(DwellingInitial());

  // Login method
  Future<void> getDwellings(String? entranceGlobalId) async {
    emit(DwellingLoading());
    try {
      emit(Dwellings(await dwellingUseCases.getDwellings(entranceGlobalId)));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }

  Future<void> getDwellingAttibutes() async {
    emit(DwellingLoading());
    try {
      emit(DwellingAttributes(await dwellingUseCases.getDwellingAttibutes()));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }

    Future<void> addDwellingFeature(
      Map<String, dynamic> attributes,) async {
    emit(DwellingLoading());
    try {
      emit(DwellingAddResponse(
          await dwellingUseCases.addDwellingFeature(attributes)));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }

   Future<void> updateDwellingFeature(
      Map<String, dynamic> attributes) async {
    emit(DwellingLoading());
    try {
      emit(DwellingUpdateResponse(
          await dwellingUseCases.updateDwellingFeature(attributes)));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }
  
  Future<void> getDwellingDetails(int objectId) async {
    emit(DwellingLoading());
    try {
      emit(Dwelling(await dwellingUseCases.getDwellingDetails(objectId)));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }

}
