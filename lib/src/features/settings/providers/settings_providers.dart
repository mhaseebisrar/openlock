import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latchly/src/core/di.dart';

/// Whether the device can offer biometric unlock at all.
final biometricSupportedProvider = FutureProvider<bool>(
  (ref) => ref.watch(biometricServiceProvider).isSupported(),
);

/// Whether biometric unlock is currently enabled. Invalidate after toggling.
final biometricEnabledProvider = FutureProvider<bool>(
  (ref) => ref.watch(biometricServiceProvider).isEnabled(),
);
