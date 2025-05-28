# NumberPaginated

A highly configurable numeric pagination widget for Flutter, perfect for managing large datasets from local lists or remote APIs. It provides a complete solution with support for ListView and GridView, including loading and error states, as well as fully customizable pagination controls.

This widget was developed in conjunction with the [number_paginator](https://pub.dev/packages/number_paginator) package, and therefore has a direct dependency on it to deliver an efficient and seamless pagination experience.

## Features

- **Local Data**: Paginate static lists in memory
- **Remote Data**: Handle async data fetching with loading/error states
- **Multiple Layouts**: ListView and GridView support
- **Customizable**: Custom separators, grid layouts, and pagination controls
- **State Management**: Built-in loading, error, and success states

## Factories

- [`NumberPaginated.listView`] for static lists
- [`NumberPaginated.listViewAsync`] for async data fetching
- [`NumberPaginated.gridView`] for static lists in grid layout
- [`NumberPaginated.gridViewAsync`] for async data fetching in grid layout

## Properties

- `limit`: Number of items per page
- `itemBuilder`: Function to build each item widget
- `data` or `fetchData`: Source of data, either local list or async function
- `onPageChanged`: Callback for page changes
- `paginatorBuilder`: Create a custom `NumberPaginator` widget
- `paginatorController`: Controller for pagination state
- `onLoading`: Widget to show while loading data
- `onError`: Widget to show on error
- `totalCount`: Optional total count of items for remote data sources

## Note

Use `totalCount` only if the value comes from a paginated API.
Using it incorrectly may break page data and pagination.
If you don’t get it from the API, **don’t use it**.

## Usage

### For local data

```dart
NumberPaginated<String>.listView(
    properties: NumberPaginatedProps(
      data: List.generate(100, (i) => 'item $i');
      limit: 5
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __, item) => Text(item)
    ),
  );
```

### For remote data

```dart
NumberPaginated<UserModel>.listViewAsync(
    properties: NumberPaginatedProps(
      fetchData: () => yourFetch() // return a list of users
      limit: 5 // max data per page
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __, item) => Text(item.username)
    ),
  );
```
