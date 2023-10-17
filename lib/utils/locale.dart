import "package:i18n_extension/i18n_extension.dart";

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

extension Localization on String {
  String get i18n => localize(this, t);
  static var t = Translations("zh_cn") +
      tt("CoTally", "一起来记账") +
      tt("Enter the password once.", '请输入一次密码') +
      tt("Enter the password again.", "请再输入一次密码") +
      tt("Password", "密码") +
      tt("Encryption Settings", "加密设置");
}
