import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:demo/utils/log.dart';
import 'package:demo/utils/random.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crypto.g.dart';

class Base64Util {
  static String encode(List<int> bytes) {
    return base64.encode(bytes);
  }

  static List<int> decode(String string) {
    return base64.decode(string);
  }
}

class JsonUtil {
  static Map<String, dynamic> decode(String jsonString) {
    return jsonDecode(jsonString);
  }

  static String encode(Map<String, dynamic> json) {
    return jsonEncode(json);
  }
}

class UTF8Util {
  static List<int> encode(String string) {
    return utf8.encode(string);
  }

  static String decode(List<int> codeUnits) {
    return utf8.decode(codeUnits);
  }
}

@JsonSerializable()
class _CryptoMessage {
  final String ciphertext;
  final String key;
  final int ivLen;
  final int tagLen;

  _CryptoMessage(this.key, this.ciphertext, this.ivLen, this.tagLen);

  factory _CryptoMessage.fromJson(String jsonString) {
    return _$CryptoMessageFromJson(JsonUtil.decode(jsonString));
  }

  String toJson() {
    return JsonUtil.encode(_$CryptoMessageToJson(this));
  }
}

class CryptoUtil {
  static final String FALT_STRING_RESULT = "";

  static List<int> transSecretBoxToCipherText(
      SecretBox secretBox, List<int> key) {
    return utf8.encode(_CryptoMessage(
      Base64Util.encode(key),
      Base64Util.encode(
        secretBox.concatenation(nonce: true, mac: true),
      ),
      secretBox.nonce.length,
      secretBox.mac.bytes.length,
    ).toJson());
  }

  static SecretBox transCipherTextToSecretBox(List<int> cipherText) {
    _CryptoMessage message = _CryptoMessage.fromJson(utf8.decode(cipherText));
    return SecretBox.fromConcatenation(
      Base64Util.decode(message.ciphertext),
      nonceLength: message.ivLen,
      macLength: message.tagLen,
    );
  }

  static List<int> transCipherTextToKey(List<int> cipherText) {
    _CryptoMessage message = _CryptoMessage.fromJson(utf8.decode(cipherText));
    return Base64Util.decode(message.key);
  }

  static Future<List<int>> aesGcmEncrypt(
      List<int> key, List<int> plaintext) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKeyFromBytes(key);
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      plaintext,
      secretKey: secretKey,
      nonce: nonce,
    );
    return transSecretBoxToCipherText(secretBox, key);
  }

  /*返回结果经过base64编码 */
  static Future<String> aesGcmEncryptBase64(
      List<int> key, List<int> plaintext) async {
    return Base64Util.encode(await aesGcmEncrypt(key, plaintext));
  }

  static Future<List<int>> AesGcmDecrypt(List<int> cipherText) async {
    final algorithm = AesGcm.with256bits();
    final secretBox = transCipherTextToSecretBox(cipherText);
    final secretKey = await algorithm.newSecretKeyFromBytes(
      transCipherTextToKey(cipherText),
    );
    return await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );
  }

  /* 入参cipherText经过base64编码 */
  static Future<List<int>> aesGcmDecryptBase64(String cipherText) {
    return AesGcmDecrypt(Base64Util.decode(cipherText));
  }

  static void test() async {
    List<int> key = RandomUtil.nextByte(32);
    String src = "123456789";
    aesGcmEncryptBase64(key, UTF8Util.encode(src)).then((value) {
      logUtil.d(value);
      aesGcmDecryptBase64(value).then((value) {
        logUtil.d(UTF8Util.decode(value));
      });
    });
  }
}
