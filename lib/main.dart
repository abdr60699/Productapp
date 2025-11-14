import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'providers/template_provider.dart';
import 'providers/product_provider.dart';
import 'providers/display_template_provider.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TemplateProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => DisplayTemplateProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Product Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
