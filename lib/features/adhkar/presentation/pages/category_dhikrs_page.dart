import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/adhkar_data.dart';
import '../../domain/entities/dhikr.dart';
import '../controllers/adhkar_controller.dart';
import '../widgets/dhikr_card.dart';

class CategoryDhikrsPage extends StatefulWidget {
  const CategoryDhikrsPage({super.key, required this.category});
  final DhikrCategory category;

  @override
  State<CategoryDhikrsPage> createState() => _CategoryDhikrsPageState();
}

class _CategoryDhikrsPageState extends State<CategoryDhikrsPage> {
  late final List<Dhikr> _dhikrs;
  late final AdhkarController _controller;

  @override
  void initState() {
    super.initState();
    _dhikrs = AdhkarData.forCategory(widget.category);
    _controller = Get.find<AdhkarController>();
    _controller.hydrateFor(_dhikrs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.englishName),
        actions: <Widget>[
          IconButton(
            tooltip: 'Reset all in this category',
            icon: const Icon(Icons.refresh),
            onPressed: _confirmResetAll,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.lg),
              itemCount: _dhikrs.length,
              itemBuilder: (_, i) => DhikrCard(dhikr: _dhikrs[i]),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmResetAll() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset all counts?'),
        content: const Text(
          'This will set every dhikr in this category back to zero.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _controller.resetCategory(widget.category, _dhikrs);
              Navigator.of(ctx).pop();
            },
            child: const Text('Reset all'),
          ),
        ],
      ),
    );
  }
}
