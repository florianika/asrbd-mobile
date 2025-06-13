import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DwellingState {}

class DwellingInitial extends DwellingState {}

class DwellingLoading extends DwellingState {}

class Dwellings extends DwellingState {
  final Map<String, dynamic> dwellings;
  final bool showDwellingList;
  Dwellings(this.dwellings, this.showDwellingList);
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
  final AttributesCubit attributesCubit;

  DwellingCubit(this.dwellingUseCases, this.attributesCubit)
      : super(Dwellings({}, false));

  Future<void> getDwellings(String? entranceGlobalId) async {
    emit(DwellingLoading());
    try {
      attributesCubit.showAttributes(false);
      final dwellings = await dwellingUseCases.getDwellings(entranceGlobalId);
      emit(Dwellings(
         dwellings , true));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }

  void closeDwellings() {
    emit(DwellingLoading());
    try {
      emit(Dwellings({}, false));
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
    Map<String, dynamic> attributes,
  ) async {
    emit(DwellingLoading());
    try {
      emit(DwellingAddResponse(
          await dwellingUseCases.addDwellingFeature(attributes)));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }

  Future<void> updateDwellingFeature(Map<String, dynamic> attributes) async {
    emit(DwellingLoading());
    try {
      emit(DwellingUpdateResponse(
          await dwellingUseCases.updateDwellingFeature(attributes)));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }

  Future<void> getDwellingDetails(int? objectId) async {
    emit(DwellingLoading());
    try {
      attributesCubit.showAttributes(true);
      await attributesCubit.showDwellingAttributes(objectId!);
      // emit(Dwelling(await attributesCubit.showDwellingAttributes(objectId!)));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }
}
