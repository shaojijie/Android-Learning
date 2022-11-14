// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CryptoMessage _$CryptoMessageFromJson(Map<String, dynamic> json) =>
    _CryptoMessage(
      json['key'] as String,
      json['ciphertext'] as String,
      json['ivLen'] as int,
      json['tagLen'] as int,
    );

Map<String, dynamic> _$CryptoMessageToJson(_CryptoMessage instance) =>
    <String, dynamic>{
      'ciphertext': instance.ciphertext,
      'key': instance.key,
      'ivLen': instance.ivLen,
      'tagLen': instance.tagLen,
    };
