import 'package:flutter/material.dart';
import 'beranda_screen.dart';
import '../utils/app_colors.dart';

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
          pageBuilder: (_, __, ___) => const BerandaScreen(),
          transitionsBuilder: (_, animation, __, child) =>
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

  // ── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFCDE9FF),
              Color(0xFFE6F4FF),
              Color(0xFFF7FAFF),
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildBackgroundDecorations(),
            _buildContent(),
            _buildBottomTagline(),
          ],
        ),
      ),
    );
  }

  // ── Background Decorative Circles ───────────────────────────

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        _circle(top: -90, left: -90, size: 240, opacity: 0.18),
        _circle(top: 50, right: -50, size: 150, opacity: 0.14, isSecondary: true),
        _circle(top: 190, left: 16, size: 48, opacity: 0.12),
        _circle(bottom: -110, right: -70, size: 300, opacity: 0.13),
        _circle(bottom: 60, left: -70, size: 190, opacity: 0.15, isSecondary: true),
        _circle(top: 155, right: 72, size: 22, opacity: 0.25),
      ],
    );
  }

  Widget _circle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double opacity,
    bool isSecondary = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (isSecondary ? AppColors.secondary : AppColors.primary)
              .withOpacity(opacity),
        ),
      ),
    );
  }

  // ── Center Content ──────────────────────────────────────────

  Widget _buildContent() {
    return Center(
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
      width: 260,
      fit: BoxFit.contain,
    );
  }

  // ── Bottom tagline ──────────────────────────────────────────

  Widget _buildBottomTagline() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _textController,
        builder: (context, child) => Opacity(
          opacity: _textOpacity.value,
          child: child,
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Jelajahi keindahan Indonesia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
