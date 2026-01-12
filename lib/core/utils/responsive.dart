import 'package:flutter/material.dart';

/// Utility class untuk responsive design
/// Mendukung berbagai ukuran layar termasuk Oppo A77s (720x1600, 20:9)
class ResponsiveUtils {
  ResponsiveUtils._();

  /// Breakpoints untuk berbagai ukuran layar
  static const double mobileSmall = 360; // Small phones
  static const double mobileMedium = 480; // Medium phones (Oppo A77s: 720px width)
  static const double mobileLarge = 600; // Large phones
  static const double tablet = 840; // Tablets
  static const double desktop = 1200; // Desktop

  /// Mendapatkan ukuran layar dari context
  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  /// Mendapatkan lebar layar
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  /// Mendapatkan tinggi layar
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  /// Mendapatkan density pixel ratio
  static double devicePixelRatio(BuildContext context) => MediaQuery.of(context).devicePixelRatio;

  /// Mendapatkan padding horizontal yang responsif
  static double horizontalPadding(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return 16; // Very small phones
    } else if (width < mobileMedium) {
      return 20; // Small-medium phones (Oppo A77s falls here)
    } else if (width < mobileLarge) {
      return 24; // Large phones
    } else if (width < tablet) {
      return 32; // Tablets
    } else {
      return 40; // Desktop
    }
  }

  /// Mendapatkan padding vertical yang responsif
  static double verticalPadding(BuildContext context) {
    final height = screenHeight(context);
    if (height < 700) {
      return 12; // Very short screens
    } else if (height < 900) {
      return 16; // Short screens
    } else if (height < 1200) {
      return 20; // Medium screens (Oppo A77s: 1600px height)
    } else {
      return 24; // Tall screens
    }
  }

  /// Mendapatkan spacing yang responsif
  static double spacing(BuildContext context, {double base = 16}) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return base * 0.75; // Smaller spacing for small phones
    } else if (width < mobileMedium) {
      return base * 0.9; // Slightly smaller for medium phones
    } else {
      return base; // Normal spacing
    }
  }

  /// Check jika layar adalah mobile kecil
  static bool isMobileSmall(BuildContext context) => screenWidth(context) < mobileSmall;

  /// Check jika layar adalah mobile medium (Oppo A77s)
  static bool isMobileMedium(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileSmall && width < mobileLarge;
  }

  /// Check jika layar adalah mobile besar
  static bool isMobileLarge(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileLarge && width < tablet;
  }

  /// Check jika layar adalah tablet
  static bool isTablet(BuildContext context) => screenWidth(context) >= tablet && screenWidth(context) < desktop;

  /// Check jika layar adalah desktop
  static bool isDesktop(BuildContext context) => screenWidth(context) >= desktop;

  /// Check jika layar adalah mobile (semua ukuran mobile)
  static bool isMobile(BuildContext context) => screenWidth(context) < tablet;

  /// Check jika layar adalah layar kecil (height < 800)
  static bool isShortScreen(BuildContext context) => screenHeight(context) < 800;

  /// Check jika layar adalah layar panjang (aspect ratio > 2.0, seperti Oppo A77s 20:9)
  static bool isLongScreen(BuildContext context) {
    final size = screenSize(context);
    return size.width / size.height < 0.5; // Aspect ratio > 2.0
  }

  /// Mendapatkan font size yang responsif
  static double fontSize(BuildContext context, double baseSize) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return baseSize * 0.9;
    } else if (width < mobileMedium) {
      return baseSize * 0.95;
    } else {
      return baseSize;
    }
  }

  /// Mendapatkan jumlah kolom untuk grid yang responsif
  static int gridColumns(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return 1;
    } else if (width < mobileMedium) {
      return 2; // Oppo A77s: 2 columns
    } else if (width < mobileLarge) {
      return 2;
    } else if (width < tablet) {
      return 3;
    } else {
      return 4;
    }
  }

  /// Mendapatkan max width untuk content container
  static double maxContentWidth(BuildContext context) {
    final width = screenWidth(context);
    if (width < tablet) {
      return double.infinity; // Full width on mobile
    } else if (width < desktop) {
      return 800; // Constrained on tablet
    } else {
      return 1200; // Constrained on desktop
    }
  }

  /// Mendapatkan icon size yang responsif
  static double iconSize(BuildContext context, {double base = 24}) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return base * 0.9;
    } else if (width < mobileMedium) {
      return base * 0.95;
    } else {
      return base;
    }
  }

  /// Mendapatkan border radius yang responsif
  static double borderRadius(BuildContext context, {double base = 24}) {
    final width = screenWidth(context);
    if (width < mobileSmall) {
      return base * 0.85;
    } else if (width < mobileMedium) {
      return base * 0.9;
    } else {
      return base;
    }
  }
}

/// Extension untuk memudahkan penggunaan responsive utils
extension ResponsiveExtension on BuildContext {
  /// Mendapatkan ukuran layar
  Size get screenSize => ResponsiveUtils.screenSize(this);

  /// Mendapatkan lebar layar
  double get screenWidth => ResponsiveUtils.screenWidth(this);

  /// Mendapatkan tinggi layar
  double get screenHeight => ResponsiveUtils.screenHeight(this);

  /// Mendapatkan padding horizontal yang responsif
  double get horizontalPadding => ResponsiveUtils.horizontalPadding(this);

  /// Mendapatkan padding vertical yang responsif
  double get verticalPadding => ResponsiveUtils.verticalPadding(this);

  /// Check jika layar adalah mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Check jika layar adalah mobile small
  bool get isMobileSmall => ResponsiveUtils.isMobileSmall(this);

  /// Check jika layar adalah mobile medium (Oppo A77s)
  bool get isMobileMedium => ResponsiveUtils.isMobileMedium(this);

  /// Check jika layar adalah tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Check jika layar adalah desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  /// Check jika layar adalah layar panjang (20:9)
  bool get isLongScreen => ResponsiveUtils.isLongScreen(this);

  /// Mendapatkan spacing yang responsif (multiplier * 8px)
  double spacing(double multiplier) => ResponsiveUtils.spacing(this, base: multiplier * 8);

  /// Mendapatkan font size yang responsif
  double fontSize(double baseSize) => ResponsiveUtils.fontSize(this, baseSize);

  /// Mendapatkan icon size yang responsif
  double iconSize({bool large = false}) {
    final base = large ? 28.0 : 24.0;
    return ResponsiveUtils.iconSize(this, base: base);
  }

  /// Mendapatkan border radius yang responsif
  double borderRadius(double multiplier) => ResponsiveUtils.borderRadius(this, base: multiplier * 8);
}






