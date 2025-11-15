import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String shopId,
    required String templateId,
    required String templateName,
    required String slug,
    required String title,
    required Map<String, dynamic> data,
    @Default([]) List<ProductImage> images,
    @Default([]) List<String> tags,
    String? category,
    double? price,
    double? compareAtPrice,
    @Default(true) bool inStock,
    @Default(false) bool featured,
    String? cardPresetId,
    ProductSeo? seo,
    @Default(true) bool isActive,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime updatedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? publishedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  static DateTime _timestampFromJson(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is Timestamp) return timestamp.toDate();
    return DateTime.parse(timestamp as String);
  }

  static dynamic _timestampToJson(DateTime? dateTime) {
    if (dateTime == null) return null;
    return Timestamp.fromDate(dateTime);
  }
}

const ProductModel._();

  String? getFieldValue(String fieldId) {
    return data[fieldId]?.toString();
  }

  bool get isPublished => publishedAt != null && isActive;

  bool get isOnSale => compareAtPrice != null && compareAtPrice! > (price ?? 0);

  double? get discountPercentage {
    if (!isOnSale || price == null || compareAtPrice == null || compareAtPrice! == 0) {
      return null;
    }
    return ((compareAtPrice! - price!) / compareAtPrice!) * 100;
  }

  String get primaryImageUrl {
    if (images.isEmpty) return '';
    return images.first.url;
  }

  String get primaryImageThumbUrl {
    if (images.isEmpty) return '';
    return images.first.thumbUrl ?? images.first.url;
  }

  List<ProductImage> get sortedImages {
    final sorted = List<ProductImage>.from(images);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }
}

@freezed
class ProductImage with _$ProductImage {
  const factory ProductImage({
    required String url,
    String? thumbUrl,
    String? mediumUrl,
    @Default(0) int order,
    String? alt,
  }) = _ProductImage;

  factory ProductImage.fromJson(Map<String, dynamic> json) => _$ProductImageFromJson(json);
}

@freezed
class ProductSeo with _$ProductSeo {
  const factory ProductSeo({
    String? title,
    String? description,
    @Default([]) List<String> keywords,
    String? ogImage,
  }) = _ProductSeo;

  factory ProductSeo.fromJson(Map<String, dynamic> json) => _$ProductSeoFromJson(json);
}
