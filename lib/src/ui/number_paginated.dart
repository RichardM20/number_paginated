import 'package:flutter/material.dart';
import 'package:number_paginated_list/src/controller/number_paginated_controller.dart';
import 'package:number_paginated_list/src/core/source/data_source.dart';
import 'package:number_paginated_list/src/core/source/local/local_data_source.dart';
import 'package:number_paginated_list/src/core/source/remote/remote_data_source.dart';
import 'package:number_paginated_list/src/core/state/data_state.dart';
import 'package:number_paginated_list/src/core/state/data_state_manager.dart';
import 'package:number_paginated_list/src/core/types/def_types.dart';
import 'package:number_paginated_list/src/models/properties.dart';
import 'package:number_paginator/number_paginator.dart';

part 'widgets/number_paginated_base.dart';

class NumberPaginated<T> extends _NumberPaginatedBase<T> {
  /// A comprehensive pagination widget for Flutter that efficiently handles large datasets
  /// with numbered page navigation. Supports both local and remote data sources.
  ///
  /// ## Features
  /// - **Local Data**: Paginate static lists in memory
  /// - **Remote Data**: Handle async data fetching with loading/error states
  /// - **Multiple Layouts**: ListView and GridView support
  /// - **Customizable**: Custom separators, grid layouts, and pagination controls
  /// - **State Management**: Built-in loading, error, and success states
  ///
  /// ## Factories
  /// - [`NumberPaginated.listView`] for static lists
  /// - [`NumberPaginated.listViewAsync`] for async data fetching
  /// - [`NumberPaginated.gridView`] for static lists in grid layout
  /// - [`NumberPaginated.gridViewAsync`] for async data fetching in grid layout
  ///
  /// ## Properties
  /// - `limit`: Number of items per page
  /// - `itemBuilder`: Function to build each item widget
  /// - `data` or `fetchData`: Source of data, either local list or async function
  /// - `onPageChanged`: Callback for page changes
  /// - `paginatorBuilder`: Create a custom `NumberPaginator` widget
  /// - `paginatorController`: Controller for pagination state
  /// - `onLoading`: Widget to show while loading data
  /// - `onError`: Widget to show on error
  /// - `totalCount`: Optional total count of items for remote data sources
  ///
  /// ## Note
  /// - Use `totalCount` only if the value comes from a paginated API.
  /// Using it incorrectly may break page data and pagination.
  /// If you don’t get it from the API, **don’t use it**.
  ///
  const NumberPaginated._({
    super.key,
    required super.itemBuilder,
    required super.limit,
    required super.dataSource,
    required super.child,
    super.onPageChanged,
    super.totalCount,
    super.paginatorBuilder,
    super.paginatorController,
    super.onLoading,
    super.onError,
  });

  /// Builds a paginated ListView using a static local list.
  ///
  /// - Best for local/in-memory data.
  /// - Supports scroll customization, separators, padding, and direction.
  /// - No loading or error state, since data is immediately available.
  factory NumberPaginated.listView({
    Key? key,
    required NumberPaginatedProps<T> properties,
  }) {
    return NumberPaginated._(
      key: key,
      limit: properties.limit,
      itemBuilder: properties.itemBuilder,
      dataSource: LocalDataSource(properties.data),
      paginatorBuilder: properties.paginatorBuilder,
      paginatorController: properties.paginatorController,
      onPageChanged: properties.onPageChanged,
      child:
          (context, items) => ListView.separated(
            separatorBuilder:
                properties.separatorBuilder ??
                (context, index) => const Divider(),
            padding: properties.padding,
            physics: properties.physics,
            controller: properties.scrollController,
            shrinkWrap: properties.shrinkWrap,
            scrollDirection: properties.scrollDirection,
            reverse: properties.reverse,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return properties.itemBuilder(context, index, items[index]);
            },
          ),
    );
  }

  /// Builds a paginated ListView using an async data source (e.g., API).
  ///
  /// - Best for remote data that must be fetched per page.
  /// - Includes loading, error, and empty states.
  /// - Optionally accepts total item count for accurate pagination.
  factory NumberPaginated.listViewAsync({
    Key? key,
    required AsyncProperties<T> properties,
  }) {
    return NumberPaginated._(
      key: key,
      limit: properties.limit,
      itemBuilder: properties.itemBuilder,
      dataSource: RemoteDataSource(properties.fetchData),
      paginatorBuilder: properties.paginatorBuilder,
      paginatorController: properties.paginatorController,
      onPageChanged: properties.onPageChanged,
      onLoading: properties.onLoading,
      onError: properties.onError,
      totalCount: properties.totalCount,
      child:
          (context, items) => ListView.separated(
            separatorBuilder:
                properties.separatorBuilder ??
                (context, index) => const Divider(),
            padding: properties.padding,
            physics: properties.physics,
            controller: properties.scrollController,
            shrinkWrap: properties.shrinkWrap,
            scrollDirection: properties.scrollDirection,
            reverse: properties.reverse,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return properties.itemBuilder(context, index, items[index]);
            },
          ),
    );
  }

  /// Builds a paginated GridView using a static local list.
  ///
  /// - Best for local grid data with a known total size.
  /// - Supports full grid layout customization and scrolling behavior.
  factory NumberPaginated.gridView({
    Key? key,
    required NumberPaginatedProps<T> properties,
  }) {
    return NumberPaginated._(
      key: key,
      limit: properties.limit,
      itemBuilder: properties.itemBuilder,
      dataSource: LocalDataSource(properties.data),
      paginatorBuilder: properties.paginatorBuilder,
      paginatorController: properties.paginatorController,
      onPageChanged: properties.onPageChanged,
      child:
          (context, items) => GridView.builder(
            gridDelegate: properties.gridDelegate,
            padding: properties.padding,
            physics: properties.physics,
            controller: properties.scrollController,
            shrinkWrap: properties.shrinkWrap,
            reverse: properties.reverse,
            scrollDirection: properties.scrollDirection,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return properties.itemBuilder(context, index, items[index]);
            },
          ),
    );
  }

  /// Builds a paginated GridView using an async data source (e.g., API).
  ///
  /// - Best for remote grid data with server-side pagination.
  /// - Includes loading, error, and empty states.
  /// - Supports total item count from API for accurate pagination.
  factory NumberPaginated.gridViewAsync({
    Key? key,
    required AsyncProperties<T> properties,
  }) {
    return NumberPaginated._(
      key: key,
      limit: properties.limit,
      itemBuilder: properties.itemBuilder,
      totalCount: properties.totalCount,
      dataSource: RemoteDataSource(properties.fetchData),
      paginatorBuilder: properties.paginatorBuilder,
      paginatorController: properties.paginatorController,
      onPageChanged: properties.onPageChanged,
      onLoading: properties.onLoading,
      onError: properties.onError,
      child:
          (context, items) => GridView.builder(
            gridDelegate: properties.gridDelegate,
            padding: properties.padding,
            physics: properties.physics,
            controller: properties.scrollController,
            shrinkWrap: properties.shrinkWrap,
            reverse: properties.reverse,
            scrollDirection: properties.scrollDirection,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return properties.itemBuilder(context, index, items[index]);
            },
          ),
    );
  }
}
