// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `No connection. Please check the connection.`
  String get can_not_connect_to_server {
    return Intl.message(
      'No connection. Please check the connection.',
      name: 'can_not_connect_to_server',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is not registered`
  String get phone_not_registered_warning {
    return Intl.message(
      'Phone number is not registered',
      name: 'phone_not_registered_warning',
      desc: '',
      args: [],
    );
  }

  /// `Email is not registered`
  String get email_not_registered_warning {
    return Intl.message(
      'Email is not registered',
      name: 'email_not_registered_warning',
      desc: '',
      args: [],
    );
  }

  /// `Login information wrong`
  String get wrong_login_information {
    return Intl.message(
      'Login information wrong',
      name: 'wrong_login_information',
      desc: '',
      args: [],
    );
  }

  /// `Login failed, please try again`
  String get login_failed_please_try_again {
    return Intl.message(
      'Login failed, please try again',
      name: 'login_failed_please_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phone_number {
    return Intl.message(
      'Phone number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number or email`
  String get enter_phone_number_or_email {
    return Intl.message(
      'Enter phone number or email',
      name: 'enter_phone_number_or_email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get enter_password {
    return Intl.message(
      'Enter password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password ?`
  String get forgot_pass {
    return Intl.message(
      'Forgot password ?',
      name: 'forgot_pass',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get full_name {
    return Intl.message(
      'Full name',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter full name`
  String get enter_your_full_name {
    return Intl.message(
      'Enter full name',
      name: 'enter_your_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter password again`
  String get enter_password_again {
    return Intl.message(
      'Enter password again',
      name: 'enter_password_again',
      desc: '',
      args: [],
    );
  }

  /// `6-12 characters, written at once, without diacritics`
  String get password_length_requite {
    return Intl.message(
      '6-12 characters, written at once, without diacritics',
      name: 'password_length_requite',
      desc: '',
      args: [],
    );
  }

  /// `There are uppercase and lowercase letters`
  String get password_capital_letters_requite {
    return Intl.message(
      'There are uppercase and lowercase letters',
      name: 'password_capital_letters_requite',
      desc: '',
      args: [],
    );
  }

  /// `Save password`
  String get save_password {
    return Intl.message(
      'Save password',
      name: 'save_password',
      desc: '',
      args: [],
    );
  }

  /// `You do not have an account?`
  String get you_not_have_account {
    return Intl.message(
      'You do not have an account?',
      name: 'you_not_have_account',
      desc: '',
      args: [],
    );
  }

  /// `You have account?`
  String get you_have_account {
    return Intl.message(
      'You have account?',
      name: 'you_have_account',
      desc: '',
      args: [],
    );
  }

  /// `You need to enter login information`
  String get login_text_empty_warning {
    return Intl.message(
      'You need to enter login information',
      name: 'login_text_empty_warning',
      desc: '',
      args: [],
    );
  }

  /// `Phone number or email invalid`
  String get email_phone_invalid_warning {
    return Intl.message(
      'Phone number or email invalid',
      name: 'email_phone_invalid_warning',
      desc: '',
      args: [],
    );
  }

  /// `Do not have device`
  String get do_not_have_device {
    return Intl.message(
      'Do not have device',
      name: 'do_not_have_device',
      desc: '',
      args: [],
    );
  }

  /// `Add device`
  String get add_device {
    return Intl.message(
      'Add device',
      name: 'add_device',
      desc: '',
      args: [],
    );
  }

  /// `Choose device type`
  String get choose_device_type {
    return Intl.message(
      'Choose device type',
      name: 'choose_device_type',
      desc: '',
      args: [],
    );
  }

  /// `Connect device`
  String get connect_device {
    return Intl.message(
      'Connect device',
      name: 'connect_device',
      desc: '',
      args: [],
    );
  }

  /// `Device code`
  String get device_code {
    return Intl.message(
      'Device code',
      name: 'device_code',
      desc: '',
      args: [],
    );
  }

  /// `Scan Serial barcode or enter code on device`
  String get add_barcode_or_enter_code_on_device {
    return Intl.message(
      'Scan Serial barcode or enter code on device',
      name: 'add_barcode_or_enter_code_on_device',
      desc: '',
      args: [],
    );
  }

  /// `Press the reset button continuously 3 times at 3 second intervals until the light flashes`
  String get enter_button_3_times_util_light_flash {
    return Intl.message(
      'Press the reset button continuously 3 times at 3 second intervals until the light flashes',
      name: 'enter_button_3_times_util_light_flash',
      desc: '',
      args: [],
    );
  }

  /// `You can scan or enter device code`
  String get you_need_scan_device_code {
    return Intl.message(
      'You can scan or enter device code',
      name: 'you_need_scan_device_code',
      desc: '',
      args: [],
    );
  }

  /// `Device type`
  String get device_type {
    return Intl.message(
      'Device type',
      name: 'device_type',
      desc: '',
      args: [],
    );
  }

  /// `Device connect time`
  String get time_to_connect_device {
    return Intl.message(
      'Device connect time',
      name: 'time_to_connect_device',
      desc: '',
      args: [],
    );
  }

  /// `Connect device unsuccessful`
  String get connect_device_fail {
    return Intl.message(
      'Connect device unsuccessful',
      name: 'connect_device_fail',
      desc: '',
      args: [],
    );
  }

  /// `Add device success`
  String get add_device_success {
    return Intl.message(
      'Add device success',
      name: 'add_device_success',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get try_again {
    return Intl.message(
      'Try again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continued {
    return Intl.message(
      'Continue',
      name: 'continued',
      desc: '',
      args: [],
    );
  }

  /// `Choose continue`
  String get choose_continue {
    return Intl.message(
      'Choose continue',
      name: 'choose_continue',
      desc: '',
      args: [],
    );
  }

  /// `Pairing success`
  String get pairing_success {
    return Intl.message(
      'Pairing success',
      name: 'pairing_success',
      desc: '',
      args: [],
    );
  }

  /// `Pairing failure`
  String get pairing_failure {
    return Intl.message(
      'Pairing failure',
      name: 'pairing_failure',
      desc: '',
      args: [],
    );
  }

  /// `Diagram`
  String get diagram {
    return Intl.message(
      'Diagram',
      name: 'diagram',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connected {
    return Intl.message(
      'Connected',
      name: 'connected',
      desc: '',
      args: [],
    );
  }

  /// `Lost connected`
  String get lost_connected {
    return Intl.message(
      'Lost connected',
      name: 'lost_connected',
      desc: '',
      args: [],
    );
  }

  /// `Warning history`
  String get warning_history {
    return Intl.message(
      'Warning history',
      name: 'warning_history',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get personal_information {
    return Intl.message(
      'Personal information',
      name: 'personal_information',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get date_of_birth {
    return Intl.message(
      'Date of birth',
      name: 'date_of_birth',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Edit information`
  String get edit_information {
    return Intl.message(
      'Edit information',
      name: 'edit_information',
      desc: '',
      args: [],
    );
  }

  /// `Save information`
  String get save_information {
    return Intl.message(
      'Save information',
      name: 'save_information',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get old_password {
    return Intl.message(
      'Old password',
      name: 'old_password',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password {
    return Intl.message(
      'New password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter password`
  String get re_enter_password {
    return Intl.message(
      'Re-enter password',
      name: 're_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Building management`
  String get building_management {
    return Intl.message(
      'Building management',
      name: 'building_management',
      desc: '',
      args: [],
    );
  }

  /// `Add house`
  String get add_house {
    return Intl.message(
      'Add house',
      name: 'add_house',
      desc: '',
      args: [],
    );
  }

  /// `House`
  String get house {
    return Intl.message(
      'House',
      name: 'house',
      desc: '',
      args: [],
    );
  }

  /// `Building name`
  String get building_name {
    return Intl.message(
      'Building name',
      name: 'building_name',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Province/City`
  String get province_city {
    return Intl.message(
      'Province/City',
      name: 'province_city',
      desc: '',
      args: [],
    );
  }

  /// `District/Town`
  String get district_town {
    return Intl.message(
      'District/Town',
      name: 'district_town',
      desc: '',
      args: [],
    );
  }

  /// `Specific address`
  String get specific_address {
    return Intl.message(
      'Specific address',
      name: 'specific_address',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `Floor-Room`
  String get floor_room {
    return Intl.message(
      'Floor-Room',
      name: 'floor_room',
      desc: '',
      args: [],
    );
  }

  /// `Floor list`
  String get floor_list {
    return Intl.message(
      'Floor list',
      name: 'floor_list',
      desc: '',
      args: [],
    );
  }

  /// `Add floor`
  String get add_floor {
    return Intl.message(
      'Add floor',
      name: 'add_floor',
      desc: '',
      args: [],
    );
  }

  /// `Floor name`
  String get floor_name {
    return Intl.message(
      'Floor name',
      name: 'floor_name',
      desc: '',
      args: [],
    );
  }

  /// `Room list`
  String get room_list {
    return Intl.message(
      'Room list',
      name: 'room_list',
      desc: '',
      args: [],
    );
  }

  /// `Room equipment`
  String get room_equipment {
    return Intl.message(
      'Room equipment',
      name: 'room_equipment',
      desc: '',
      args: [],
    );
  }

  /// `Room name`
  String get room_name {
    return Intl.message(
      'Room name',
      name: 'room_name',
      desc: '',
      args: [],
    );
  }

  /// `Update current location`
  String get update_current_location {
    return Intl.message(
      'Update current location',
      name: 'update_current_location',
      desc: '',
      args: [],
    );
  }

  /// `Device management`
  String get device_management {
    return Intl.message(
      'Device management',
      name: 'device_management',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Add members`
  String get add_members {
    return Intl.message(
      'Add members',
      name: 'add_members',
      desc: '',
      args: [],
    );
  }

  /// `House owner`
  String get house_owner {
    return Intl.message(
      'House owner',
      name: 'house_owner',
      desc: '',
      args: [],
    );
  }

  /// `Relatives`
  String get relatives {
    return Intl.message(
      'Relatives',
      name: 'relatives',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message(
      'Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `Add share`
  String get add_share {
    return Intl.message(
      'Add share',
      name: 'add_share',
      desc: '',
      args: [],
    );
  }

  /// `Open App`
  String get open_app {
    return Intl.message(
      'Open App',
      name: 'open_app',
      desc: '',
      args: [],
    );
  }

  /// `Select Menu`
  String get select_menu {
    return Intl.message(
      'Select Menu',
      name: 'select_menu',
      desc: '',
      args: [],
    );
  }

  /// `Click QR code`
  String get click_qr_code {
    return Intl.message(
      'Click QR code',
      name: 'click_qr_code',
      desc: '',
      args: [],
    );
  }

  /// `3 Steps to open the shared code of the shared member`
  String get three_steps_to_open_the_shared_code_of_the_shared_member {
    return Intl.message(
      '3 Steps to open the shared code of the shared member',
      name: 'three_steps_to_open_the_shared_code_of_the_shared_member',
      desc: '',
      args: [],
    );
  }

  /// `Shared code`
  String get shared_code {
    return Intl.message(
      'Shared code',
      name: 'shared_code',
      desc: '',
      args: [],
    );
  }

  /// `Account type`
  String get account_type {
    return Intl.message(
      'Account type',
      name: 'account_type',
      desc: '',
      args: [],
    );
  }

  /// `Share all devices`
  String get share_all_devices {
    return Intl.message(
      'Share all devices',
      name: 'share_all_devices',
      desc: '',
      args: [],
    );
  }

  /// `All devices in the house will be shared. Please consider to ensure privacy and security for your home.`
  String get share_all_devices_hint_text {
    return Intl.message(
      'All devices in the house will be shared. Please consider to ensure privacy and security for your home.',
      name: 'share_all_devices_hint_text',
      desc: '',
      args: [],
    );
  }

  /// `female`
  String get female {
    return Intl.message(
      'female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `male`
  String get male {
    return Intl.message(
      'male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Enter email address`
  String get enter_email_address {
    return Intl.message(
      'Enter email address',
      name: 'enter_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Full name cannot be empty`
  String get name_empty {
    return Intl.message(
      'Full name cannot be empty',
      name: 'name_empty',
      desc: '',
      args: [],
    );
  }

  /// `Email/phone cannot be empty`
  String get email_phone_empty {
    return Intl.message(
      'Email/phone cannot be empty',
      name: 'email_phone_empty',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get password_empty {
    return Intl.message(
      'Password cannot be empty',
      name: 'password_empty',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect email/phone number format`
  String get email_phone_wrong_format {
    return Intl.message(
      'Incorrect email/phone number format',
      name: 'email_phone_wrong_format',
      desc: '',
      args: [],
    );
  }

  /// `Password format wrong`
  String get wrong_password_format {
    return Intl.message(
      'Password format wrong',
      name: 'wrong_password_format',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password again`
  String get confirm_password_empty {
    return Intl.message(
      'Enter your password again',
      name: 'confirm_password_empty',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter incorrect password`
  String get not_matched_password {
    return Intl.message(
      'Re-enter incorrect password',
      name: 'not_matched_password',
      desc: '',
      args: [],
    );
  }

  /// `Email was registered`
  String get email_was_registered {
    return Intl.message(
      'Email was registered',
      name: 'email_was_registered',
      desc: '',
      args: [],
    );
  }

  /// `Phone number was registered`
  String get phone_number_was_registered {
    return Intl.message(
      'Phone number was registered',
      name: 'phone_number_was_registered',
      desc: '',
      args: [],
    );
  }

  /// `Failed, please try again.`
  String get failed_please_try_again {
    return Intl.message(
      'Failed, please try again.',
      name: 'failed_please_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Sent SMS max in day. Please try again tomorrow.`
  String get sent_sms_limit {
    return Intl.message(
      'Sent SMS max in day. Please try again tomorrow.',
      name: 'sent_sms_limit',
      desc: '',
      args: [],
    );
  }

  /// `Confirm OTP`
  String get confirm_otp {
    return Intl.message(
      'Confirm OTP',
      name: 'confirm_otp',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the code we sent you via phone number`
  String get please_enter_the_code_we_sent_you_via_phone_number {
    return Intl.message(
      'Please enter the code we sent you via phone number',
      name: 'please_enter_the_code_we_sent_you_via_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to logout`
  String get do_you_want_to_logout {
    return Intl.message(
      'Do you want to logout',
      name: 'do_you_want_to_logout',
      desc: '',
      args: [],
    );
  }

  /// `Ignore`
  String get ignore {
    return Intl.message(
      'Ignore',
      name: 'ignore',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Please enter current password.`
  String get please_enter_current_password {
    return Intl.message(
      'Please enter current password.',
      name: 'please_enter_current_password',
      desc: '',
      args: [],
    );
  }

  /// `Old password is incorrect.`
  String get old_password_is_incorrect {
    return Intl.message(
      'Old password is incorrect.',
      name: 'old_password_is_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Please re-enter password.`
  String get please_re_enter_password {
    return Intl.message(
      'Please re-enter password.',
      name: 'please_re_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter incorrect password.`
  String get re_enter_incorrect_password {
    return Intl.message(
      'Re-enter incorrect password.',
      name: 're_enter_incorrect_password',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully.\nPlease log in again with the new password.`
  String
      get password_changed_successfully_please_log_in_again_with_the_new_password {
    return Intl.message(
      'Password changed successfully.\nPlease log in again with the new password.',
      name:
          'password_changed_successfully_please_log_in_again_with_the_new_password',
      desc: '',
      args: [],
    );
  }

  /// `You need to enter the building name.`
  String get you_need_to_enter_the_building_name {
    return Intl.message(
      'You need to enter the building name.',
      name: 'you_need_to_enter_the_building_name',
      desc: '',
      args: [],
    );
  }

  /// `You need to enter a building name of less than 25 characters.`
  String get you_need_to_enter_a_building_name_of_less_than_25_characters {
    return Intl.message(
      'You need to enter a building name of less than 25 characters.',
      name: 'you_need_to_enter_a_building_name_of_less_than_25_characters',
      desc: '',
      args: [],
    );
  }

  /// `You need to enter the building address.`
  String get you_need_to_enter_the_building_address {
    return Intl.message(
      'You need to enter the building address.',
      name: 'you_need_to_enter_the_building_address',
      desc: '',
      args: [],
    );
  }

  /// `Successfully created new building.`
  String get successfully_created_new_building {
    return Intl.message(
      'Successfully created new building.',
      name: 'successfully_created_new_building',
      desc: '',
      args: [],
    );
  }

  /// `Creating new building failed, please try again.`
  String get creating_new_building_failed_please_try_again {
    return Intl.message(
      'Creating new building failed, please try again.',
      name: 'creating_new_building_failed_please_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Update successful.`
  String get update_successful {
    return Intl.message(
      'Update successful.',
      name: 'update_successful',
      desc: '',
      args: [],
    );
  }

  /// `Update failed, please try again.`
  String get update_failed_please_try_again {
    return Intl.message(
      'Update failed, please try again.',
      name: 'update_failed_please_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Rename floor`
  String get rename_floor {
    return Intl.message(
      'Rename floor',
      name: 'rename_floor',
      desc: '',
      args: [],
    );
  }

  /// `Floor name`
  String get floor_name_title_input_text {
    return Intl.message(
      'Floor name',
      name: 'floor_name_title_input_text',
      desc: '',
      args: [],
    );
  }

  /// `You need to enter the floor name.`
  String get you_need_to_enter_the_floor_name {
    return Intl.message(
      'You need to enter the floor name.',
      name: 'you_need_to_enter_the_floor_name',
      desc: '',
      args: [],
    );
  }

  /// `Rename room`
  String get rename_room {
    return Intl.message(
      'Rename room',
      name: 'rename_room',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this room?`
  String get do_you_want_to_delete_this_room {
    return Intl.message(
      'Do you want to delete this room?',
      name: 'do_you_want_to_delete_this_room',
      desc: '',
      args: [],
    );
  }

  /// `Share management`
  String get share_management {
    return Intl.message(
      'Share management',
      name: 'share_management',
      desc: '',
      args: [],
    );
  }

  /// `Add member successful.`
  String get add_member_successful {
    return Intl.message(
      'Add member successful.',
      name: 'add_member_successful',
      desc: '',
      args: [],
    );
  }

  /// `Invalid sharing account.`
  String get invalid_sharing_account {
    return Intl.message(
      'Invalid sharing account.',
      name: 'invalid_sharing_account',
      desc: '',
      args: [],
    );
  }

  /// `This account already exists.`
  String get this_account_already_exists {
    return Intl.message(
      'This account already exists.',
      name: 'this_account_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Sharing failed, please try again.`
  String get sharing_failed_please_try_again {
    return Intl.message(
      'Sharing failed, please try again.',
      name: 'sharing_failed_please_try_again',
      desc: '',
      args: [],
    );
  }

  /// `You need to enter the sharing code, email or phone number of the shared account.`
  String
      get you_need_to_enter_the_sharing_code_email_or_phone_number_of_the_shared_account {
    return Intl.message(
      'You need to enter the sharing code, email or phone number of the shared account.',
      name:
          'you_need_to_enter_the_sharing_code_email_or_phone_number_of_the_shared_account',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Share settings`
  String get share_settings {
    return Intl.message(
      'Share settings',
      name: 'share_settings',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete the share?`
  String get do_you_want_to_delete_the_share {
    return Intl.message(
      'Do you want to delete the share?',
      name: 'do_you_want_to_delete_the_share',
      desc: '',
      args: [],
    );
  }

  /// `The selected time must be greater than the current time.`
  String get the_selected_time_must_be_greater_than_the_current_time {
    return Intl.message(
      'The selected time must be greater than the current time.',
      name: 'the_selected_time_must_be_greater_than_the_current_time',
      desc: '',
      args: [],
    );
  }

  /// `Emergency\nfire alarm`
  String get emergency_fire_alarm {
    return Intl.message(
      'Emergency\nfire alarm',
      name: 'emergency_fire_alarm',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Network connection`
  String get network_connection {
    return Intl.message(
      'Network connection',
      name: 'network_connection',
      desc: '',
      args: [],
    );
  }

  /// `Child devices`
  String get child_devices {
    return Intl.message(
      'Child devices',
      name: 'child_devices',
      desc: '',
      args: [],
    );
  }

  /// `Low battery`
  String get low_battery {
    return Intl.message(
      'Low battery',
      name: 'low_battery',
      desc: '',
      args: [],
    );
  }

  /// `OTP code expires after`
  String get OTP_code_expires_after {
    return Intl.message(
      'OTP code expires after',
      name: 'OTP_code_expires_after',
      desc: '',
      args: [],
    );
  }

  /// `second`
  String get second {
    return Intl.message(
      'second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `Send back`
  String get send_back {
    return Intl.message(
      'Send back',
      name: 'send_back',
      desc: '',
      args: [],
    );
  }

  /// `OTP code has expired.`
  String get OTP_code_has_expired {
    return Intl.message(
      'OTP code has expired.',
      name: 'OTP_code_has_expired',
      desc: '',
      args: [],
    );
  }

  /// `OTP code is incorrect.`
  String get OTP_code_is_incorrect {
    return Intl.message(
      'OTP code is incorrect.',
      name: 'OTP_code_is_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP code`
  String get resend_OTP_code {
    return Intl.message(
      'Resend OTP code',
      name: 'resend_OTP_code',
      desc: '',
      args: [],
    );
  }

  /// `Device details`
  String get device_details {
    return Intl.message(
      'Device details',
      name: 'device_details',
      desc: '',
      args: [],
    );
  }

  /// `Delete device`
  String get delete_device {
    return Intl.message(
      'Delete device',
      name: 'delete_device',
      desc: '',
      args: [],
    );
  }

  /// `Set up warning sounds`
  String get set_up_warning_sounds {
    return Intl.message(
      'Set up warning sounds',
      name: 'set_up_warning_sounds',
      desc: '',
      args: [],
    );
  }

  /// `Please press and hold the button on the device until the light flashes.`
  String
      get please_press_and_hold_the_button_on_the_device_until_the_light_flashes {
    return Intl.message(
      'Please press and hold the button on the device until the light flashes.',
      name:
          'please_press_and_hold_the_button_on_the_device_until_the_light_flashes',
      desc: '',
      args: [],
    );
  }

  /// `Device information`
  String get device_information {
    return Intl.message(
      'Device information',
      name: 'device_information',
      desc: '',
      args: [],
    );
  }

  /// `Network connection configuration`
  String get network_connection_configuration {
    return Intl.message(
      'Network connection configuration',
      name: 'network_connection_configuration',
      desc: '',
      args: [],
    );
  }

  /// `Device naming`
  String get device_naming {
    return Intl.message(
      'Device naming',
      name: 'device_naming',
      desc: '',
      args: [],
    );
  }

  /// `Warranty information`
  String get warranty_information {
    return Intl.message(
      'Warranty information',
      name: 'warranty_information',
      desc: '',
      args: [],
    );
  }

  /// `Device parameters`
  String get device_parameters {
    return Intl.message(
      'Device parameters',
      name: 'device_parameters',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Device name cannot be longer than 50 characters.`
  String get device_name_cannot_be_longer_than_50_characters {
    return Intl.message(
      'Device name cannot be longer than 50 characters.',
      name: 'device_name_cannot_be_longer_than_50_characters',
      desc: '',
      args: [],
    );
  }

  /// `Device name cannot be blank.`
  String get device_name_cannot_be_blank {
    return Intl.message(
      'Device name cannot be blank.',
      name: 'device_name_cannot_be_blank',
      desc: '',
      args: [],
    );
  }

  /// `Expiration date`
  String get expiration_date {
    return Intl.message(
      'Expiration date',
      name: 'expiration_date',
      desc: '',
      args: [],
    );
  }

  /// `Select preferred network when connecting`
  String get select_preferred_network_when_connecting {
    return Intl.message(
      'Select preferred network when connecting',
      name: 'select_preferred_network_when_connecting',
      desc: '',
      args: [],
    );
  }

  /// `Set warning time`
  String get set_warning_time {
    return Intl.message(
      'Set warning time',
      name: 'set_warning_time',
      desc: '',
      args: [],
    );
  }

  /// `Users can customize the confirmation time before the system sends an alert.`
  String
      get users_can_customize_the_confirmation_time_before_the_system_sends_an_alert {
    return Intl.message(
      'Users can customize the confirmation time before the system sends an alert.',
      name:
          'users_can_customize_the_confirmation_time_before_the_system_sends_an_alert',
      desc: '',
      args: [],
    );
  }

  /// `Warning confirmation time`
  String get warning_confirmation_time {
    return Intl.message(
      'Warning confirmation time',
      name: 'warning_confirmation_time',
      desc: '',
      args: [],
    );
  }

  /// `minute`
  String get minute {
    return Intl.message(
      'minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `Choose time`
  String get choose_time {
    return Intl.message(
      'Choose time',
      name: 'choose_time',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to erase the device?`
  String get are_you_sure_you_want_to_erase_the_device {
    return Intl.message(
      'Are you sure you want to erase the device?',
      name: 'are_you_sure_you_want_to_erase_the_device',
      desc: '',
      args: [],
    );
  }

  /// `Mode`
  String get mode {
    return Intl.message(
      'Mode',
      name: 'mode',
      desc: '',
      args: [],
    );
  }

  /// `Important warnings related to security, hazard detection, incidents,...`
  String
      get important_warnings_related_to_security_hazard_detection_incidents_etc {
    return Intl.message(
      'Important warnings related to security, hazard detection, incidents,...',
      name:
          'important_warnings_related_to_security_hazard_detection_incidents_etc',
      desc: '',
      args: [],
    );
  }

  /// `Sound`
  String get sound {
    return Intl.message(
      'Sound',
      name: 'sound',
      desc: '',
      args: [],
    );
  }

  /// `Warning sound cycle`
  String get warning_sound_cycle {
    return Intl.message(
      'Warning sound cycle',
      name: 'warning_sound_cycle',
      desc: '',
      args: [],
    );
  }

  /// `Send warning later`
  String get send_warning_later {
    return Intl.message(
      'Send warning later',
      name: 'send_warning_later',
      desc: '',
      args: [],
    );
  }

  /// `Number of iterations`
  String get number_of_iterations {
    return Intl.message(
      'Number of iterations',
      name: 'number_of_iterations',
      desc: '',
      args: [],
    );
  }

  /// `times`
  String get times {
    return Intl.message(
      'times',
      name: 'times',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
