part of '../number_paginated.dart';

class _NumberPaginatedBase<T> extends StatefulWidget {
  final ItemBuilder<T> itemBuilder;
  final DataSource<T> dataSource;
  final PaginatorBuilder? paginatorBuilder;
  final NumberPaginatorController? paginatorController;
  final ListBuilder child;
  final void Function(int page)? onPageChanged;
  final Widget Function()? onLoading;
  final Widget Function(String error)? onError;
  final int limit;
  final int? totalCount;

  const _NumberPaginatedBase({
    super.key,
    required this.itemBuilder,
    required this.limit,
    required this.dataSource,
    required this.child,
    this.totalCount,
    this.paginatorBuilder,
    this.paginatorController,
    this.onPageChanged,
    this.onLoading,
    this.onError,
  });

  @override
  State<_NumberPaginatedBase> createState() => _NumberPaginatedBaseState();
}

class _NumberPaginatedBaseState<T> extends State<_NumberPaginatedBase<T>> {
  late int _currentPage;
  late List<T> _items;
  late DataStateManager<T> _dataStateManager;
  late NumberPaginatorController _paginatorController;
  late NumberPaginatedController _paginatedListController;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _dataStateManager = DataStateManager<T>();
    _paginatorController =
        widget.paginatorController ?? NumberPaginatorController();

    _paginatorController.addListener(_onPageChanged);
    _initializeData();
  }

  /// Initializes the data by fetching it from the data source.
  Future<void> _initializeData() async {
    if (widget.dataSource.isAsync) {
      _dataStateManager.setLoading();
      if (mounted) setState(() {});
    }

    try {
      final data = await widget.dataSource.getData();
      if (!mounted) return;

      _dataStateManager.setLoaded(data);
      _setupPagination(data);
    } catch (e) {
      if (!mounted) return;
      _dataStateManager.setError(e.toString());
      if (mounted) setState(() {});
    }
  }

  /// Sets up pagination with the provided data.
  void _setupPagination(List<T> data) {
    _paginatedListController = NumberPaginatedController(
      listData: data,
      limit: widget.limit,
      totalCount: widget.totalCount,
    );

    _loadPage(0);
  }

  void _onPageChanged() {
    final page = _paginatorController.currentPage;
    if (page != _currentPage) {
      _loadPage(page);
    }
  }

  /// Loads the specified page of items.
  Future<void> _loadPage(int page) async {
    if (_dataStateManager.state != DataState.loaded) return;

    final items = _paginatedListController.goToPage(page);
    if (!mounted) return;

    setState(() {
      _items = items.cast<T>();
      _currentPage = page;
    });

    if (_paginatorController.currentPage != page) {
      _paginatorController.navigateToPage(page);
    }

    widget.onPageChanged?.call(page);
  }

  @override
  void didUpdateWidget(covariant _NumberPaginatedBase<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(oldWidget.dataSource, widget.dataSource) ||
        oldWidget.limit != widget.limit) {
      _initializeData();
    }
  }

  @override
  void dispose() {
    _paginatorController.removeListener(_onPageChanged);
    if (widget.paginatorController == null) {
      _paginatorController.dispose();
    }
    super.dispose();
  }

  Widget _buildPaginator() {
    if (_dataStateManager.state != DataState.loaded) {
      return const SizedBox.shrink();
    }

    return widget.paginatorBuilder != null
        ? widget.paginatorBuilder!(
          context,
          _currentPage,
          _paginatedListController.totalPages,
          (page) => _loadPage(page),
        )
        : NumberPaginator(
          controller: _paginatorController,
          numberPages: _paginatedListController.totalPages,
          initialPage: _currentPage,
          onPageChange: (page) => _loadPage(page),
        );
  }

  Widget _defaultLoadingWidget() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _defaultErrorWidget(String error) {
    return Center(
      child: Text(error, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_dataStateManager.state) {
      case DataState.loading:
        return widget.onLoading?.call() ?? _defaultLoadingWidget();

      case DataState.error:
        return widget.onError?.call(_dataStateManager.error!) ??
            _defaultErrorWidget(_dataStateManager.error!);

      case DataState.loaded:
        return Column(
          children: [
            Flexible(child: widget.child(context, _items)),
            const SizedBox(height: 10),
            _buildPaginator(),
          ],
        );
    }
  }
}
