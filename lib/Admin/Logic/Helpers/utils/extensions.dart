import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

extension NumberX on int {
  String toNumber() {
    final formatter = NumberFormat('#,###', 'fa');
    return formatter.format(this);
  }
}
extension StringX on String {

  /// Converts a string in "yyyy/MM/dd" format to a Jalali date.
  Jalali toJalai() {
    // Split the string by '/'
    List<String> parts = this.split('/');
    if (parts.length != 3) {
      throw FormatException('Invalid Jalali date format. Expected yyyy/MM/dd');
    }

    // Parse each part safely
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) {
      throw FormatException('Invalid number in Jalali date string.');
    }

    return Jalali(year, month, day);
  }

}

extension DateTimeXPro on DateTime {

  // -------------------------
  // Basic Components
  // -------------------------
  int get y => year;
  int get m => month;
  int get d => day;
  int get h => hour;
  int get min => minute;
  int get s => second;
  int get ms => millisecond;
  int get weekdayNum => int.parse(weekday.toString()); // 1=Mon ... 7=Sun

  // -------------------------
  // Weekday Names
  // -------------------------
  String get weekday => DateFormat('EEEE', 'en').format(this);     // full name
  String get weekdayShort => DateFormat('EEE', 'en').format(this); // short name
  String get weekdayFa => DateFormat('EEEE', 'fa').format(this);
  String get weekdayShortFa => DateFormat('EEE', 'fa').format(this);

  // -------------------------
  // Month Names
  // -------------------------
  String get monthName => DateFormat('MMMM', 'en').format(this); // full
  String get monthShort => DateFormat('MMM', 'en').format(this); // short
  String get monthNameFa => DateFormat('MMMM', 'fa').format(this);
  String get monthShortFa => DateFormat('MMM', 'fa').format(this);

  // -------------------------
  // Full Formats
  // -------------------------
  String get ymd => DateFormat('yyyy/MM/dd').format(this);
  String get ymdDash => DateFormat('yyyy-MM-dd').format(this);
  String get ymdDot => DateFormat('yyyy.MM.dd').format(this);

  String get dmy => DateFormat('dd/MM/yyyy').format(this);
  String get dmyDash => DateFormat('dd-MM-yyyy').format(this);

  String get ymdhm => DateFormat('yyyy/MM/dd HH:mm').format(this);
  String get ymdhms => DateFormat('yyyy/MM/dd HH:mm:ss').format(this);

  String get hm => DateFormat('HH:mm').format(this);
  String get hms => DateFormat('HH:mm:ss').format(this);

  // -------------------------
  // Relative
  // -------------------------
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  // -------------------------
  // Add / Subtract
  // -------------------------
  DateTime addYears(int years) => DateTime(year + years, month, day, hour, minute, second, millisecond);

  DateTime addMonths(int months) {
    int newYear = year + ((month + months - 1) ~/ 12);
    int newMonth = (month + months - 1) % 12 + 1;
    int newDay = day;
    final daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > daysInNewMonth) newDay = daysInNewMonth;
    return DateTime(newYear, newMonth, newDay, hour, minute, second, millisecond);
  }

  DateTime addDays(int days) => add(Duration(days: days));
  DateTime addHours(int hours) => add(Duration(hours: hours));
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));
  DateTime addSeconds(int seconds) => add(Duration(seconds: seconds));

  DateTime subtractYears(int years) => addYears(-years);
  DateTime subtractMonths(int months) => addMonths(-months);
  DateTime subtractDays(int days) => addDays(-days);
  DateTime subtractHours(int hours) => addHours(-hours);
  DateTime subtractMinutes(int minutes) => addMinutes(-minutes);
  DateTime subtractSeconds(int seconds) => addSeconds(-seconds);

  // -------------------------
  // Leap Year & Days
  // -------------------------
  bool get isLeapYear =>
      (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  int get daysInMonth {
    final beginningNextMonth = (month < 12)
        ? DateTime(year, month + 1, 1)
        : DateTime(year + 1, 1, 1);
    return beginningNextMonth.subtract(Duration(days: 1)).day;
  }

  // -------------------------
  // Ago / Time Difference
  // -------------------------
  String timeAgo({bool fa = true}) {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return fa ? 'چند ثانیه پیش' : 'just now';
    if (diff.inMinutes < 60) return fa ? '${diff.inMinutes} دقیقه پیش' : '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return fa ? '${diff.inHours} ساعت پیش' : '${diff.inHours} h ago';
    if (diff.inDays < 7) return fa ? '${diff.inDays} روز پیش' : '${diff.inDays} d ago';
    if (diff.inDays < 30) return fa ? '${(diff.inDays/7).floor()} هفته پیش' : '${(diff.inDays/7).floor()} w ago';
    if (diff.inDays < 365) return fa ? '${(diff.inDays/30).floor()} ماه پیش' : '${(diff.inDays/30).floor()} mo ago';
    return fa ? '${(diff.inDays/365).floor()} سال پیش' : '${(diff.inDays/365).floor()} y ago';
  }
}

extension JalaliXPro on Jalali {

  // -------------------------
  // Basic Components
  // -------------------------
  int get y => year;
  int get m => month;
  int get d => day;
  int get weekdayNum => weekDay; // 1=Sat ... 7=Fri

  // -------------------------
  // Weekday Names
  // -------------------------
  String get weekdayName => formatter.wN; // full name

  // -------------------------
  // Month Names
  // -------------------------
  String get monthName => formatter.mN; // full month name

  // -------------------------
  // Full Formats
  // -------------------------
  String get ymd => '$year/${month.toString().padLeft(2,'0')}/${day.toString().padLeft(2,'0')}';
  String get dmy => '${day.toString().padLeft(2,'0')}/${month.toString().padLeft(2,'0')}/$year';
  String get ymdDash => '$year-${month.toString().padLeft(2,'0')}-${day.toString().padLeft(2,'0')}';
  String get dmyDash => '${day.toString().padLeft(2,'0')}-${month.toString().padLeft(2,'0')}-$year';

  // -------------------------
  // Conversion to DateTime
  // -------------------------
  DateTime get convertDateTime => toDateTime();

  // -------------------------
  // Relative Dates
  // -------------------------
  bool get isToday {
    final now = Jalali.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = Jalali.now().subtractDays(1);
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = Jalali.now().addDays(1);
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  // -------------------------
  // Add / Subtract
  // -------------------------
  Jalali addYears(int years) => Jalali(year + years, month, day);

  Jalali addMonths(int months) {
    int newYear = year + ((month + months - 1) ~/ 12);
    int newMonth = (month + months - 1) % 12 + 1;
    int newDay = day > Jalali(newYear, newMonth, 1).monthLength
        ? Jalali(newYear, newMonth, 1).monthLength
        : day;
    return Jalali(newYear, newMonth, newDay);
  }

  Jalali addDays(int days) => this.addDays(days);
  Jalali addHours(int hours) => this.addHours(hours);
  Jalali addMinutes(int minutes) => this.addMinutes(minutes);
  Jalali addSeconds(int seconds) => this.addSeconds(seconds);

  Jalali subtractYears(int years) => addYears(-years);
  Jalali subtractMonths(int months) => addMonths(-months);
  Jalali subtractDays(int days) => addDays(-days);
  Jalali subtractHours(int hours) => addHours(-hours);
  Jalali subtractMinutes(int minutes) => addMinutes(-minutes);
  Jalali subtractSeconds(int seconds) => addSeconds(-seconds);

  // -------------------------
  // Leap Year & Days
  // -------------------------
  // bool get isLeapYear => Jalali..isLeapYear(year);
  int get daysInMonth => monthLength;

  // -------------------------
  // Time Helper
  // -------------------------
  int get hour => convertDateTime.hour;
  int get minute => convertDateTime.minute;
  int get second => convertDateTime.second;

  String get hm => '${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}';
  String get hms => '${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}:${second.toString().padLeft(2,'0')}';

  // -------------------------
  // Ago / Time Difference
  // -------------------------
  String timeAgo({bool fa = true}) {
    final now = DateTime.now();
    final diff = now.difference(convertDateTime);

    if (diff.inSeconds < 60) return fa ? 'چند ثانیه پیش' : 'just now';
    if (diff.inMinutes < 60) return fa ? '${diff.inMinutes} دقیقه پیش' : '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return fa ? '${diff.inHours} ساعت پیش' : '${diff.inHours} h ago';
    if (diff.inDays < 7) return fa ? '${diff.inDays} روز پیش' : '${diff.inDays} d ago';
    if (diff.inDays < 30) return fa ? '${(diff.inDays/7).floor()} هفته پیش' : '${(diff.inDays/7).floor()} w ago';
    if (diff.inDays < 365) return fa ? '${(diff.inDays/30).floor()} ماه پیش' : '${(diff.inDays/30).floor()} mo ago';
    return fa ? '${(diff.inDays/365).floor()} سال پیش' : '${(diff.inDays/365).floor()} y ago';
  }


}
