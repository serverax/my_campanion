import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_bindings.dart';
import 'core/constants/app_sizes.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/text_styles.dart';

class RahmaApp extends StatelessWidget {
  const RahmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rahma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      initialBinding: InitialBindings(),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rahma')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Welcome', style: AppTextStyles.h1()),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'بسم الله الرحمن الرحيم',
                    style: AppTextStyles.quranArabic(),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: const Text('Prayer Times'),
                    onPressed: () => Get.toNamed(AppRoutes.prayerTimes),
                  ),
                  const SizedBox(height: AppSizes.md),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.explore),
                    label: const Text('Qibla'),
                    onPressed: () => Get.toNamed(AppRoutes.qibla),
                  ),
                  const SizedBox(height: AppSizes.md),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Islamic Calendar'),
                    onPressed: () => Get.toNamed(AppRoutes.calendar),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'More features coming: Quran, Masjid Finder, '
                    'Adhkar, Quran Radio.',
                    style: AppTextStyles.bodySmall(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
