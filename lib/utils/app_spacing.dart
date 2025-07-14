// lib/utils/app_spacing.dart

import 'package:flutter/material.dart';

class AppSpacing {
  // Base spacing unit
  static const double _baseUnit = 4.0;

  // Spacing values
  static const double xs = _baseUnit; // 4
  static const double sm = _baseUnit * 2; // 8
  static const double md = _baseUnit * 3; // 12
  static const double lg = _baseUnit * 4; // 16
  static const double xl = _baseUnit * 5; // 20
  static const double xxl = _baseUnit * 6; // 24
  static const double xxxl = _baseUnit * 8; // 32
  static const double huge = _baseUnit * 12; // 48
  static const double massive = _baseUnit * 16; // 64

  // Semantic spacing
  static const double cardPadding = lg; // 16
  static const double screenPadding = xl; // 20
  static const double sectionSpacing = xxxl; // 32
  static const double elementSpacing = md; // 12
  static const double listItemSpacing = sm; // 8

  // Border radius values
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;
  static const double radiusXxxl = 24.0;
  static const double radiusRound = 999.0;

  // Shadow elevation values
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation3 = 3.0;
  static const double elevation4 = 4.0;
  static const double elevation6 = 6.0;
  static const double elevation8 = 8.0;
  static const double elevation12 = 12.0;
  static const double elevation16 = 16.0;
  static const double elevation24 = 24.0;

  // Component specific spacing
  static const double buttonHeight = 48.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonHeightSmall = 40.0;

  static const double textFieldHeight = 48.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;
  static const double tabBarHeight = 48.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Layout breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Helper methods for EdgeInsets
  static EdgeInsets all(double value) => EdgeInsets.all(value);
  static EdgeInsets symmetric({double vertical = 0, double horizontal = 0}) =>
      EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  // Common padding presets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);
  static const EdgeInsets paddingXxxl = EdgeInsets.all(xxxl);

  static const EdgeInsets paddingHorizontalSm =
      EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl =
      EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl =
      EdgeInsets.symmetric(vertical: xl);

  // Screen padding presets
  static const EdgeInsets screenPaddingAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets screenPaddingHorizontal =
      EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenPaddingVertical =
      EdgeInsets.symmetric(vertical: screenPadding);

  // Card padding presets
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(cardPadding);
  static const EdgeInsets cardPaddingHorizontal =
      EdgeInsets.symmetric(horizontal: cardPadding);
  static const EdgeInsets cardPaddingVertical =
      EdgeInsets.symmetric(vertical: cardPadding);

  // Helper methods for SizedBox
  static Widget verticalSpace(double height) => SizedBox(height: height);
  static Widget horizontalSpace(double width) => SizedBox(width: width);

  // Common spacing widgets
  static const Widget verticalSpaceXs = SizedBox(height: xs);
  static const Widget verticalSpaceSm = SizedBox(height: sm);
  static const Widget verticalSpaceMd = SizedBox(height: md);
  static const Widget verticalSpaceLg = SizedBox(height: lg);
  static const Widget verticalSpaceXl = SizedBox(height: xl);
  static const Widget verticalSpaceXxl = SizedBox(height: xxl);
  static const Widget verticalSpaceXxxl = SizedBox(height: xxxl);

  static const Widget horizontalSpaceXs = SizedBox(width: xs);
  static const Widget horizontalSpaceSm = SizedBox(width: sm);
  static const Widget horizontalSpaceMd = SizedBox(width: md);
  static const Widget horizontalSpaceLg = SizedBox(width: lg);
  static const Widget horizontalSpaceXl = SizedBox(width: xl);
  static const Widget horizontalSpaceXxl = SizedBox(width: xxl);
  static const Widget horizontalSpaceXxxl = SizedBox(width: xxxl);

  // Helper method for responsive spacing
  static double responsive(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopBreakpoint && desktop != null) return desktop;
    if (width >= tabletBreakpoint && tablet != null) return tablet;
    return mobile;
  }
}
