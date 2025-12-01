import 'package:flutter/widgets.dart';

part 'async_data_value_notifier_ext.dart';

/// 定义一个基于异步状态的数据结构
sealed class AsyncData<T extends Object> {
  AsyncData._();

  factory AsyncData.loading([T? value]) => AsyncDataLoading<T>._(value);

  factory AsyncData.value(T value) => AsyncDataValue<T>._(value);

  factory AsyncData.error(Object error, [StackTrace? stackTrace]) =>
      AsyncDataError<T>._(error, stackTrace);
}

/// 加载中
class AsyncDataLoading<T extends Object> extends AsyncData<T> {
  final T? value;

  AsyncDataLoading._(this.value) : super._();

  @override
  int get hashCode => Object.hash(AsyncDataLoading, T, value);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other.runtimeType == runtimeType &&
          other is AsyncDataLoading<T> &&
          other.value == value);
}

///  加载完成 包含数据
class AsyncDataValue<T extends Object> extends AsyncData<T> {
  final T value;

  T get date => value;

  AsyncDataValue._(this.value) : super._();

  @override
  int get hashCode => Object.hash(AsyncDataValue, value);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other.runtimeType == runtimeType &&
          other is AsyncDataValue<T> &&
          other.value == value);
}

/// 加载失败 存在异常
class AsyncDataError<T extends Object> extends AsyncData<T> {
  final Object error;
  final StackTrace? stackTrace;

  AsyncDataError._(this.error, [this.stackTrace]) : super._();

  @override
  int get hashCode => Object.hash(AsyncDataError, error, stackTrace);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other.runtimeType == runtimeType &&
          other is AsyncDataError<T> &&
          other.error == error &&
          other.stackTrace == stackTrace);
}

extension AsyncDataTypedExt<T extends Object> on AsyncData<T> {
  bool get isLoading => this is AsyncDataLoading<T>;

  bool get hasError => this is AsyncDataError<T>;

  bool get isError => this is AsyncDataError<T>;

  bool get hasValue {
    final that = this;
    return that is AsyncDataValue<T> ||
        (that is AsyncDataLoading<T> && that.value != null);
  }

  bool get isValue => this is AsyncDataValue<T>;

  bool get hasData => hasValue;

  T get value {
    final that = this;
    if (that is AsyncDataValue<T>) {
      return that.value;
    } else if (that is AsyncDataLoading<T> && that.value != null) {
      return that.value!;
    } else {
      throw StateError('AsyncData has no value');
    }
  }

  T get data => value;

  T? get valueOrNull {
    final that = this;
    if (that is AsyncDataValue<T>) {
      return that.value;
    } else if (that is AsyncDataLoading<T> && that.value != null) {
      return that.value;
    } else {
      return null;
    }
  }

  T? get dataOrNull => valueOrNull;

  Object get error => (this as AsyncDataError<T>).error;

  StackTrace? get stackTrace {
    final that = this;
    if (that is AsyncDataError<T>) {
      return that.stackTrace;
    } else {
      return null;
    }
  }

  R when<R>({
    required R Function(T? value) loading,
    required R Function(T value) value,
    required R Function(Object error, StackTrace? stackTrace) error,
  }) {
    if (isLoading) {
      return loading(valueOrNull);
    } else if (isValue) {
      return value(this.value);
    } else {
      return error(this.error, stackTrace);
    }
  }

  AsyncData<T> _toLoading(T? value) => isLoading && valueOrNull == value
      ? this as AsyncDataLoading<T>
      : AsyncData<T>.loading(value);

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
}
