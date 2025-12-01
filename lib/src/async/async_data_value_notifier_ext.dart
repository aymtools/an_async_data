part of 'async_data.dart';

extension AsyncDataNotifierTypedExt<T extends Object>
    on ValueNotifier<AsyncData<T>> {
  bool get isLoading => value.isLoading;

  bool get hasError => value.hasError;

  bool get isError => value.isError;

  bool get isValue => value.isValue;

  bool get hasData => value.hasData;

  T get data => value.data;

  T? get dataOrNull => valueOrNull;

  T? get valueOrNull => value.valueOrNull;

  Object get error => value.error;

  StackTrace? get stackTrace => value.stackTrace;

  R when<R>({
    required R Function(T? data) loading,
    required R Function(T data) value,
    required R Function(Object error, StackTrace? stackTrace) error,
  }) => this.value.when<R>(loading: loading, value: value, error: error);

  void toLoading([T? data]) => value = value._toLoading(data);

  void toValue(T data) => value = value._toValue(data);

  void toError(Object error, [StackTrace? stackTrace]) =>
      value = value._toError(error, stackTrace);
}
