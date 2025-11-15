import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'shop_model.freezed.dart';
part 'shop_model.g.dart';

@freezed
class ShopModel with _$ShopModel {
  const factory ShopModel({
    required String id,
    required String name,
    required String slug,
    required String ownerId,
    required String description,
    String? logo,
    String? coverImage,
    required BrandColors brandColors,
    required ContactInfo contactInfo,
    required SocialLinks socialLinks,
    required SeoSettings seoSettings,
    @Default(true) bool isActive,
    @Default('free') String plan,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime updatedAt,
  }) = _ShopModel;

  factory ShopModel.fromJson(Map<String, dynamic> json) => _$ShopModelFromJson(json);

  static DateTime _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.parse(timestamp as String);
  }

  static dynamic _timestampToJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}

@freezed
class BrandColors with _$BrandColors {
  const factory BrandColors({
    @Default('#FF6B35') String primary,
    @Default('#FFA500') String accent,
  }) = _BrandColors;

  factory BrandColors.fromJson(Map<String, dynamic> json) => _$BrandColorsFromJson(json);
}

@freezed
class ContactInfo with _$ContactInfo {
  const factory ContactInfo({
    String? phone,
    String? whatsapp,
    String? email,
    String? address,
  }) = _ContactInfo;

  factory ContactInfo.fromJson(Map<String, dynamic> json) => _$ContactInfoFromJson(json);
}

@freezed
class SocialLinks with _$SocialLinks {
  const factory SocialLinks({
    String? facebook,
    String? instagram,
    String? twitter,
    String? youtube,
    String? website,
  }) = _SocialLinks;

  factory SocialLinks.fromJson(Map<String, dynamic> json) => _$SocialLinksFromJson(json);
}

@freezed
class SeoSettings with _$SeoSettings {
  const factory SeoSettings({
    required String title,
    required String description,
    @Default([]) List<String> keywords,
  }) = _SeoSettings;

  factory SeoSettings.fromJson(Map<String, dynamic> json) => _$SeoSettingsFromJson(json);
}
