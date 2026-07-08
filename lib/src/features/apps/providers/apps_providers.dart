import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latchly/src/core/di.dart';
import 'package:latchly/src/core/interfaces/enforcement_bridge.dart';

/// The launchable apps installed on the device, loaded once from native.
final installedAppsProvider = FutureProvider<List<InstalledApp>>((ref) {
  return ref.watch(enforcementBridgeProvider).getInstalledApps();
});

/// The current search query in the app picker.
final appSearchQueryProvider = StateProvider<String>((_) => '');
