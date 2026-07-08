import 'package:core_theme/core_theme.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latchly/src/core/interfaces/enforcement_bridge.dart';
import 'package:latchly/src/features/apps/providers/apps_providers.dart';
import 'package:latchly/src/features/apps/services/app_list_filter.dart';
import 'package:latchly/src/features/enforcement/models/lock_config.dart';
import 'package:latchly/src/features/enforcement/providers/config_providers.dart';

class AppPickerScreen extends ConsumerWidget {
  const AppPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(installedAppsProvider);
    final configAsync = ref.watch(configControllerProvider);
    final query = ref.watch(appSearchQueryProvider);
    final config = configAsync.valueOrNull ?? LockConfig.empty;

    return Scaffold(
      appBar: AppBar(title: const Text('Locked apps')),
      body: SafeArea(
        child: appsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const VaultEmptyState(
            icon: Icons.error_outline,
            message: 'Could not load installed apps.',
          ),
          data: (apps) {
            final visible = AppListFilter.apply(
              apps: apps,
              lockedPackages: config.lockedPackages,
              query: query,
            );
            final lockedCount = AppListFilter.lockedCount(
              apps: apps,
              lockedPackages: config.lockedPackages,
            );
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: TextField(
                    onChanged: (value) =>
                        ref.read(appSearchQueryProvider.notifier).state = value,
                    decoration: const InputDecoration(
                      hintText: 'Search apps',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                _LockNewAppsTile(config: config),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$lockedCount locked',
                      style: AppTextStyles.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: visible.isEmpty
                      ? const VaultEmptyState(
                          icon: Icons.apps_outlined,
                          message: 'No apps match your search.',
                        )
                      : ListView.builder(
                          itemCount: visible.length,
                          itemBuilder: (context, index) {
                            final app = visible[index];
                            return _AppTile(
                              app: app,
                              locked: config.lockedPackages
                                  .contains(app.packageName),
                              onToggle: () => ref
                                  .read(configControllerProvider.notifier)
                                  .toggleApp(app.packageName),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LockNewAppsTile extends ConsumerWidget {
  const _LockNewAppsTile({required this.config});

  final LockConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      value: config.lockNewApps,
      onChanged: (value) =>
          ref.read(configControllerProvider.notifier).setLockNewApps(value),
      secondary: const Icon(Icons.new_releases_outlined),
      title: const Text('Lock newly installed apps'),
      subtitle: const Text('Automatically guard apps you install later'),
    );
  }
}

class _AppTile extends StatelessWidget {
  const _AppTile({
    required this.app,
    required this.locked,
    required this.onToggle,
  });

  final InstalledApp app;
  final bool locked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SwitchListTile(
      value: locked,
      onChanged: (_) => onToggle(),
      secondary: SizedBox(
        width: 40,
        height: 40,
        child: app.icon != null
            ? Image.memory(app.icon!, gaplessPlayback: true)
            : Icon(Icons.android, color: scheme.onSurfaceVariant),
      ),
      title: Text(app.label, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        app.packageName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}
