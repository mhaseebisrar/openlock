/// Secure-storage keys used by Latchly. Namespaced to avoid clashing with
/// sibling apps that share the core packages.
abstract final class LatchlyKeys {
  /// Random AES key that encrypts the app's config file at rest.
  static const String configKey = 'latchly_config_key';

  /// PIN verifier (PBKDF2 hash, base64) and its salt (base64). Mirrored into
  /// the native EncryptedSharedPreferences so LockActivity can verify offline.
  static const String pinHash = 'latchly_pin_hash';
  static const String pinSalt = 'latchly_pin_salt';

  static const String failedAttempts = 'latchly_failed_attempts';
  static const String lockoutUntil = 'latchly_lockout_until';

  static const String biometricEnabled = 'latchly_biometric_enabled';
  static const String onboardingSeen = 'latchly_onboarding_seen';

  static const List<String> all = [
    configKey,
    pinHash,
    pinSalt,
    failedAttempts,
    lockoutUntil,
    biometricEnabled,
    onboardingSeen,
  ];
}
