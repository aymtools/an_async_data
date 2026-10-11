# an_async_data

An asynchronous data state management library for Flutter that provides a convenient single-state model (`loading`, `data`, `error`, `dataLoading`, `dataError`), state-conversion mechanisms, and `ValueNotifier` builder extensions.

---

## Features

- 🚀 **Unified Async State**: Supports states (`loading`, `data`, `error`, `dataLoading`, `dataError`), including retaining historical data for seamless refresh and error states.
- ⚡ **ValueNotifier Extensions**: Provides state transition methods such as `toLoading()`, `toData()`, `toError()`, `toDataLoading()`, and `toDataError()`.
- 🎨 **Flutter UI Integration**: Easily map a `ValueNotifier` to Widgets via `Builder2`, `BuilderList`, and `BuilderList2`.
- ⚙️ **Configurable Default UI**: Configure global or subtree level default loading and error UI logic (with Sliver support) via `ValueNotifierBuilderConfig`.

---

## Installation

In your `pubspec.yaml`:

```yaml
dependencies:
  an_async_data: ^1.3.0
```

Import in your Dart code:

```dart
import 'package:an_async_data/an_async_data.dart';
// Optional: If you need Flutter Builder extensions
import 'package:an_async_data/builder.dart';
```

---

## Quick Start

### 1. `AsyncData<T>` State Management

```dart
// 1. Loading state
final state1 = AsyncData<String>.loading();

// 2. Data state
final state2 = AsyncData<String>.data('Hello World');

// 3. Error state
final state3 = AsyncData<String>.error('Failed to load');

// 4. Loading with previous data (e.g. pull-to-refresh)
final state4 = AsyncData<String>.dataLoading('Previous Data');

// 5. Error with previous data
final state5 = AsyncData<String>.dataError('Previous Data', 'Network Timeout');
```

### 2. State Inspection & Reading

```dart
print(state2.isData);     // true
print(state2.hasData);    // true
print(state2.data);       // 'Hello World'
print(state2.dataOrNull); // 'Hello World'

// State pattern matching
final result = state2.when(
  loading: () => 'Loading...',
  value: (data) => 'Data: $data',
  error: (err, stack) => 'Error: $err',
);
```

### 3. ValueNotifier Extensions

```dart
final notifier = ValueNotifier<AsyncData<String>>(AsyncData.loading());

// Update state easily
notifier.toData('Alice');         // Switch to data state
notifier.toDataLoading();         // Switch to loading with retained data
notifier.toDataError('Timeout');   // Switch to error with retained data
notifier.toLoading();             // Switch to loading
notifier.toError('Unknown error');// Switch to error

// Quick access properties directly from ValueNotifier
if (notifier.hasData) {
  print(notifier.data);
}
```

### 4. Flutter UI Widgets

#### `Builder2` (Single Item)

```dart
notifier.Builder2(
  loadingBuilder: (context) => const CircularProgressIndicator(),
  errorBuilder: (context, error, stackTrace) => Text('Error: $error'),
  builder: (context, data, child) => Text('Hello, $data!'),
);
```

#### `BuilderList2` (List Item)

```dart
final listNotifier = ValueNotifier<AsyncData<List<String>>>(AsyncData.loading());

listNotifier.BuilderList2(
  emptyBuilder: (context) => const Text('No items found'),
  itemBuilder: (context, item, index) => ListTile(
    title: Text(item),
  ),
);
```

#### `ValueNotifierBuilderConfig` (Global or Subtree Config)

```dart
ValueNotifierBuilderConfig(
  loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
  errorBuilder: (context, error, stackTrace) => Center(child: Text('Error: $error')),
  child: const MyAppBody(),
)
```

---

## Example

Check out the full runnable example in [`example/example.dart`](example/example.dart).

```dart
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
        loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
        errorBuilder: (context, error, stackTrace) => Center(child: Text('Error: $error')),
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
  final _userNotifier = ValueNotifier<AsyncData<String>>(AsyncData.loading());

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _userNotifier.toLoading();
    await Future.delayed(const Duration(seconds: 1));
    _userNotifier.toData('Alice');
  }

  @override
  void dispose() {
    _userNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('an_async_data Example')),
      body: Center(
        child: _userNotifier.Builder2(
          builder: (context, user, child) => Text('Welcome, $user!'),
        ),
      ),
    );
  }
}
```

---

## Issues

If you encounter issues, here are some tips for debug, if nothing helps report
to [issue tracker on GitHub](https://github.com/aymtools/an_async_data/issues):
