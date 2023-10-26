// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(name) => "${name}不可为空";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "abort": MessageLookupByLibrary.simpleMessage("终止"),
        "accessToken": MessageLookupByLibrary.simpleMessage("访问令牌"),
        "appName": MessageLookupByLibrary.simpleMessage("一起来记账"),
        "authenticationFailed": MessageLookupByLibrary.simpleMessage("认证失败"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cannotBeEmpty": m0,
        "confirm": MessageLookupByLibrary.simpleMessage("确认"),
        "confirmDeletion": MessageLookupByLibrary.simpleMessage("确定要删除吗?"),
        "create": MessageLookupByLibrary.simpleMessage("创建"),
        "createBook": MessageLookupByLibrary.simpleMessage("创建账本"),
        "detail": MessageLookupByLibrary.simpleMessage("详细"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "empty": MessageLookupByLibrary.simpleMessage("啥都没有耶"),
        "encryptionSettings": MessageLookupByLibrary.simpleMessage("加密设置"),
        "enterPwd": MessageLookupByLibrary.simpleMessage("请输入密码"),
        "enterPwdAgain": MessageLookupByLibrary.simpleMessage("再输入一次密码"),
        "goOn": MessageLookupByLibrary.simpleMessage("继续"),
        "loading": MessageLookupByLibrary.simpleMessage("加载中"),
        "name": MessageLookupByLibrary.simpleMessage("名称"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "public": MessageLookupByLibrary.simpleMessage("公开"),
        "reconfirm": MessageLookupByLibrary.simpleMessage("再次确认"),
        "removeLocal": MessageLookupByLibrary.simpleMessage("只删除本地"),
        "reset": MessageLookupByLibrary.simpleMessage("重置"),
        "submit": MessageLookupByLibrary.simpleMessage("提交"),
        "summary": MessageLookupByLibrary.simpleMessage("简介"),
        "twoPwdDifferent": MessageLookupByLibrary.simpleMessage("两次输入的密码不同"),
        "user": MessageLookupByLibrary.simpleMessage("用户"),
        "verify": MessageLookupByLibrary.simpleMessage("验证"),
        "wrongAccessToken": MessageLookupByLibrary.simpleMessage("令牌错误")
      };
}
