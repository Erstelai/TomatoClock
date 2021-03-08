import 'package:intl/intl.dart';
class DateTool {
  static String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }
  static String getTodayFormatDateString() {
    DateTime todayDate = DateTime.now();
    DateFormat format = DateFormat('yyyy/MM/dd');
    String dateString = format.format(todayDate);
    return dateString;
  }

  static String getMinutes(int sec) {
    int min = (sec / 60).truncate();
    String minStr = (min % 60).toString();
    return minStr;
  }
}