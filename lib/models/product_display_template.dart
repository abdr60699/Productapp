enum ProductDisplayType {
  grid,     // Grid layout like Flipkart/Amazon
  list,     // List layout like traditional e-commerce
  card,     // Card layout like modern marketplaces
}

class ProductDisplayTemplate {
  final ProductDisplayType type;
  final String name;
  final String description;
  final String icon;

  const ProductDisplayTemplate({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
  });

  static const List<ProductDisplayTemplate> templates = [
    ProductDisplayTemplate(
      type: ProductDisplayType.grid,
      name: 'Grid View',
      description: 'Modern grid layout similar to Flipkart/Amazon - perfect for retail stores',
      icon: '🛍️',
    ),
    ProductDisplayTemplate(
      type: ProductDisplayType.list,
      name: 'List View',
      description: 'Clean list layout ideal for service providers and catalogs',
      icon: '📋',
    ),
    ProductDisplayTemplate(
      type: ProductDisplayType.card,
      name: 'Card View',
      description: 'Beautiful card layout perfect for restaurants, hotels, and portfolios',
      icon: '🎴',
    ),
  ];

  static ProductDisplayTemplate getByType(ProductDisplayType type) {
    return templates.firstWhere((template) => template.type == type);
  }
}