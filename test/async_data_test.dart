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
  });
}
