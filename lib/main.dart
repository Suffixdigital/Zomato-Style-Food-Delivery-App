import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Assuming OnboardingScreen is in this path
import 'screens/onboarding_screen.dart'; //

/**If this path is incorrect, please adjust.

 * Initializes and runs the Flutter application.

 * This function serves as the primary entry point for the application.
 * It performs several critical setup tasks:
 * 1.  Ensures the Flutter widget binding is initialized, which is necessary for
 *     platform channel communication and other core Flutter functionalities
 *     before `runApp()` is called.
 * 2.  Configures the system UI to be transparent for both the status bar
 *     and navigation bar, allowing the application's content to extend
 *     into these areas. It also sets the icon brightness on these bars to dark
 *     for better visibility on light backgrounds.
 * 3.  Enables edge-to-edge display mode, which allows the app to draw under
 *     system bars for a more immersive user experience.
 * 4.  Wraps the root widget `MyApp` with a `ProviderScope` to enable state
 *     management via the Riverpod package throughout the application.

 * This setup aims to create a modern, immersive user interface from the very
 * start of the application lifecycle. */
void main() {
  // Ensures that the Flutter widget binding is initialized.
  // This is a mandatory step if you need to interact with the Flutter engine
  // or use plugins before `runApp()` is called (e.g., for platform-specific
  // setup or accessing device features early).
  WidgetsFlutterBinding.ensureInitialized();

  // Customizes the appearance of the system UI elements (status and navigation bars).
  // The goal is to make these bars transparent to allow app content to render
  // underneath, creating a seamless, edge-to-edge visual experience.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Makes the Android status bar transparent.
      statusBarColor: Colors.transparent,
      // Makes the Android navigation bar transparent.
      systemNavigationBarColor: Colors.transparent,
      // Sets the icons on the navigation bar (e.g., back, home, recent) to be dark.
      // Choose Brightness.light if your navigation bar background is dark.
      systemNavigationBarIconBrightness: Brightness.dark,
      // Sets the icons on the status bar (e.g., time, battery, Wi-Fi) to be dark.
      // Choose Brightness.light if your status bar background is dark.
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Instructs the system to allow the application to draw into the display cutout
  // areas and under the system bars (status bar and navigation bar).
  // `SystemUiMode.edgeToEdge` is preferred for creating immersive UIs.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Example for further UI customization:
  // If you need to programmatically hide or show the system navigation bar
  // after the initial setup (e.g., for a fullscreen video player or game),
  // you might use a controller or specific platform channel calls here or elsewhere.
  // Consider using packages or custom logic for more advanced control.
  // UiOverlayController.hideNavBar(); // Placeholder for potential future implementation

  // Starts the Flutter application by inflating the given widget and attaching
  // it to the screen.
  // `ProviderScope` is the root widget required by Riverpod for state management.
  // It makes all declared providers available to the widgets below it in the tree.
  runApp(const ProviderScope(child: MyApp()));
}

/// The root widget of this Flutter application.
///
/// `MyApp` is a [StatelessWidget] that sets up the high-level structure of the
/// application, including screen responsiveness, theming, and the initial screen.
/// It utilizes `ScreenUtilInit` for responsive UI sizing and `MaterialApp`
/// to define the application's core visual and navigational properties.
class MyApp extends StatelessWidget {
  /// Creates an instance of the main application widget.
  ///
  /// The [key] is passed to the superclass [StatelessWidget].
  const MyApp({super.key});

  /// Describes the part of the user interface represented by this widget.
  ///
  /// This method is called by the Flutter framework when this widget is
  /// inserted into the tree. It returns a widget tree that defines what
  /// this widget displays.
  ///
  /// The build process involves:
  /// 1.  Initializing `ScreenUtil` for responsive design, adapting UI elements
  ///     and text sizes based on the specified `designSize`.
  /// 2.  Returning a `MaterialApp` widget, which configures:
  ///     -   Theming (primary color swatch, background color, Material 3 usage).
  ///     -   Hiding the debug banner.
  ///     -   Setting the initial screen (`home`) of the application.
  ///
  /// Returns a [Widget] that represents the application's root UI.
  @override
  Widget build(BuildContext context) {
    // Initializes ScreenUtil to make the UI responsive across different screen sizes.
    // This should generally wrap your `MaterialApp` or the root of your application.
    return ScreenUtilInit(
      // The screen size (width, height) in logical pixels that the UI was designed for.
      // ScreenUtil will use this to scale UI elements and font sizes.
      // This example uses dimensions similar to an iPhone X/11 Pro.
      designSize: const Size(375, 812),
      // Whether to allow font sizes to adapt to screen size.
      minTextAdapt: true,
      // Whether to support splitting the screen for multi-window support.
      splitScreenMode: true,
      // The builder function receives the `context` and an optional `child` widget.
      // It's responsible for returning the widget tree that `ScreenUtilInit` manages.
      // The `child` argument passed to this builder is the `OnboardingScreen`
      // specified in `ScreenUtilInit`'s `child` parameter below.
      builder: (BuildContext buildContext, Widget? child) {
        // MaterialApp is a convenience widget that wraps a number of widgets
        // that are commonly required for Material Design applications.
        return MaterialApp(
          // Hides the "debug" banner shown in the top right corner in debug mode.
          debugShowCheckedModeBanner: false,
          // Defines the visual appearance of the application.
          theme: ThemeData(
            // Sets the primary color swatch for the application.
            // Colors.orange will generate different shades of orange for UI elements.
            primarySwatch: Colors.orange,
            // Sets the default background color for [Scaffold] widgets.
            scaffoldBackgroundColor: Colors.white,
            // Enables Material 3 design features and components.
            useMaterial3: true,
          ),
          // The widget to show when the application is started for the default route.
          // Here, it's the `child` provided by the `ScreenUtilInit.builder`,
          // which is the `OnboardingScreen`.
          home: child,
        );
      },
      // The widget that `ScreenUtilInit` makes available to its `builder` function.
      // This is typically the first screen or main layout of your application.
      child: const OnboardingScreen(),
    );
  }
}