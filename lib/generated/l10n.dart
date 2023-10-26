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

  /// `CoTally`
  String get appName {
    return Intl.message(
      'CoTally',
      name: 'appName',
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
  String get enterPwd {
    return Intl.message(
      'Enter password',
      name: 'enterPwd',
      desc: '',
      args: [],
    );
  }

  /// `Enter password again`
  String get enterPwdAgain {
    return Intl.message(
      'Enter password again',
      name: 'enterPwdAgain',
      desc: '',
      args: [],
    );
  }

  /// `Encryption Settings`
  String get encryptionSettings {
    return Intl.message(
      'Encryption Settings',
      name: 'encryptionSettings',
      desc: '',
      args: [],
    );
  }

  /// `{name} cannot be empty`
  String cannotBeEmpty(Object name) {
    return Intl.message(
      '$name cannot be empty',
      name: 'cannotBeEmpty',
      desc: '',
      args: [name],
    );
  }

  /// `The two passwords entered are different`
  String get twoPwdDifferent {
    return Intl.message(
      'The two passwords entered are different',
      name: 'twoPwdDifferent',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Go on`
  String get goOn {
    return Intl.message(
      'Go on',
      name: 'goOn',
      desc: '',
      args: [],
    );
  }

  /// `Abort`
  String get abort {
    return Intl.message(
      'Abort',
      name: 'abort',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed`
  String get authenticationFailed {
    return Intl.message(
      'Authentication failed',
      name: 'authenticationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Access Token`
  String get accessToken {
    return Intl.message(
      'Access Token',
      name: 'accessToken',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Access Token`
  String get wrongAccessToken {
    return Intl.message(
      'Wrong Access Token',
      name: 'wrongAccessToken',
      desc: '',
      args: [],
    );
  }

  /// `Empty`
  String get empty {
    return Intl.message(
      'Empty',
      name: 'empty',
      desc: '',
      args: [],
    );
  }

  /// `Create Book`
  String get createBook {
    return Intl.message(
      'Create Book',
      name: 'createBook',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Completely Delete`
  String get removeCompletely {
    return Intl.message(
      'Completely Delete',
      name: 'removeCompletely',
      desc: '',
      args: [],
    );
  }

  /// `Remove Local`
  String get removeLocal {
    return Intl.message(
      'Remove Local',
      name: 'removeLocal',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get summary {
    return Intl.message(
      'Summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  /// `detail`
  String get detail {
    return Intl.message(
      'detail',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `Public`
  String get public {
    return Intl.message(
      'Public',
      name: 'public',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deletion?`
  String get confirmDeletion {
    return Intl.message(
      'Confirm Deletion?',
      name: 'confirmDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Reconfirm`
  String get reconfirm {
    return Intl.message(
      'Reconfirm',
      name: 'reconfirm',
      desc: '',
      args: [],
    );
  }

  /// `loading`
  String get loading {
    return Intl.message(
      'loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Operation Failed`
  String get failed {
    return Intl.message(
      'Operation Failed',
      name: 'failed',
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
      Locale.fromSubtags(languageCode: 'zh'),
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
