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
      expect(notifier.isData, isFalse);
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

    test('data', () {
      final data = TestObject();
      final notifier = ValueNotifier(AsyncData<TestObject>.data(data));
      expect(notifier.isLoading, isFalse);
      expect(notifier.isData, isTrue);
      expect(notifier.isError, isFalse);
      expect(notifier.hasError, isFalse);
      expect(notifier.hasData, isTrue);
      expect(notifier.dataOrNull, isNotNull);
      expect(notifier.dataOrNull, isA<TestObject>());
      expect(notifier.dataOrNull, equals(data));
      expect(notifier.data, equals(data));
      expect(() => notifier.error, throwsStateError);
      expect(notifier.stackTrace, isNull);

      notifier.toData(TestObject());
      expect(notifier.isLoading, isFalse);
      expect(notifier.isData, isTrue);
      expect(notifier.data, isNot(equals(data)));

      final data2 = TestEqualsObject();
      final notifier2 =
          ValueNotifier(AsyncData<TestEqualsObject>.data(data2));
      notifier2.toData(TestEqualsObject());
      expect(notifier2.isLoading, isFalse);
      expect(notifier2.isData, isTrue);
      expect(notifier2.data, isNot(equals(data)));
      expect(notifier2.data, equals(data2));
    });

    test('error', () {
      final error = 'error';
      final notifier = ValueNotifier(AsyncData<TestObject>.error(error));
      expect(notifier.isLoading, isFalse);
      expect(notifier.isData, isFalse);
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
      expect(notifier.isData, isFalse);
      expect(notifier.isError, isTrue);
      expect(notifier.error, equals(error2));
    });

    test('state change', () {
      final loading = AsyncData<TestObject>.loading();
      final data = TestObject();
      final error = 'error';
      final notifier = ValueNotifier(loading);
      expect(notifier.isLoading, isTrue);
      expect(notifier.isData, isFalse);
      expect(notifier.isError, isFalse);

      notifier.toData(data);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isData, isTrue);
      expect(notifier.isError, isFalse);
      expect(notifier.dataOrNull, isNotNull);
      expect(notifier.data, equals(data));

      notifier.toError(error);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isData, isFalse);
      expect(notifier.isError, isTrue);
      expect(notifier.error, equals(error));
      expect(notifier.stackTrace, isNull);
    });

    test('state equals not change', () {
      final loading = AsyncData<TestObject>.loading();
      final data = TestObject();
      final error = 'error';
      final notifier = ValueNotifier(loading);
      expect(notifier.isLoading, isTrue);
      expect(notifier.isData, isFalse);
      expect(notifier.isError, isFalse);

      notifier.toLoading();
      expect(notifier.isLoading, isTrue);
      expect(notifier.isData, isFalse);
      expect(notifier.isError, isFalse);
      expect(notifier.value, loading);

      notifier.toData(data);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isData, isTrue);
      expect(notifier.isError, isFalse);
      expect(notifier.dataOrNull, isNotNull);
      expect(notifier.data, equals(data));

      notifier.toData(data);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isData, isTrue);
      expect(notifier.isError, isFalse);
      expect(notifier.dataOrNull, isNotNull);
      expect(notifier.data, equals(data));

      notifier.toError(error);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isData, isFalse);
      expect(notifier.isError, isTrue);
      expect(notifier.error, equals(error));
      expect(notifier.stackTrace, isNull);

      notifier.toError(error);
      expect(notifier.isLoading, isFalse);
      expect(notifier.isData, isFalse);
      expect(notifier.isError, isTrue);
      expect(notifier.error, equals(error));
      expect(notifier.stackTrace, isNull);
    });

    test('dataLoading transitions', () {
      final data = TestObject();
      final notifier =
          ValueNotifier<AsyncData<TestObject>>(AsyncData.data(data));

      notifier.toDataLoading();
      expect(notifier.isLoading, isTrue);
      expect(notifier.hasData, isTrue);
      expect(notifier.value.data, equals(data));

      final data2 = TestObject();
      notifier.toDataLoadingRaw(data2);
      expect(notifier.isLoading, isTrue);
      expect(notifier.hasData, isTrue);
      expect(notifier.value.data, equals(data2));
    });

    test('dataError transitions', () {
      final data = TestObject();
      final notifier =
          ValueNotifier<AsyncData<TestObject>>(AsyncData.data(data));
      final error = 'error';

      notifier.toDataError(error);
      expect(notifier.isError, isTrue);
      expect(notifier.hasData, isTrue);
      expect(notifier.value.data, equals(data));
      expect(notifier.error, equals(error));

      final data2 = TestObject();
      final error2 = 'error2';
      notifier.toDataErrorRaw(data2, error2);
      expect(notifier.isError, isTrue);
      expect(notifier.hasData, isTrue);
      expect(notifier.value.data, equals(data2));
      expect(notifier.error, equals(error2));
    });

    test('when', () {
      final loading = AsyncData<TestObject>.loading();
      final data = TestObject();
      final error = 'error';
      final notifier = ValueNotifier(loading);

      bool isLoading = false;
      TestObject? resData;
      Object? err;
      void reset() {
        isLoading = false;
        resData = null;
        err = null;
      }

      void setValues() => notifier.when(
          loading: () => isLoading = true,
          value: (d) => resData = d,
          error: (e, _) => err = e);

      setValues();
      expect(isLoading, isTrue);
      expect(resData, isNull);
      expect(err, isNull);
      reset();

      notifier.toData(data);
      setValues();
      expect(isLoading, isFalse);
      expect(resData, equals(data));
      expect(err, isNull);
      reset();

      notifier.toError(error);
      setValues();
      expect(isLoading, isFalse);
      expect(resData, isNull);
      expect(err, equals(error));
      reset();
    });
  });

  group('AsyncDataNotifierTypedExt', () {
    test('toLoading', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.data(1));
      notifier.toLoading();
      expect(notifier.value.isLoading, isTrue);
      expect(notifier.value.hasData, isFalse);
    });

    test('toData', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.loading());
      notifier.toData(1);
      expect(notifier.value.isData, isTrue);
      expect(notifier.value.data, equals(1));
    });

    test('toError', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.loading());
      notifier.toError('error');
      expect(notifier.value.isError, isTrue);
      expect(notifier.value.error, equals('error'));
    });

    test('toDataLoading', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.data(1));
      notifier.toDataLoading();
      expect(notifier.value.isLoading, isTrue);
      expect(notifier.value.hasData, isTrue);
      expect(notifier.value.data, equals(1));
    });

    test('toDataError', () {
      final notifier = ValueNotifier<AsyncData<int>>(AsyncData.data(1));
      notifier.toDataError('error');
      expect(notifier.value.isError, isTrue);
      expect(notifier.value.hasData, isTrue);
      expect(notifier.value.data, equals(1));
      expect(notifier.value.error, equals('error'));
    });
  });
}
