import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/firebase_options.dart';
import 'package:smart_flutter/routes/app_routes.dart';
import 'package:smart_flutter/services/deep_link_service.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:smart_flutter/theme/app_theme.dart';
import 'package:smart_flutter/viewmodels/settings_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SharedPreferencesService.init();

  await Supabase.initialize(
    url: 'https://evqveotscootuaaruplk.supabase.co',
    authOptions: const FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce),
    realtimeClientOptions: const RealtimeClientOptions(logLevel: RealtimeLogLevel.info),

    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2cXZlb3RzY29vdHVhYXJ1cGxrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5MTg4NjQsImV4cCI6MjA2NjQ5NDg2NH0.HKn7JP4qvnMCQLW8guV4uzWrzv5ft_gBZo_HKeFDW3U',
  );

  runApp(DevicePreview(builder: (context) => const ProviderScope(child: MyApp()), isToolbarVisible: true, enabled: false));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(deepLinkServiceProvider).init();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final provider = ref.watch(settingsViewModelProvider);
    return ScreenUtilInit(
      designSize: Size(375, 812), // your design base size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(isTablet: isTablet),
          darkTheme: AppTheme.darkTheme(isTablet: isTablet),
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: ref.watch(appRouterProvider),
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, DefaultWidgetsLocalizations.delegate],
          supportedLocales: [Locale('en')],
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0), // ✅ lock text scaling
                devicePixelRatio: 1.0, // optional: lock density
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
