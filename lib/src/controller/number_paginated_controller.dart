/// A controller for managing pagination of a list of items.
class NumberPaginatedController<T> {
  final List<T> listData;
  final int limit;
  final int? totalCount;
  int _currentPage = 0;

  NumberPaginatedController({
    required this.listData,
    required this.limit,
    this.totalCount,
  });

  int get currentPage => _currentPage;

  int get totalPages => totalCount ?? (listData.length / limit).ceil();

  List<T> getCurrentPageItems() {
    try {
      final start = _currentPage * limit;
      final end = (start + limit).clamp(0, listData.length);
      return listData.sublist(start, end);
    } catch (e) {
      return [];
    }
  }

  List<T> goToPage(int page) {
    _currentPage = page.clamp(0, totalPages - 1);
    return getCurrentPageItems();
  }
}
