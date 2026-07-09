import 'package:core_theme/core_theme.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:latchly/src/core/app_info.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.shield_rounded, size: 64, color: scheme.primary),
                  const SizedBox(height: AppSpacing.md),
                  const Text(AppInfo.name, style: AppTextStyles.h1),
                  Text(
                    'Version ${AppInfo.version}',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            VaultCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock_rounded, color: scheme.primary, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      const Text('Private by design', style: AppTextStyles.h4),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'OpenLock runs entirely on your device. Your lock settings '
                    'and any intruder photos are encrypted and never leave '
                    'your phone. No account, no ads, no tracking.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Part of the Secure Suite — a family of offline, encrypted, '
              'open-source apps.',
              style: AppTextStyles.bodySmall
                  .copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
