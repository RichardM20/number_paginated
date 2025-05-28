import 'package:example/api_call.dart';
import 'package:example/user_model.dart';
import 'package:flutter/material.dart';
import 'package:number_paginated_list/package.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Pagination Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: const PaginatedTabsPage(),
  );
}

class PaginatedTabsPage extends StatefulWidget {
  const PaginatedTabsPage({super.key});
  @override
  State<PaginatedTabsPage> createState() => _PaginatedTabsPageState();
}

class _PaginatedTabsPageState extends State<PaginatedTabsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _localListController = NumberPaginatorController();
  final _networkListController = NumberPaginatorController();
  final _localGridController = NumberPaginatorController();
  final _networkGridController = NumberPaginatorController();

  final List<String> _localData = List.generate(100, (i) => 'Local item $i');
  int _limit = 5;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _localListController.dispose();
    _networkListController.dispose();
    _localGridController.dispose();
    _networkGridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('NumberPaginated Demo'),
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.list), text: 'List Local'),
          Tab(icon: Icon(Icons.list), text: 'List Network'),
          Tab(icon: Icon(Icons.grid_view), text: 'Grid Local'),
          Tab(icon: Icon(Icons.grid_view), text: 'Grid Network'),
        ],
      ),
    ),
    body: TabBarView(
      controller: _tabController,
      children: [
        _buildLocalListView(),
        _buildAsyncListView(),
        _buildLocalGridView(),
        _buildAsyncGridView(),
      ],
    ),
  );

  // Local List
  Widget _buildLocalListView() => NumberPaginated<String>.listView(
    properties: NumberPaginatedProps(
      data: _localData,
      limit: _limit,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __, item) => _box(item),
    ),
  );

  // Async List
  Widget _buildAsyncListView() => NumberPaginated<Post>.listViewAsync(
    properties: AsyncProperties(
      limit: _limit,
      fetchData: () => fetchPosts(limit: 30),
      paginatorController: _networkListController,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __, item) => _box('${item.id} - ${item.title}'),
      paginatorBuilder: _buildPaginator(_networkListController),
    ),
  );

  // Local Grid
  Widget _buildLocalGridView() => NumberPaginated<String>.gridView(
    properties: NumberPaginatedProps(
      data: _localData,
      limit: _limit,
      paginatorController: _localGridController,
      itemBuilder: (_, __, item) => _box(item),
      paginatorBuilder: _buildPaginator(_localGridController),
    ),
  );

  // Async Grid
  Widget _buildAsyncGridView() => NumberPaginated<Post>.gridViewAsync(
    properties: AsyncProperties(
      limit: _limit,
      fetchData: () => fetchPosts(limit: 100),
      paginatorController: _networkGridController,
      itemBuilder: (_, __, item) => _box('${item.id} - ${item.title}'),
      paginatorBuilder: _buildPaginator(_networkGridController),
    ),
  );

  // Paginator with Dropdown
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<int>(
                  value: _limit,
                  dropdownColor: Colors.white,
                  underline: const SizedBox(),
                  iconEnabledColor: Colors.black,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5')),
                    DropdownMenuItem(value: 10, child: Text('10')),
                    DropdownMenuItem(value: 20, child: Text('20')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _limit = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box(String content) => Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
    child: Text(content),
  );
}

class _CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isSelected;

  const _CustomButton({
    required this.onTap,
    required this.text,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.red,
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.yellow : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
