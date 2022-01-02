/// 由所有应用例外实现的标记接口。
abstract class AppException implements Exception {}

// 异常不应该发生，但由于错误而无论如何都会发生
// 假设/用法。
// ///
// 如果发生崩溃报告，我们应该使用崩溃报告工具报告此异常
// 在生产中尽快修复它，因为它是故意未处理的
// 以编程方式，我们不希望它发生。
// ///
// 扩展 [Error] 类将允许我们在
// 第一次错误是由"throw"表达式引发的。
class UnexpectedError extends Error implements AppException {
  /// 描述错误的消息
  final Object? message;

  UnexpectedError([this.message]);

  @override
  String toString() {
    if (message != null) return Error.safeToString(message);
    return 'Unexpected error.';
  }
}
