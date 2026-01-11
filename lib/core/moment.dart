// ignore_for_file: constant_identifier_names, collection_methods_unrelated_type

void main() {
  Moment f = Moment.now();
  print(f);
}

class Moment {
  int? second;
  int? minute;
  int? hour;
  int? date;
  int? month;
  int? year;
  List<String>? formatStyle;
  SpacingSide? spacingSide;

  Moment({
    this.second,
    this.minute,
    this.hour,
    this.date,
    this.month,
    this.year,
    this.formatStyle = const [
      the,
      space,
      Do,
      space,
      of,
      space,
      MMMM,
      space,
      yyyy,
      space,
      at,
      space,
      hh,
      colon,
      mm,
      colon,
      ss,
    ],
    this.spacingSide,
  });

  @override
  String toString() {
    formatStyle = [
      date != null ? D : '',
      slash,
      month != null ? M : '',
      slash,
      year != null ? yyyy : '',
      dash,
      hour != null ? h : '',
      colon,
      minute != null ? m : '',
      colon,
      second != null ? s : '',
    ];
    return format(formatStyle);
  }

  static Moment now() {
    return Moment().fromDateTime(DateTime.now());
  }

  DateTime toDateTime() {
    return DateTime(
      year ?? DateTime.now().year,
      month ?? 1,
      date ?? 1,
      hour ?? 0,
      minute ?? 0,
      second ?? 0,
    );
  }

  Moment fromDateTime(DateTime dateTime) {
    return Moment(
      year: dateTime.year,
      second: dateTime.second,
      minute: dateTime.minute,
      hour: dateTime.hour,
      date: dateTime.day,
      month: dateTime.month,
      formatStyle: const [
        The,
        space,
        Do,
        space,
        of,
        space,
        MMMM,
        space,
        yyyy,
        space,
        at,
        space,
        hh,
        colon,
        mm,
        colon,
        ss,
      ],
    );
  }

  List toList() => [second, minute, hour, date, month, year];

  Moment fromMap(Map<String, dynamic> map) {
    return Moment(
      second: map[second],
      minute: map[minute],
      hour: map[hour],
      date: map[date],
      month: map[month],
      year: map[year],
      formatStyle: const [
        the,
        space,
        Do,
        space,
        of,
        space,
        MMMM,
        space,
        yyyy,
        space,
        at,
        space,
        hh,
        colon,
        mm,
        colon,
        ss,
      ],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      second.toString(): second ?? 0.0,
      minute.toString(): minute ?? 0.0,
      hour.toString(): hour ?? 0.0,
      date.toString(): date ?? 0.0,
      month.toString(): month ?? 0.0,
      year.toString(): year ?? 0.0,
    };
  }

  Period toPeriod() {
    return Period(
      seconds: second ?? 0,
      minutes: minute ?? 0,
      hours: hour ?? 0,
      days: date ?? 0,
      months: month ?? 0,
      years: year ?? 0,
    );
  }

  Moment fromPeriod(Period period) {
    return Moment(
      second: period.seconds,
      minute: period.minutes,
      hour: period.hours,
      date: period.days,
      month: period.months,
      year: period.years,
    );
  }

  int toTotalSeconds() {
    int y = year ?? 1970;
    int m = month ?? 1;
    int d = date ?? 1;
    int h = hour ?? 0;
    int min = minute ?? 0;
    int s = second ?? 0;

    int totalDays = 0;

    for (int yr = 1970; yr < y; yr++) {
      totalDays += isLeapYear(yr) ? 366 : 365;
    }

    for (int yr = y; yr < 1970; yr++) {
      totalDays -= isLeapYear(yr) ? 366 : 365;
    }

    for (int mn = 1; mn < m; mn++) {
      totalDays += daysInMonth(mn, y);
    }

    totalDays += d - 1;

    int totalSeconds = totalDays * 86400 + h * 3600 + min * 60 + s;

    return totalSeconds;
  }

  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  static int daysInMonth(int month, int year) {
    const monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && isLeapYear(year)) return 29;
    return monthDays[month - 1];
  }

  Moment operator +(Period period) {
    int sign = period.isNegative ? -1 : 1;

    int sec = (second ?? 0) + (period.seconds * sign);
    int min = (minute ?? 0) + (period.minutes * sign);
    int hr = (hour ?? 0) + (period.hours * sign);
    int d = (date ?? 1) + (period.days * sign);
    int mo = (month ?? 1) + (period.months * sign);
    int yr = (year ?? 0) + (period.years * sign);

    min += sec ~/ 60;
    sec %= 60;
    if (sec < 0) {
      sec += 60;
      min--;
    }

    hr += min ~/ 60;
    min %= 60;
    if (min < 0) {
      min += 60;
      hr--;
    }

    d += hr ~/ 24;
    hr %= 24;
    if (hr < 0) {
      hr += 24;
      d--;
    }

    mo += (d - 1) ~/ 30;
    d = ((d - 1) % 30) + 1;
    if (d <= 0) {
      d += 30;
      mo--;
    }

    yr += (mo - 1) ~/ 12;
    mo = ((mo - 1) % 12) + 1;
    if (mo <= 0) {
      mo += 12;
      yr--;
    }

    return Moment(
      second: sec,
      minute: min,
      hour: hr,
      date: d,
      month: mo,
      year: yr,
      formatStyle: formatStyle,
      spacingSide: spacingSide,
    );
  }

  Moment operator -(Period period) {
    int sign = period.isNegative ? 1 : -1;

    int sec = (second ?? 0) + (period.seconds * sign);
    int min = (minute ?? 0) + (period.minutes * sign);
    int hr = (hour ?? 0) + (period.hours * sign);
    int d = (date ?? 1) + (period.days * sign);
    int mo = (month ?? 1) + (period.months * sign);
    int yr = (year ?? 0) + (period.years * sign);

    while (sec < 0) {
      sec += 60;
      min--;
    }
    min += sec ~/ 60;
    sec %= 60;

    while (min < 0) {
      min += 60;
      hr--;
    }
    hr += min ~/ 60;
    min %= 60;

    while (hr < 0) {
      hr += 24;
      d--;
    }
    d += hr ~/ 24;
    hr %= 24;

    while (d <= 0) {
      d += 30;
      mo--;
    }
    mo += (d - 1) ~/ 30;
    d = ((d - 1) % 30) + 1;

    while (mo <= 0) {
      mo += 12;
      yr--;
    }
    yr += (mo - 1) ~/ 12;
    mo = ((mo - 1) % 12) + 1;

    return Moment(
      second: sec,
      minute: min,
      hour: hr,
      date: d,
      month: mo,
      year: yr,
      formatStyle: formatStyle,
      spacingSide: spacingSide,
    );
  }

  Period difference(Moment other) {
    int totalSecs = toTotalSeconds() - other.toTotalSeconds();
    bool isNeg = totalSecs < 0;
    totalSecs = totalSecs.abs();

    int secs = totalSecs % 60;
    int totalMins = totalSecs ~/ 60;
    int mins = totalMins % 60;
    int totalHrs = totalMins ~/ 60;
    int hrs = totalHrs % 24;
    int days = totalHrs ~/ 24;

    int yrs = days ~/ 365;
    int remainingDays = days % 365;
    int months = remainingDays ~/ 30;
    remainingDays = remainingDays % 30;

    return Period(
      years: yrs,
      months: months,
      days: remainingDays,
      hours: hrs,
      minutes: mins,
      seconds: secs,
      isNegative: isNeg,
    );
  }

  Period untilNow() {
    Moment now = Moment.now();
    return difference(now);
  }

  Period since([Moment? other]) {
    return difference(other ?? Moment.now());
  }

  Period until([Moment? other]) {
    return other == null
        ? Moment.now().difference(this)
        : other.difference(this);
  }

  int? get weekday {
    if (date == null || month == null || year == null) return null;
    int y = year!;
    int m = month!;
    int d = date!;

    if (m < 3) {
      m += 12;
      y -= 1;
    }

    int yearOfCentury = y % 100;
    int zeroBasedCentury = y ~/ 100;

    int h =
        (d +
            (13 * (m + 1) ~/ 5) +
            yearOfCentury +
            (yearOfCentury ~/ 4) +
            (zeroBasedCentury ~/ 4) -
            (2 * zeroBasedCentury) +
            700) %
        7;

    return ((h + 5) % 7) + 1;
  }

  String get time => '${hour ?? 00}:${minute ?? 00}:${second ?? 00}';

  String get shortTime => '${hour ?? 00}:${minute ?? 00}';

  String get clock =>
      '${clockPhase == 'PM' ? (hour! - 12) : hour}:$minute:${second ?? 00} $clockPhase';

  String get shortClock =>
      '${clockPhase == 'PM' ? (hour! - 12) : hour}:$minute $clockPhase';

  String get clockPhase => hour! < 12 ? 'AM' : 'PM';

  String? get era => year! >= 1
      ? 'AD'
      : year! <= -1
      ? 'BC'
      : null;

  Moment get tomorrow => this + Period(days: 1);

  Moment get yesterday => this - Period(days: 1);

  static String getOrdinal(int? value) {
    String valString = value.toString();
    if (valString.length >= 2) {
      int trailingTwo = int.parse(
        value.toString().substring(valString.length - 2, valString.length),
      );
      if (trailingTwo == 11 || trailingTwo == 12 || trailingTwo == 13) {
        return 'th';
      }
    }
    int trailing = int.parse(value.toString()[value.toString().length - 1]);
    switch (trailing) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String format([List<String>? formatStyle]) {
    String val = '';
    for (int i = 0; i < formatStyle!.length; i++) {
      val = spacingSide == null
          ? val + formatToken(this, formatStyle[i]).toString()
          : spacingSide == SpacingSide.left
          ? val + space + formatToken(this, formatStyle[i]).toString()
          : val + formatToken(this, formatStyle[i]).toString() + space;
    }
    return val;
  }

  String? formatToken(Moment moment, String token) {
    switch (token) {
      case ddd:
        return weekDayNames[moment.weekday]!.substring(0, 3);
      case dddd:
        return weekDayNames[moment.weekday];
      case D:
        return moment.date.toString();
      case Do:
        return '${moment.date}${getOrdinal(moment.date!)}';
      case DD:
        return moment.date.toString().padLeft(2, '0');
      case M:
        return moment.month.toString();
      case Mo:
        return '${moment.month}${getOrdinal(moment.month)}';
      case MM:
        return moment.month.toString().padLeft(2, '0');
      case MMM:
        return monthNames[moment.month]!.substring(0, 3);
      case MMMM:
        return monthNames[moment.month];
      case yy:
        return moment.year.toString().substring(2);
      case yyyy:
        return moment.year.toString();
      case h:
        int hour12 = moment.hour! % 12;
        return hour12 == 0 ? '12' : hour12.toString();
      case hh:
        int hour12 = moment.hour! % 12;
        return (hour12 == 0 ? 12 : hour12).toString().padLeft(2, '0');
      case H:
        return moment.hour.toString();
      case HH:
        return moment.hour.toString().padLeft(2, '0');
      case m:
        return moment.minute.toString();
      case mm:
        return moment.minute.toString().padLeft(2, '0');
      case s:
        return moment.second.toString();
      case ss:
        return moment.second.toString().padLeft(2, '0');
      case A:
        return moment.clockPhase;
      case a:
        return moment.clockPhase.toLowerCase();
      case t:
        return '${moment.hour}:${moment.minute}:${moment.second}';
      case T:
        return '${(moment.hour! % 12) == 0 ? '12' : (moment.hour! % 12).toString()}:${moment.minute}:${moment.second} ${moment.clockPhase}';
      case DDDD:
        return '${moment.date.toString().padLeft(2, '0')}/${moment.month.toString().padLeft(2, '0')}/$year';
      default:
        return token;
    }
  }

  int get millisecondsSinceEpoch {
    int y = year ?? 1970;
    int m = month ?? 1;
    int d = date ?? 1;

    int leapYears = 0;
    for (int i = 1970; i < y; i++) {
      if ((i % 4 == 0 && i % 100 != 0) || (i % 400 == 0)) {
        leapYears++;
      }
    }

    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    bool isLeap = (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
    if (isLeap) daysInMonth[1] = 29;

    int totalDays = (y - 1970) * 365 + leapYears;

    for (int i = 0; i < m - 1; i++) {
      totalDays += daysInMonth[i];
    }

    totalDays += d - 1;

    int totalSeconds = totalDays * 86400;
    totalSeconds += (hour ?? 0) * 3600;
    totalSeconds += (minute ?? 0) * 60;
    totalSeconds += (second ?? 0);

    return totalSeconds * 1000;
  }
}

class Period {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isNegative;

  const Period({
    this.years = 0,
    this.months = 0,
    this.days = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
    this.isNegative = false,
  });

  int get totalSeconds =>
      (isNegative ? -1 : 1) *
      (seconds +
          minutes * 60 +
          hours * 3600 +
          days * 86400 +
          months * 2592000 +
          years * 31536000);

  int get totalMinutes => totalSeconds ~/ 60;

  int get totalHours => totalSeconds ~/ 3600;

  int get totalDays => totalSeconds ~/ 86400;

  @override
  String toString() {
    String prefix = isNegative ? '-' : '';
    return '$prefix$years years $months months $days days $hours hours $minutes minutes $seconds seconds';
  }

  String get formatted {
    String val = '';
    years != 0 ? val += '$years years ' : '';
    months != 0 ? val += '$months months ' : '';
    days != 0 ? val += '$days days ' : '';
    hours != 0 ? val += '$hours hours ' : '';
    minutes != 0 ? val += '$minutes minutes ' : '';
    seconds != 0 ? val += '$seconds seconds ' : '';
    return val;
  }
}

const String slash = '/';
const String dash = '-';
const String dot = '.';
const String comma = ',';
const String space = ' ';
const String backSlash = '\\';
const String colon = ':';
const String semicolon = ';';
const String at = 'at';
const String of = 'of';
const String the = 'the';
const String At = 'At';
const String Of = 'Of';
const String The = 'The';

enum SpacingSide { left, right }

const Map<int, String> weekDayNames = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};

const Map<int, String> monthNames = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

// --------------------------------------SECONDS------------------------------------ \\

/// # [Second]
/// ---
/// **Format:** `0 1 ... 58 59`
///
/// > **Summary:** The raw numerical second of the minute.
///
/// **Details:** Used for countdowns or high-precision logging where
/// leading zeros are not required for the specific string output.
const String s = 's';

/// # [Second (Long)]
/// ---
/// **Format:** `00 01 ... 58 59`
///
/// > **Summary:** A two-digit, zero-padded representation of seconds.
///
/// **Details:** The standard format for media players and stopwatches.
/// It ensures that the "seconds" column remains consistent as the
/// time increments.
const String ss = 'ss';

// --------------------------------------MINUTES------------------------------------ \\
/// # [Minute]
/// ---
/// **Format:** `0 1 ... 58 59`
///
/// > **Summary:** The raw numerical minute of the hour.
///
/// **Details:** Returns the minute without any padding. While less common
/// in digital clocks, it is frequently used in natural language strings
/// like "Arrived 5 minutes ago."
const String m = 'm';

/// # [Minute (Long)]
/// ---
/// **Format:** `00 01 ... 58 59`
///
/// > **Summary:** The minute of the hour with leading zeros.
///
/// **Details:** Ensures that the minute always appears as two digits.
/// This is the universal standard for time display; single-digit
/// minutes (like 5:5) are generally considered incorrect in time displays.
const String mm = 'mm';

// --------------------------------------HOURS------------------------------------ \\

/// # [Hour (12-Hour Clock)]
/// ---
/// **Format:** `1 2 ... 11 12`
///
/// > **Summary:** The hour of the day in a 12-hour cycle.
///
/// **Details:** This format is the standard for civilian time. It
/// translates 00:00 to 12 and 13:00 to 1. Usually paired with the
/// AM/PM token for clarity.
const String h = 'h';

/// # [Hour (12-Hour Clock, Full)]
/// ---
/// **Format:** `01 02 ... 11 12`
///
/// > **Summary:** The hour of the day in a 12-hour cycle with a leading zero.
///
/// **Details:** Similar to the `h` token, but ensures a two-digit output.
/// This is preferred in UI design for digital clocks to prevent the
/// alignment of the time from shifting when the hour changes from 9 to 10.
const String hh = 'hh';

/// # [Hour (24-Hour Clock)]
/// ---
/// **Format:** `0 1 ... 22 23`
///
/// > **Summary:** The hour of the day in military/international time.
///
/// **Details:** This uses the 0-23 index, where 0 represents midnight.
/// It is the standard for backend logging, data storage, and international
/// systems where AM/PM ambiguity must be avoided.
const String H = 'H';

/// # [Hour (24-Hour Clock, Padded)]
/// ---
/// **Format:** `00 01 ... 22 23`
///
/// > **Summary:** The zero-padded hour of the day in 24-hour format.
///
/// **Details:** The standard format for ISO-8601 time representations.
/// It provides a consistent two-character width for all hours of the day,
/// making it ideal for table columns and file timestamps.
const String HH = 'HH';

/// # [AM/PM]
/// ---
/// **Format:** `AM PM`
///
/// > **Summary:** The meridiem indicator in uppercase.
///
/// **Details:** Used to differentiate between morning and afternoon
/// when using the 12-hour clock system. Essential for scheduling and
/// alarm-based features.
const String A = 'A';

/// # [AM/PM (Lowercase)]
/// ---
/// **Format:** `am pm`
///
/// > **Summary:** The meridiem indicator in lowercase.
///
/// **Details:** A stylistic alternative to the `A` token. It is often
/// used in modern, minimalist web design or mobile apps where a less
/// prominent "am/pm" indicator is desired.
const String a = 'a';

// --------------------------------------DAYS------------------------------------ \\
/// # [Day of Month]
/// ---
/// **Format:** `1 2 ... 30 31`
///
/// > **Summary:** The raw numerical day of the current month.
///
/// **Details:** This returns the day as a single or double digit without
/// any leading zeros. It is typically used in sentences (e.g., "March 5")
/// or in layouts where a clean, minimal look is desired.
const String D = 'D';

/// # [Day of Month (Ordinal)]
/// ---
/// **Format:** `1st 2nd ... 30th 31st`
///
/// > **Summary:** The day of the month followed by its ordinal suffix.
///
/// **Details:** This converts the day number into its spoken-word equivalent
/// format. It is essentially the standard for invitations, formal
/// letters, and any interface attempting to sound conversational.
const String Do = 'Do';

/// # [Day of Week (Short)]
/// ---
/// **Format:** `Mon Tue ... Sat Sun`
///
/// > **Summary:** The standard three-letter abbreviation for the day.
///
/// **Details:** This provides a balance between readability and space
/// efficiency. It is the most common format used in digital dashboards
/// and general scheduling software to identify the day of the week.
const String ddd = 'ddd';

/// # [Day of Week (Full)]
/// ---
/// **Format:** `Monday Tuesday ... Sunday`
///
/// > **Summary:** The complete, unabbreviated name of the day.
///
/// **Details:** Use this for formal displays and primary headers.
/// It provides the highest level of clarity and is preferred for
/// desktop layouts and formal documents where space is not a constraint.
const String dddd = 'dddd';

/// # [Day of Month (Padded)]
/// ---
/// **Format:** `01 02 ... 30 31`
///
/// > **Summary:** A two-digit, zero-padded day of the month.
///
/// **Details:** This ensures that the day always occupies two characters.
/// This is required for fixed-width layouts and digital clock displays
/// where jumping text widths would be visually distracting.
const String DD = 'DD';

// --------------------------------------MONTHS------------------------------------ \\

/// # [Month (Number)]
/// ---
/// **Format:** `1 2 ... 11 12`
///
/// > **Summary:** The numerical index of the month.
///
/// **Details:** Represents the month in a non-padded format. 1 maps to
/// January and 12 maps to December. This is ideal for compact
/// date-picker logic or simple slash-separated date formats.
const String M = 'M';

/// # [Month (Ordinal)]
/// ---
/// **Format:** `1st 2nd ... 11th 12th`
///
/// > **Summary:** The numerical index of the month's position and order.
///
/// **Details:** Represents the month in a non-padded format. 1 maps to
/// January and 12 maps to December. This is ideal for compact
/// date-picker logic or simple slash-separated date formats.
const String Mo = 'Mo';

/// # [Month (Padded)]
/// ---
/// **Format:** `01 02 ... 11 12`
///
/// > **Summary:** A two-digit, zero-padded numerical month.
///
/// **Details:** Ensures that the month value is always two digits long.
/// This is the standard for numerical date formats like MM/DD/YYYY.
const String MM = 'MM';

/// # [Month (Short)]
/// ---
/// **Format:** `Jan Feb ... Nov Dec`
///
/// > **Summary:** The three-letter abbreviation of the month name.
///
/// **Details:** A culturally universal way to shorten month names while
/// maintaining high readability. It is used extensively in list views
/// and timeline markers.
const String MMM = 'MMM';

/// # [Month (Full)]
/// ---
/// **Format:** `January February ... December`
///
/// > **Summary:** The full name of the month.
///
/// **Details:** Provides the complete string for the month. This is the
/// most formal way to represent the month and is the foundation for
/// long-form date formatting.
const String MMMM = 'MMMM';
// --------------------------------------YEARS------------------------------------ \\

/// # [Year (Short)]
/// ---
/// **Format:** `70 71 ... 24 25`
///
/// > **Summary:** The last two digits of the year.
///
/// **Details:** Provides a truncated version of the year. While useful for
/// informal dates or space-restricted UI, it should be used cautiously
/// to avoid ambiguity between centuries.
const String yy = 'yy';

/// # [Year (Full)]
/// ---
/// **Format:** `1970 1971 ... 2024 2025`
///
/// > **Summary:** The complete four-digit year.
///
/// **Details:** The absolute numerical representation of the year.
const String yyyy = 'yyyy';
// --------------------------------------TEMPLATES------------------------------------ \\

/// # [Time (24-Hour)]
/// ---
/// **Format:** `14:35:22`
///
/// > **Summary:** A complete time string in 24-hour format.
///
/// **Details:** Outputs the full time as `hour:minute:second` using the
/// 24-hour clock. This is a convenient shorthand for displaying complete
/// timestamps in logs, data exports, or anywhere military time is preferred.
const String t = 't';

/// # [Time (12-Hour)]
/// ---
/// **Format:** `2:35:22 PM`
///
/// > **Summary:** A complete time string in 12-hour format with AM/PM.
///
/// **Details:** Outputs the full time as `hour:minute:second AM/PM` using the
/// 12-hour clock. Converts hour values accordingly (e.g., 0 becomes 12, 13
/// becomes 1) and appends the meridiem indicator for civilian time display.
const String T = 'T';

/// # [Date (Numeric)]
/// ---
/// **Format:** `05/03/2025`
///
/// > **Summary:** A complete date string in DD/MM/YYYY format.
///
/// **Details:** Outputs the full date with zero-padded day and month values
/// separated by slashes. This is the standard format for international date
/// display and is widely used in forms, reports, and date pickers.
const String DDDD = 'DDDD';
