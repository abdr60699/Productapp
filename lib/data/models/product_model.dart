import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.shopId,
    required super.templateId,
    required super.templateName,
    required super.slug,
    required super.title,
    required super.data,
    super.images,
    super.tags,
    super.category,
    super.price,
    super.compareAtPrice,
    super.inStock,
    super.featured,
    super.cardPresetId,
    super.seo,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.publishedAt,
  });

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      shopId: product.shopId,
      templateId: product.templateId,
      templateName: product.templateName,
      slug: product.slug,
      title: product.title,
      data: product.data,
      images: product.images,
      tags: product.tags,
      category: product.category,
      price: product.price,
      compareAtPrice: product.compareAtPrice,
      inStock: product.inStock,
      featured: product.featured,
      cardPresetId: product.cardPresetId,
      seo: product.seo,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      publishedAt: product.publishedAt,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      templateId: json['templateId'] as String,
      templateName: json['templateName'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      data: Map<String, dynamic>.from(json['data'] as Map),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      category: json['category'] as String?,
      price: json['price'] as double?,
      compareAtPrice: json['compareAtPrice'] as double?,
      inStock: json['inStock'] as bool? ?? true,
      featured: json['featured'] as bool? ?? false,
      cardPresetId: json['cardPresetId'] as String?,
      seo: json['seo'] != null
          ? ProductSeoModel.fromJson(json['seo'] as Map<String, dynamic>)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'templateId': templateId,
      'templateName': templateName,
      'slug': slug,
      'title': title,
      'data': data,
      'images': images.map((e) => ProductImageModel.fromEntity(e).toJson()).toList(),
      'tags': tags,
      'category': category,
      'price': price,
      'compareAtPrice': compareAtPrice,
      'inStock': inStock,
      'featured': featured,
      'cardPresetId': cardPresetId,
      'seo': seo != null ? ProductSeoModel.fromEntity(seo!).toJson() : null,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt?.toIso8601String(),
    };
  }
}

class ProductImageModel extends ProductImage {
  ProductImageModel({
    required super.url,
    super.thumbUrl,
    super.mediumUrl,
    super.order,
    super.alt,
  });

  factory ProductImageModel.fromEntity(ProductImage image) {
    return ProductImageModel(
      url: image.url,
      thumbUrl: image.thumbUrl,
      mediumUrl: image.mediumUrl,
      order: image.order,
      alt: image.alt,
    );
  }

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      url: json['url'] as String,
      thumbUrl: json['thumbUrl'] as String?,
      mediumUrl: json['mediumUrl'] as String?,
      order: json['order'] as int? ?? 0,
      alt: json['alt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'thumbUrl': thumbUrl,
      'mediumUrl': mediumUrl,
      'order': order,
      'alt': alt,
    };
  }
}

class ProductSeoModel extends ProductSeo {
  ProductSeoModel({
    super.title,
    super.description,
    super.keywords,
    super.ogImage,
  });

  factory ProductSeoModel.fromEntity(ProductSeo seo) {
    return ProductSeoModel(
      title: seo.title,
      description: seo.description,
      keywords: seo.keywords,
      ogImage: seo.ogImage,
    );
  }

  factory ProductSeoModel.fromJson(Map<String, dynamic> json) {
    return ProductSeoModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      keywords: (json['keywords'] as List<dynamic>?)?.cast<String>() ?? [],
      ogImage: json['ogImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'keywords': keywords,
      'ogImage': ogImage,
    };
  }
}
