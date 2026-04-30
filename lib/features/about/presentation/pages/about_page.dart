import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String _privacyUrl =
      'https://serverax.github.io/my_campanion/PRIVACY_POLICY';
  static const String _dataSafetyUrl =
      'https://serverax.github.io/my_campanion/DATA_SAFETY';
  static const String _sourceUrl = 'https://github.com/serverax/my_campanion';
  static const String _contactEmail = 'rahmahislamic48@gmail.com';

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> _email() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _contactEmail,
      queryParameters: <String, String>{'subject': 'Rahma app — feedback'},
    );
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
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
                _Section(
                  title: 'Tagline',
                  child: Text(
                    'Your daily companion for prayer, Quran, and remembrance — '
                    'offline-first, free forever.',
                    style: AppTextStyles.bodyRegular(),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                _Section(
                  title: 'Sadaqa Jareya',
                  child: Text(
                    'Rahma is built as ongoing charity. No ads, no tracking, '
                    'no account, no monthly cost. Every prayer it helps you '
                    'remember and every verse it helps you read is a benefit '
                    'that continues.',
                    style: AppTextStyles.bodyRegular(),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                _Section(
                  title: 'Content attributions',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      _Bullet(
                        'Arabic Qur\'an: Tanzil Quran-Uthmani '
                        '(CC BY-ND 3.0)',
                      ),
                      _Bullet(
                        'English translation: Sahih International '
                        '(open redistribution)',
                      ),
                      _Bullet('Mirror used to bundle both: alquran.cloud'),
                      _Bullet(
                        'Quran recitation audio: Yaser Al-Dosari '
                        'served by mp3quran.net',
                      ),
                      _Bullet(
                        'Mosque data: OpenStreetMap via Overpass API '
                        '(ODbL)',
                      ),
                      _Bullet('Map tiles: openstreetmap.org tile server'),
                      _Bullet('Prayer time math: adhan-dart package'),
                      _Bullet(
                        'Hijri ↔ Gregorian: hijri Dart package '
                        '(Umm al-Qura table)',
                      ),
                      _Bullet(
                        'Hadith citations and Q&A: hand-curated from '
                        'Sahih al-Bukhari, Sahih Muslim, the Sunan, and the '
                        'public-domain Quran. General guidance only — not a '
                        'fatwa.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                _Section(
                  title: 'Privacy',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'No PII collected. No analytics. No crash reporting. '
                        'No backend operated by us. The only outbound calls '
                        'are to: Overpass (when you open Masjid Finder), '
                        'mp3quran.net (when you stream a surah), and '
                        'openstreetmap.org tile server (when the map view '
                        'is open).',
                        style: AppTextStyles.bodyRegular(),
                      ),
                      const SizedBox(height: AppSizes.md),
                      _LinkRow(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy policy',
                        onTap: () => _open(_privacyUrl),
                      ),
                      _LinkRow(
                        icon: Icons.shield_outlined,
                        label: 'Play Store Data Safety reference',
                        onTap: () => _open(_dataSafetyUrl),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                _Section(
                  title: 'Source',
                  child: _LinkRow(
                    icon: Icons.code,
                    label: 'github.com/serverax/my_campanion',
                    onTap: () => _open(_sourceUrl),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                _Section(
                  title: 'Contact',
                  child: _LinkRow(
                    icon: Icons.mail_outline,
                    label: _contactEmail,
                    onTap: _email,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                Text(
                  '— Alhamdulillah —',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall().copyWith(
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
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusCards),
            child: Image.asset(
              'assets/images/logo.png',
              height: 96,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Rahma',
            style: AppTextStyles.h1().copyWith(color: AppColors.bgWhite),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'رحمة',
            textDirection: TextDirection.rtl,
            style: AppTextStyles.h3().copyWith(color: AppColors.accentGold),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Version 1.0.0  •  Islamic companion',
            style: AppTextStyles.caption().copyWith(
              color: AppColors.bgOffWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTextStyles.h4()),
          const SizedBox(height: AppSizes.sm),
          child,
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 6, right: AppSizes.sm),
            child: Icon(Icons.circle, size: 6, color: AppColors.primaryGreen),
          ),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall())),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Icon(icon, color: AppColors.primaryGreen, size: AppSizes.iconSm),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmall().copyWith(
                  color: AppColors.primaryDarkGreen,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Icon(
              Icons.open_in_new,
              size: AppSizes.iconSm,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
