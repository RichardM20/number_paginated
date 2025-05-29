import 'package:flutter/widgets.dart';

typedef PageFetcher<T> = Future<List<T>> Function(int pageKey);
typedef ItemBuilder<T> =
    Widget Function(BuildContext context, int index, T item);
typedef ListBuilder = Widget Function(BuildContext context, List items);
typedef PaginatorBuilder =
    Widget Function(
      BuildContext context,
      int index,
      int totalPages,
      void Function(int page) onPageChanged,
    );
