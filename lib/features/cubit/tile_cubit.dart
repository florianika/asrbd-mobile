import 'package:flutter_bloc/flutter_bloc.dart';

/// State
abstract class TileCubitState {}

class Tile extends TileCubitState {
  final String path;
  Tile(this.path);
}

/// Cubit
class TileCubit extends Cubit<TileCubitState> {
  TileCubit() : super(Tile(''));

  String _path = '';

  void _emitCurrentState() {
    emit(Tile(_path));
  }

  void setPath(String path) {
    _path = path;
    _emitCurrentState();
  }

  String get path => _path;
}
