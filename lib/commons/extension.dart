import 'package:dio/dio.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/configs/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

extension BuildContextExtension on BuildContext {
  // S get applocalization => S.of(this);

  double get getWidth => MediaQuery.of(this).size.width;
  double get getHeight => MediaQuery.of(this).size.height;

  double get getStatusBarHeight => MediaQuery.of(this).padding.top;
  double get getBottomBarHeight => MediaQuery.of(this).padding.bottom;

  ThemeData get getTheme => Theme.of(this);

  NavigatorState get getNavigator => Navigator.of(this);

  canPop({Function()? canPopCallback, Function()? canNotPopCallback}) {
    getNavigator.canPop() ? canPopCallback?.call() : canNotPopCallback?.call();
  }

  // Typo get getTypo => Typo();
}

extension StringExtension on String? {
  String get toCapitalize => this!.isNotEmpty ? this!.substring(0, 1).toUpperCase() + this!.substring(1) : '';

  String orEmpty() => this ?? '';
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

extension IntExtension on int? {
  int orZero() {
    return this ?? 0;
  }

  int orInt(int value) {
    return this ?? -1;
  }
}

extension DoubleExtension on double? {
  double orZero() {
    return this ?? 0;
  }

  double or(double value) {
    return this ?? value;
  }
}

extension BoolExtension on bool? {
  bool orFalse() {
    return this ?? false;
  }

  bool orTrue() {
    return this ?? true;
  }
}

extension NumDurationExtensions on num {
  Duration get microseconds => Duration(microseconds: round());
  Duration get ms => (this * 1000).microseconds;
  Duration get milliseconds => (this * 1000).microseconds;
  Duration get seconds => (this * 1000 * 1000).microseconds;
  Duration get minutes => (this * 1000 * 1000 * 60).microseconds;
  Duration get hours => (this * 1000 * 1000 * 60 * 60).microseconds;
  Duration get days => (this * 1000 * 1000 * 60 * 60 * 24).microseconds;
}

extension DataSourceExtension on DataSource {
  Failure getFailure({Response? res}) {
    //   var mContext = navigatorKey!.currentState!.context;
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

abstract interface class GlobaleExtensions {
  static tryCatch(Function() callback, {Function(Object)? onError}) {
    try {
      callback();
    } catch (e) {
      onError?.call(e);
    }
  }

  static fistFrameRender(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callback();
    });
  }

  static fistScheduleRender(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      callback();
    });
  }
}
