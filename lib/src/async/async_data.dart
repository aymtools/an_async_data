import 'package:flutter/widgets.dart';

part 'async_data_value_notifier_ext.dart';

/// 定义一个基于异步状态的数据结构
sealed class AsyncData<T> {
  bool get hasValue;

  AsyncData._();

  factory AsyncData.loading() => AsyncDataLoading<T>._();

  factory AsyncData.value(T value) => AsyncDataValue<T>._(value);

  factory AsyncData.error(Object error, [StackTrace? stackTrace]) =>
      AsyncDataError<T>._(error, stackTrace);

  factory AsyncData.valueLoading(T value) => AsyncDataLoading<T>._value(value);

  factory AsyncData.valueError(T value, Object error,
          [StackTrace? stackTrace]) =>
      AsyncDataError<T>._value(value, error, stackTrace);
}

/// 加载中
class AsyncDataLoading<T> extends AsyncData<T> {
  final bool hasValue;
  final T? value;

  AsyncDataLoading._()
      : hasValue = false,
        value = null,
        super._();

  AsyncDataLoading._value(T this.value)
      : hasValue = true,
        super._();

  @override
  int get hashCode => Object.hash(AsyncDataLoading, T, hasValue, value);

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other.runtimeType == runtimeType);
}

///  加载完成 包含数据
class AsyncDataValue<T> extends AsyncData<T> {
  final T value;

  T get date => value;

  bool get hasValue => true;

  AsyncDataValue._(this.value) : super._();

  @override
  int get hashCode => Object.hash(AsyncDataValue, T, value);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other.runtimeType == runtimeType &&
          other is AsyncDataValue<T> &&
          other.value == value);
}

/// 加载失败 存在异常
class AsyncDataError<T> extends AsyncData<T> {
  final Object error;
  final StackTrace? stackTrace;
  final bool hasValue;
  final T? value;

  AsyncDataError._(this.error, [this.stackTrace])
      : hasValue = false,
        value = null,
        super._();

  AsyncDataError._value(T this.value, this.error, [this.stackTrace])
      : hasValue = true,
        super._();

  @override
  int get hashCode =>
      Object.hash(AsyncDataError, T, hasValue, value, error, stackTrace);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other.runtimeType == runtimeType &&
          other is AsyncDataError<T> &&
          other.hasValue == hasValue &&
          other.value == value &&
          other.error == error &&
          other.stackTrace == stackTrace);
}

extension AsyncDataTypedExt<T> on AsyncData<T> {
  bool get isLoading => this is AsyncDataLoading<T>;

  bool get hasError => this is AsyncDataError<T>;

  bool get isError => this is AsyncDataError<T>;

  bool get isValue => this is AsyncDataValue<T>;

  bool get hasData => hasValue;

  T get value {
    final that = this;
    if (that is AsyncDataValue<T>) {
      return that.value;
    } else if (that is AsyncDataLoading<T> && that.hasValue) {
      return that.value as T;
    } else if (that is AsyncDataError<T> && that.hasValue) {
      return that.value as T;
    } else {
      throw StateError('AsyncData not has value');
    }
  }

  T get data {
    final that = this;
    if (that is AsyncDataValue<T>) {
      return that.value;
    } else {
      throw StateError('AsyncData is not AsyncDataValue<$T>');
    }
  }

  T? get valueOrNull {
    final that = this;
    if (that is AsyncDataValue<T>) {
      return that.value;
    } else if (that is AsyncDataLoading<T> && that.hasValue) {
      return that.value as T;
    } else if (that is AsyncDataError<T> && that.hasValue) {
      return that.value as T;
    } else {
      return null;
    }
  }

  T? get dataOrNull {
    final that = this;
    if (that is AsyncDataValue<T>) {
      return that.value;
    } else {
      return null;
    }
  }

  Object get error {
    final that = this;
    if (that is AsyncDataError<T>) {
      return that.error;
    } else {
      throw StateError('AsyncData $this is not error');
    }
  }

  StackTrace? get stackTrace {
    final that = this;
    if (that is AsyncDataError<T>) {
      return that.stackTrace;
    } else {
      return null;
    }
  }

  R when<R>({
    required R Function() loading,
    required R Function(T value) value,
    required R Function(Object error, StackTrace? stackTrace) error,
  }) {
    if (isLoading) {
      return loading();
    } else if (isValue) {
      return value(this.value);
    } else {
      return error(this.error, stackTrace);
    }
  }

  AsyncData<T> _toLoading() =>
      isLoading ? this as AsyncDataLoading<T> : AsyncData<T>.loading();

  AsyncData<T> _toValue(T value) =>
      (this is AsyncDataValue<T> && (this as AsyncDataValue<T>).value == value)
          ? this
          : AsyncData<T>.value(value);

  AsyncData<T> _toError(Object error, [StackTrace? stackTrace]) =>
      (this is AsyncDataError<T> &&
              (this as AsyncDataError<T>).error == error &&
              (this as AsyncDataError<T>).stackTrace == stackTrace)
          ? this
          : AsyncData<T>.error(error, stackTrace);

  AsyncData<T> _toValueLoading() {
    final that = this;
    if (that is AsyncDataLoading<T> && that.hasValue) {
      return this;
    }
    if (hasValue) {
      return AsyncData<T>.valueLoading(value);
    }
    return AsyncData<T>.loading();
  }

  AsyncData<T> _toValueLoadingRaw(T value) {
    final that = this;
    if (that is AsyncDataLoading<T> && that.hasValue && that.value == value) {
      return this;
    }
    return AsyncData<T>.valueLoading(value);
  }

  AsyncData<T> _toValueError(Object error, [StackTrace? stackTrace]) {
    final that = this;
    if (that is AsyncDataError<T> &&
        that.hasValue &&
        that.value == value &&
        that.error == error &&
        that.stackTrace == stackTrace) {
      return this;
    }

    if (hasValue) {
      return AsyncData<T>.valueError(value, error, stackTrace);
    }
    return AsyncData<T>.error(error, stackTrace);
  }

  AsyncData<T> _toValueErrorRaw(T value, Object error,
      [StackTrace? stackTrace]) {
    final that = this;
    if (that is AsyncDataError<T> &&
        that.hasValue &&
        that.value == value &&
        that.error == error &&
        that.stackTrace == stackTrace) {
      return this;
    }
    return AsyncData<T>.valueError(value, error, stackTrace);
  }
}
