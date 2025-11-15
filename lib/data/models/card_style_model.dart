import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'card_style_model.freezed.dart';
part 'card_style_model.g.dart';

@freezed
class CardPresetModel with _$CardPresetModel {
  const factory CardPresetModel({
    required String id,
    required String shopId,
    required String name,
    required String description,
    required CardLayout layout,
    required CardStyleConfig style,
    @Default(false) bool isDefault,
    @Default(true) bool isActive,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime updatedAt,
  }) = _CardPresetModel;

  factory CardPresetModel.fromJson(Map<String, dynamic> json) => _$CardPresetModelFromJson(json);

  static DateTime _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) return timestamp.toDate();
    return DateTime.parse(timestamp as String);
  }

  static dynamic _timestampToJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}

@freezed
class CardStyleConfig with _$CardStyleConfig {
  const factory CardStyleConfig({
    // Visible fields configuration
    @Default([]) List<String> visibleFields,
    @Default([]) List<String> fieldOrder,

    // Image settings
    @Default(ImageAspectRatio.square) ImageAspectRatio imageAspectRatio,
    @Default(true) bool showImage,
    @Default(ImageFit.cover) ImageFit imageFit,

    // Layout settings
    @Default(12.0) double borderRadius,
    @Default(2.0) double elevation,
    @Default(true) bool showShadow,
    @Default(16.0) double padding,
    @Default(8.0) double spacing,

    // Typography
    required TypographyConfig typography,

    // Badges
    required BadgeConfig badges,

    // CTA Button
    required CtaButtonConfig ctaButton,

    // Colors
    required CardColorConfig colors,

    // Additional settings
    @Default(true) bool showPrice,
    @Default(true) bool showCategory,
    @Default(true) bool showTags,
    @Default(true) bool showRating,
    @Default(2) int maxTagsVisible,
  }) = _CardStyleConfig;

  factory CardStyleConfig.fromJson(Map<String, dynamic> json) => _$CardStyleConfigFromJson(json);
}

@freezed
class TypographyConfig with _$TypographyConfig {
  const factory TypographyConfig({
    @Default(16.0) double titleSize,
    @Default(600) int titleWeight, // 400=normal, 500=medium, 600=semibold, 700=bold
    @Default(18.0) double priceSize,
    @Default(700) int priceWeight,
    @Default(14.0) double bodySize,
    @Default(400) int bodyWeight,
    @Default(12.0) double captionSize,
    @Default(2) int titleMaxLines,
    @Default(3) int descriptionMaxLines,
  }) = _TypographyConfig;

  factory TypographyConfig.fromJson(Map<String, dynamic> json) => _$TypographyConfigFromJson(json);
}

// Extension to convert int to FontWeight
extension TypographyConfigExtension on TypographyConfig {
  FontWeight get titleFontWeight => FontWeight.values[(titleWeight ~/ 100) - 1];
  FontWeight get priceFontWeight => FontWeight.values[(priceWeight ~/ 100) - 1];
  FontWeight get bodyFontWeight => FontWeight.values[(bodyWeight ~/ 100) - 1];
}

@freezed
class BadgeConfig with _$BadgeConfig {
  const factory BadgeConfig({
    @Default(true) bool showNew,
    @Default(true) bool showSale,
    @Default(true) bool showOutOfStock,
    @Default(true) bool showFeatured,
    @Default(BadgePosition.topRight) BadgePosition position,
    required BadgeColorConfig colors,
    @Default(8.0) double borderRadius,
    @Default(4.0) double padding,
  }) = _BadgeConfig;

  factory BadgeConfig.fromJson(Map<String, dynamic> json) => _$BadgeConfigFromJson(json);
}

@freezed
class BadgeColorConfig with _$BadgeColorConfig {
  const factory BadgeColorConfig({
    @Default('#4CAF50') String newBadge,
    @Default('#FF5722') String saleBadge,
    @Default('#9E9E9E') String outOfStockBadge,
    @Default('#FFD700') String featuredBadge,
  }) = _BadgeColorConfig;

  factory BadgeColorConfig.fromJson(Map<String, dynamic> json) => _$BadgeColorConfigFromJson(json);
}

@freezed
class CtaButtonConfig with _$CtaButtonConfig {
  const factory CtaButtonConfig({
    @Default(CtaButtonType.enquire) CtaButtonType type,
    String? customLabel,
    @Default(CtaButtonStyle.filled) CtaButtonStyle style,
    @Default(true) bool showIcon,
    @Default(8.0) double borderRadius,
    @Default(12.0) double paddingHorizontal,
    @Default(12.0) double paddingVertical,
    String? backgroundColor,
    String? textColor,
  }) = _CtaButtonConfig;

  factory CtaButtonConfig.fromJson(Map<String, dynamic> json) => _$CtaButtonConfigFromJson(json);
}

// Extension to get EdgeInsets
extension CtaButtonConfigExtension on CtaButtonConfig {
  EdgeInsets get padding => EdgeInsets.symmetric(
    horizontal: paddingHorizontal,
    vertical: paddingVertical,
  );
}

@freezed
class CardColorConfig with _$CardColorConfig {
  const factory CardColorConfig({
    @Default('#FFFFFF') String background,
    @Default('#212121') String titleColor,
    @Default('#FF6B35') String priceColor,
    @Default('#757575') String bodyColor,
    @Default('#FF6B35') String accentColor,
    @Default('#E0E0E0') String dividerColor,
    @Default('#F5F5F5') String surfaceColor,
  }) = _CardColorConfig;

  factory CardColorConfig.fromJson(Map<String, dynamic> json) => _$CardColorConfigFromJson(json);
}

// Enums
enum CardLayout {
  @JsonValue('grid_compact')
  gridCompact,

  @JsonValue('grid_large')
  gridLarge,

  @JsonValue('list')
  list,

  @JsonValue('media_dominant')
  mediaDominant,

  @JsonValue('minimal')
  minimal,

  @JsonValue('premium')
  premium;

  String get displayName {
    switch (this) {
      case CardLayout.gridCompact:
        return 'Grid Compact';
      case CardLayout.gridLarge:
        return 'Grid Large';
      case CardLayout.list:
        return 'List View';
      case CardLayout.mediaDominant:
        return 'Media Dominant';
      case CardLayout.minimal:
        return 'Minimal';
      case CardLayout.premium:
        return 'Premium';
    }
  }

  String get description {
    switch (this) {
      case CardLayout.gridCompact:
        return 'Compact grid layout ideal for showing many products';
      case CardLayout.gridLarge:
        return 'Large grid cards with prominent images';
      case CardLayout.list:
        return 'Horizontal list layout with detail view';
      case CardLayout.mediaDominant:
        return 'Focus on images with minimal text';
      case CardLayout.minimal:
        return 'Clean and minimal design';
      case CardLayout.premium:
        return 'Premium card with elegant styling';
    }
  }

  String get icon {
    switch (this) {
      case CardLayout.gridCompact:
        return '🔲';
      case CardLayout.gridLarge:
        return '⬜';
      case CardLayout.list:
        return '📋';
      case CardLayout.mediaDominant:
        return '🖼️';
      case CardLayout.minimal:
        return '▫️';
      case CardLayout.premium:
        return '✨';
    }
  }
}

enum ImageAspectRatio {
  @JsonValue('1:1')
  square,

  @JsonValue('4:3')
  landscape,

  @JsonValue('16:9')
  widescreen,

  @JsonValue('3:4')
  portrait;

  String get displayName {
    switch (this) {
      case ImageAspectRatio.square:
        return '1:1 Square';
      case ImageAspectRatio.landscape:
        return '4:3 Landscape';
      case ImageAspectRatio.widescreen:
        return '16:9 Widescreen';
      case ImageAspectRatio.portrait:
        return '3:4 Portrait';
    }
  }

  double get ratio {
    switch (this) {
      case ImageAspectRatio.square:
        return 1.0;
      case ImageAspectRatio.landscape:
        return 4 / 3;
      case ImageAspectRatio.widescreen:
        return 16 / 9;
      case ImageAspectRatio.portrait:
        return 3 / 4;
    }
  }
}

enum ImageFit {
  @JsonValue('cover')
  cover,

  @JsonValue('contain')
  contain,

  @JsonValue('fill')
  fill;

  BoxFit get boxFit {
    switch (this) {
      case ImageFit.cover:
        return BoxFit.cover;
      case ImageFit.contain:
        return BoxFit.contain;
      case ImageFit.fill:
        return BoxFit.fill;
    }
  }
}

enum BadgePosition {
  @JsonValue('topLeft')
  topLeft,

  @JsonValue('topRight')
  topRight,

  @JsonValue('bottomLeft')
  bottomLeft,

  @JsonValue('bottomRight')
  bottomRight;

  String get displayName {
    switch (this) {
      case BadgePosition.topLeft:
        return 'Top Left';
      case BadgePosition.topRight:
        return 'Top Right';
      case BadgePosition.bottomLeft:
        return 'Bottom Left';
      case BadgePosition.bottomRight:
        return 'Bottom Right';
    }
  }
}

enum CtaButtonType {
  @JsonValue('call')
  call,

  @JsonValue('whatsapp')
  whatsapp,

  @JsonValue('enquire')
  enquire,

  @JsonValue('cart')
  cart,

  @JsonValue('custom')
  custom;

  String get defaultLabel {
    switch (this) {
      case CtaButtonType.call:
        return 'Call Now';
      case CtaButtonType.whatsapp:
        return 'WhatsApp';
      case CtaButtonType.enquire:
        return 'Enquire';
      case CtaButtonType.cart:
        return 'Add to Cart';
      case CtaButtonType.custom:
        return 'Action';
    }
  }

  IconData get icon {
    switch (this) {
      case CtaButtonType.call:
        return Icons.phone;
      case CtaButtonType.whatsapp:
        return Icons.chat;
      case CtaButtonType.enquire:
        return Icons.email;
      case CtaButtonType.cart:
        return Icons.shopping_cart;
      case CtaButtonType.custom:
        return Icons.touch_app;
    }
  }
}

enum CtaButtonStyle {
  @JsonValue('filled')
  filled,

  @JsonValue('outlined')
  outlined,

  @JsonValue('text')
  text;

  String get displayName {
    switch (this) {
      case CtaButtonStyle.filled:
        return 'Filled';
      case CtaButtonStyle.outlined:
        return 'Outlined';
      case CtaButtonStyle.text:
        return 'Text';
    }
  }
}

// Default presets
class DefaultCardPresets {
  static CardPresetModel ecommerceCompact(String shopId) {
    return CardPresetModel(
      id: 'default_ecommerce_compact',
      shopId: shopId,
      name: 'E-commerce Compact',
      description: 'Perfect for retail stores with many products',
      layout: CardLayout.gridCompact,
      style: const CardStyleConfig(
        visibleFields: ['title', 'price', 'category'],
        imageAspectRatio: ImageAspectRatio.square,
        borderRadius: 8.0,
        elevation: 2.0,
        typography: TypographyConfig(
          titleSize: 14.0,
          priceSize: 16.0,
          titleMaxLines: 2,
        ),
        badges: BadgeConfig(
          position: BadgePosition.topRight,
          colors: BadgeColorConfig(),
        ),
        ctaButton: CtaButtonConfig(
          type: CtaButtonType.cart,
          style: CtaButtonStyle.filled,
        ),
        colors: CardColorConfig(),
      ),
      isDefault: true,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static CardPresetModel restaurantMenu(String shopId) {
    return CardPresetModel(
      id: 'default_restaurant',
      shopId: shopId,
      name: 'Restaurant Menu',
      description: 'Beautiful cards for food items',
      layout: CardLayout.mediaDominant,
      style: const CardStyleConfig(
        visibleFields: ['dishName', 'description', 'price', 'cuisine'],
        imageAspectRatio: ImageAspectRatio.landscape,
        borderRadius: 12.0,
        elevation: 3.0,
        typography: TypographyConfig(
          titleSize: 18.0,
          priceSize: 20.0,
          descriptionMaxLines: 2,
        ),
        badges: BadgeConfig(
          position: BadgePosition.topLeft,
          colors: BadgeColorConfig(),
        ),
        ctaButton: CtaButtonConfig(
          type: CtaButtonType.whatsapp,
          style: CtaButtonStyle.filled,
        ),
        colors: CardColorConfig(),
      ),
      isDefault: false,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static CardPresetModel premiumCatalog(String shopId) {
    return CardPresetModel(
      id: 'default_premium',
      shopId: shopId,
      name: 'Premium Catalog',
      description: 'Elegant design for high-end products',
      layout: CardLayout.premium,
      style: const CardStyleConfig(
        visibleFields: ['title', 'price', 'description'],
        imageAspectRatio: ImageAspectRatio.portrait,
        borderRadius: 16.0,
        elevation: 4.0,
        typography: TypographyConfig(
          titleSize: 20.0,
          priceSize: 22.0,
          titleMaxLines: 1,
          descriptionMaxLines: 2,
        ),
        badges: BadgeConfig(
          position: BadgePosition.topRight,
          colors: BadgeColorConfig(),
        ),
        ctaButton: CtaButtonConfig(
          type: CtaButtonType.enquire,
          style: CtaButtonStyle.outlined,
        ),
        colors: CardColorConfig(),
      ),
      isDefault: false,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<CardPresetModel> getAllDefaults(String shopId) {
    return [
      ecommerceCompact(shopId),
      restaurantMenu(shopId),
      premiumCatalog(shopId),
    ];
  }
}
