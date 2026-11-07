import 'package:flutter/material.dart';
import 'core/theme/weman_theme.dart';
import 'core/routing/app_router.dart';

class WemanApp extends StatelessWidget {
  const WemanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WEMAN FIT - Social Fitness',
      debugShowCheckedModeBanner: false,
      theme: WemanTheme.lightTheme,
      darkTheme: WemanTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
