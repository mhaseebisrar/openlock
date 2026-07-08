package dev.abdullah.latchly

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

/**
 * FlutterFragmentActivity is required by local_auth (biometric prompt). Hosts
 * the enforcement MethodChannel that bridges the Flutter app to the native
 * app-lock layer.
 */
class MainActivity : FlutterFragmentActivity() {

    private var enforcementPlugin: EnforcementPlugin? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        enforcementPlugin = EnforcementPlugin(this).also {
            it.register(flutterEngine.dartExecutor.binaryMessenger)
        }
    }

    override fun onDestroy() {
        enforcementPlugin?.dispose()
        enforcementPlugin = null
        super.onDestroy()
    }
}
