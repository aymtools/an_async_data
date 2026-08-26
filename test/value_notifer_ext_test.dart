import 'package:an_async_data/an_async_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tools.dart';

void main() {
  group('AsyncDataNotifierTypedExt', () {
    test('loading', () {
      final loading = AsyncData<TestObject>.loading();
      final notifier = ValueNotifier<AsyncData<TestObject>>(loading);
      expect(notifier.isLoading, isTrue);
      expect(notifier.isValue, isFalse);
      expect(notifier.isError, isFalse);
      expect(notifier.hasError, isFalse);
      expect(notifier.hasData, isFalse);
      expect(notifier.dataOrNull, isNull);
      expect(() => notifier.data, throwsStateError);
      expect(() => notifier.error, throwsStateError);
      expect(notifier.stackTrace, isNull);

      notifier.toLoading();
      expect(notifier.isLoading, isTrue);
      expect(notifier.value, equals(loading));
    });
    test('value', () {
      final value = TestObject();
      final notifier = ValueNotifier(AsyncData<TestObject>.value(value));
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isTrue);
      expect(notifier.isError, isFalse);
      expect(notifier.hasError, isFalse);
      expect(notifier.hasData, isTrue);
      expect(notifier.dataOrNull, isNotNull);
      expect(notifier.dataOrNull, isA<TestObject>());
      expect(notifier.dataOrNull, equals(value));
      expect(notifier.data, equals(value));
      expect(() => notifier.error, throwsStateError);
      expect(notifier.stackTrace, isNull);
      notifier.toValue(TestObject());
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isTrue);
      expect(notifier.data, isNot(equals(value)));

      final value2 = TestEqualsObject();
      final notifier2 =
          ValueNotifier(AsyncData<TestEqualsObject>.value(value2));
      notifier2.toValue(TestEqualsObject());
      expect(notifier2.isLoading, isFalse);
      expect(notifier2.isValue, isTrue);
      expect(notifier2.data, isNot(equals(value)));
      expect(notifier2.data, equals(value2));
    });

    test('error', () {
      final error = 'error';
      final notifier = ValueNotifier(AsyncData<TestObject>.error(error));
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isFalse);
      expect(notifier.isError, isTrue);
      expect(notifier.hasError, isTrue);
      expect(notifier.hasData, isFalse);
      expect(notifier.dataOrNull, isNull);
      expect(() => notifier.data, throwsStateError);
      expect(notifier.error, equals(error));
      expect(notifier.stackTrace, isNull);

      final error2 = 'error2';
      notifier.toError(error2);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isFalse);
      expect(notifier.isError, isTrue);
      expect(notifier.error, equals(error2));
    });

    test('state change', () {
      final loading = AsyncData<TestObject>.loading();
      final value = TestObject();
      final error = 'error';
      final notifier = ValueNotifier(loading);
      expect(notifier.isLoading, isTrue);
      expect(notifier.isValue, isFalse);
      expect(notifier.isError, isFalse);
      notifier.toValue(value);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isTrue);
      expect(notifier.isError, isFalse);
      expect(notifier.dataOrNull, isNotNull);
      expect(notifier.data, equals(value));
      notifier.toError(error);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isFalse);
      expect(notifier.isError, isTrue);
      expect(notifier.error, equals(error));
      expect(notifier.stackTrace, isNull);
    });

    test('state  equals not change', () {
      final loading = AsyncData<TestObject>.loading();
      final value = TestObject();
      final error = 'error';
      final notifier = ValueNotifier(loading);
      expect(notifier.isLoading, isTrue);
      expect(notifier.isValue, isFalse);
      expect(notifier.isError, isFalse);

      notifier.toLoading();
      expect(notifier.isLoading, isTrue);
      expect(notifier.isValue, isFalse);
      expect(notifier.isError, isFalse);
      expect(notifier.value, loading);

      notifier.toValue(value);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isTrue);
      expect(notifier.isError, isFalse);
      expect(notifier.dataOrNull, isNotNull);
      expect(notifier.data, equals(value));

      notifier.toValue(value);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isTrue);
      expect(notifier.isError, isFalse);
      expect(notifier.dataOrNull, isNotNull);
      expect(notifier.data, equals(value));

      notifier.toError(error);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isFalse);
      expect(notifier.isError, isTrue);
      expect(notifier.error, equals(error));
      expect(notifier.stackTrace, isNull);

      notifier.toError(error);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isValue, isFalse);
      expect(notifier.isError, isTrue);
      expect(notifier.error, equals(error));
      expect(notifier.stackTrace, isNull);
    });

    test('valueLoading transitions', () {
      final value = TestObject();
      final notifier =
          ValueNotifier<AsyncData<TestObject>>(AsyncData.value(value));

      notifier.toDataLoading();
      expect(notifier.isLoading, isTrue);
      expect(notifier.hasValue, isTrue);
      expect(notifier.value.value, equals(value));

      final value2 = TestObject();
      notifier.toDataLoadingRaw(value2);
      expect(notifier.isLoading, isTrue);
      expect(notifier.hasValue, isTrue);
      expect(notifier.value.value, equals(value2));
    });

    test('valueError transitions', () {
      final value = TestObject();
      final notifier =
          ValueNotifier<AsyncData<TestObject>>(AsyncData.value(value));
      final error = 'error';

      notifier.toDataError(error);
      expect(notifier.isError, isTrue);
      expect(notifier.hasValue, isTrue);
      expect(notifier.value.value, equals(value));
      expect(notifier.error, equals(error));

      final value2 = TestObject();
      final error2 = 'error2';
      notifier.toDataErrorRaw(value2, error2);
      expect(notifier.isError, isTrue);
      expect(notifier.hasValue, isTrue);
      expect(notifier.value.value, equals(value2));
      expect(notifier.error, equals(error2));
    });

    test('when', () {
      final loading = AsyncData<TestObject>.loading();
      final value = TestObject();
      final error = 'error';
      final notifier = ValueNotifier(loading);

      bool isLoading = false;
      TestObject? data;
      Object? err;
      void reset() {
        isLoading = false;
        data = null;
        err = null;
      }

      void setValues() => notifier.when(
          loading: () => isLoading = true,
          value: (d) => data = d,
          error: (e, _) => err = e);

      setValues();
      expect(isLoading, isTrue);
      expect(data, isNull);
      expect(err, isNull);
      reset();

      notifier.toValue(value);
      setValues();
      expect(isLoading, isFalse);
      expect(data, equals(value));
      expect(err, isNull);
      reset();

      notifier.toError(error);
      setValues();
      expect(isLoading, isFalse);
      expect(data, isNull);
      expect(err, equals(error));
      reset();
    });
  });

  group('AsyncDataNotifierTypedExt', () {
    test('toLoading', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.value(1));
      notifier.toLoading();
      expect(notifier.value.isLoading, isTrue);
      expect(notifier.value.hasValue, isFalse);
    });

    test('toValue', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.loading());
      notifier.toValue(1);
      expect(notifier.value.isValue, isTrue);
      expect(notifier.value.value, equals(1));
    });

    test('toError', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.loading());
      notifier.toError('error');
      expect(notifier.value.isError, isTrue);
      expect(notifier.value.error, equals('error'));
    });

    test('toValueLoading', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.value(1));
      notifier.toDataLoading();
      expect(notifier.value.isLoading, isTrue);
      expect(notifier.value.hasValue, isTrue);
      expect(notifier.value.value, equals(1));
    });

    test('toValueError', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.value(1));
      notifier.toDataError('error');
      expect(notifier.value.isError, isTrue);
      expect(notifier.value.hasValue, isTrue);
      expect(notifier.value.value, equals(1));
      expect(notifier.value.error, equals('error'));
    });
  });
}
