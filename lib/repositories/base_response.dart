import 'package:equatable/equatable.dart';

class BaseResponse<T> extends Equatable {
  final T? data;
  final int code;
  final String? message;
  final String? status;
  final int? totalCount;

  const BaseResponse({
    this.data,
    required this.code,
    this.message,
    this.status,
    this.totalCount,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse<T>(
      data: json['data'] ?? null,
      code: json['statusCode'] ?? json['code'] ?? 0,
      message: json['message'] ?? '',
      status: json['status'] ?? false,
      totalCount: json['totalCount'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [data, code, message, status, totalCount];

  @override
  bool get stringify => true;
}

class HTTPResponse<T> {
  int? httpStatusCode;
  int? result;
  String? errorMessage;
  T? data;
  HTTPResponse({this.httpStatusCode, this.result, this.data, this.errorMessage});
}
