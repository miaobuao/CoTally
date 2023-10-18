import "package:i18n_extension/i18n_extension.dart";

extension Localization on String {
  String get i18n => localize(this, t);
  static var t = translations("zh_cn", [
    ("CoTally", "一起来记账"),
    ("Enter the password once", '请输入一次密码'),
    ("Enter the password again", "请再输入一次密码"),
    ("Password", "密码"),
    ("Encryption Settings", "加密设置"),
    ("Cannot be empty", "不可为空"),
    ("The passwords entered twice are not the same", "两次输入的密码不相同"),
    ("Done", "完成"),
    ("Verify", "身份验证"),
    ("Submit", "提交"),
    ("Confirm", "确认"),
    ("Cancel", "取消"),
    ("Reset", "重置"),
  ]);
}

Translations translations(String defaultLocale, List<(String, String)> locale) {
  var t = Translations(defaultLocale);
  for (var element in locale) {
    final (en, zh) = element;
    t += tt(en, zh);
  }
  return t;
}

Map<String, String> tt(String? enUs, String? zhCn) {
  final Map<String, String> rec = {};
  if (enUs != null) {
    rec["en_us"] = enUs;
  }
  if (zhCn != null) {
    rec["zh_cn"] = zhCn;
  }
  return rec;
}
