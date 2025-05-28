import 'package:number_paginated_list/src/core/source/data_source.dart';

/// A data source that fetches data from a remote source asynchronously.
class RemoteDataSource<T> extends DataSource<T> {
  final Future<List<T>> Function() _fetchFunction;

  RemoteDataSource(this._fetchFunction);

  @override
  Future<List<T>> getData() async => await _fetchFunction();

  @override
  bool get isAsync => true;
}
