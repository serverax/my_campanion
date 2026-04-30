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
    final tiles = <_FeatureTile>[
      const _FeatureTile(
        label: 'Prayer Times',
        arabicLabel: 'الصلاة',
        asset: 'assets/images/duaa.png',
        route: AppRoutes.prayerTimes,
      ),
      const _FeatureTile(
        label: 'Qibla',
        arabicLabel: 'القبلة',
        asset: 'assets/images/qibla.jpg',
        route: AppRoutes.qibla,
      ),
      const _FeatureTile(
        label: 'Quran',
        arabicLabel: 'القرآن',
        asset: 'assets/images/quraan.png',
        route: AppRoutes.quran,
      ),
      const _FeatureTile(
        label: 'Quran Radio',
        arabicLabel: 'إذاعة القرآن',
        asset: 'assets/images/quraan.png',
        route: AppRoutes.quranRadio,
      ),
      const _FeatureTile(
        label: 'Adhkar',
        arabicLabel: 'الأذكار',
        asset: 'assets/images/adhkar.png',
        route: AppRoutes.adhkar,
      ),
      const _FeatureTile(
        label: 'Masjid Finder',
        arabicLabel: 'المساجد',
        asset: 'assets/images/masjid.png',
        route: AppRoutes.masjidFinder,
      ),
      const _FeatureTile(
        label: 'Calendar',
        arabicLabel: 'التقويم',
        asset: 'assets/images/99_names.png',
        route: AppRoutes.calendar,
      ),
      const _FeatureTile(
        label: 'Knowledge',
        arabicLabel: 'العلم',
        asset: 'assets/images/shekh.png',
        route: AppRoutes.askSheikh,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rahma'),
        actions: <Widget>[
          IconButton(
            tooltip: 'About',
            icon: const Icon(Icons.info_outline),
            onPressed: () => Get.toNamed(AppRoutes.about),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.lg),
              children: <Widget>[
                _Hero(),
                const SizedBox(height: AppSizes.xl),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = constraints.maxWidth > 600 ? 4 : 2;
                    return GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: cols,
                      crossAxisSpacing: AppSizes.md,
                      mainAxisSpacing: AppSizes.md,
                      childAspectRatio: 0.95,
                      children: tiles,
                    );
                  },
                ),
                const SizedBox(height: AppSizes.lg),
                Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.info_outline),
                    label: const Text('About Rahma & content attributions'),
                    onPressed: () => Get.toNamed(AppRoutes.about),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primaryDarkGreen, AppColors.primaryGreen],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusModals),
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusCards),
            child: Image.asset(
              'assets/images/logo.png',
              height: 80,
              width: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'بسم الله',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.h3().copyWith(
                    color: AppColors.accentGold,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Rahma — Islamic companion',
                  style: AppTextStyles.h4().copyWith(color: AppColors.bgWhite),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Offline-first. No ads, no tracking, no monthly cost.',
                  style: AppTextStyles.caption().copyWith(
                    color: AppColors.bgOffWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.label,
    required this.arabicLabel,
    required this.asset,
    required this.route,
  });

  final String label;
  final String arabicLabel;
  final String asset;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusCards),
          onTap: () => Get.toNamed(route),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Image.asset(asset, fit: BoxFit.contain)),
                const SizedBox(height: AppSizes.sm),
                Text(
                  label,
                  style: AppTextStyles.bodySmall().copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  arabicLabel,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.caption().copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
