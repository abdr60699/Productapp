# Build Guide - Clean Architecture Refactoring

## Overview
This application has been refactored to use **Clean Architecture** with normal Dart classes instead of freezed and code generation.

## Architecture

The application now follows a clean architecture pattern with three main layers:

### 1. Domain Layer (`lib/domain/`)
Contains business logic and entities:
- **Entities** (`lib/domain/entities/`): Core business objects
  - `Product`: Product entity with all properties
  - `Template`: Template entity for forms
  - `Field`: Form field entity
  - `Shop`: Shop entity

- **Repositories** (`lib/domain/repositories/`): Abstract repository interfaces
  - `ProductRepository`: Interface for product operations
  - `TemplateRepository`: Interface for template operations
  - `ShopRepository`: Interface for shop operations

- **Use Cases** (`lib/domain/usecases/`): Business logic operations
  - Product use cases: `GetProducts`, `GetProduct`, `SaveProduct`, `DeleteProduct`
  - Template use cases: `GetTemplates`, `GetTemplate`, `SaveTemplate`, `DeleteTemplate`

### 2. Data Layer (`lib/data/`)
Handles data operations and persistence:
- **Models** (`lib/data/models/`): Data models extending domain entities with JSON serialization
  - `ProductModel extends Product`
  - `TemplateModel extends Template`
  - `FieldModel extends Field`

- **Repositories** (`lib/data/repositories/`): Concrete implementations of repository interfaces
  - `ProductRepositoryImpl`
  - `TemplateRepositoryImpl`

- **Data Sources** (`lib/data/datasources/`): Local storage implementation
  - `LocalDataSource`: SharedPreferences-based local storage

### 3. Presentation Layer (`lib/presentation/`)
UI and state management:
- **Providers** (`lib/presentation/providers/`): State management using Provider pattern
  - `ProductProvider`: Manages product state
  - `TemplateProvider`: Manages template state

- **Screens** (`lib/screens/`): UI screens
- **Widgets** (`lib/widgets/`): Reusable UI components

### 4. Core Layer (`lib/core/`)
Cross-cutting concerns:
- **Dependency Injection** (`lib/core/di/`):
  - `InjectionContainer`: Simple DI container for managing dependencies

## Key Changes from Previous Version

1. **Removed Dependencies**:
   - ❌ `freezed` and `freezed_annotation` - No longer using code generation
   - ❌ `json_serializable` - Manual JSON serialization instead
   - ❌ `build_runner` - No code generation needed

2. **Normal Classes Instead of Freezed**:
   - All models are now normal Dart classes
   - Manual `copyWith` methods
   - Manual `toJson` and `fromJson` methods
   - Cleaner, more maintainable code

3. **Clean Architecture**:
   - Clear separation of concerns
   - Domain layer is independent of frameworks
   - Data layer implements domain interfaces
   - Presentation layer depends on domain, not data

4. **Dependency Injection**:
   - Simple DI container manages all dependencies
   - Easy to test and maintain
   - Clear dependency flow

## Building the Application

### Prerequisites
- Flutter SDK (3.4.1 or higher)
- Dart SDK (3.4.1 or higher)

### Steps

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the application**:
   ```bash
   flutter run
   ```

3. **Build for production**:
   ```bash
   # Android
   flutter build apk --release

   # iOS
   flutter build ios --release

   # Web
   flutter build web --release
   ```

## Project Structure

```
lib/
├── core/
│   ├── di/
│   │   └── injection_container.dart    # Dependency injection setup
│   └── constants/                       # App constants
│
├── domain/                              # Business logic layer
│   ├── entities/                        # Domain entities
│   │   ├── product.dart
│   │   ├── template.dart
│   │   ├── field.dart
│   │   └── shop.dart
│   ├── repositories/                    # Repository interfaces
│   │   ├── product_repository.dart
│   │   ├── template_repository.dart
│   │   └── shop_repository.dart
│   └── usecases/                        # Business use cases
│       ├── get_products.dart
│       ├── get_product.dart
│       ├── save_product.dart
│       ├── delete_product.dart
│       ├── get_templates.dart
│       ├── get_template.dart
│       ├── save_template.dart
│       └── delete_template.dart
│
├── data/                                # Data layer
│   ├── models/                          # Data models (with JSON)
│   │   ├── product_model.dart
│   │   ├── template_model.dart
│   │   └── field_model.dart
│   ├── repositories/                    # Repository implementations
│   │   ├── product_repository_impl.dart
│   │   └── template_repository_impl.dart
│   └── datasources/                     # Data sources
│       └── local_data_source.dart       # SharedPreferences
│
├── presentation/                        # Presentation layer
│   ├── providers/                       # State management
│   │   ├── product_provider.dart
│   │   └── template_provider.dart
│   ├── screens/                         # UI screens
│   └── widgets/                         # UI widgets
│
├── screens/                             # App screens (legacy location)
├── widgets/                             # Reusable widgets (legacy location)
├── utils/                               # Utility files
├── main.dart                            # App entry point
└── pubspec.yaml                         # Dependencies
```

## No Code Generation Required

Unlike the previous version, this application **does NOT require** running `build_runner`. All code is written manually, making it:
- ✅ Easier to understand
- ✅ Easier to debug
- ✅ Easier to maintain
- ✅ No generated file conflicts
- ✅ Faster development cycle

## Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  provider: ^6.1.2

  # Local storage
  shared_preferences: ^2.2.3

  # Firebase (configured but not implemented yet)
  cloud_firestore: ^5.2.1

  # UUID generation
  uuid: ^4.4.0

  # UI
  flutter_screenutil: ^5.9.3
  google_fonts: ^6.2.1

  # Media
  file_picker: ^8.0.0+1
  image: ^4.1.7
  url_launcher: ^6.2.5
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## Testing

Currently using local storage (SharedPreferences). To test:

1. Run the app
2. Create templates using preset templates (Clothing, Restaurant, Electronics)
3. Add products using the templates
4. All data persists locally

## Future Enhancements

1. **Firebase Integration**: Replace `LocalDataSource` with Firebase Firestore
2. **Unit Tests**: Add tests for use cases, repositories, and providers
3. **Integration Tests**: Test the full flow
4. **Error Handling**: Add proper error handling and user feedback

## Troubleshooting

### Common Issues

1. **Import errors**: Make sure all imports use the new structure:
   - Use `domain/entities/` for business objects
   - Use `presentation/providers/` for state management

2. **Provider not found**: Ensure `InjectionContainer` is initialized in `main.dart`

3. **Data not persisting**: Check SharedPreferences permissions

## Support

For issues or questions, please create an issue in the repository.
