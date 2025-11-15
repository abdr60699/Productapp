class Product {
  final String id;
  final String shopId;
  final String templateId;
  final String templateName;
  final String slug;
  final String title;
  final Map<String, dynamic> data;
  final List<ProductImage> images;
  final List<String> tags;
  final String? category;
  final double? price;
  final double? compareAtPrice;
  final bool inStock;
  final bool featured;
  final String? cardPresetId;
  final ProductSeo? seo;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;

  Product({
    required this.id,
    required this.shopId,
    required this.templateId,
    required this.templateName,
    required this.slug,
    required this.title,
    required this.data,
    this.images = const [],
    this.tags = const [],
    this.category,
    this.price,
    this.compareAtPrice,
    this.inStock = true,
    this.featured = false,
    this.cardPresetId,
    this.seo,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  Product copyWith({
    String? id,
    String? shopId,
    String? templateId,
    String? templateName,
    String? slug,
    String? title,
    Map<String, dynamic>? data,
    List<ProductImage>? images,
    List<String>? tags,
    String? category,
    double? price,
    double? compareAtPrice,
    bool? inStock,
    bool? featured,
    String? cardPresetId,
    ProductSeo? seo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
  }) {
    return Product(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      data: data ?? this.data,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      price: price ?? this.price,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      inStock: inStock ?? this.inStock,
      featured: featured ?? this.featured,
      cardPresetId: cardPresetId ?? this.cardPresetId,
      seo: seo ?? this.seo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  String? getFieldValue(String fieldId) {
    return data[fieldId]?.toString();
  }

  bool get isPublished => publishedAt != null;

  bool get isOnSale =>
      compareAtPrice != null && price != null && compareAtPrice! > price!;

  double? get discountPercentage {
    if (!isOnSale || compareAtPrice == null || price == null) return null;
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
    final imagesCopy = List<ProductImage>.from(images);
    imagesCopy.sort((a, b) => a.order.compareTo(b.order));
    return imagesCopy;
  }
}

class ProductImage {
  final String url;
  final String? thumbUrl;
  final String? mediumUrl;
  final int order;
  final String? alt;

  ProductImage({
    required this.url,
    this.thumbUrl,
    this.mediumUrl,
    this.order = 0,
    this.alt,
  });

  ProductImage copyWith({
    String? url,
    String? thumbUrl,
    String? mediumUrl,
    int? order,
    String? alt,
  }) {
    return ProductImage(
      url: url ?? this.url,
      thumbUrl: thumbUrl ?? this.thumbUrl,
      mediumUrl: mediumUrl ?? this.mediumUrl,
      order: order ?? this.order,
      alt: alt ?? this.alt,
    );
  }
}

class ProductSeo {
  final String? title;
  final String? description;
  final List<String> keywords;
  final String? ogImage;

  ProductSeo({
    this.title,
    this.description,
    this.keywords = const [],
    this.ogImage,
  });

  ProductSeo copyWith({
    String? title,
    String? description,
    List<String>? keywords,
    String? ogImage,
  }) {
    return ProductSeo(
      title: title ?? this.title,
      description: description ?? this.description,
      keywords: keywords ?? this.keywords,
      ogImage: ogImage ?? this.ogImage,
    );
  }
}
