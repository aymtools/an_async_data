import 'package:an_async_data/an_async_data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tools.dart';

void main() {
  group('AsyncData', () {
    group('loading', () {
      test('equals', () {
        final loading = AsyncData<TestObject>.loading();
        final loading2 = AsyncData<TestObject>.loading();
        expect(loading, equals(loading2));
      });

      test('not equals', () {
        final loading = AsyncData<TestObject>.loading();
        final loading2 = AsyncData<TestEqualsObject>.loading();
        expect(loading, isNot(equals(loading2)));
      });
    });

    group('value data', () {
      test('equals', () {
        final value = AsyncData<TestObject>.value(TestEqualsObject());
        final value2 = AsyncData<TestObject>.value(TestEqualsObject());
        expect(value, equals(value2));
      });
      test('not equals', () {
        final value = AsyncData<TestObject>.value(TestObject());
        final value2 = AsyncData<TestObject>.value(TestObject());
        expect(value, isNot(equals(value2)));
      });
      test('not equals sub class', () {
        final value = AsyncData<TestObject>.value(TestEqualsObject());
        final value2 = AsyncData<TestObject>.value(TestAwayHashObject());
        expect(value, isNot(equals(value2)));
      });
    });

    group('error', () {
      test('equals', () {
        final error = AsyncData<TestObject>.error('error');
        final error2 = AsyncData<TestObject>.error('error');
        expect(error, equals(error2));
      });
      test('equals has stack trace', () {
        final current = StackTrace.current;
        final error = AsyncData<TestObject>.error('error', current);
        final error2 = AsyncData<TestObject>.error('error', current);
        expect(error, equals(error2));
      });

      test('not equals', () {
        final error = AsyncData<TestObject>.error('error');
        final error2 = AsyncData<TestObject>.error('error2');
        expect(error, isNot(equals(error2)));
      });

      test('not equals stack trace', () {
        final error = AsyncData<TestObject>.error('error');
        final error2 = AsyncData<TestObject>.error('error', StackTrace.current);
        expect(error, isNot(equals(error2)));
      });
    });
    group('valueOrNull', () {
      test('isLoading', () {
        final loading = AsyncData<TestObject>.loading();
        expect(loading.isLoading, isTrue);
        final value = AsyncData<TestObject>.value(TestObject());
        expect(value.isLoading, isFalse);
        final error = AsyncData<TestObject>.error('error');
        expect(error.isLoading, isFalse);
      });

      test('isValue', () {
        final loading = AsyncData<TestObject>.loading();
        expect(loading.isValue, isFalse);
        final value = AsyncData<TestObject>.value(TestObject());
        expect(value.isValue, isTrue);
        final error = AsyncData<TestObject>.error('error');
        expect(error.isValue, isFalse);
      });

      test('isError', () {
        final loading = AsyncData<TestObject>.loading();
        expect(loading.isError, isFalse);
        final value = AsyncData<TestObject>.value(TestObject());
        expect(value.isError, isFalse);
        final error = AsyncData<TestObject>.error('error');
        expect(error.isError, isTrue);
        final error2 = AsyncData<TestObject>.error('error', StackTrace.current);
        expect(error2.isError, isTrue);
      });

      test('value', () {
        final data = TestObject();
        final value = AsyncData<TestObject>.value(data);
        expect(value.valueOrNull, isNotNull);
        expect(value.valueOrNull, isA<TestObject>());
        expect(value.valueOrNull, equals(data));
      });
      test('value nullable', () {
        final value = AsyncData<TestObject?>.value(null);
        expect(value.valueOrNull, isNull);
        expect(value.valueOrNull, isA<TestObject?>());
        expect(value.valueOrNull, equals(null));
      });

      test('loading', () {
        final value = AsyncData<TestObject>.loading();
        expect(value.valueOrNull, isNull);
      });
      test('error', () {
        final value = AsyncData<TestObject>.error('error');
        expect(value.valueOrNull, isNull);
      });
    });

    group('when', () {
      test('loading', () {
        final value = AsyncData<TestObject>.loading();
        final curr = value.when(
            loading: () => true, value: (_) => false, error: (_, __) => false);
        expect(curr, isTrue);
      });

      test('value', () {
        final value = AsyncData<TestObject>.value(TestObject());
        final curr = value.when(
            loading: () => false, value: (_) => true, error: (_, __) => false);
        expect(curr, isTrue);
      });

      test('error', () {
        final value = AsyncData<TestObject>.error('error');
        final curr = value.when(
            loading: () => false, value: (_) => false, error: (_, __) => true);
        expect(curr, isTrue);
      });
    });

    group('valueLoading', () {
      test('equals', () {
        final data = TestEqualsObject('1');
        final value = AsyncData<TestObject>.dataLoading(data);
        final value2 = AsyncData<TestObject>.dataLoading(data);
        expect(value, equals(value2));
      });

      test('not equals loading', () {
        final loading = AsyncData<TestObject>.loading();
        final valueLoading = AsyncData<TestObject>.dataLoading(TestObject());
        expect(loading, isNot(equals(valueLoading)));
      });

      test('properties', () {
        final data = TestObject();
        final value = AsyncData<TestObject>.dataLoading(data);
        expect(value.isLoading, isTrue);
        expect(value.hasValue, isTrue);
        expect(value.value, equals(data));
        expect(value.valueOrNull, equals(data));
      });
    });

    group('valueError', () {
      test('equals', () {
        final data = TestEqualsObject('1');
        final error = 'error';
        final value = AsyncData<TestObject>.dataError(data, error);
        final value2 = AsyncData<TestObject>.dataError(data, error);
        expect(value, equals(value2));
      });

      test('not equals error', () {
        final error = AsyncData<TestObject>.error('error');
        final valueError =
            AsyncData<TestObject>.dataError(TestObject(), 'error');
        expect(error, isNot(equals(valueError)));
      });

      test('properties', () {
        final data = TestObject();
        final error = 'error';
        final value = AsyncData<TestObject>.dataError(data, error);
        expect(value.isError, isTrue);
        expect(value.hasValue, isTrue);
        expect(value.value, equals(data));
        expect(value.error, equals(error));
      });
    });

    group('getters', () {
      test('value throws StateError', () {
        final loading = AsyncData<TestObject>.loading();
        expect(() => loading.value, throwsStateError);
        final error = AsyncData<TestObject>.error('error');
        expect(() => error.value, throwsStateError);
      });

      test('data throws StateError', () {
        final loading = AsyncData<TestObject>.loading();
        expect(() => loading.data, throwsStateError);
        final valueLoading = AsyncData<TestObject>.dataLoading(TestObject());
        expect(() => valueLoading.data, throwsStateError);
        final error = AsyncData<TestObject>.error('error');
        expect(() => error.data, throwsStateError);
      });

      test('error throws StateError', () {
        final loading = AsyncData<TestObject>.loading();
        expect(() => loading.error, throwsStateError);
        final value = AsyncData<TestObject>.value(TestObject());
        expect(() => value.error, throwsStateError);
      });

      test('hasData', () {
        expect(AsyncData<int>.loading().hasData, isFalse);
        expect(AsyncData<int>.value(1).hasData, isTrue);
        expect(AsyncData<int>.error('err').hasData, isFalse);
        expect(AsyncData<int>.dataLoading(1).hasData, isTrue);
        expect(AsyncData<int>.dataError(1, 'err').hasData, isTrue);
      });

      test('dataOrNull', () {
        expect(AsyncData<int>.loading().dataOrNull, isNull);
        expect(AsyncData<int>.value(1).dataOrNull, equals(1));
        expect(AsyncData<int>.error('err').dataOrNull, isNull);
        expect(AsyncData<int>.dataLoading(1).dataOrNull, isNull);
        expect(AsyncData<int>.dataError(1, 'err').dataOrNull, isNull);
      });

      test('stackTrace', () {
        final st = StackTrace.current;
        expect(AsyncData<int>.loading().stackTrace, isNull);
        expect(AsyncData<int>.value(1).stackTrace, isNull);
        expect(AsyncData<int>.error('err', st).stackTrace, equals(st));
        expect(AsyncData<int>.dataError(1, 'err', st).stackTrace, equals(st));
      });
    });
  });

}

