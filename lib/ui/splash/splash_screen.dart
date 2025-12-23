import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:istreet/providers/auth_provider.dart';
import 'package:istreet/ui/navigation/bottom_nav.dart';
import 'package:istreet/data/services/auth_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🔥 MISSING (MAIN FIX)
import 'package:istreet/providers/after_login/nav_mode_provider.dart';
import 'package:istreet/ui/navigation/navigation_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0, 0.6, curve: Curves.easeIn),
    );

    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _textOpacity = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _textController.forward();
    });

    // 🔑 LOGIN RESTORE
    Timer(const Duration(milliseconds: 2800), () async {
      if (!mounted) return;

      final isLoggedIn = await AuthStorage.isLoggedIn();
      final token = await AuthStorage.getToken();

      if (isLoggedIn && token != null) {
        ref.read(authProvider.notifier).state = ref
            .read(authProvider)
            .copyWith(isLoggedIn: true, token: token);
      }

      ref.read(navModeProvider.notifier).state = isLoggedIn
          ? AppNavMode.mystreet
          : AppNavMode.guest;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavigationScreen()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              FadeTransition(
                opacity: _logoOpacity,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: SvgPicture.asset(
                    "assets/images/istreetlogo.svg",
                    width: 150,
                    height: 150,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // TEXT
              FadeTransition(
                opacity: _textOpacity,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: const [
                      Text(
                        'iStreet',
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2563EB),
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Smart Market Intelligence',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: 64,
                        height: 4,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFF2563EB),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
