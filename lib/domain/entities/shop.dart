class Shop {
  final String id;
  final String name;
  final String slug;
  final String ownerId;
  final String description;
  final String? logo;
  final String? coverImage;
  final BrandColors brandColors;
  final ContactInfo contactInfo;
  final SocialLinks socialLinks;
  final SeoSettings seoSettings;
  final bool isActive;
  final String plan;
  final DateTime createdAt;
  final DateTime updatedAt;

  Shop({
    required this.id,
    required this.name,
    required this.slug,
    required this.ownerId,
    this.description = '',
    this.logo,
    this.coverImage,
    required this.brandColors,
    required this.contactInfo,
    required this.socialLinks,
    required this.seoSettings,
    this.isActive = true,
    this.plan = 'free',
    required this.createdAt,
    required this.updatedAt,
  });

  Shop copyWith({
    String? id,
    String? name,
    String? slug,
    String? ownerId,
    String? description,
    String? logo,
    String? coverImage,
    BrandColors? brandColors,
    ContactInfo? contactInfo,
    SocialLinks? socialLinks,
    SeoSettings? seoSettings,
    bool? isActive,
    String? plan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      coverImage: coverImage ?? this.coverImage,
      brandColors: brandColors ?? this.brandColors,
      contactInfo: contactInfo ?? this.contactInfo,
      socialLinks: socialLinks ?? this.socialLinks,
      seoSettings: seoSettings ?? this.seoSettings,
      isActive: isActive ?? this.isActive,
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BrandColors {
  final String primary;
  final String accent;

  BrandColors({
    this.primary = '#FF6B35',
    this.accent = '#FFA500',
  });

  BrandColors copyWith({
    String? primary,
    String? accent,
  }) {
    return BrandColors(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
    );
  }
}

class ContactInfo {
  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? address;

  ContactInfo({
    this.phone,
    this.whatsapp,
    this.email,
    this.address,
  });

  ContactInfo copyWith({
    String? phone,
    String? whatsapp,
    String? email,
    String? address,
  }) {
    return ContactInfo(
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}

class SocialLinks {
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? youtube;
  final String? website;

  SocialLinks({
    this.facebook,
    this.instagram,
    this.twitter,
    this.youtube,
    this.website,
  });

  SocialLinks copyWith({
    String? facebook,
    String? instagram,
    String? twitter,
    String? youtube,
    String? website,
  }) {
    return SocialLinks(
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      youtube: youtube ?? this.youtube,
      website: website ?? this.website,
    );
  }
}

class SeoSettings {
  final String title;
  final String description;
  final List<String> keywords;

  SeoSettings({
    required this.title,
    required this.description,
    this.keywords = const [],
  });

  SeoSettings copyWith({
    String? title,
    String? description,
    List<String>? keywords,
  }) {
    return SeoSettings(
      title: title ?? this.title,
      description: description ?? this.description,
      keywords: keywords ?? this.keywords,
    );
  }
}
