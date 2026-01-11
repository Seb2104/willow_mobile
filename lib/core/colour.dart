// ignore_for_file: prefer_adjacent_string_concatenation, camel_case_types

import 'dart:ui';

class Colour {
  final int a, r, g, b;

  const Colour({this.a = 255, this.r = 255, this.g = 255, this.b = 255})
    : assert(a >= 0, a <= 100),
      assert(r >= 0, r <= 255),
      assert(g >= 0, g <= 255),
      assert(b >= 0, b <= 255);

  Colour.fromRGB({this.r = 255, this.g = 255, this.b = 255})
    : a = 255,
      assert(r >= 0, r <= 255),
      assert(g >= 0, g <= 255),
      assert(b >= 0, b <= 255);

  Colour.fromB256(String data)
    : a = Value.base(data[0], 256),
      r = Value.base(data[1], 256),
      g = Value.base(data[2], 256),
      b = Value.base(data[3], 256),
      assert(data.length == 4);

  Colour.fromPercent({
    double alpha = 100.0,
    double red = 100.0,
    double green = 100.0,
    double blue = 100.0,
  }) : a = Value.percentToColourValue(alpha),
       r = Value.percentToColourValue(red),
       g = Value.percentToColourValue(green),
       b = Value.percentToColourValue(blue);

  Colour.fromFraction([
    double alpha = 1.0,
    double red = 1.0,
    double green = 1.0,
    double blue = 1.0,
  ]) : a = Value.fractionToColourValue(alpha),
       r = Value.fractionToColourValue(red),
       g = Value.fractionToColourValue(green),
       b = Value.fractionToColourValue(blue);

  Colour.fromColor(Color color)
    : a = Value.fractionToColourValue(color.a),
      r = Value.fractionToColourValue(color.r),
      g = Value.fractionToColourValue(color.g),
      b = Value.fractionToColourValue(color.b);

  Color get color => Color.fromARGB(a, r, g, b);

  String get hex => Value.hex(a) + Value.hex(r) + Value.hex(g) + Value.hex(b);

  String get argb => '$a,$r,$g,$b';

  String get rgb => '$r,$g,$b';

  Colour withAlpha(int alpha) => Colour(a: alpha, r: r, g: g, b: b);

  Colour withRed(int red) => Colour(a: a, r: red, g: g, b: b);

  Colour withGreen(int green) => Colour(a: a, r: r, g: green, b: b);

  Colour withBlue(int blue) => Colour(a: a, r: r, g: g, b: blue);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Colour && other == this;
  }

  @override
  int get hashCode => Value.base(toString(), 256);

  @override
  String toString() {
    return '${Value.base(a, 256)}${Value.base(r, 256)}${Value.base(g, 256)}${Value.base(b, 256)}';
  }
}

class Value {
  static dynamic base(dynamic data, int radix) {
    return data is int
        ? _crypt(
            data: data.toString(),
            from: _base.substring(0, 10),
            to: _base.substring(0, radix),
          )
        : int.parse(
            _crypt(
              data: data,
              from: _base.substring(0, radix),
              to: _base.substring(0, 10),
            ),
          );
  }

  static String oct(int data) {
    return base(data, 8);
  }

  static String bin(int data) {
    return base(data, 2).toUpperCase();
  }

  static String hex(int data) {
    return base(data, 16).toUpperCase();
  }

  static String dec(int data) {
    return base(data, 10);
  }

  static String _crypt({
    dynamic data,
    required String from,
    required String to,
  }) {
    if (data.isEmpty || from == to) {
      return data;
    }

    final int sourceBase = from.length;
    final int destinationBase = to.length;
    final Map<int, int> numberMap = {};
    int divide = 0;
    int newLength = 0;
    int length = data.length;
    String result = '';

    for (int i = 0; i < length; i++) {
      final index = from.indexOf(data[i]);
      if (index == -1) {
        throw FormatException(
          'Source "$data" contains character ' +
              '"${data[i]}" which is outside of the defined source alphabet ' +
              '"$from"',
        );
      }
      numberMap[i] = from.indexOf(data[i]);
    }

    do {
      divide = 0;
      newLength = 0;
      for (int i = 0; i < length; i++) {
        divide = divide * sourceBase + (numberMap[i] as int);
        if (divide >= destinationBase) {
          numberMap[newLength++] = divide ~/ destinationBase;
          divide = divide % destinationBase;
        } else if (newLength > 0) {
          numberMap[newLength++] = 0;
        }
      }
      length = newLength;
      result = to[divide] + result;
    } while (newLength != 0);
    return result;
  }

  /// 0.0 >= a <= 255.0
  static int colourValue(double data) {
    return data.clamp(0, 255).round();
  }

  /// 0.0 >= a <= 1.0 --> 0-255
  static int fractionToColourValue(double data) {
    return (data.clamp(0.0, 1.0) * 255).round();
  }

  /// 0.0 >= a <= 100.0 --> 0-255
  static int percentToColourValue(double data) {
    return ((data.clamp(0.0, 100.0) / 100) * 255).round();
  }

  static const String _base =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/!@%^\$&*()-_=[]{}|;:,.<>?~`\'"\\ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψϏϐϑϒϓϔϕϖϗϘϙϚϛϜϝϞϟϠϡϢϣϤϥϦϧϨϩϪϫϬϭϮϯϰϱϲϳϴϵ϶ϷϸϹϺϻϼϽϾϿЀЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя#';
}

class radix {
  static const int bin = 2;
  static const int dec = 10;
  static const int oct = 8;
  static const int hex = 16;
  static const int binary = 2;
  static const int ternary = 3;
  static const int quaternary = 4;
  static const int quinary = 5;
  static const int senary = 6;
  static const int septenary = 7;
  static const int octal = 8;
  static const int nonary = 9;
  static const int decimal = 10;
  static const int undecimal = 11;
  static const int duodecimal = 12;
  static const int tridecimal = 13;
  static const int tetradecimal = 14;
  static const int pentadecimal = 15;
  static const int hexadecimal = 16;
  static const int heptadecimal = 17;
  static const int octodecimal = 18;
  static const int enneadecimal = 19;
  static const int vigesimal = 20;
  static const int unvigesimal = 21;
  static const int duovigesimal = 22;
  static const int trivigesimal = 23;
  static const int tetravigesimal = 24;
  static const int pentavigesimal = 25;
  static const int hexavigesimal = 26;
  static const int heptavigesimal = 27;
  static const int septemvigesimal = 27;
  static const int octovigesimal = 28;
  static const int enneavigesimal = 29;
  static const int trigesimal = 30;
  static const int untrigesimal = 31;
  static const int duotrigesimal = 32;
  static const int tritrigesimal = 33;
  static const int tetratrigesimal = 34;
  static const int pentatrigesimal = 35;
  static const int hexatrigesimal = 36;
  static const int heptatrigesimal = 37;
  static const int octotrigesimal = 38;
  static const int enneatrigesimal = 39;
  static const int quadragesimal = 40;
  static const int duoquadragesimal = 42;
  static const int pentaquadragesimal = 45;
  static const int septaquadragesimal = 47;
  static const int octoquadragesimal = 48;
  static const int enneaquadragesimal = 49;
  static const int quinquagesimal = 50;
  static const int duoquinquagesimal = 52;
  static const int tetraquinquagesimal = 54;
  static const int hexaquinquagesimal = 56;
  static const int heptaquinquagesimal = 57;
  static const int octoquinquagesimal = 58;
  static const int sexagesimal = 60;
  static const int duosexagesimal = 62;
  static const int tetrasexagesimal = 64;
  static const int duoseptuagesimal = 72;
  static const int octogesimal = 80;
  static const int unoctogesimal = 81;
  static const int pentoctogesimal = 85;
  static const int enneaoctogesimal = 89;
  static const int nonagesimal = 90;
  static const int unnonagesimal = 91;
  static const int duononagesimal = 92;
  static const int trinonagesimal = 93;
  static const int tetranonagesimal = 94;
  static const int pentanonagesimal = 95;
  static const int hexanonagesimal = 96;
  static const int septanonagesimal = 97;
  static const int centesimal = 100;
  static const int centevigesimal = 120;
  static const int centeunvigesimal = 121;
  static const int centepentavigesimal = 125;
  static const int centeoctovigesimal = 128;
  static const int centetetraquadragesimal = 144;
  static const int centenovemsexagesimal = 169;
  static const int centepentoctogesimal = 185;
  static const int centehexanonagesimal = 196;
  static const int duocentesimal = 200;
  static const int duocentedecimal = 210;
  static const int duocentehexidecimal = 216;
  static const int duocentepentavigesimal = 225;
  static const int duocentehexaquinquagesimal = 256;
  static const int trecentesimal = 300;
  static const int trecentosexagesimal = 360;
}
