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
  static var t = Translations("en_us") + tt("CoTally", "CoTally");
}
