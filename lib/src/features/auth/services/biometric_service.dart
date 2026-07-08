import 'package:core_storage/core_storage.dart';
import 'package:latchly/src/core/interfaces/biometric_auth.dart';
import 'package:latchly/src/core/storage_keys.dart';

/// Optional biometric unlock for opening the Latchly app itself. The PIN is
/// always the source of truth (and is what the native LockActivity uses);
/// biometrics are only a convenience gate here, so no key material is stored —
/// a successful prompt simply grants entry.
final class BiometricService {
  BiometricService({
    required ISecureStorage storage,
    required IBiometricAuth biometric,
  })  : _storage = storage,
        _biometric = biometric;

  final ISecureStorage _storage;
  final IBiometricAuth _biometric;

  Future<bool> isSupported() => _biometric.isAvailable();

  Future<bool> isEnabled() async =>
      await _storage.read(key: LatchlyKeys.biometricEnabled) == 'true';

  Future<bool> enable() async {
    if (!await _biometric.isAvailable()) return false;
    final ok = await _biometric.authenticate(
      reason: 'Confirm to enable fingerprint unlock',
    );
    if (!ok) return false;
    await _storage.write(key: LatchlyKeys.biometricEnabled, value: 'true');
    return true;
  }

  Future<void> disable() => _storage.delete(key: LatchlyKeys.biometricEnabled);

  /// Shows the biometric prompt. Returns true on success.
  Future<bool> authenticate() async {
    if (!await isEnabled()) return false;
    return _biometric.authenticate(reason: 'Unlock Latchly');
  }
}
