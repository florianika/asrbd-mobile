import 'package:asrdb/core/enums/service_mode.dart';
import 'package:asrdb/domain/entities/municipality_entity.dart';
import 'package:asrdb/features/home/domain/municipality_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MunicipalityState {}

class MunicipalityInitial extends MunicipalityState {}

class MunicipalityLoading extends MunicipalityState {}

class Municipality extends MunicipalityState {
  final MunicipalityEntity? municipality;
  Municipality(this.municipality);
}

class MunicipalityError extends MunicipalityState {
  final String message;
  MunicipalityError(this.message);
}

class MunicipalityCubit extends Cubit<MunicipalityState> {
  final MunicipalityUseCases municipalityUseCases;

  MunicipalityCubit(
    this.municipalityUseCases,
  ) : super(MunicipalityInitial());

  Future<void> getMunicipality(
      int municipalityId, ServiceMode serviceMode) async {
    emit(MunicipalityLoading());
    try {
      emit(Municipality(await municipalityUseCases.getMunicipality(
          municipalityId, serviceMode)));
    } catch (e) {
      emit(MunicipalityError(e.toString()));
    }
  }
}
