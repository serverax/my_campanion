import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_bindings.dart';
import 'core/constants/app_colors.dart';
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
                    'Foundation in place. Theme, colors, typography, '
                    'routing, and 8 feature folders are wired up.',
                    style: AppTextStyles.bodyRegular(),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  Text(
                    'السلام عليكم',
                    style: AppTextStyles.h3(),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    'بسم الله الرحمن الرحيم',
                    style: AppTextStyles.quranArabic(),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  _PaletteSwatches(),
                  const SizedBox(height: AppSizes.xl),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Primary action'),
                  ),
                  const SizedBox(height: AppSizes.md),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Secondary action'),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'caption text — secondary information',
                    style: AppTextStyles.caption(),
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

class _PaletteSwatches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final swatches = <_Swatch>[
      const _Swatch('Dark green', AppColors.primaryDarkGreen),
      const _Swatch('Green', AppColors.primaryGreen),
      const _Swatch('Gold', AppColors.accentGold),
      const _Swatch('Off-white', AppColors.bgOffWhite),
      const _Swatch('Soft green', AppColors.bgSoftGreen),
    ];
    return Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.md,
      children: swatches
          .map(
            (s) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: s.color,
                    borderRadius: BorderRadius.circular(AppSizes.radiusCards),
                    border: Border.all(color: AppColors.divider),
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(s.label, style: AppTextStyles.caption()),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _Swatch {
  final String label;
  final Color color;
  const _Swatch(this.label, this.color);
}
