import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/model/login_data_model.dart';
import 'package:flutter/widgets.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List get props => [];
}

class SubmittedLoginAccountEvent extends AccountEvent {
  final LoginData? dataObject;

  const SubmittedLoginAccountEvent(this.dataObject);

  @override
  List get props => [dataObject];
}

class CheckAccountIsExistedAccountEvent extends AccountEvent {
  final String? provider;
  final String? providerUserId;

  const CheckAccountIsExistedAccountEvent(this.provider, this.providerUserId);

  @override
  List get props => [provider, providerUserId];
}

class RefreshAccountTokenAccountEvent extends AccountEvent {
  @override
  List get props => [];
}

class GetAccountLoginEvent extends AccountEvent {
  @override
  List get props => [];
}

class RegisterAccountEvent extends AccountEvent {
  final RegisterAccountModel registerAccountModel;

  const RegisterAccountEvent({required this.registerAccountModel});

  @override
  List get props => [registerAccountModel];
}

class UpdateAccountEvent extends AccountEvent {
  final Account account;

  const UpdateAccountEvent({required this.account});

  @override
  List get props => [account];
}

class LogoutAccountEvent extends AccountEvent {
  @override
  List get props => [];
}

class AccountChangeLanguageEvent extends AccountEvent {
  final Locale locale;

  const AccountChangeLanguageEvent({required this.locale});

  @override
  List get props => [];
}

class AccountGetLanguageEvent extends AccountEvent {
  @override
  List get props => [];
}

class AccountChangePasswordEvent extends AccountEvent {
  final String oldPassword;
  final String newPassword;

  const AccountChangePasswordEvent({required this.oldPassword, required this.newPassword});
}

class AccountSendOTPCodeEvent extends AccountEvent {
  final String providerUserId;
  final String provider;
  final String activeCode;

  const AccountSendOTPCodeEvent({required this.providerUserId, required this.provider, required this.activeCode});
}
