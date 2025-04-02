import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:either_dart/either.dart';
import 'package:fire_alarm_app/commons/constant.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/repositories/base_response.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/utils/shared_preferences.dart';
import 'package:fire_alarm_app/utils/shared_preferences_keys.dart';
import 'package:fire_alarm_app/commons/extension.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum DioProviderType { dio, formData }

abstract interface class BaseDioProvider {
  Future<Either<Failure, Response>> get(String apiPath, {Map<String, dynamic>? data, Map<String, dynamic>? param});
  Future<Either<Failure, Response>> post(String apiPath, {Map<String, dynamic>? data, Map<String, dynamic>? param});
  Future<Either<Failure, Response>> put(String apiPath, {Map<String, dynamic>? data, Map<String, dynamic>? param});
  Future<Either<Failure, Response>> delete(String apiPath, {Map<String, dynamic>? data});
  Future<Either<Failure, Response>> postFormData(String apiPath, {FormData? data, Map<String, dynamic>? param});
  Future<Either<Failure, Response>> postArray<T>(String apiPath, {List<T>? datas, Map<String, dynamic>? param});
  Future<Either<Failure, Response>> putArray<T>(String apiPath, {List<T>? datas, Map<String, dynamic>? param});
}

class DioProvider implements BaseDioProvider {
  final Dio _dio = Dio();
  final DioProviderType type;

  DioProvider({this.type = DioProviderType.dio}) {
    _dio.options = BaseOptions(
      baseUrl: getUrl(), //using config base url on ConfigApp
      connectTimeout: AppConstant.duration20s,
      receiveTimeout: AppConstant.duration30s,
      sendTimeout: AppConstant.duration10s,
      receiveDataWhenStatusError: true,
    );
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers[ConfigApp.CONTENT_TYPE] = type != DioProviderType.formData ? ConfigApp.CONTENT_TYPE_VALUE : ConfigApp.CONTENT_TYPE_VALUE_NO_CHARSET;

        _getHeader(options);
        handler.next(options);
      },
    ));
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        filter: (options, args) {
          //  return !options.uri.path.contains('posts');
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
        () => HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }

  void _getHeader(RequestOptions options) async {
    SpUtil? spUtil = await SpUtil.getInstance();
    switch (type) {
      case DioProviderType.dio:
        if (!options.headers.containsKey('X-Authorization') || (options.headers['X-Authorization'] as String).isEmpty) {
          if ((spUtil?.hasKey(SharedPreferencesKeys.accessToken)).orFalse()) {
            String? value = spUtil?.getString(SharedPreferencesKeys.accessToken);
            if (value != null && value.isNotEmpty) {
              options.headers['X-Authorization'] = value;
            }
          }
          if ((spUtil?.hasKey(SharedPreferencesKeys.currentHomeId)).orFalse()) {
            int? value = spUtil?.getInt(SharedPreferencesKeys.currentHomeId);
            if (value != null) {
              options.headers['HomeID'] = value;
            }
          }
        }
        break;
      case DioProviderType.formData:
        if (!options.headers.containsKey('X-Authorization') || (options.headers['X-Authorization'] as String).isEmpty) {
          if ((spUtil?.hasKey(SharedPreferencesKeys.accessToken)).orFalse()) {
            String? value = spUtil?.getString(SharedPreferencesKeys.accessToken);
            if (value != null && value.isNotEmpty) {
              options.headers['X-Authorization'] = value;
            }
          }
        }
        break;
      default:
        break;
    }
    if (!options.headers.containsKey('X-Authorization') || (options.headers['X-Authorization'] as String).isEmpty) {
      if ((spUtil?.hasKey(SharedPreferencesKeys.accessToken)).orFalse()) {
        String? value = spUtil?.getString(SharedPreferencesKeys.accessToken);
        if (value != null && value.isNotEmpty) {
          options.headers['X-Authorization'] = value;
        }
      }
      if ((spUtil?.hasKey(SharedPreferencesKeys.currentHomeId)).orFalse()) {
        int? value = spUtil?.getInt(SharedPreferencesKeys.currentHomeId);
        if (value != null) {
          options.headers['HomeID'] = value;
        }
      }
    }
  }

  String getUrl() {
    switch (type) {
      case DioProviderType.dio:
        return ConfigApp.getBaseUrl();
      case DioProviderType.formData:
        return ConfigApp.getBaseUrl();
      default:
        return ConfigApp.getBaseUrl();
    }
  }

  @override
  Future<Either<Failure, Response>> get(String apiPath, {Map<String, dynamic>? data, Map<String, dynamic>? param}) async {
    try {
      Response response = await _dio.get(apiPath, data: data, queryParameters: param);
      return _handlerServerResponse(response);
    } on DioException catch (e) {
      Common.printLog('method: ${e.requestOptions.method}, path : ${e.requestOptions.baseUrl + e.requestOptions.path}, responseCode: ${e.response?.statusCode ?? -1}, responseMessage: ${e.response?.statusMessage ?? ''}');
      return Left(_handlerDioError(e));
    } catch (error) {
      return Left(_handleOtherError(error));
    }
  }

  @override
  Future<Either<Failure, Response>> post(
    String apiPath, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? param,
  }) async {
    try {
      Response response = await _dio.post(apiPath, data: data, queryParameters: param);
      return _handlerServerResponse(response);
    } on DioException catch (e) {
      Common.printLog('method: ${e.requestOptions.method}, path : ${e.requestOptions.baseUrl + e.requestOptions.path}, responseCode: ${e.response?.statusCode ?? -1}, responseMessage: ${e.response?.statusMessage ?? ''}');
      return Left(_handlerDioError(e));
    } catch (error) {
      return Left(_handleOtherError(error));
    }
  }

  @override
  Future<Either<Failure, Response>> postFormData(String apiPath, {FormData? data, Map<String, dynamic>? param}) async {
    try {
      Response response = await _dio.post(
        apiPath,
        data: data,
        queryParameters: param,
        options: Options(headers: {
          // ConfigApp.CONTENT_TYPE: ConfigApp.MULTIPART_FORM_DATA,
        }),
      );
      return _handlerServerResponse(response);
    } on DioException catch (e) {
      return Left(_handlerDioError(e));
    } catch (error) {
      return Left(_handleOtherError(error));
    }
  }

  @override
  Future<Either<Failure, Response>> put(String apiPath, {Map<String, dynamic>? data, Map<String, dynamic>? param}) async {
    try {
      Response response = await _dio.put(apiPath, data: data);

      return _handlerServerResponse(response);
    } on DioException catch (e) {
      return Left(_handlerDioError(e));
    } catch (error) {
      return Left(_handleOtherError(error));
    }
  }

  @override
  Future<Either<Failure, Response>> delete(String apiPath, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.delete(apiPath, data: data);

      return _handlerServerResponse(response);
    } on DioException catch (e) {
      return Left(_handlerDioError(e));
    } catch (error) {
      return Left(_handleOtherError(error));
    }
  }

  @override
  Future<Either<Failure, Response>> postArray<T>(String apiPath, {List<T>? datas, Map<String, dynamic>? param}) async {
    try {
      Response response = await _dio.post(apiPath, data: datas, queryParameters: param);
      return _handlerServerResponse(response);
    } on DioException catch (e) {
      return Left(_handlerDioError(e));
    } catch (error) {
      return Left(_handleOtherError(error));
    }
  }

  @override
  Future<Either<Failure, Response>> putArray<T>(String apiPath, {List<T>? datas, Map<String, dynamic>? param}) async {
    try {
      Response response = await _dio.put(apiPath, data: datas, queryParameters: param);
      return _handlerServerResponse(response);
    } on DioException catch (e) {
      return Left(_handlerDioError(e));
    } catch (error) {
      return Left(_handleOtherError(error));
    }
  }

  ServerError _handleOtherError(dynamic error) {
    // Other errors
    return ServerError(statusCode: 0, message: 'Unexpected error: $error', errorCode: 'unexpected_error', status: 'error');
  }

  Failure _handlerDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECEIVE_TIMEOUT.getFailure();
      case DioExceptionType.badCertificate:
        return AppError(statusCode: 0, key: 'err_bat_certificate');
      case DioExceptionType.badResponse:
        if (e.response != null && e.response?.statusCode != null && e.response?.statusMessage != null) {
          return ServerError(
            statusCode: e.response!.statusCode ?? 0,
            message: e.response!.data['message'],
            errorCode: e.response!.data['errorCode'].toString(),
            status: e.response!.data['timestamp'].toString(),
          );
        } else {
          return DataSource.DEFAULT.getFailure();
        }
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      case DioExceptionType.connectionError:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.unknown:
        return DataSource.DEFAULT.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  }

  Either<Failure, Response> _handlerServerResponse(Response response) {
    switch (response.statusCode) {
      case StatusCode.STATUS_OK:
      case StatusCode.STATUS_CREATED:
      case StatusCode.STATUS_ACCEPTED:
        return Right(response);

      case StatusCode.STATUS_BAD_REQUEST:
      case StatusCode.STATUS_UNAUTHORIZED:
      case StatusCode.STATUS_FORBIDDEN:
      case StatusCode.STATUS_NOT_FOUND:
      case StatusCode.STATUS_NOT_ACCEPTABLE:
      case StatusCode.STATUS_CONFLICT:
      case StatusCode.STATUS_UNSUPPORTED_MEDIA_TYPE:
      case StatusCode.INTERNAL_SERVER_ERROR:
      case StatusCode.BAD_GATEWAY:
        return Left(ServerError.fromJson(response.data));

      default:
        return Left(DataSource.DEFAULT.getFailure());
    }
  }

  Either<Failure, T?> convertToModel<T>(BaseResponse<T> data) {
    switch (data.code) {
      case StatusCode.SUCCESS:
        return Right(data.data);
      case StatusCode.NOT_FOUND:
        return Left(AppError(statusCode: data.code, errMessage: data.message, key: StatusCode.getStatusCodeName(data.code)));
      default:
        return Left(AppError(statusCode: data.code, errMessage: data.message, key: StatusCode.getStatusCodeName(data.code)));
    }
  }
}

enum DataSource {
  OK,
  CREATED,
  ACCEPTED,
  BAD_REQUEST,
  UNAUTHORISED,
  FORBIDDEN,
  NOT_FOUND,
  NOT_ACCEPTABLE,
  CONFLICT,
  UNSUPPORTED_MEDIA_TYPE,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECEIVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
}

extension DataSourceExtension on DataSource {
  Failure getFailure({Response? res}) {
    switch (this) {
      case DataSource.OK:
        return ServerError.fromJson(res?.data);
      case DataSource.CREATED:
        return ServerError.fromJson(res?.data);
      case DataSource.ACCEPTED:
        return ServerError.fromJson(res?.data);
      case DataSource.BAD_REQUEST:
        return ServerError.fromJson(res?.data);
      case DataSource.UNAUTHORISED:
        return ServerError.fromJson(res?.data);
      case DataSource.FORBIDDEN:
        return ServerError.fromJson(res?.data);
      case DataSource.NOT_FOUND:
        return ServerError.fromJson(res?.data);
      case DataSource.NOT_ACCEPTABLE:
        return ServerError.fromJson(res?.data);
      case DataSource.CONFLICT:
        return ServerError.fromJson(res?.data);
      case DataSource.UNSUPPORTED_MEDIA_TYPE:
        return ServerError.fromJson(res?.data);
      case DataSource.INTERNAL_SERVER_ERROR:
        return ServerError.fromJson(res?.data);
      case DataSource.CONNECT_TIMEOUT:
        return AppError(statusCode: StatusCode.CONNECT_TIMEOUT, key: 'err_connect_timeout');
      case DataSource.CANCEL:
        return AppError(statusCode: StatusCode.CANCEL, key: 'err_cancel');
      case DataSource.RECEIVE_TIMEOUT:
        return AppError(statusCode: StatusCode.RECIEVE_TIMEOUT, key: 'err_receive_timeout');
      case DataSource.SEND_TIMEOUT:
        return AppError(statusCode: StatusCode.SEND_TIMEOUT, key: 'err_send_timeout');
      case DataSource.CACHE_ERROR:
        return AppError(statusCode: StatusCode.CACHE_ERROR, key: 'err_cache');
      case DataSource.NO_INTERNET_CONNECTION:
        return AppError(statusCode: StatusCode.NO_INTERNET_CONNECTION, key: 'err_no_internet');
      case DataSource.DEFAULT:
        return AppError(statusCode: StatusCode.DEFAULT, key: 'err_default');

      default:
        return AppError(statusCode: StatusCode.DEFAULT, key: 'err_unknown');
    }
  }
}
