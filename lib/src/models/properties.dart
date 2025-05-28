import 'package:flutter/widgets.dart';
import 'package:number_paginated_list/src/core/types/def_types.dart';
import 'package:number_paginator/number_paginator.dart';

class _GeneralProperties<T> {
  final int limit;
  final Function(int page)? onPageChanged;
  final ItemBuilder<T> itemBuilder;
  final PaginatorBuilder? paginatorBuilder;
  final NumberPaginatorController? paginatorController;
  final Widget Function()? onLoading;
  final Widget Function(String error)? onError;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics physics;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final SliverGridDelegate gridDelegate;

  _GeneralProperties({
    required this.limit,
    required this.itemBuilder,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 1.0,
    ),
    this.onPageChanged,
    this.paginatorBuilder,
    this.paginatorController,
    this.onLoading,
    this.onError,
    this.padding = const EdgeInsets.all(8.0),
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.scrollController,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.separatorBuilder,
  });
}

class AsyncProperties<T> extends _GeneralProperties {
  final int? totalCount;
  final Future<List<T>> Function() fetchData;

  AsyncProperties({
    required super.itemBuilder,
    required super.limit,
    required this.fetchData,
    this.totalCount,
    super.onPageChanged,
    super.paginatorBuilder,
    super.paginatorController,
    super.onLoading,
    super.onError,
    super.padding,
    super.physics,
    super.scrollController,
    super.shrinkWrap,
    super.scrollDirection,
    super.reverse,
    super.separatorBuilder,
    super.gridDelegate,
  });
}

class NumberPaginatedProps<T> extends _GeneralProperties {
  final List<T> data;
  NumberPaginatedProps({
    required super.itemBuilder,
    required super.limit,
    required this.data,
    super.onPageChanged,
    super.paginatorBuilder,
    super.paginatorController,
    super.onLoading,
    super.onError,
    super.padding,
    super.physics,
    super.scrollController,
    super.shrinkWrap,
    super.scrollDirection,
    super.reverse,
    super.separatorBuilder,
    super.gridDelegate,
  });
}
