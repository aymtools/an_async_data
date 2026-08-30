import 'package:flutter/widgets.dart';

part 'async_data_value_notifier_ext.dart';

/// 定义一个基于异步状态的数据结构
sealed class AsyncData<T> {
  bool get hasData;

  AsyncData._();

  factory AsyncData.loading() => AsyncDataLoading<T>._();

  factory AsyncData.value(T data) => AsyncDataValue<T>._(data);

  factory AsyncData.data(T data) => AsyncDataValue<T>._(data);

  factory AsyncData(T data) => AsyncDataValue<T>._(data);

  factory AsyncData.error(Object error, [StackTrace? stackTrace]) =>
      AsyncDataError<T>._(error, stackTrace);

  factory AsyncData.dataLoading(T data) => AsyncDataLoading<T>._data(data);

  factory AsyncData.dataError(T data, Object error, [StackTrace? stackTrace]) =>
      AsyncDataError<T>._data(data, error, stackTrace);
}

/// 加载中
class AsyncDataLoading<T> extends AsyncData<T> {
  @override
  final bool hasData;
  final T? data;

  AsyncDataLoading._()
      : hasData = false,
        data = null,
        super._();

  AsyncDataLoading._data(T this.data)
      : hasData = true,
        super._();

  @override
  int get hashCode => Object.hash(AsyncDataLoading, T, hasData, data);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other.runtimeType == runtimeType &&
          other is AsyncDataLoading<T> &&
          other.hasData == hasData &&
          other.data == data);
}

///  加载完成 包含数据
class AsyncDataValue<T> extends AsyncData<T> {
  final T data;

  T get value => data;

  @override
  bool get hasData => true;

  AsyncDataValue._(this.data) : super._();

  @override
  int get hashCode => Object.hash(AsyncDataValue, T, data);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other.runtimeType == runtimeType &&
          other is AsyncDataValue<T> &&
          other.data == data);
}

/// 加载失败 存在异常
class AsyncDataError<T> extends AsyncData<T> {
  final Object error;
  final StackTrace? stackTrace;
  @override
  final bool hasData;
  final T? data;

  AsyncDataError._(this.error, [this.stackTrace])
      : hasData = false,
        data = null,
        super._();

  AsyncDataError._data(T this.data, this.error, [this.stackTrace])
      : hasData = true,
        super._();

  @override
  int get hashCode =>
      Object.hash(AsyncDataError, T, hasData, data, error, stackTrace);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other.runtimeType == runtimeType &&
          other is AsyncDataError<T> &&
          other.hasData == hasData &&
          other.data == data &&
          other.error == error &&
          other.stackTrace == stackTrace);
}

extension AsyncDataTypedExt<T> on AsyncData<T> {
  bool get isLoading => this is AsyncDataLoading<T>;

  bool get hasError => this is AsyncDataError<T>;

  bool get isError => this is AsyncDataError<T>;

  bool get isValue => this is AsyncDataValue<T>;

  bool get isData => this is AsyncDataValue<T>;

  bool get hasValue => hasData;

  T get value {
    final that = this;
    if (that is AsyncDataValue<T>) {
      return that.data;
    } else if (that is AsyncDataLoading<T> && that.hasData) {
      return that.data as T;
    } else if (that is AsyncDataError<T> && that.hasData) {
      return that.data as T;
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
      return that.data;
    } else if (that is AsyncDataLoading<T> && that.hasData) {
      return that.data as T;
    } else if (that is AsyncDataError<T> && that.hasData) {
      return that.data as T;
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
      return value(data);
    } else {
      return error(this.error, stackTrace);
    }
  }

  AsyncData<T> _toLoading() =>
      isLoading ? this as AsyncDataLoading<T> : AsyncData<T>.loading();

  AsyncData<T> _toData(T data) =>
      (this is AsyncDataValue<T> && (this as AsyncDataValue<T>).data == data)
          ? this
          : AsyncData<T>.data(data);

  AsyncData<T> _toError(Object error, [StackTrace? stackTrace]) =>
      (this is AsyncDataError<T> &&
              (this as AsyncDataError<T>).error == error &&
              (this as AsyncDataError<T>).stackTrace == stackTrace)
          ? this
          : AsyncData<T>.error(error, stackTrace);

  AsyncData<T> _toDataLoading() {
    final that = this;
    if (that is AsyncDataLoading<T> && that.hasData) {
      return this;
    }
    if (hasData) {
      return AsyncData<T>.dataLoading(data);
    }
    return AsyncData<T>.loading();
  }

  AsyncData<T> _toDataLoadingRaw(T data) {
    final that = this;
    if (that is AsyncDataLoading<T> && that.hasData && that.data == data) {
      return this;
    }
    return AsyncData<T>.dataLoading(data);
  }

  AsyncData<T> _toDataError(Object error, [StackTrace? stackTrace]) {
    final that = this;
    if (that is AsyncDataError<T> &&
        that.hasData &&
        that.data == value &&
        that.error == error &&
        that.stackTrace == stackTrace) {
      return this;
    }

    if (hasData) {
      return AsyncData<T>.dataError(data, error, stackTrace);
    }
    return AsyncData<T>.error(error, stackTrace);
  }

  AsyncData<T> _toDataErrorRaw(T data, Object error, [StackTrace? stackTrace]) {
    final that = this;
    if (that is AsyncDataError<T> &&
        that.hasData &&
        that.data == data &&
        that.error == error &&
        that.stackTrace == stackTrace) {
      return this;
    }
    return AsyncData<T>.dataError(data, error, stackTrace);
  }
}
