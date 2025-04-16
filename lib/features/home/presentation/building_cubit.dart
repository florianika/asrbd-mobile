import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define Buildingentication states
abstract class BuildingState {}

class BuildingInitial extends BuildingState {}

class BuildingLoading extends BuildingState {}

class Buildings extends BuildingState {
  final Map<String, dynamic> buildings;
  Buildings(this.buildings);
}

class BuildingError extends BuildingState {
  final String message;
  BuildingError(this.message);
}

class BuildingCubit extends Cubit<BuildingState> {
  final BuildingUseCases buildingUseCases;

  BuildingCubit(this.buildingUseCases) : super(BuildingInitial());

  // Login method
  Future<void> getBuildings() async {
    emit(BuildingLoading());
    try {
      emit(Buildings(await buildingUseCases.getBuildings()));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }
}
