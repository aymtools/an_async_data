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

    group('data', () {
      test('equals', () {
        final data = AsyncData<TestObject>.data(TestEqualsObject());
        final data2 = AsyncData<TestObject>.data(TestEqualsObject());
        expect(data, equals(data2));
      });
      test('not equals', () {
        final data = AsyncData<TestObject>.data(TestObject());
        final data2 = AsyncData<TestObject>.data(TestObject());
        expect(data, isNot(equals(data2)));
      });
      test('not equals sub class', () {
        final data = AsyncData<TestObject>.data(TestEqualsObject());
        final data2 = AsyncData<TestObject>.data(TestAwayHashObject());
        expect(data, isNot(equals(data2)));
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

    group('dataOrNull', () {
      test('isLoading', () {
        final loading = AsyncData<TestObject>.loading();
        expect(loading.isLoading, isTrue);
        final data = AsyncData<TestObject>.data(TestObject());
        expect(data.isLoading, isFalse);
        final error = AsyncData<TestObject>.error('error');
        expect(error.isLoading, isFalse);
      });

      test('isData', () {
        final loading = AsyncData<TestObject>.loading();
        expect(loading.isData, isFalse);
        final data = AsyncData<TestObject>.data(TestObject());
        expect(data.isData, isTrue);
        final error = AsyncData<TestObject>.error('error');
        expect(error.isData, isFalse);
      });

      test('isError', () {
        final loading = AsyncData<TestObject>.loading();
        expect(loading.isError, isFalse);
        final data = AsyncData<TestObject>.data(TestObject());
        expect(data.isError, isFalse);
        final error = AsyncData<TestObject>.error('error');
        expect(error.isError, isTrue);
        final error2 = AsyncData<TestObject>.error('error', StackTrace.current);
        expect(error2.isError, isTrue);
      });

      test('data', () {
        final obj = TestObject();
        final data = AsyncData<TestObject>.data(obj);
        expect(data.dataOrNull, isNotNull);
        expect(data.dataOrNull, isA<TestObject>());
        expect(data.dataOrNull, equals(obj));
      });
      test('data nullable', () {
        final data = AsyncData<TestObject?>.data(null);
        expect(data.dataOrNull, isNull);
        expect(data.dataOrNull, isA<TestObject?>());
        expect(data.dataOrNull, equals(null));
      });

      test('loading', () {
        final data = AsyncData<TestObject>.loading();
        expect(data.dataOrNull, isNull);
      });
      test('error', () {
        final data = AsyncData<TestObject>.error('error');
        expect(data.dataOrNull, isNull);
      });
    });

    group('when', () {
      test('loading', () {
        final data = AsyncData<TestObject>.loading();
        final curr = data.when(
            loading: () => true, value: (_) => false, error: (_, __) => false);
        expect(curr, isTrue);
      });

      test('data', () {
        final data = AsyncData<TestObject>.data(TestObject());
        final curr = data.when(
            loading: () => false, value: (_) => true, error: (_, __) => false);
        expect(curr, isTrue);
      });

      test('error', () {
        final data = AsyncData<TestObject>.error('error');
        final curr = data.when(
            loading: () => false, value: (_) => false, error: (_, __) => true);
        expect(curr, isTrue);
      });
    });

    group('dataLoading', () {
      test('equals', () {
        final data = TestEqualsObject('1');
        final dataLoading1 = AsyncData<TestObject>.dataLoading(data);
        final dataLoading2 = AsyncData<TestObject>.dataLoading(data);
        expect(dataLoading1, equals(dataLoading2));
      });

      test('not equals loading', () {
        final loading = AsyncData<TestObject>.loading();
        final dataLoading = AsyncData<TestObject>.dataLoading(TestObject());
        expect(loading, isNot(equals(dataLoading)));
      });

      test('properties', () {
        final data = TestObject();
        final dataLoading = AsyncData<TestObject>.dataLoading(data);
        expect(dataLoading.isLoading, isTrue);
        expect(dataLoading.hasData, isTrue);
        expect(dataLoading.data, equals(data));
        expect(dataLoading.dataOrNull, equals(data));
      });
    });

    group('dataError', () {
      test('equals', () {
        final data = TestEqualsObject('1');
        final error = 'error';
        final dataError1 = AsyncData<TestObject>.dataError(data, error);
        final dataError2 = AsyncData<TestObject>.dataError(data, error);
        expect(dataError1, equals(dataError2));
      });

      test('not equals error', () {
        final error = AsyncData<TestObject>.error('error');
        final dataError =
            AsyncData<TestObject>.dataError(TestObject(), 'error');
        expect(error, isNot(equals(dataError)));
      });

      test('properties', () {
        final data = TestObject();
        final error = 'error';
        final dataError = AsyncData<TestObject>.dataError(data, error);
        expect(dataError.isError, isTrue);
        expect(dataError.hasData, isTrue);
        expect(dataError.data, equals(data));
        expect(dataError.error, equals(error));
      });
    });

    group('getters', () {
      test('data throws StateError', () {
        final loading = AsyncData<TestObject>.loading();
        expect(() => loading.data, throwsStateError);
        final error = AsyncData<TestObject>.error('error');
        expect(() => error.data, throwsStateError);
      });

      test('error throws StateError', () {
        final loading = AsyncData<TestObject>.loading();
        expect(() => loading.error, throwsStateError);
        final data = AsyncData<TestObject>.data(TestObject());
        expect(() => data.error, throwsStateError);
      });

      test('hasData', () {
        expect(AsyncData<int>.loading().hasData, isFalse);
        expect(AsyncData<int>.data(1).hasData, isTrue);
        expect(AsyncData<int>.error('err').hasData, isFalse);
        expect(AsyncData<int>.dataLoading(1).hasData, isTrue);
        expect(AsyncData<int>.dataError(1, 'err').hasData, isTrue);
      });

      test('dataOrNull', () {
        expect(AsyncData<int>.loading().dataOrNull, isNull);
        expect(AsyncData<int>.data(1).dataOrNull, equals(1));
        expect(AsyncData<int>.error('err').dataOrNull, isNull);
        expect(AsyncData<int>.dataLoading(1).dataOrNull, equals(1));
        expect(AsyncData<int>.dataError(1, 'err').dataOrNull, equals(1));
      });

      test('stackTrace', () {
        final st = StackTrace.current;
        expect(AsyncData<int>.loading().stackTrace, isNull);
        expect(AsyncData<int>.data(1).stackTrace, isNull);
        expect(AsyncData<int>.error('err', st).stackTrace, equals(st));
        expect(AsyncData<int>.dataError(1, 'err', st).stackTrace, equals(st));
      });
    });
  });
}
