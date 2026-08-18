import 'package:an_async_data/an_async_data.dart';
import 'package:an_async_data/builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ValueNotifierAsyncBuilderExt', () {
    testWidgets('Builder2 shows loading state', (WidgetTester tester) async {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.loading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: notifier.Builder2(
              loadingBuilder: (context) => const Text('Loading...'),
              builder: (context, value, child) => Text('Value: $value'),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
            ),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('Builder2 shows value state', (WidgetTester tester) async {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.value(42));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: notifier.Builder2(
              loadingBuilder: (context) => const Text('Loading...'),
              builder: (context, value, child) => Text('Value: $value'),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
            ),
          ),
        ),
      );

      expect(find.text('Value: 42'), findsOneWidget);
    });

    testWidgets('Builder2 shows error state', (WidgetTester tester) async {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.error('Oops'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: notifier.Builder2(
              loadingBuilder: (context) => const Text('Loading...'),
              builder: (context, value, child) => Text('Value: $value'),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
            ),
          ),
        ),
      );

      expect(find.text('Error: Oops'), findsOneWidget);
    });

    testWidgets('Builder2 uses ValueNotifierBuilderConfig',
        (WidgetTester tester) async {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.loading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueNotifierBuilderConfig(
              loadingBuilder: (context) => const Text('Config Loading'),
              errorBuilder: (context, error, stackTrace) =>
                  const Text('Config Error'),
              errorBuilderToSliver: (context, widget, error, stackTrace) =>
                  SliverToBoxAdapter(child: widget),
              loadingBuilderToSliver: (context, widget) =>
                  SliverToBoxAdapter(child: widget),
              child: notifier.Builder2(
                builder: (context, value, child) => Text('Value: $value'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Config Loading'), findsOneWidget);
    });
  });

  group('ValueNotifierListBuilderExt', () {
    testWidgets('BuilderList shows list items', (WidgetTester tester) async {
      final notifier = ValueNotifier<List<int>>([1, 2, 3]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: notifier.BuilderList(
              itemBuilder: (context, value, index) => Text('Item $value'),
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('BuilderList shows empty state', (WidgetTester tester) async {
      final notifier = ValueNotifier<List<int>>([]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: notifier.BuilderList(
              itemBuilder: (context, value, index) => Text('Item $value'),
              emptyBuilder: (context) => const Text('Empty'),
            ),
          ),
        ),
      );

      expect(find.text('Empty'), findsOneWidget);
    });
  });

  group('ValueNotifierAsyncListBuilderExt', () {
    testWidgets('BuilderList2 shows list items when value is available',
        (WidgetTester tester) async {
      final notifier =
          ValueNotifier<AsyncData<List<int>>>(AsyncData.value([10, 20]));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: notifier.BuilderList2(
              itemBuilder: (context, value, index) => Text('Val $value'),
            ),
          ),
        ),
      );

      expect(find.text('Val 10'), findsOneWidget);
      expect(find.text('Val 20'), findsOneWidget);
    });

    testWidgets('BuilderList2 shows loading state',
        (WidgetTester tester) async {
      final notifier = ValueNotifier<AsyncData<List<int>>>(AsyncData.loading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: notifier.BuilderList2(
              loadingBuilder: (context) => const Text('List Loading...'),
              itemBuilder: (context, value, index) => Text('Val $value'),
            ),
          ),
        ),
      );

      expect(find.text('List Loading...'), findsOneWidget);
    });
  });
}
