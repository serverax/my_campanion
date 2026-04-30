import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/repositories/islamic_kb_repository.dart';
import '../../domain/entities/islamic_qa_data.dart';
import '../../domain/entities/islamic_question.dart';
import 'islamic_kb_detail_page.dart';

/// Chat-style wrapper around the existing curated knowledge pool.
/// User types a question → repository's substring search runs over the
/// 30 hand-curated entries → matching entry's answer surfaces as a
/// chat-bubble reply. No AI, no API, no PII.
class IslamicKbChatPage extends StatefulWidget {
  const IslamicKbChatPage({super.key});

  @override
  State<IslamicKbChatPage> createState() => _IslamicKbChatPageState();
}

class _IslamicKbChatPageState extends State<IslamicKbChatPage> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_Turn> _turns = <_Turn>[];
  late final IslamicKbRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = Get.find<IslamicKbRepository>();
    _turns.add(const _Turn.greeting());
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _ask(String raw) {
    final q = raw.trim();
    if (q.isEmpty) return;
    final results = _repo.search(q);
    setState(() {
      _turns.add(_Turn.user(q));
      if (results.isEmpty) {
        _turns.add(const _Turn.notFound());
      } else {
        _turns.add(_Turn.answer(results.first));
        // Record view in history
        _repo.recordView(results.first.id);
      }
    });
    _input.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _quickAsk(String prompt) {
    _input.text = prompt;
    _ask(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Rahma'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Browse all categories',
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => Get.toNamed(AppRoutes.askSheikhBrowse),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: Column(
              children: <Widget>[
                _DisclaimerStrip(),
                Expanded(
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(AppSizes.lg),
                    itemCount: _turns.length,
                    itemBuilder: (_, i) =>
                        _BubbleFor(turn: _turns[i], onQuickAsk: _quickAsk),
                  ),
                ),
                _Composer(controller: _input, onSubmit: _ask),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DisclaimerStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      color: AppColors.bgSoftGreen,
      child: Text(
        'Rahma searches a curated pool of widely-accepted Islamic '
        'guidance. It is a search tool, not a scholar — answers are '
        'general only. For personal rulings, consult a qualified '
        'local scholar.',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption(),
      ),
    );
  }
}

enum _TurnKind { greeting, user, answer, notFound }

class _Turn {
  final _TurnKind kind;
  final String? text;
  final IslamicQuestion? entry;

  const _Turn._({required this.kind, this.text, this.entry});
  const _Turn.greeting() : this._(kind: _TurnKind.greeting);
  const _Turn.user(String text) : this._(kind: _TurnKind.user, text: text);
  const _Turn.answer(IslamicQuestion e)
    : this._(kind: _TurnKind.answer, entry: e);
  const _Turn.notFound() : this._(kind: _TurnKind.notFound);
}

class _BubbleFor extends StatelessWidget {
  const _BubbleFor({required this.turn, required this.onQuickAsk});
  final _Turn turn;
  final void Function(String) onQuickAsk;

  @override
  Widget build(BuildContext context) {
    switch (turn.kind) {
      case _TurnKind.greeting:
        return _GreetingBubble(onQuickAsk: onQuickAsk);
      case _TurnKind.user:
        return _UserBubble(text: turn.text!);
      case _TurnKind.answer:
        return _AnswerBubble(entry: turn.entry!);
      case _TurnKind.notFound:
        return const _NotFoundBubble();
    }
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusCards),
                topRight: Radius.circular(AppSizes.radiusCards),
                bottomLeft: Radius.circular(AppSizes.radiusCards),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              text,
              style: AppTextStyles.bodyRegular().copyWith(
                color: AppColors.bgWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GreetingBubble extends StatelessWidget {
  const _GreetingBubble({required this.onQuickAsk});
  final void Function(String) onQuickAsk;

  static const List<_QuickPrompt> _prompts = <_QuickPrompt>[
    _QuickPrompt('🕌', 'How do I make wudu?'),
    _QuickPrompt('🌙', 'What invalidates the fast?'),
    _QuickPrompt('💰', 'Who can receive zakat?'),
    _QuickPrompt('🕋', 'What are the pillars of Hajj?'),
    _QuickPrompt('📿', 'Morning and evening adhkar'),
    _QuickPrompt('🍽️', 'What foods are halal?'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.bgSoftGreen,
              border: Border.all(color: AppColors.primaryGreen),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(AppSizes.radiusCards),
                bottomLeft: Radius.circular(AppSizes.radiusCards),
                bottomRight: Radius.circular(AppSizes.radiusCards),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Rahma',
                  style: AppTextStyles.caption().copyWith(
                    color: AppColors.primaryDarkGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'السلام عليكم ورحمة الله',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.arabicBody().copyWith(
                    fontSize: 18,
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Welcome. Ask a question about prayer, fasting, '
                  'zakat, hajj, daily practice, or everyday halal '
                  'matters. I\'ll search the curated knowledge pool.',
                  style: AppTextStyles.bodySmall(),
                ),
                const SizedBox(height: AppSizes.md),
                Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: _prompts
                      .map(
                        (p) => ActionChip(
                          avatar: Text(p.emoji),
                          label: Text(p.label),
                          onPressed: () => onQuickAsk(p.label),
                          backgroundColor: AppColors.bgWhite,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickPrompt {
  final String emoji;
  final String label;
  const _QuickPrompt(this.emoji, this.label);
}

class _AnswerBubble extends StatelessWidget {
  const _AnswerBubble({required this.entry});
  final IslamicQuestion entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              border: Border.all(color: AppColors.divider),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(AppSizes.radiusCards),
                bottomLeft: Radius.circular(AppSizes.radiusCards),
                bottomRight: Radius.circular(AppSizes.radiusCards),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Rahma',
                      style: AppTextStyles.caption().copyWith(
                        color: AppColors.primaryDarkGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgSoftGreen,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusChips,
                        ),
                      ),
                      child: Text(
                        entry.category.englishName,
                        style: AppTextStyles.caption().copyWith(
                          color: AppColors.primaryDarkGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  entry.questionEn,
                  style: AppTextStyles.bodyRegular().copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  entry.questionAr,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.arabicBody().copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
                  child: Divider(height: 1),
                ),
                Text(
                  entry.answerEn,
                  style: AppTextStyles.bodyRegular().copyWith(height: 1.55),
                ),
                const SizedBox(height: AppSizes.md),
                _MetaChip(
                  icon: Icons.menu_book_outlined,
                  label: 'Source',
                  text: entry.source,
                ),
                if (entry.scholarlyNote != null) ...<Widget>[
                  const SizedBox(height: AppSizes.sm),
                  _MetaChip(
                    icon: Icons.school_outlined,
                    label: 'Scholarly note',
                    text: entry.scholarlyNote!,
                  ),
                ],
                const SizedBox(height: AppSizes.sm),
                _MetaChip(
                  icon: Icons.info_outline,
                  label: 'Disclaimer',
                  text: IslamicQaData.universalDisclaimer,
                ),
                const SizedBox(height: AppSizes.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.open_in_full, size: AppSizes.iconSm),
                    label: const Text('Open full entry'),
                    onPressed: () =>
                        Get.to<void>(() => IslamicKbDetailPage(entry: entry)),
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

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.text,
  });
  final IconData icon;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.bgOffWhite,
        borderRadius: BorderRadius.circular(AppSizes.radiusChips),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: AppSizes.iconSm, color: AppColors.primaryGreen),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: AppTextStyles.caption().copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
                Text(text, style: AppTextStyles.caption()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFoundBubble extends StatelessWidget {
  const _NotFoundBubble();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.bgOffWhite,
              border: Border.all(color: AppColors.divider),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(AppSizes.radiusCards),
                bottomLeft: Radius.circular(AppSizes.radiusCards),
                bottomRight: Radius.circular(AppSizes.radiusCards),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Rahma',
                  style: AppTextStyles.caption().copyWith(
                    color: AppColors.primaryDarkGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'I couldn\'t find that exact topic in the curated pool. '
                  'Try a simpler keyword (e.g. "wudu", "fasting", "zakat") '
                  'or browse all categories.',
                  style: AppTextStyles.bodySmall(),
                ),
                const SizedBox(height: AppSizes.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.menu_book_outlined,
                      size: AppSizes.iconSm,
                    ),
                    label: const Text('Browse categories'),
                    onPressed: () => Get.toNamed(AppRoutes.askSheikhBrowse),
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

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSubmit});
  final TextEditingController controller;
  final void Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: const BoxDecoration(
        color: AppColors.bgWhite,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Ask about ibadah…',
                isDense: true,
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: onSubmit,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Material(
            color: AppColors.primaryGreen,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => onSubmit(controller.text),
              child: const Padding(
                padding: EdgeInsets.all(AppSizes.md),
                child: Icon(
                  Icons.send_rounded,
                  color: AppColors.bgWhite,
                  size: AppSizes.iconMd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
