import 'package:core_crypto/core_crypto.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latchly/src/core/clock.dart';
import 'package:latchly/src/core/interfaces/biometric_auth.dart';
import 'package:latchly/src/core/interfaces/config_file_store.dart';
import 'package:latchly/src/core/interfaces/enforcement_bridge.dart';
import 'package:latchly/src/core/interfaces/key_derivation.dart';
import 'package:latchly/src/core/services/method_channel_enforcement_bridge.dart';
import 'package:latchly/src/features/auth/services/biometric_service.dart';
import 'package:latchly/src/features/auth/services/pin_auth_service.dart';
import 'package:latchly/src/features/auth/services/pin_hasher.dart';
import 'package:latchly/src/features/backup/services/backup_codec.dart';
import 'package:latchly/src/features/enforcement/services/config_repository.dart';

/// Composition root. Tests override the leaf providers (storage, file store,
/// clock, biometrics, enforcement bridge) with in-memory fakes — no platform
/// channels.
final clockProvider = Provider<Clock>((_) => const SystemClock());

final secureStorageProvider = Provider<ISecureStorage>(
  (_) => const SecureStorageImpl(FlutterSecureStorage()),
);

final cipherServiceProvider = Provider<CipherService>(
  (_) => const CipherService(),
);

final keyDerivationProvider = Provider<IKeyDerivation>(
  (_) => const Argon2KeyDerivation(KeyDerivationService()),
);

final pinHasherProvider = Provider<PinHasher>((_) => const PinHasher());

final configFileStoreProvider = Provider<IConfigFileStore>(
  (_) => const DocumentsConfigFileStore(),
);

final enforcementBridgeProvider = Provider<IEnforcementBridge>(
  (_) => const MethodChannelEnforcementBridge(),
);

final biometricAuthProvider = Provider<IBiometricAuth>(
  (_) => LocalAuthBiometric(),
);

final pinAuthServiceProvider = Provider<PinAuthService>(
  (ref) => PinAuthService(
    storage: ref.watch(secureStorageProvider),
    hasher: ref.watch(pinHasherProvider),
    clock: ref.watch(clockProvider),
  ),
);

final biometricServiceProvider = Provider<BiometricService>(
  (ref) => BiometricService(
    storage: ref.watch(secureStorageProvider),
    biometric: ref.watch(biometricAuthProvider),
  ),
);

final configRepositoryProvider = Provider<ConfigRepository>(
  (ref) => ConfigRepository(
    storage: ref.watch(secureStorageProvider),
    cipher: ref.watch(cipherServiceProvider),
    fileStore: ref.watch(configFileStoreProvider),
  ),
);

final backupCodecProvider = Provider<BackupCodec>(
  (ref) => BackupCodec(
    keyDerivation: ref.watch(keyDerivationProvider),
    cipher: ref.watch(cipherServiceProvider),
    clock: ref.watch(clockProvider),
  ),
);
