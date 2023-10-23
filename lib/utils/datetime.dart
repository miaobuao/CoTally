import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String timeFormat(DateTime time) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").format(time);
}
