import 'dart:async';

import 'package:fire_alarm_app/blocs/account_bloc/account_event.dart';
import 'package:fire_alarm_app/blocs/account_bloc/account_state.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/model/login_data_model.dart';
import 'package:fire_alarm_app/provides/database_provider.dart';
import 'package:fire_alarm_app/repositories/account_repo.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/utils/shared_preferences.dart';
import 'package:fire_alarm_app/utils/shared_preferences_keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepo _accountRepo = AccountRepoImpl();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SpUtil? spUtil;

  AccountBloc() : super(InitialAccountState()) {
    on<SubmittedLoginAccountEvent>(_onSubmittedLoginAccountEvent);
    on<CheckAccountIsExistedAccountEvent>(_onCheckAccountIsExistedAccountEvent);
    on<RefreshAccountTokenAccountEvent>(_onRefreshAccountTokenAccountEvent);
    on<GetAccountLoginEvent>(_onGetAccountLoginEvent);
    on<UpdateAccountEvent>(_onUpdateAccountEvent);
    on<RegisterAccountEvent>(_onRegisterUserAccountEvent);
    on<LogoutAccountEvent>(_onLogoutAccountEvent);
    on<AccountChangeLanguageEvent>(_onAccountChangeLanguageEvent);
    on<AccountGetLanguageEvent>(_onAccountGetLanguageEvent);
    on<AccountChangePasswordEvent>(_onAccountChangePasswordEvent);
    on<AccountSendOTPCodeEvent>(_onAccountSendOTPCodeEvent);
  }

  void _onSubmittedLoginAccountEvent(SubmittedLoginAccountEvent event, Emitter<AccountState> emit) async {
    await _databaseHelper.cleanDatabase();
    spUtil = await SpUtil.instance;
    String? languageCode = spUtil?.getString(SharedPreferencesKeys.language);
    final dataObject = event.dataObject;
    dataObject?.language = languageCode == 'en' ? 2 : 1;

    if (dataObject == null) {
      emit(LoginFailure());
      return;
    }

    final response = await _accountRepo.doLogin(dataObject);

    await response.fold(
      (l) async {
        Common.printLog(l);
        if (l is ServerError && l.applicationStatusCode == 401) {
          emit(LoginWrongUsernameOrPassword(dataObject));
        } else {
          emit(LoginFailure());
        }
      },
      (r) async {
        Common.printLog(r);
        final data = r.data;
        if (data != null && data is Map<String, dynamic>) {
          spUtil?.remove(SharedPreferencesKeys.accessToken);

          Account account = Account.fromBEJson(data['user']);
          account.password = dataObject.password;
          await _databaseHelper.addOrUpdateAccount(account);

          spUtil?.putString(SharedPreferencesKeys.password, account.password);
          spUtil?.putInt(SharedPreferencesKeys.currentAccountId, account.id);
          spUtil?.putString(SharedPreferencesKeys.accessToken, data['token']);
          spUtil?.putString(SharedPreferencesKeys.deviceToken, dataObject.deviceToken);
          spUtil?.putInt(SharedPreferencesKeys.osSystem, data['user']['osSystem']);
          spUtil?.putString(SharedPreferencesKeys.providerUserId, dataObject.providerUserId);
          spUtil?.putString(SharedPreferencesKeys.provider, dataObject.provider);
          spUtil?.putInt(SharedPreferencesKeys.sessionId, data['user']['sessionId']);

          emit(LoginSuccessful(account));
        } else {
          emit(LoginFailure());
          return;
        }
      },
    );
  }

  void _onCheckAccountIsExistedAccountEvent(CheckAccountIsExistedAccountEvent event, Emitter<AccountState> emit) async {
    emit(CheckingAccountExistedState());
    final response = await _accountRepo.checkAccountIsExist<Map<String, dynamic>>(param: {'provider': event.provider, 'providerUserId': event.providerUserId});
    response.fold(
      (l) {
        if (l is AppError && l.applicationStatusCode == StatusCode.ALREADY_EXISTS) {
          emit(AccountWasExistedState(event.provider, event.providerUserId));
        } else if (l is AppError && l.applicationStatusCode == StatusCode.NO_INTERNET_CONNECTION) {
          emit(LoginConnectError());
        }

        emit(LoginFailure());
        return;
      },
      (r) {
        if (r != null) {
          final data = response.right;
          if (data != null && data['code'] != null && data['code'] == StatusCode.ALREADY_EXISTS) {
            emit(AccountWasExistedState(event.provider, event.providerUserId));
          } else {
            emit(AccountNotExistedState(event.provider, event.providerUserId));
          }
        } else {
          emit(AccountNotExistedState(event.provider, event.providerUserId));
        }
      },
    );
  }

  void _onRefreshAccountTokenAccountEvent(RefreshAccountTokenAccountEvent event, Emitter<AccountState> emit) async {
    spUtil = await SpUtil.getInstance();
    int? accountId = spUtil?.getInt(SharedPreferencesKeys.currentAccountId);
    int? osSystem = spUtil?.getInt(SharedPreferencesKeys.osSystem);
    String? deviceToken = spUtil?.getString(SharedPreferencesKeys.deviceToken);
    String? languageCode = spUtil?.getString(SharedPreferencesKeys.language);
    String? accessToken = spUtil?.getString(SharedPreferencesKeys.accessToken);
    String? provider = spUtil?.getString(SharedPreferencesKeys.provider);
    String? providerUserId = spUtil?.getString(SharedPreferencesKeys.providerUserId);

    if (accountId != null) {
      Account? account = await _databaseHelper.getAccountWithId(accountId);
      if (account != null) {
        deviceToken = "ABCDEFGHIKLMNOPQRSTUVXY";
        LoginData loginData = LoginData(
            language: languageCode == 'vi' ? 1 : 2,
            deviceToken: deviceToken,
            osSystem: osSystem,
            password: account.password,
            provider: provider,
            providerUserId: providerUserId);
        final response = await _accountRepo.refreshToken(loginData, accessToken, deviceToken);

        if (response.isLeft) {
          if (response.left.applicationStatusCode == StatusCode.STATUS_UNAUTHORIZED) {
            bool? isSavePass = spUtil?.getBool(SharedPreferencesKeys.isSavePass);
            await spUtil?.clear();
            if (provider == ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE || provider == ConfigApp.PROVIDER_LOGIN_PHONE_TYPE) {
              spUtil?.putString(SharedPreferencesKeys.providerUserId, providerUserId);
              spUtil?.putString(SharedPreferencesKeys.password, account.password);
              spUtil?.putBool(SharedPreferencesKeys.isSavePass, isSavePass);
              spUtil?.putString(SharedPreferencesKeys.provider, provider);
              spUtil?.putString(SharedPreferencesKeys.language, languageCode);
            }
          }
          emit(const AuthenticatedSuccessState(1));
          return;
        }

        final data = response.right;
        if (data != null) {
          Account acc = Account.fromBEJson(data['user']);
          acc.password = account.password;
          _databaseHelper.addOrUpdateAccount(acc);
          spUtil?.putString(SharedPreferencesKeys.accessToken, data['token']);
          spUtil?.putInt(SharedPreferencesKeys.sessionId, data['user']['sessionId']);
          emit(const AuthenticatedSuccessState(1));
        }
      }
    } else {
      emit(const UnAuthenticatedState(1));
    }
  }

  void _onGetAccountLoginEvent(GetAccountLoginEvent event, Emitter<AccountState> emit) async {
    spUtil = await SpUtil.getInstance();
    int? id = spUtil?.getInt(SharedPreferencesKeys.currentAccountId);
    Account? account;
    if (id != null) {
      account = await _databaseHelper.getAccountWithId(id);
      if (account == null) return;
    } else
      return;

    emit(GetAccountLoginState(account: account));
  }

  void _onUpdateAccountEvent(UpdateAccountEvent event, Emitter<AccountState> emit) async {
    UpdateAccountData accountData = UpdateAccountData.fromAccountMap(event.account.toBEMap());
    final response = await _accountRepo.updateAccount(accountData);
    if (response.isLeft) {
      emit(UpdateAccountFailedState());
      return;
    }
    final data = response.right;
    if (data != null) {
      Account accountUpdate = Account.fromBEToUpdateAccountJson(data);
      await _databaseHelper.updateAccount(accountUpdate);
      emit(UpdateAccountSuccessState());
    } else {
      emit(UpdateAccountFailedState());
    }
  }

  void _onRegisterUserAccountEvent(RegisterAccountEvent event, Emitter<AccountState> emit) async {
    spUtil = await SpUtil.getInstance();
    String? lang = spUtil?.getString(SharedPreferencesKeys.language);
    int lan = lang != null ? (lang == 'vi' ? 1 : 2) : 1;
    event.registerAccountModel.lang = lan;
    final response = await _accountRepo.registerAccount(event.registerAccountModel);
    return response.fold(
      (left) {
        if (left is AppError) {
          switch (left.applicationStatusCode) {
            case StatusCode.ERROR:
              emit(RegisterAccountSystemErrorState());
              break;
            case StatusCode.DEVICE_DELETE_ERROR_BY_STATUS:
              emit(RegisterAccountSentSMSLimitState());
              break;
            default:
              emit(RegisterAccountSystemErrorState());
              break;
          }
        } else {
          emit(RegisterAccountSystemErrorState());
        }
      },
      (right) {
        emit(RegisterAccountSuccessfulState());
      },
    );
  }

  void _onLogoutAccountEvent(LogoutAccountEvent event, Emitter<AccountState> emit) async {
    spUtil = await SpUtil.instance;
    int? accountId = spUtil?.getInt(SharedPreferencesKeys.currentAccountId);
    String? password = spUtil?.getString(SharedPreferencesKeys.password);
    String? provider = spUtil?.getString(SharedPreferencesKeys.provider);
    String? providerUserId = spUtil?.getString(SharedPreferencesKeys.providerUserId);
    String? deviceToken = spUtil?.getString(SharedPreferencesKeys.deviceToken);
    bool isSavePass = spUtil?.getBool(SharedPreferencesKeys.isSavePass) ?? false;
    String? languageCode = spUtil?.getString(SharedPreferencesKeys.language);
    String? mapFavoriteStr = spUtil?.getString(SharedPreferencesKeys.listFavoriteDeviceJson);

    final response = await _accountRepo.doLogOut(deviceToken ?? "");
    if (response.isLeft) {
      emit(AccountLogoutFailedState());
      return;
    }

    final data = response.right;
    if (data != null) {
      await _databaseHelper.deleteAccount(accountId);
      //todo: đang bị lỗi nếu bảng Device bị null
      // await _databaseHelper.deleteAllDevice();
      await spUtil?.clear();
      if (provider == ConfigApp.PROVIDER_LOGIN_EMAIL_TYPE || provider == ConfigApp.PROVIDER_LOGIN_PHONE_TYPE) {
        spUtil?.putString(SharedPreferencesKeys.providerUserId, providerUserId);
        spUtil?.putString(SharedPreferencesKeys.provider, provider);
        if (isSavePass) {
          spUtil?.putString(SharedPreferencesKeys.password, password);
        }
        spUtil?.putBool(SharedPreferencesKeys.isSavePass, isSavePass);
        spUtil?.putString(SharedPreferencesKeys.language, languageCode);
      }
      spUtil?.putString(SharedPreferencesKeys.language, languageCode);
      spUtil?.putString(SharedPreferencesKeys.listFavoriteDeviceJson, mapFavoriteStr);
      emit(AccountLogoutSuccessfulState());
    } else {
      emit(AccountLogoutFailedState());
    }
  }

  void _onAccountChangeLanguageEvent(AccountChangeLanguageEvent event, Emitter<AccountState> emit) async {
    Locale locale = event.locale;

    await S.load(locale);
    spUtil = await SpUtil.instance;
    spUtil?.putString(SharedPreferencesKeys.language, locale.languageCode);

    emit(AccountChangeLanguageState(locale: locale));
  }

  void _onAccountGetLanguageEvent(AccountGetLanguageEvent event, Emitter<AccountState> emit) async {
    spUtil = await SpUtil.instance;
    String? language = spUtil?.getString(SharedPreferencesKeys.language);

    Locale locale = const Locale('vi');

    if (language != null) {
      locale = Locale(language);
    } else {
      spUtil?.putString(SharedPreferencesKeys.language, 'vi');
      locale = const Locale('vi');
    }
    emit(AccountGetLanguageState(locale: locale));
  }

  void _onAccountChangePasswordEvent(AccountChangePasswordEvent event, Emitter<AccountState> emit) async {
    spUtil = await SpUtil.instance;
    var accountId = spUtil?.getInt(SharedPreferencesKeys.currentAccountId);

    final response = await _accountRepo.changePassword(event.oldPassword, event.newPassword);
    if (response.isLeft) {
      emit(AccountChangePasswordFailState());
      return;
    }
    final changeSuccess = response.right;
    // Common.printLog('Data response change password: $changeSuccess');

    Account? account = await _databaseHelper.getAccountWithId(accountId ?? 0);
    account?.password = event.newPassword;

    if (changeSuccess && account != null) {
      await _databaseHelper.updateAccount(account);
      emit(AccountChangePasswordSuccessfulState());
    } else {
      emit(AccountChangePasswordFailState());
    }
  }

  void _onAccountSendOTPCodeEvent(AccountSendOTPCodeEvent event, Emitter<AccountState> emit) async {
    final response = await _accountRepo.sendOTPCode(providerUserId: event.providerUserId, provider: event.provider, activeCode: event.activeCode);
    if (response.isLeft) {
      emit(AccountSendOTPCodeFailState());
      return;
    }
    final data = response.right;
    if (data != null) {
      (data['code'] == 1) ? emit(AccountSendOTPCodeSuccessState()) : emit(AccountSendOTPWrongCodeState());
    } else {
      emit(AccountSendOTPCodeFailState());
    }
  }
}
