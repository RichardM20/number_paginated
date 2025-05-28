/// A abstract class representing a data source for pagination.
abstract class DataSource<T> {
  Future<List<T>> getData();

  bool get isAsync;
}
