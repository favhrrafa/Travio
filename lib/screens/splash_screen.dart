import 'package:flutter/material.dart';
import 'beranda_screen.dart';

/// Halaman Splash Screen.
/// Menampilkan logo dan tagline Travio dengan animasi,
/// lalu berpindah ke [BerandaScreen] setelah 2.8 detik.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────
  late final AnimationController _logoController;
  late final AnimationController _textController;

  // ── Animations ─────────────────────────────────────────────
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToHome();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Logo muncul lebih dulu, lalu teks menyusul.
    _logoController.forward().then((_) {
      if (mounted) _textController.forward();
    });
  }

  /// Pindah ke Beranda setelah 2.8 detik dengan transisi fade.
  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, anim, secAnim) => const BerandaScreen(),
          transitionsBuilder: (context, animation, secAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // ── Build 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Gambar Splash
            Image.asset(
              'assets/other/splash_background.jpg',
              fit: BoxFit.cover,
            ),
            // Gradient Overlay lembut untuk kontras dan estetika
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.35),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            _buildContent(),
            _buildBottomTagline(),
          ],
        ),
      ),
    );
  }

  // ── Center/Upper Content 

  Widget _buildContent() {
    return Align(
      alignment: const Alignment(0, -0.32),
      child: _buildAnimatedLogo(),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) => Opacity(
        opacity: _logoOpacity.value,
        child: Transform.scale(scale: _logoScale.value, child: child),
      ),
      child: _buildLogoWidget(),
    );
  }

  Widget _buildLogoWidget() {
    return Image.asset(
      'assets/icons/icon.png',
      width: 270,
      fit: BoxFit.contain,
    );
  }

  // ── Bottom Tagline

  Widget _buildBottomTagline() {
    return Positioned(
      bottom: 44,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _textController,
        builder: (context, child) => Opacity(
          opacity: _textOpacity.value,
          child: SlideTransition(
            position: _textSlide,
            child: child,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Jelajahi keindahan Indonesia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
