import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latchly/src/core/di.dart';
import 'package:latchly/src/core/router/app_router.dart';
import 'package:latchly/src/features/enforcement/models/lock_config.dart';
import 'package:latchly/src/features/enforcement/models/relock_policy.dart';
import 'package:latchly/src/features/enforcement/providers/config_providers.dart';
import 'package:latchly/src/features/settings/providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _relockLabel(RelockPolicy policy) {
    switch (policy.mode) {
      case RelockMode.immediately:
        return 'When you leave the app';
      case RelockMode.onScreenOff:
        return 'When the screen turns off';
      case RelockMode.afterTimeout:
        return 'After ${policy.timeout.inMinutes} min';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config =
        ref.watch(configControllerProvider).valueOrNull ?? LockConfig.empty;
    final controller = ref.read(configControllerProvider.notifier);
    final biometricSupported =
        ref.watch(biometricSupportedProvider).valueOrNull ?? false;
    final biometricEnabled =
        ref.watch(biometricEnabledProvider).valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          children: [
            _section(context, 'Protection'),
            ListTile(
              leading: const Icon(Icons.verified_user_outlined),
              title: const Text('Permissions & status'),
              subtitle: const Text('Usage access, overlay, monitor service'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.permissions),
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Relock behavior'),
              subtitle: Text(_relockLabel(config.relock)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.relock),
            ),
            _section(context, 'Security'),
            ListTile(
              leading: const Icon(Icons.pin_outlined),
              title: const Text('Change PIN'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.changePin),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: const Text('Fingerprint unlock'),
              subtitle: Text(
                biometricSupported
                    ? 'Use your fingerprint to open Latchly'
                    : 'Not available on this device',
              ),
              value: biometricEnabled,
              onChanged: biometricSupported
                  ? (value) async {
                      final service = ref.read(biometricServiceProvider);
                      if (value) {
                        await service.enable();
                      } else {
                        await service.disable();
                      }
                      ref.invalidate(biometricEnabledProvider);
                    }
                  : null,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.shuffle),
              title: const Text('Randomize keypad'),
              subtitle: const Text('Shuffle digits to foil shoulder-surfers'),
              value: config.randomizeKeypad,
              onChanged: controller.setRandomizeKeypad,
            ),
            _section(context, 'Intruder detection'),
            SwitchListTile(
              secondary: const Icon(Icons.photo_camera_outlined),
              title: const Text('Capture intruder photos'),
              subtitle: Text(
                'After ${config.intruderThreshold} failed attempts, take a '
                'silent front-camera photo',
              ),
              value: config.intruderCaptureEnabled,
              onChanged: (value) =>
                  controller.setIntruderCapture(enabled: value),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_outlined),
              title: const Text('View intruder log'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(AppRoutes.intruder),
            ),
            _section(context, 'Advanced'),
            SwitchListTile(
              secondary: const Icon(Icons.warning_amber_outlined),
              title: const Text('Decoy cover'),
              subtitle: const Text(
                'Show a fake "app has stopped" dialog; long-press to unlock',
              ),
              value: config.fakeCoverEnabled,
              onChanged: controller.setFakeCover,
            ),
            ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: const Text('Backup & restore'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.backup),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.about),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.overline.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}
