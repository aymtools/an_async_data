part of 'async_data.dart';

extension AsyncDataNotifierTypedExt<T> on ValueNotifier<AsyncData<T>> {
  bool get isLoading => value.isLoading;

  bool get hasError => value.hasError;

  bool get isError => value.isError;

  bool get isValue => value.isValue;

  bool get isData => value.isData;

  bool get hasData => value.hasData;

  bool get hasValue => value.hasValue;

  T get data => value.data;

  T? get dataOrNull => valueOrNull;

  T? get valueOrNull => value.valueOrNull;

  Object get error => value.error;

  StackTrace? get stackTrace => value.stackTrace;

  R when<R>({
    required R Function() loading,
    required R Function(T data) value,
    required R Function(Object error, StackTrace? stackTrace) error,
  }) =>
      this.value.when<R>(loading: loading, value: value, error: error);

  void toLoading() => value = value._toLoading();

  void toValue(T data) => toData(data);

  void toData(T data) => value = value._toData(data);

  void toError(Object error, [StackTrace? stackTrace]) =>
      value = value._toError(error, stackTrace);

  void toDataLoading() => value = value._toDataLoading();

  void toDataLoadingRaw(T data) => value = value._toDataLoadingRaw(data);

  void toDataError(Object error, [StackTrace? stackTrace]) =>
      value = value._toDataError(error, stackTrace);

  void toDataErrorRaw(T data, Object error, [StackTrace? stackTrace]) =>
      value = value._toDataErrorRaw(data, error, stackTrace);
}
