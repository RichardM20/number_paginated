import 'package:number_paginated_list/src/core/source/data_source.dart';

/// A local data source that provides data from a list
class LocalDataSource<T> extends DataSource<T> {
  final List<T> _data;

  LocalDataSource(this._data);

  @override
  Future<List<T>> getData() async => _data;

  @override
  bool get isAsync => false;
}
