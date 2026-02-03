part of 'location_accuracy_cubit.dart';

abstract class LocationAccuracyState extends Equatable {
  const LocationAccuracyState();

  @override
  List<Object?> get props => [];
}

class LocationAccuracyInitial extends LocationAccuracyState {
  const LocationAccuracyInitial();
}

class LocationAccuracyUpdated extends LocationAccuracyState {
  final LatLng position;
  final double accuracy;
  final bool isAccurate;

  const LocationAccuracyUpdated({
    required this.position,
    required this.accuracy,
    required this.isAccurate,
  });

  @override
  List<Object?> get props => [position, accuracy, isAccurate];
}

class LocationAccuracyError extends LocationAccuracyState {
  final String message;

  const LocationAccuracyError(this.message);

  @override
  List<Object?> get props => [message];
}
