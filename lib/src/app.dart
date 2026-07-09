import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latchly/src/core/router/app_router.dart';
import 'package:latchly/src/core/theme.dart';

class LatchlyApp extends ConsumerWidget {
  const LatchlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'OpenLock',
      theme: AppTheme.build(Brightness.light, accent: latchlyAccent),
      darkTheme: AppTheme.build(Brightness.dark, accent: latchlyAccent),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
