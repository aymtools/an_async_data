import 'package:an_async_data/an_async_data.dart';
import 'package:an_async_data/builder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ValueNotifierBuilderConfig(
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        errorBuilderToSliver: (context, widget, error, stackTrace) =>
            SliverToBoxAdapter(child: widget),
        loadingBuilderToSliver: (context, widget) =>
            SliverToBoxAdapter(child: widget),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ValueNotifier managing AsyncData<String>
  final _userNotifier = ValueNotifier<AsyncData<String>>(AsyncData.loading());

  // ValueNotifier managing AsyncData<List<String>>
  final _itemsNotifier =
      ValueNotifier<AsyncData<List<String>>>(AsyncData.loading());

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchItems();
  }

  Future<void> _fetchUserData() async {
    _userNotifier.toLoading();
    await Future.delayed(const Duration(seconds: 1));
    _userNotifier.toData('Alice');
  }

  Future<void> _fetchItems() async {
    _itemsNotifier.toLoading();
    await Future.delayed(const Duration(seconds: 1));
    _itemsNotifier.toData(['Item 1', 'Item 2', 'Item 3']);
  }

  @override
  void dispose() {
    _userNotifier.dispose();
    _itemsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('an_async_data Example'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Keep previous data while loading (dataLoading state)
          _userNotifier.toDataLoading();
          _itemsNotifier.toDataLoading();

          await Future.delayed(const Duration(seconds: 1));

          _userNotifier.toData('Alice (Refreshed)');
          _itemsNotifier.toData(['Item 1', 'Item 2', 'Item 3', 'Item 4']);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'User Info (AsyncData<String>):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Using Builder2 extension on ValueNotifier<AsyncData<T>>
            _userNotifier.Builder2(
              builder: (context, user, child) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Welcome, $user!'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _fetchUserData,
                  child: const Text('Load User'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _userNotifier.toError('Failed to load user'),
                  child: const Text('Simulate Error'),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Items List (AsyncData<List<String>>):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Using BuilderList2 extension on ValueNotifier<AsyncData<List<T>>>
            _itemsNotifier.BuilderList2(
              emptyBuilder: (context) => const Center(
                child: Text('No items found'),
              ),
              itemBuilder: (context, item, index) => ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _fetchItems,
                  child: const Text('Load Items'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _itemsNotifier.toData([]),
                  child: const Text('Set Empty'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      _itemsNotifier.toError('Failed to load items'),
                  child: const Text('Simulate Error'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
