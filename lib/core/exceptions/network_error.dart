import 'package:flutter/foundation.dart';

import 'app_exception.dart';

// 通用网络异常。
//
// 帮助我们将网络异常从远程源层传播到任何
// 层以上。通过使用 [ NetworkException.api ] 我们可以传递任何自定义
// 错误 [T]，例如从服务器返回的验证错误。
@immutable
abstract class NetworkException<T>
    with _HelperMixin<T>
    implements AppException {
  /// 当向服务器成功发出请求并且错误为
  /// 从服务器返回。例如，404（未找到）响应。
  ///
  /// 通常，此例外适用于状态为 4xx 的客户端错误。
  /// Checkout https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#4xx_client_errors
  /// 了解更多信息。
  const factory NetworkException.api(T error) = _ApiException<T>;

  /// 当请求被取消时，就会发生这种情况
  const factory NetworkException.cancelled() = _RequestCancelledException<T>;

  /// 当没有互联网连接时，就会发生这种情况
  const factory NetworkException.connection() = _InternetConnectionException<T>;

  /// 当抛出 [FormatException] 或 [TypeError] 时，就会发生这种情况。
  const factory NetworkException.format() = _NetworkFormatException<T>;

  /// 当服务器错误（状态代码为 > = 500 的响应）时，将发生这种情况
  /// 从服务器返回。
  const factory NetworkException.server() = _ServerException<T>;

  /// 当从服务器打开、发送或接收数据时，就会发生这种情况
  /// 超时
  const factory NetworkException.timeout() = _NetworkTimeoutException<T>;

  /// 我们不希望任何其他类扩展此类。
  const NetworkException._();

  @override
  String toString() {
    if (this is _ApiException<T>) {
      final error = (this as _ApiException<T>).error;
      return '$runtimeType($error)';
    }
    return '$runtimeType()';
  }
}

class _ApiException<T> extends NetworkException<T> {
  final T error;

  const _ApiException(this.error) : super._();

  @override
  int get hashCode => error.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ApiException<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;
}

/// [NetworkException] helper mixin methods and getters.
mixin _HelperMixin<T> {
  /// 如果错误为 [NetworkException.api]，则返回 true。
  bool get isApiError => this is _ApiException<T>;

  /// 如果错误为 [NetworkException.cancelled]，则返回 true
  bool get isCancellationError => this is _RequestCancelledException<T>;

  /// 如果错误为 [NetworkException.connection]，则返回 true
  bool get isConnectionError => this is _InternetConnectionException<T>;

  /// 如果错误为 [NetworkException.format]，则返回 true。
  bool get isFormatException => this is _NetworkFormatException<T>;

  /// 如果错误为 [NetworkException.server]，则返回 true。
  bool get isServerError => this is _ServerException<T>;

  /// 如果错误为 [NetworkException.timeout]，则返回 true。
  bool get isTimeoutError => this is _NetworkTimeoutException<T>;

  /// 返回错误类型的短名称。
  String get name {
    if (isApiError) return 'api';
    if (isCancellationError) return 'cancelled';
    if (isConnectionError) return 'connection';
    if (isFormatException) return 'format';
    if (isServerError) return 'server';
    if (isTimeoutError) return 'timeout';
    throw FallThroughError();
  }
}

class _InternetConnectionException<T> extends NetworkException<T> {
  const _InternetConnectionException() : super._();
}

class _NetworkFormatException<T> extends NetworkException<T> {
  const _NetworkFormatException() : super._();
}

class _NetworkTimeoutException<T> extends NetworkException<T> {
  const _NetworkTimeoutException() : super._();
}

class _RequestCancelledException<T> extends NetworkException<T> {
  const _RequestCancelledException() : super._();
}

class _ServerException<T> extends NetworkException<T> {
  const _ServerException() : super._();
}
