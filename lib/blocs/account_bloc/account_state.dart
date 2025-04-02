import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/model/login_data_model.dart';
import 'package:flutter/material.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List get props => [];
}

class InitialAccountState extends AccountState {
  @override
  List get props => [];
}

class LoginFailure extends AccountState {}

class LoginWrongUsernameOrPassword extends AccountState {
  final LoginData loginData;

  const LoginWrongUsernameOrPassword(this.loginData);

  @override
  List get props => [this.loginData];
}

class LoginSuccessful extends AccountState {
  final Account account;

  const LoginSuccessful(this.account);

  @override
  List get props => [account, Random().nextInt(999999)];
}

class CheckingAccountExistedState extends AccountState {}

class AccountWasExistedState extends AccountState {
  final String? providerUserId;
  final String? provider;

  const AccountWasExistedState(this.provider, this.providerUserId);

  @override
  List get props => [providerUserId, provider];
}

class LoginConnectError extends AccountState {}

class AccountNotExistedState extends AccountState {
  final String? providerUserId;
  final String? provider;

  const AccountNotExistedState(this.provider, this.providerUserId);

  @override
  List get props => [providerUserId, provider];
}

class AuthenticatedSuccessState extends AccountState {
  final int randomAuthenticatedKey;

  const AuthenticatedSuccessState(this.randomAuthenticatedKey);

  @override
  List get props => [randomAuthenticatedKey];
}

class UnAuthenticatedState extends AccountState {
  final int randomKey;

  const UnAuthenticatedState(this.randomKey);

  @override
  List get props => [randomKey];
}

class GetAccountLoginState extends AccountState {
  final Account account;

  const GetAccountLoginState({required this.account});

  @override
  List get props => [account];
}

class UpdateAccountSuccessState extends AccountState {
  @override
  List get props => [];
}

class UpdateAccountFailedState extends AccountState {
  @override
  List get props => [Random().nextInt(9999)];
}

class RegisterAccountSystemErrorState extends AccountState {
  @override
  List get props => [];
}

class RegisterAccountSentSMSLimitState extends AccountState {
  @override
  List get props => [];
}

class RegisterAccountSuccessfulState extends AccountState {
  @override
  List get props => [];
}

class AccountLogoutFailedState extends AccountState {
  @override
  List get props => [];
}

class AccountLogoutSuccessfulState extends AccountState {
  @override
  List get props => [];
}

class AccountChangeLanguageState extends AccountState {
  final Locale locale;

  const AccountChangeLanguageState({required this.locale});

  @override
  List get props => [Random().nextInt(999999), locale];
}

class AccountGetLanguageState extends AccountState {
  final Locale locale;

  const AccountGetLanguageState({required this.locale});

  @override
  List get props => [Random().nextInt(999999), locale];
}

class AccountChangePasswordSuccessfulState extends AccountState {
  @override
  List get props => [Random().nextInt(999999)];
}

class AccountChangePasswordFailState extends AccountState {
  @override
  List get props => [Random().nextInt(999999)];
}

class AccountSendOTPCodeSuccessState extends AccountState {
  @override
  List get props => [Random().nextInt(999999)];
}

class AccountSendOTPWrongCodeState extends AccountState {
  @override
  List get props => [Random().nextInt(999999)];
}

class AccountSendOTPCodeFailState extends AccountState {
  @override
  List get props => [Random().nextInt(999999)];
}
