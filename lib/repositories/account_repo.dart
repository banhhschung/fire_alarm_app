import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/model/device_info.dart';

import 'dart:convert';

import 'package:fire_alarm_app/model/login_data_model.dart';
import 'package:fire_alarm_app/provides/dio_provider.dart';
import 'package:fire_alarm_app/repositories/base_response.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract interface class AccountRepo {
  Future<Either<Failure, Response>> doLogin(LoginData loginData);

  Future<Either<Failure, T?>> checkAccountIsExist<T>({required Map<String, dynamic> param});

  Future<Either<Failure, Map<String, dynamic>?>> updateAccount<T>(UpdateAccountData accountData);

  Future<Either<Failure, Map<String, dynamic>?>> registerAccount<T>(RegisterAccountModel registerAccountModel);

  Future<Either<Failure, T?>> doLogOut<T>(String deviceToken);

  Future<Either<Failure, bool>> changePassword<T>(String password, String passwordNew);

  Future<Either<Failure, Map<String, dynamic>?>> sendOTPCode<T>({
    String providerUserId,
    String provider,
    String activeCode,
  });

  // Future<Either<Failure, Map<String, dynamic>?>> sendVerifyCode<T>({
  //   required String providerUserId,
  //   required String provider,
  //   required String activeCode,
  // });
  // Future<Either<Failure, Map<String, dynamic>?>> sendVerifyCodeResetPassword<T>({
  //   required String providerUserId,
  //   required String provider,
  //   required String token,
  // });
  // Future<Either<Failure, Map<String, dynamic>?>> resetPassword<T>({Map<String, dynamic>? param});
  // Future<Either<Failure, Map<String, dynamic>?>> getEmailConfig<T>();
  // // Future<Either<Failure, bool>> setEmailConfig<T>(EmailNotifyConfigModel emailNotifyConfigModel);

  // // Future<Either<Failure, Map<String, dynamic>?>> confirmResetPassword<T>(ResetPasswordModel resetPasswordModel);
  // // Future<Either<Failure, T?>> deleteAccount<T>(DeleteAccountReasonArgs? reasonArgs);
  // Future<Either<Failure, Map<String, dynamic>?>> sendCode<T>(String phoneNumber, int verificationType);
  // Future<Either<Failure, Map<String, dynamic>?>> sendVerifyCodeForPhoneNumber<T>(String code, int verificationType);
  // Future<Either<Failure, Map<String, dynamic>?>> changeStatusOfActivatePin<T>(int currentStatus);
  // Future<Either<Failure, Map<String, dynamic>?>> getSmartLockMembersList<T>(String address);
  // Future<Either<Failure, Map<String, dynamic>?>> removeSmartLockMember<T>(int id);
  // // Future<Either<Failure, Map<String, dynamic>?>> saveSmartLockMember<T>(SmartLockMemberModel smartLockMemberModel);
  // Future<Either<Failure, Map<String, dynamic>?>> getSmartLockMember<T>(int? id);
  // Future<Either<Failure, T?>> saveActiveTimePin<T>(String? phoneNumber, int activeTimePin);
  Future<Either<Failure, Map<String, dynamic>?>> refreshToken<T>(LoginData loginData, String? token, String? deviceToken);
}

const LOGIN_PATH = '/api/auth/login';
const VERIFY_EXIST_USER = '/api/user/verify-exist-user';
const UPDATE_USER_PATH = '/api/user/update-user';
const CREATE_USER_PATH = '/api/user/create-user';
const DELETE_USER_PATH = '/api/user/delete';
const USER_DATA_PATH = '/api/user/data';
const USER_LOGOUT_PATH = '/api/user/logout';
const VERIFY_ACTIVE_CODE = '/api/user/verify-active-code';
const VERIFY_PASSWORD_TOKEN = '/api/user/verify-password-token';
const RESET_PASSWORD_PATH = '/api/user/resetPassword';
const UPDATE_PASSWORD_PATH = '/api/user/updatePassword';
const GET_EMAIL_CONFIG_PATH = 'api/user/data?keys=userConfigEmail';
const CONFIRM_RESET_PASSWORD_PATH = 'api/user/confirm-resetPassword';
const SEND_NEW_CODE_PATH = 'api/user-security/new-code';
const SEND_FORGOT_PIN_PATH = 'api/user-security/forgot-pin';
const SEND_VERIFY_CODE_PATH = 'api/user-security/verify-code';
const SEND_VERIFY_FORGOT_CODE_PATH = 'api/user-security/verify-forgot-code';
const CHANGE_STATUS_PATH = 'api/user-security/change-status';
const SMART_LOCK_MEMBERS_LIST_PATH = 'api/slk-member';
const ACTIVE_TIME_PIN_PATH = 'api/user-security/active-time-pin';
const AUTH_TOKEN_PATH = '/api/auth/token';

class AccountRepoImpl extends AccountRepo {
  final DioProvider _dioProvider = DioProvider();

  @override
  Future<Either<Failure, Response>> doLogin(LoginData loginData) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version;
      String data = '${loginData.providerUserId}${loginData.password}${ConfigApp.SHARE_KEY}';
      var usernameBytes = utf8.encode(data);
      var checksum = sha256.convert(usernameBytes);
      loginData.checksum = checksum.toString();

      DeviceInfo deviceInfo = await Common.getDeviceUUID();
      loginData.deviceId = deviceInfo.deviceId;
      loginData.deviceName = deviceInfo.deviceName;
      loginData.deviceVersion = deviceInfo.deviceVersion;
      loginData.appVersion = appVersion;

      final response = await _dioProvider.post(LOGIN_PATH, data: loginData.toMap());

      return response;
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, T?>> checkAccountIsExist<T>({required Map<String, dynamic> param}) async {
    try {
      if (!(await Common.isConnectToServer())) {
        return Left(AppError(statusCode: StatusCode.NO_INTERNET_CONNECTION, key: 'no_internet_connection'));
      }
      final response = await _dioProvider.get(VERIFY_EXIST_USER, param: param);

      return response.fold((left) {
        return Left(left);
      }, (right) {
        // return Right(_dioProvider.convertToModel(BaseResponse.fromJson(right.data)));
        return Right(right.data.cast<String, dynamic>());
      });
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, Map<String, dynamic>?>> registerAccount<T>(RegisterAccountModel registerAccountModel) async {
  //   try {
  //     final response = await _dioProvider.post(CREATE_USER_PATH, data: registerAccountModel.toMap());
  //     return response.fold((left) {
  //       return Left(left);
  //     }, (right) {
  //       return _dioProvider.convertToModel<Map<String, dynamic>>(BaseResponse.fromJson(right.data));
  //     });
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, Map<String, dynamic>?>> sendVerifyCode<T>({
  //   required String providerUserId,
  //   required String provider,
  //   required String activeCode,
  // }) async {
  //   try {
  //     Map<String, dynamic> data;
  //     if (provider == ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE) {
  //       data = {ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE: '$providerUserId', 'activeCode': activeCode};
  //     } else {
  //       data = {"phonenumber": '$providerUserId', 'activeCode': activeCode};
  //     }
  //     final response = await _dioProvider.post(VERIFY_ACTIVE_CODE, data: data);
  //     return response.fold((left) {
  //       return Left(left);
  //     }, (right) {
  //       return Right(right.data.cast<String, dynamic>());
  //     });
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, Map<String, dynamic>?>> sendVerifyCodeResetPassword<T>({
  //   required String providerUserId,
  //   required String provider,
  //   required String token,
  // }) async {
  //   try {
  //     final Map<String, dynamic> _param = {"token": token};
  //     if (provider == ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE) {
  //       _param.addAll({ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE: providerUserId});
  //     } else {
  //       _param.addAll({"phonenumber": providerUserId});
  //     }
  //
  //     final response = await _dioProvider.get(VERIFY_PASSWORD_TOKEN, param: _param);
  //
  //     return response.fold(
  //       (left) => Left(left),
  //       (right) {
  //         return Right(right.data.cast<String, dynamic>());
  //       },
  //     );
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, Map<String, dynamic>?>> resetPassword<T>({Map<String, dynamic>? param}) async {
  //   try {
  //     final response = await _dioProvider.post(RESET_PASSWORD_PATH, data: param);
  //     return response.fold(
  //       (left) => Left(left),
  //       (right) {
  //         return Right(right.data.cast<String, dynamic>());
  //       },
  //     );
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, Map<String, dynamic>?>> getEmailConfig<T>() async {
  //   try {
  //     final response = await _dioProvider.get(GET_EMAIL_CONFIG_PATH);
  //     return response.fold(
  //       (left) {
  //         return Left(left);
  //       },
  //       (right) {
  //         return Right(right.data.cast<String, dynamic>());
  //       },
  //     );
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, bool>> setEmailConfig<T>(EmailNotifyConfigModel emailNotifyConfigModel) async {
  //   try {
  //     final response = await _dioProvider.put(USER_DATA_PATH, data: {'userConfigEmail': emailNotifyConfigModelToJson(emailNotifyConfigModel)});
  //     return response.fold(
  //       (left) => Left(left),
  //       (right) {
  //         return Right(right.statusCode == StatusCode.STATUS_ACCEPTED ||
  //             right.statusCode == StatusCode.STATUS_CREATED ||
  //             right.statusCode == StatusCode.STATUS_ACCEPTED);
  //       },
  //     );
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, bool>> changePassword<T>(String password, String passwordNew) async {
  //   try {
  //     final response = await _dioProvider.put(UPDATE_PASSWORD_PATH, data: {'password': password, 'newpassword': passwordNew});
  //     return response.fold(
  //       (left) => Left(left),
  //       (right) {
  //         return Right(right.statusCode == StatusCode.STATUS_ACCEPTED ||
  //             right.statusCode == StatusCode.STATUS_CREATED ||
  //             right.statusCode == StatusCode.STATUS_ACCEPTED);
  //       },
  //     );
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, T?>> doLogOut<T>(String deviceToken) async {
  //   try {
  //     if (!(await Common.isConnectToServer())) {
  //       return Left(AppError(statusCode: StatusCode.NO_INTERNET_CONNECTION, key: 'no_internet_connection'));
  //     }
  //
  //     final response = await _dioProvider.post(USER_LOGOUT_PATH, param: {'deviceToken': deviceToken});
  //     return response.fold(
  //       (left) => Left(left),
  //       (right) {
  //         return _dioProvider.convertToModel<T>(BaseResponse.fromJson(right.data));
  //       },
  //     );
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, Map<String, dynamic>?>> confirmResetPassword<T>(ResetPasswordModel resetPasswordModel) async {
  //   try {
  //     String data =
  //         '${resetPasswordModel.provider}${resetPasswordModel.providerUserId}${resetPasswordModel.password}${resetPasswordModel.token}${ConfigApp.SHARE_KEY_RESET_PASSWORD}';
  //     var dataBytes = utf8.encode(data);
  //     var checksum = sha256.convert(dataBytes);
  //     resetPasswordModel.checkSum = checksum.toString();
  //
  //     final response = await _dioProvider.put(CONFIRM_RESET_PASSWORD_PATH, data: resetPasswordModel.toMap());
  //     return response.fold(
  //       (left) => Left(left),
  //       (right) {
  //         return Right(right.data);
  //       },
  //     );
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, T?>> deleteAccount<T>(DeleteAccountReasonArgs? reasonArgs) async {
  //   try {
  //     if (reasonArgs == null) return Left(UnknownException('reasonArgs is null'));
  //     final response = await _dioProvider.delete(DELETE_USER_PATH, data: {'reason': deleteAccountReasonArgsToJson(reasonArgs)});
  //     return response.fold(
  //       (left) => Left(left),
  //       (right) {
  //         return _dioProvider.convertToModel<T>(BaseResponse.fromJson(right.data));
  //       },
  //     );
  //   } catch (e) {
  //     return Left(UnknownException(e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> sendCode<T>(String phoneNumber, int verificationType) async {
    try {
      final param = {"phone": phoneNumber};

      final response = verificationType == ConfigApp.CREATE_PIN_CODE
          ? await _dioProvider.post(SEND_NEW_CODE_PATH, param: param)
          : await _dioProvider.post(SEND_FORGOT_PIN_PATH);
      return response.fold(
        (left) => Left(left),
        (right) {
          return Right(right.data.cast<String, dynamic>());
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> sendVerifyCodeForPhoneNumber<T>(String code, int verificationType) async {
    try {
      final param = {"code": code};

      final response = verificationType == ConfigApp.CREATE_PIN_CODE
          ? await _dioProvider.post(SEND_VERIFY_CODE_PATH, param: param)
          : await _dioProvider.post(SEND_VERIFY_FORGOT_CODE_PATH, param: param);
      return response.fold(
        (left) => Left(left),
        (right) {
          return Right(right.data.cast<String, dynamic>());
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> refreshToken<T>(LoginData loginData, String? token, String? deviceToken) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version;

      String data = '$token${ConfigApp.SHARE_KEY}';
      var hashCode = utf8.encode(data);
      var checksum = sha256.convert(hashCode);
      Map<String, dynamic> stringParams = {
        'refreshToken': token,
        'checksum': checksum.toString(),
        'deviceToken': deviceToken,
        'language': loginData.language,
        'appVersion': appVersion,
        'cameraRegionID': 'ap-southeast-1'
      };
      final response = await _dioProvider.post(AUTH_TOKEN_PATH, data: stringParams);
      return response.fold(
        (left) => Left(left),
        (right) {
          return Right(right.data.cast<String, dynamic>());
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> updateAccount<T>(UpdateAccountData accountData) async {
    try {
      final response = await _dioProvider.put(UPDATE_USER_PATH, data: accountData.toMap());
      return response.fold(
        (left) {
          return Left(left);
        },
        (right) {
          return _dioProvider.convertToModel<Map<String, dynamic>>(BaseResponse.fromJson(right.data));
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> registerAccount<T>(RegisterAccountModel registerAccountModel) async {
    try {
      final response = await _dioProvider.post(CREATE_USER_PATH, data: registerAccountModel.toMap());
      return response.fold((left) {
        return Left(left);
      }, (right) {
        return _dioProvider.convertToModel<Map<String, dynamic>>(BaseResponse.fromJson(right.data));
      });
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, T?>> doLogOut<T>(String deviceToken) async {
    try {
      if (!(await Common.isConnectToServer())) {
        return Left(AppError(statusCode: StatusCode.NO_INTERNET_CONNECTION, key: 'no_internet_connection'));
      }

      final response = await _dioProvider.post(USER_LOGOUT_PATH, param: {'deviceToken': deviceToken});
      return response.fold(
        (left) => Left(left),
        (right) {
          return _dioProvider.convertToModel<T>(BaseResponse.fromJson(right.data));
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword<T>(String password, String passwordNew) async {
    try {
      final response = await _dioProvider.put(UPDATE_PASSWORD_PATH, data: {'password': password, 'newpassword': passwordNew});
      return response.fold(
        (left) => Left(left),
        (right) {
          return Right(right.statusCode == StatusCode.STATUS_OK);
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> sendOTPCode<T>({String? providerUserId, String? provider, String? activeCode}) async {
    try {
      Map<String, dynamic> data;
      if (provider == ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE) {
        data = {ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE: '$providerUserId', 'activeCode': activeCode};
      } else {
        data = {"phonenumber": '$providerUserId', 'activeCode': activeCode};
      }
      final response = await _dioProvider.post(VERIFY_ACTIVE_CODE, data: data);
      return response.fold((left) {
        return Left(left);
      }, (right) {
        return Right(right.data.cast<String, dynamic>());
      });
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }
}
