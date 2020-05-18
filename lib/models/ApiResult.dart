import 'package:cmp/public/Utils.dart';

enum ResultStatus { Success, Error }

class ApiResult {
  final bool isError;
  final ResultStatus status;
  final dynamic data;
  final String message;

  ApiResult({
    this.isError,
    this.status,
    this.data,
    this.message,
  });

  static parse(dynamic json) {
    final isError = json['status'] != 'success';
    final data = !isError ? json['data'] : null;
    final message = isError && !Utils.isEmpty(json['message'])
        ? json['message']
        : 'Error unexpected';

    return ApiResult(
      isError: isError,
      status: isError ? ResultStatus.Success : ResultStatus.Error,
      data: data,
      message: message,
    );
  }
}
