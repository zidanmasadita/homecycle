import 'package:flutter/material.dart';

/// Arah animasi slide untuk [SlidePageRoute].
enum SlideDirection {
  /// Slide dari kanan ke kiri (default — maju ke halaman baru).
  rightToLeft,

  /// Slide dari kiri ke kanan (biasanya untuk kembali).
  leftToRight,

  /// Slide dari bawah ke atas.
  bottomToTop,

  /// Slide dari atas ke bawah.
  topToBottom,
}

/// Custom [PageRouteBuilder] dengan animasi slide yang sepenuhnya dapat dikonfigurasi.
///
/// Pengganti drop-in untuk [MaterialPageRoute] dengan kontrol penuh atas:
/// - Arah slide ([direction])
/// - Durasi animasi ([duration] & [reverseDuration])
/// - Kurva animasi ([curve] & [reverseCurve])
/// - Apakah halaman lama tetap visible selama transisi ([maintainState])
/// - Apakah route bersifat fullscreen dialog ([fullscreenDialog])
/// - Callback saat animasi selesai ([onComplete])
///
/// ### Contoh pemakaian:
/// ```dart
/// // Push biasa — slide dari kanan
/// Navigator.push(
///   context,
///   SlidePageRoute(page: const DetailScreen()),
/// );
///
/// // Push dengan arah & kurva custom
/// Navigator.push(
///   context,
///   SlidePageRoute(
///     page: const ProfileScreen(),
///     direction: SlideDirection.bottomToTop,
///     curve: Curves.easeOutCubic,
///     duration: const Duration(milliseconds: 400),
///     onComplete: () => debugPrint('navigasi selesai'),
///   ),
/// );
///
/// // Sebagai named route factory
/// AppRoutes.detail: (ctx) => SlidePageRoute.builder(
///   page: const DetailScreen(),
/// ),
/// ```
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  /// Widget halaman tujuan.
  final Widget page;

  /// Arah animasi slide. Default: [SlideDirection.rightToLeft].
  final SlideDirection direction;

  /// Durasi animasi maju (push). Default: 300ms.
  final Duration duration;

  /// Durasi animasi balik (pop). Default: sama dengan [duration].
  final Duration? reverseDuration;

  /// Kurva animasi maju. Default: [Curves.easeOutCubic].
  final Curve curve;

  /// Kurva animasi balik. Default: sama dengan [curve].
  final Curve? reverseCurve;

  /// Seberapa besar overlap/parallax halaman lama.
  /// 0.0 = tidak bergerak, 1.0 = ikut slide penuh.
  /// Default: 0.25 (halaman lama bergeser sedikit, seperti iOS).
  final double backgroundParallaxFactor;

  /// Callback yang dipanggil tepat setelah animasi push selesai.
  final VoidCallback? onComplete;

  /// Callback yang dipanggil tepat setelah animasi pop selesai.
  final VoidCallback? onPopComplete;

  SlidePageRoute({
    required this.page,
    this.direction = SlideDirection.rightToLeft,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration,
    this.curve = Curves.easeOutCubic,
    this.reverseCurve,
    this.backgroundParallaxFactor = 0.25,
    this.onComplete,
    this.onPopComplete,
    super.fullscreenDialog,
    super.maintainState,
    super.settings,
    super.opaque,
    super.barrierDismissible,
  }) : super(
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration ?? duration,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final effectiveCurve = curve;
            final effectiveReverseCurve = reverseCurve ?? curve;

            final curvedAnim = CurvedAnimation(
              parent: animation,
              curve: effectiveCurve,
              reverseCurve: effectiveReverseCurve,
            );

            final beginOffset = _offsetForDirection(direction);

            // Halaman baru — slide masuk
            final incomingSlide = SlideTransition(
              position: Tween<Offset>(
                begin: beginOffset,
                end: Offset.zero,
              ).animate(curvedAnim),
              child: child,
            );

            // Parallax halaman lama (opsional)
            if (backgroundParallaxFactor == 0.0) return incomingSlide;

            final exitOffset = _reverseOffset(direction, backgroundParallaxFactor);
            return Stack(
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: exitOffset,
                  ).animate(curvedAnim),
                  child: const ColoredBox(
                    color: Colors.black12,
                    child: SizedBox.expand(),
                  ),
                ),
                incomingSlide,
              ],
            );
          },
        );

  @override
  void didComplete(T? result) {
    super.didComplete(result);
    if (animation?.status == AnimationStatus.dismissed) {
      onPopComplete?.call();
    } else {
      onComplete?.call();
    }
  }

  // ─────────────────────────────────────────────────────────
  // Internal helpers
  // ─────────────────────────────────────────────────────────

  static Offset _offsetForDirection(SlideDirection dir) {
    return switch (dir) {
      SlideDirection.rightToLeft => const Offset(1.0, 0.0),
      SlideDirection.leftToRight => const Offset(-1.0, 0.0),
      SlideDirection.bottomToTop => const Offset(0.0, 1.0),
      SlideDirection.topToBottom => const Offset(0.0, -1.0),
    };
  }

  static Offset _reverseOffset(SlideDirection dir, double factor) {
    return switch (dir) {
      SlideDirection.rightToLeft => Offset(-factor, 0.0),
      SlideDirection.leftToRight => Offset(factor, 0.0),
      SlideDirection.bottomToTop => Offset(0.0, -factor),
      SlideDirection.topToBottom => Offset(0.0, factor),
    };
  }
}

/// Extension factory — berguna untuk `onGenerateRoute` atau named route.
///
/// ```dart
/// onGenerateRoute: (settings) => SlidePageRouteFactory.withSettings(
///   settings: settings,
///   page: const MyScreen(),
/// ),
/// ```
class SlidePageRouteFactory {
  SlidePageRouteFactory._();

  static SlidePageRoute<T> withSettings<T>({
    required RouteSettings settings,
    required Widget page,
    SlideDirection direction = SlideDirection.rightToLeft,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
    double backgroundParallaxFactor = 0.25,
    VoidCallback? onComplete,
    VoidCallback? onPopComplete,
  }) {
    return SlidePageRoute<T>(
      page: page,
      direction: direction,
      duration: duration,
      curve: curve,
      backgroundParallaxFactor: backgroundParallaxFactor,
      onComplete: onComplete,
      onPopComplete: onPopComplete,
      settings: settings,
    );
  }
}
