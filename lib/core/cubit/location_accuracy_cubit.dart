import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

part 'location_accuracy_state.dart';

class LocationAccuracyCubit extends Cubit<LocationAccuracyState> {
  StreamSubscription<Position>? _positionSubscription;
  static const double _accuracyThreshold = 10.0; // meters

  LocationAccuracyCubit() : super(const LocationAccuracyInitial());

  /// Starts listening to location updates with best accuracy
  Future<void> startListening() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const LocationAccuracyError('Location services are disabled'));
        return;
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const LocationAccuracyError('Location permissions denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const LocationAccuracyError(
            'Location permissions permanently denied'));
        return;
      }

      // Start streaming position updates
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0, // Get all updates
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        _onPositionUpdate,
        onError: (error) {
          emit(LocationAccuracyError(error.toString()));
        },
      );
    } catch (e) {
      emit(LocationAccuracyError(e.toString()));
    }
  }

  /// Handles each position update from the stream
  void _onPositionUpdate(Position position) {
    final accuracy = position.accuracy;

    // Treat null or zero accuracy as invalid
    if (accuracy == 0.0) {
      emit(LocationAccuracyUpdated(
        position: LatLng(position.latitude, position.longitude),
        accuracy: accuracy,
        isAccurate: false,
      ));
      return;
    }

    // Check if accuracy meets threshold
    final isAccurate = accuracy <= _accuracyThreshold;

    emit(LocationAccuracyUpdated(
      position: LatLng(position.latitude, position.longitude),
      accuracy: accuracy,
      isAccurate: isAccurate,
    ));
  }

  /// Stops listening to location updates
  void stopListening() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    emit(const LocationAccuracyInitial());
  }

  @override
  Future<void> close() {
    stopListening();
    return super.close();
  }
}
