import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/views/widgets/Style9BottomNavBar.dart';

class BottomTabShell extends ConsumerStatefulWidget {
  final Widget child;

  const BottomTabShell({super.key, required this.child});

  @override
  ConsumerState<BottomTabShell> createState() => _BottomTabShellState();
}

class _BottomTabShellState extends ConsumerState<BottomTabShell> {
  DateTime? lastBackPressTime;

  final tabs = ['/home', '/cart', '/chat', '/profile'];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(tabIndexProvider);

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          ref.read(tabIndexProvider.notifier).state = 0;
          context.go(tabs[0]);
          return false;
        }

        final now = DateTime.now();
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
          lastBackPressTime = now;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press back again to exit')),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: Style9BottomNavBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(tabIndexProvider.notifier).state = index;
            context.go(tabs[index]);
          },
          items: [
            _navBarItem('home.svg', 'Home', currentIndex == 0),
            _navBarItem('cart.svg', 'Cart', currentIndex == 1),
            _navBarItem('chat.svg', 'Chat', currentIndex == 2),
            _navBarItem('profile.svg', 'Profile', currentIndex == 3),
          ],
        ),
      ),
    );
  }

  NavBarItem _navBarItem(String asset, String title, bool isActive) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return NavBarItem(
      icon: SvgPicture.asset(
        'assets/icons/$asset',
        colorFilter: ColorFilter.mode(
          isActive ? context.colors.primary : context.colors.defaultGray878787,
          BlendMode.srcIn,
        ),
      ),
      title: title,
    );
  }
}
