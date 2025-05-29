# NumberPaginatedList

[![pub package](https://img.shields.io/pub/v/number_paginated_list.svg)](https://pub.dev/packages/number_paginated_list)
[![analysis](https://github.com/RichardM20/number_paginated/workflows/analysis/badge.svg)](https://github.com/RichardM20/number_paginated/actions)
[![demo](https://img.shields.io/badge/web-online-blue)](https://url.com)

A highly configurable numeric pagination widget for Flutter, perfect for managing large datasets from local lists or remote APIs. It provides a complete solution with support for ListView and GridView, including loading and error states, as well as fully customizable pagination controls.

This widget was developed in conjunction with the [number_paginator](https://github.com/WieFel/number_paginator) package, and therefore has a direct dependency on it to deliver an efficient and seamless pagination experience.

## Preview

<p align="center">
  <img src="https://github.com/RichardM20/number_paginated/raw/main/screenshots/demo.gif" width="220" />
  <img src="https://github.com/RichardM20/number_paginated/raw/main/screenshots/paginated_list_view.png" width="220" />
  <img src="https://github.com/RichardM20/number_paginated/raw/main/screenshots/paginated_list_view_net.png" width="220" />
  <img src="https://github.com/RichardM20/number_paginated/raw/main/screenshots/paginated_list_grid.png" width="220" />
</p>

## Features

- **Local Data**: Paginate static lists in memory
- **Remote Data**: Handle async data fetching with loading/error states
- **Multiple Layouts**: ListView and GridView support
- **Customizable**: Custom separators, grid layouts, and pagination controls
- **State Management**: Built-in loading, error, and success states

## Factories

- `NumberPaginated.listView` for static lists
- `NumberPaginated.listViewAsync` for async data fetching
- `NumberPaginated.gridView` for static lists in grid layout
- `NumberPaginated.gridViewAsync` for async data fetching in grid layout

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

### Custom paginator

If for some reason you want to change and have more control over the pagination, it is possible. NumberPaginated has the property `buildPaginator` that allows you to build your own paginator based on the one from the package: [number_paginator](https://pub.dev/packages/number_paginator)

> Something very important to keep in mind, if you want to customize the paginator I recommend going directly to the source package and reading its documentation for a better understanding.

**paginatorBuilder:** is a function that receives:

- `context` (BuildContext): The current Flutter context.

- `index` (int): The currently selected page.

- `totalPages` (int): The total number of pages available.

- `onPageChanged` (void Function(int page)): A callback function you should call with the page number to update the current page.

It must return a widget (Widget) that will be used as the paginator, in this case `NumberPaginator`

This lets you create a fully customized paginator widget using the current state info and controlling page navigation by calling `onPageChanged`.

```dart
NumberPaginated<String>.listView(
    properties: NumberPaginatedProps(
      data: List.generate(100, (i) => 'item $i');
      limit: 5
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __, item) => Text(item)
      paginatorBuilder: _buildPaginator(_controller),
    ),
  );
```

It should look something like this:

```dart
Widget Function(BuildContext, int, int, void Function(int)) _buildPaginator(
    NumberPaginatorController controller,
  ) {
    return (context, index, totalPages, onPageChanged) => SizedBox(
      height: 50,
      child: Material(
        color: Colors.grey[300],
        child: NumberPaginator(
          numberPages: totalPages,
          controller: controller,
          child: Row(
            children: [
              TextButton(
                child: Text('prev'),
                onPressed: () {
                  controller.prev();
                },
              ),
              Expanded(
                child: NumberContent(
                  buttonBuilder:
                      (context, index, isSelected) => _CustomButton(
                        text: '${index + 1}',
                        isSelected: isSelected,
                        onTap: () => onPageChanged(index),
                      ),
                ),
              ),
              NextButton()
            ],
          ),
        ),
      ),
    );
  }
```
