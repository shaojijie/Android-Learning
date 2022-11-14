import 'dart:math';
import 'dart:typed_data';

import 'package:demo/utils/crypto.dart';

class RandomUtil {
  static Random _random = new Random();

  static int nextInt({int start = 0, int end = 1 << 32}) {
    if (end < 0) {
      return 0;
    }

    int value = _random.nextInt(end);
    return value + start;
  }

  static int nextSingleInt() {
    return nextInt(start: 0, end: 10);
  }

  static bool nextBoolean() {
    return _random.nextBool();
  }

  static double nextDouble() {
    return _random.nextDouble();
  }

  static String nextLowerChar() {
    List<int> codes = [65 + nextInt(end: 26)];
    return String.fromCharCodes(codes);
  }

  static String nextUpperChar() {
    List<int> codes = [97 + nextInt(end: 26)];
    return String.fromCharCodes(codes);
  }

  static String nextChar() {
    if (nextBoolean()) {
      return nextLowerChar();
    }
    return nextUpperChar();
  }

  static String nextString(int length) {
    StringBuffer stringBuffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      stringBuffer.write(nextChar());
    }
    return stringBuffer.toString();
  }

  static String nextUpperString(int length) {
    return nextString(length).toUpperCase();
  }

  static String nextLowerString(int length) {
    return nextString(length).toLowerCase();
  }

  static List<int> nextByte(int length) {
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = nextInt(end: 256);
    }
    return bytes;
  }

  static void test() {
    print(RandomUtil.nextLowerString(50));
    print(nextUpperString(50));
    print(nextString(50));
    CryptoUtil.test();
  }
}
