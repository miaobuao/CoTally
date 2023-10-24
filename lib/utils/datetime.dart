import 'package:intl/intl.dart';

String timeFormat(DateTime time) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").format(time);
}
