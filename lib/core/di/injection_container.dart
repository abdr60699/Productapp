import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/template_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/template_repository.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/save_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_templates.dart';
import '../../domain/usecases/get_template.dart';
import '../../domain/usecases/save_template.dart';
import '../../domain/usecases/delete_template.dart';
import '../../presentation/providers/product_provider.dart';
import '../../presentation/providers/template_provider.dart';

// Simple dependency injection container
class InjectionContainer {
  // Singleton instance
  static final InjectionContainer _instance = InjectionContainer._internal();

  factory InjectionContainer() {
    return _instance;
  }

  InjectionContainer._internal();

  // Data sources
  late LocalDataSource _localDataSource;

  // Repositories
  late ProductRepository _productRepository;
  late TemplateRepository _templateRepository;

  // Use cases
  late GetProducts _getProducts;
  late GetProduct _getProduct;
  late SaveProduct _saveProduct;
  late DeleteProduct _deleteProduct;
  late GetTemplates _getTemplates;
  late GetTemplate _getTemplate;
  late SaveTemplate _saveTemplate;
  late DeleteTemplate _deleteTemplate;

  // Providers
  late ProductProvider _productProvider;
  late TemplateProvider _templateProvider;

  Future<void> init() async {
    // Data sources
    _localDataSource = LocalDataSource();

    // Repositories
    _productRepository = ProductRepositoryImpl(_localDataSource);
    _templateRepository = TemplateRepositoryImpl(_localDataSource);

    // Use cases
    _getProducts = GetProducts(_productRepository);
    _getProduct = GetProduct(_productRepository);
    _saveProduct = SaveProduct(_productRepository);
    _deleteProduct = DeleteProduct(_productRepository);
    _getTemplates = GetTemplates(_templateRepository);
    _getTemplate = GetTemplate(_templateRepository);
    _saveTemplate = SaveTemplate(_templateRepository);
    _deleteTemplate = DeleteTemplate(_templateRepository);

    // Providers
    _productProvider = ProductProvider(
      getProductsUseCase: _getProducts,
      getProductUseCase: _getProduct,
      saveProductUseCase: _saveProduct,
      deleteProductUseCase: _deleteProduct,
      productRepository: _productRepository,
    );

    _templateProvider = TemplateProvider(
      getTemplatesUseCase: _getTemplates,
      getTemplateUseCase: _getTemplate,
      saveTemplateUseCase: _saveTemplate,
      deleteTemplateUseCase: _deleteTemplate,
    );
  }

  // Getters
  ProductProvider get productProvider => _productProvider;
  TemplateProvider get templateProvider => _templateProvider;
}
