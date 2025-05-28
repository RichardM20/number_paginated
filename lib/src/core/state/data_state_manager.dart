
import 'package:number_paginated_list/src/core/state/data_state.dart';

/// A simple state manager for handling data states in a Flutter application.
class DataStateManager<T> {
  DataState _state = DataState.loading;
  List<T> _data = [];
  String? _error;

  DataState get state => _state;
  List<T> get data => _data;
  String? get error => _error;

  void setLoading() {
    _state = DataState.loading;
    _error = null;
  }

  void setLoaded(List<T> data) {
    _state = DataState.loaded;
    _data = data;
    _error = null;
  }

  void setError(String error) {
    _state = DataState.error;
    _error = error;
    _data = [];
  }
}
