import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends DioException {
  final String? errorMessage;

  final int? applicationStatusCode;

  @override
  String get message => errorMessage ?? '';

  Failure({
    this.applicationStatusCode,
    this.errorMessage,
  }) : super(requestOptions: RequestOptions(path: ''));

  @override
  String toString() {
    if (message.isNotEmpty) {
      return message;
    } else {
      return "code: $applicationStatusCode -> Something went wrong, Please try again";
    }
  }
}

class UnknownException extends Failure {
  final String? errMessage;
  UnknownException([this.errMessage]) : super(errorMessage: errMessage);

  @override
  String toString() {
    if ((errMessage ?? '').isNotEmpty) {
      return message;
    } else {
      return "Something went wrong, Please try again";
    }
  }
}

class ServerError extends Equatable implements Failure {
  final int? statusCode;
  @override
  final String message;
  final String? errorCode;
  final String? status;

  const ServerError({
    this.statusCode,
    required this.message,
    this.errorCode,
    this.status,
  });

  factory ServerError.fromJson(Map<String, dynamic> json) {
    return ServerError(
      statusCode: json['status_code'],
      message: json['message'],
      errorCode: json['error_key'],
      status: json['status'],
    );
  }

  @override
  List<Object?> get props => [statusCode, message, errorCode, status];

  @override
  int? get applicationStatusCode => statusCode;

  @override
  DioException copyWith({RequestOptions? requestOptions, Response? response, DioExceptionType? type, Object? error, StackTrace? stackTrace, String? message}) {
    throw UnimplementedError();
  }

  @override
  Object? get error => null;

  @override
  String? get errorMessage => message;

  @override
  RequestOptions get requestOptions => throw UnimplementedError();

  @override
  Response? get response => throw UnimplementedError();

  @override
  StackTrace get stackTrace => throw UnimplementedError();

  @override
  DioExceptionType get type => throw UnimplementedError();
}

class AppError extends Failure {
  final int statusCode;
  final String? errMessage;
  final String? key;

  AppError({
    required this.statusCode,
    this.errMessage,
    this.key = 'err_unknown',
  }) : super(applicationStatusCode: statusCode, errorMessage: errMessage);
}

abstract interface class StatusCode {
  //TODO: add more status code to handler error

  //* Server error code
  static const int STATUS_OK = 200; // ok, request successful
  static const int STATUS_CREATED = 201; // Created, resource created successfully.
  static const int STATUS_ACCEPTED = 202; // Accepted, request accepted for processing.
  static const int STATUS_BAD_REQUEST = 400; // Bad request, invalid input.
  static const int STATUS_UNAUTHORIZED = 401; // Unauthorized, authentication required.
  static const int STATUS_FORBIDDEN = 403; // Forbidden, access denied.
  static const int STATUS_NOT_FOUND = 404; // Not found, resource missing.
  static const int STATUS_NOT_ACCEPTABLE = 406; // Content not acceptable.
  static const int STATUS_CONFLICT = 409; // Conflict, resource state mismatch.
  static const int STATUS_UNSUPPORTED_MEDIA_TYPE = 415; // Media type not supported.
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int BAD_GATEWAY = 502; // failure, crash in server side

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;

  //BaseResponse status code
  static const int SUCCESS = 1; // success
  static const int ERROR = 2; // error
  static const int WARNING = 3; // warning
  static const int CONFILICT_CODE = 4; // conflict code
  static const int CONFILICT_NAME = 5; // conflict name
  static const int CONFILICT_EMAIL = 6; // conflict email
  static const int CONFILICT_PHONE = 7; // conflict phone
  static const int NOT_FOUND_BY_ID = 8; // not found by id
  static const int REQUEST_BODY_INVALID = 9; // request body invalid
  static const int ALREADY_EXISTS = 10; // already exists
  static const int ACCESS_TOKEN_NOT_EXISTS = 11; // access token not exists
  static const int EXPIRE_CODE = 12; // expire code
  static const int INVALID_PARAMETER = 14; // invalid parameter
  static const int NOT_FOUND = 15; // not found
  static const int INVALID_DATE_FORMAT = 16; // invalid date format
  static const int OBJECT_CONFIGURED = 17; // object configured
  static const int STATUS_ACTIVING = 18; // status activing
  static const int STATUS_INACTIVE = 19; // status inactive
  static const int INVALID_PASSWORD = 66; // invalid password
  static const int CONFILICT_APPID = 71; // conflict appid
  static const int CONFILICT_SUBVERSION = 34; // conflict subversion
  static const int CONFILICT_LINK = 35; // conflict link
  static const int NOT_FOUND_BY_PARAM = 83; // not found by param
  static const int STATUS_EXPORT = 84; // status export
  static const int CONFILICT_TAX_CODE = 4; // conflict tax code

  //account
  static const int USER_NOT_EXISTS = 20; // user not exists
  static const int USER_INACTIVATE = 21; // user inactivate
  static const int USER_NOT_PERMISSION = 22; // user not permission
  static const int CHECKSUM_NOT_MATCH = 23; // checksum not match
  static const int SEND_EMAIL_ERROR = 24; // send email error
  //device
  static const int DEVICE_DELETE_ERROR_BY_STATUS = 30; // device delete error by status
  static const int DEVICE_UPDATE_ERROR_PERMISSION_ADMIN = 31; // device update error permission admin
  static const int DEVICE_UPDATE_PROPERTY_CLOUD = 32; // device update property cloud
  static const int DEVICE_FULL = 33; // device full
  //ALERT
  static const int ALERT_THRESHOLD_VALUE_CONFLICT = 40; // alert threshold value conflict
  static const int ALERT_RULE_IS_EXISTS = 41; // alert rule is exists
  static const int ALERT_INFO_EXIST = 42; // alert info exist
  static const int REACH_LIMIT = 50; // reach limit
  //reach limit
  static const int SEND_SMS_REACH_LIMIT = 30; // send sms reach limit
  //ROLE
  static const int ROLE_ASSIGN_USER = 60; // role assign user
  static const int PERMISSON_ASSIGN_ROLE = 65; // permission assign role
  static const int NOT_IMPLEMENTED = 13; // not implemented
  static const int DUPLICATE = 69; // duplicate
  static const int NOT_ENOUGH = 70; // not enough
  //HISTORY TEST
  static const int MAC_EXIST = 80; // mac exist
  static const int SERIAL_EXIST = 81; // serial exist
  static const int MAC_NOT_EXIST = 82; // mac not exist
  //STOCK
  static const int NOT_IN_STOCK = 85; // not in stock
  //DEVICE TYPE GROUP
  static const int COLOR_IS_NULL = 86; // color is null
  static const int STANDARD_IS_NULL = 87; // standard is null
  static const int VERSION_IS_NULL = 88; // version is null
  static const int DEVICE_TYPE_GROUP_DETAIL_HAS_BEEN_USED = 89; // device type group detail has been used
  static const int CONFILICT_MODEL = 90; // conflict model
  static const int PROJECT_TYPE_NULL = 91; // project type null
  static const int CONFILICT_ABCODE = 92; // conflict abcode
  static const int NOT_REGISTERED_GATEWAY = 93; // not registered gateway
  static const int NON_OWNER_DEVICE = 94; // non owner device
  static const int NOT_EXIST_DEVICE_TYPE_GROUP_WMS = 96; // not exist device type group
  static const int DEVICE_IS_GATEWAY = 95; // device is gateway
  static const int NOT_EXIST_DEVICE_TYPE_GROUP = 96; // not exist device type group
  static const int REQUEST_BODY_INVALID_WMS = 97; // request body invalid
  static const int INVALID_PARAMETER_WMS = 98; // invalid parameter
  static const int CONFILICT_NAME_WMS = 99; // conflict name
  static const int CONFILICT_CODE_WMS = 100; // conflict code
  static const int ALREADY_EXISTS_WMS = 101; // already exists
  static const int NOT_FOUND_BY_ID_WMS = 102; // not found by id
  static const int DEVICE_EXISTS_USB_GW = 103; // device exists usb gw
  static const int DEVICE_EXISTS_IN_GROUP = 104; // device exists in group
  static const int START_TIME_ERROR = 106; // start time error
  static const int BETWEEN_TIME_INVALID = 105; // between time invalid
  static const int ERROR_SQL = 107; // error sql

  static const int REQUEST_IN_PROGRESS = 88;
  static const int REQUEST_SUCCESS = 25;
  static const int REQUEST_SUCCESS_EMPTY = 26;

  ///when error happen, give user a way to retry the action
  static const int ERROR_SHOULD_RETRY = -25;

  ///when not authenticated, throw user to login page
  static const int ERROR_NOT_AUTHENTICATED = -26;

  ///When error happen, just do nothing
  static const int ERROR_DO_NOTHING = -27;

  static getStatusCodeName(int code) {
    switch (code) {
      case STATUS_OK:
        return 'STATUS_OK';
      case STATUS_CREATED:
        return 'STATUS_CREATED';
      case STATUS_ACCEPTED:
        return 'STATUS_ACCEPTED';
      case STATUS_BAD_REQUEST:
        return 'STATUS_BAD_REQUEST';
      case STATUS_UNAUTHORIZED:
        return 'STATUS_UNAUTHORIZED';
      case STATUS_FORBIDDEN:
        return 'STATUS_FORBIDDEN';
      case STATUS_NOT_FOUND:
        return 'STATUS_NOT_FOUND';
      case STATUS_NOT_ACCEPTABLE:
        return 'STATUS_NOT_ACCEPTABLE';
      case STATUS_CONFLICT:
        return 'STATUS_CONFLICT';
      case STATUS_UNSUPPORTED_MEDIA_TYPE:
        return 'STATUS_UNSUPPORTED_MEDIA_TYPE';
      case INTERNAL_SERVER_ERROR:
        return 'INTERNAL_SERVER_ERROR';
      case BAD_GATEWAY:
        return 'BAD_GATEWAY';
      case CONNECT_TIMEOUT:
        return 'CONNECT_TIMEOUT';
      case CANCEL:
        return 'CANCEL';
      case RECIEVE_TIMEOUT:
        return 'RECIEVE_TIMEOUT';
      case SEND_TIMEOUT:
        return 'SEND_TIMEOUT';
      case CACHE_ERROR:
        return 'CACHE_ERROR';
      case NO_INTERNET_CONNECTION:
        return 'NO_INTERNET_CONNECTION';
      case DEFAULT:
        return 'DEFAULT';
      case SUCCESS:
        return 'SUCCESS';
      case ERROR:
        return 'ERROR';
      case WARNING:
        return 'WARNING';
      case CONFILICT_CODE:
        return 'CONFILICT_CODE';
      case CONFILICT_NAME:
        return 'CONFILICT_NAME';
      case CONFILICT_EMAIL:
        return 'CONFILICT_EMAIL';
      case CONFILICT_PHONE:
        return 'CONFILICT_PHONE';
      case NOT_FOUND_BY_ID:
        return 'NOT_FOUND_BY_ID';
      case REQUEST_BODY_INVALID:
        return 'REQUEST_BODY_INVALID';
      case ALREADY_EXISTS:
        return 'ALREADY_EXISTS';
      case ACCESS_TOKEN_NOT_EXISTS:
        return 'ACCESS_TOKEN_NOT_EXISTS';
      case EXPIRE_CODE:
        return 'EXPIRE_CODE';
      case INVALID_PARAMETER:
        return 'INVALID_PARAMETER';
      case NOT_FOUND:
        return 'NOT_FOUND';
      case INVALID_DATE_FORMAT:
        return 'INVALID_DATE_FORMAT';
      case OBJECT_CONFIGURED:
        return 'OBJECT_CONFIGURED';
      case STATUS_ACTIVING:
        return 'STATUS_ACTIVING';
      case STATUS_INACTIVE:
        return 'STATUS_INACTIVE';
      case INVALID_PASSWORD:
        return 'INVALID_PASSWORD';
      case CONFILICT_APPID:
        return 'CONFILICT_APPID';
      case CONFILICT_SUBVERSION:
        return 'CONFILICT_SUBVERSION';
      case CONFILICT_LINK:
        return 'CONFILICT_LINK';
      case NOT_FOUND_BY_PARAM:
        return 'NOT_FOUND_BY_PARAM';
      case STATUS_EXPORT:
        return 'STATUS_EXPORT';
      case USER_NOT_EXISTS:
        return 'USER_NOT_EXISTS';
      case USER_INACTIVATE:
        return 'USER_INACTIVATE';
      case USER_NOT_PERMISSION:
        return 'USER_NOT_PERMISSION';
      case CHECKSUM_NOT_MATCH:
        return 'CHECKSUM_NOT_MATCH';
      case SEND_EMAIL_ERROR:
        return 'SEND_EMAIL_ERROR';
      case DEVICE_DELETE_ERROR_BY_STATUS:
        return 'DEVICE_DELETE_ERROR_BY_STATUS';
      case DEVICE_UPDATE_ERROR_PERMISSION_ADMIN:
        return 'DEVICE_UPDATE_ERROR_PERMISSION_ADMIN';
      case DEVICE_UPDATE_PROPERTY_CLOUD:
        return 'DEVICE_UPDATE_PROPERTY_CLOUD';
      case DEVICE_FULL:
        return 'DEVICE_FULL';
      case ALERT_THRESHOLD_VALUE_CONFLICT:
        return 'ALERT_THRESHOLD_VALUE_CONFLICT';
      case ALERT_RULE_IS_EXISTS:
        return 'ALERT_RULE_IS_EXISTS';
      case ALERT_INFO_EXIST:
        return 'ALERT_INFO_EXIST';
      case REACH_LIMIT:
        return 'REACH_LIMIT';
      case ROLE_ASSIGN_USER:
        return 'ROLE_ASSIGN_USER';
      case PERMISSON_ASSIGN_ROLE:
        return 'PERMISSON_ASSIGN_ROLE';
      case NOT_IMPLEMENTED:
        return 'NOT_IMPLEMENTED';
      case DUPLICATE:
        return 'DUPLICATE';
      case NOT_ENOUGH:
        return 'NOT_ENOUGH';
      case MAC_EXIST:
        return 'MAC_EXIST';
      case SERIAL_EXIST:
        return 'SERIAL_EXIST';
      case MAC_NOT_EXIST:
        return 'MAC_NOT_EXIST';
      case NOT_IN_STOCK:
        return 'NOT_IN_STOCK';
      case COLOR_IS_NULL:
        return 'COLOR_IS_NULL';
      case STANDARD_IS_NULL:
        return 'STANDARD_IS_NULL';
      // case VERSION_IS_NULL:
      //   return 'VERSION_IS_NULL';
      case DEVICE_TYPE_GROUP_DETAIL_HAS_BEEN_USED:
        return 'DEVICE_TYPE_GROUP_DETAIL_HAS_BEEN_USED';
      case CONFILICT_MODEL:
        return 'CONFILICT_MODEL';
      case PROJECT_TYPE_NULL:
        return 'PROJECT_TYPE_NULL';
      case CONFILICT_ABCODE:
        return 'CONFILICT_ABCODE';
      case NOT_REGISTERED_GATEWAY:
        return 'NOT_REGISTERED_GATEWAY';
      case NON_OWNER_DEVICE:
        return 'NON_OWNER_DEVICE';
      case NOT_EXIST_DEVICE_TYPE_GROUP_WMS:
        return 'NOT_EXIST_DEVICE_TYPE_GROUP_WMS';
      case DEVICE_IS_GATEWAY:
        return 'DEVICE_IS_GATEWAY';
      case REQUEST_BODY_INVALID_WMS:
        return 'REQUEST_BODY_INVALID_WMS';
      case INVALID_PARAMETER_WMS:
        return 'INVALID_PARAMETER_WMS';
      case CONFILICT_NAME_WMS:
        return 'CONFILICT_NAME_WMS';
      case CONFILICT_CODE_WMS:
        return 'CONFILICT_CODE_WMS';
      case ALREADY_EXISTS_WMS:
        return 'ALREADY_EXISTS_WMS';
      case NOT_FOUND_BY_ID_WMS:
        return 'NOT_FOUND_BY_ID_WMS';
      case DEVICE_EXISTS_USB_GW:
        return 'DEVICE_EXISTS_USB_GW';
      case DEVICE_EXISTS_IN_GROUP:
        return 'DEVICE_EXISTS_IN_GROUP';
      case START_TIME_ERROR:
        return 'START_TIME_ERROR';
      case BETWEEN_TIME_INVALID:
        return 'BETWEEN_TIME_INVALID';
      case ERROR_SQL:
        return 'ERROR_SQL';
      case REQUEST_IN_PROGRESS:
        return 'REQUEST_IN_PROGRESS';
      case REQUEST_SUCCESS:
        return 'REQUEST_SUCCESS';
      case REQUEST_SUCCESS_EMPTY:
        return 'REQUEST_SUCCESS_EMPTY';
      case ERROR_SHOULD_RETRY:
        return 'ERROR_SHOULD_RETRY';
      case ERROR_NOT_AUTHENTICATED:
        return 'ERROR_NOT_AUTHENTICATED';
      case ERROR_DO_NOTHING:
        return 'ERROR_DO_NOTHING';

      default:
        return 'UNKNOWN';
    }
  }
}
