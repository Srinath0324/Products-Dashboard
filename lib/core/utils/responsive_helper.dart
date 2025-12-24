import 'package:flutter/material.dart';

/// Responsive utility helper for managing breakpoints and responsive values
class ResponsiveHelper {
  // Breakpoint constants
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  /// Check if current screen is mobile (< 600px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet (600px - 1024px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if current screen is desktop (>= 1024px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Get responsive padding based on screen size
  static double getPadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  /// Get responsive spacing based on screen size
  static double getSpacing(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  /// Get responsive card spacing
  static double getCardSpacing(BuildContext context) {
    if (isMobile(context)) return 12.0;
    return 16.0;
  }

  /// Get responsive title font size
  static double getTitleFontSize(BuildContext context) {
    if (isMobile(context)) return 24.0;
    return 32.0;
  }

  /// Get responsive chart height
  static double getChartHeight(BuildContext context, {double defaultHeight = 350}) {
    if (isMobile(context)) return defaultHeight * 0.7; // 70% of default
    if (isTablet(context)) return defaultHeight * 0.85; // 85% of default
    return defaultHeight;
  }

  /// Get responsive chart size for pie charts
  static double getChartSize(BuildContext context) {
    if (isMobile(context)) return 150.0;
    if (isTablet(context)) return 180.0;
    return 200.0;
  }

  /// Get column count for grid layouts
  static int getColumnCount(BuildContext context, {int maxColumns = 3}) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return maxColumns > 2 ? 2 : maxColumns;
    return maxColumns;
  }

  /// Get responsive card width for wrapping layouts
  static double getCardWidth(BuildContext context, int columns) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = getPadding(context);
    final spacing = getCardSpacing(context);
    
    // Calculate available width
    final availableWidth = screenWidth - (padding * 2);
    
    // Calculate width per card
    final totalSpacing = spacing * (columns - 1);
    return (availableWidth - totalSpacing) / columns;
  }

  /// Get responsive font size for chart labels
  static double getChartLabelFontSize(BuildContext context) {
    if (isMobile(context)) return 9.0;
    return 10.0;
  }

  /// Get responsive bar width for bar charts
  static double getBarWidth(BuildContext context) {
    if (isMobile(context)) return 16.0;
    return 20.0;
  }

  /// Get responsive reserved size for chart axes
  static double getAxisReservedSize(BuildContext context, {double defaultSize = 40}) {
    if (isMobile(context)) return defaultSize * 0.8;
    return defaultSize;
  }

  /// Check if screen is very small (< 400px)
  static bool isVerySmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 400;
  }

  /// Get responsive card padding
  static EdgeInsets getCardPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(12);
    return const EdgeInsets.all(16);
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context, {double defaultSize = 32}) {
    if (isMobile(context)) return defaultSize * 0.85;
    return defaultSize;
  }
}
