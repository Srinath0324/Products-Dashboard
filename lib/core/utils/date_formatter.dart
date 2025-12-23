import 'package:intl/intl.dart';

/// Utility class for date formatting operations
class DateFormatter {
  // Private constructor to prevent instantiation
  DateFormatter._();

  /// Format DateTime to string in MM/dd/yy format
  /// Example: 12/23/25
  static String formatDate(DateTime date) {
    return DateFormat('M/d/yy').format(date);
  }

  /// Format DateTime to string in MM/dd/yyyy format
  /// Example: 12/23/2025
  static String formatDateFull(DateTime date) {
    return DateFormat('M/d/yyyy').format(date);
  }

  /// Parse string date to DateTime
  /// Supports formats: M/d/yy, M/d/yyyy, MM/dd/yy, MM/dd/yyyy
  static DateTime? parseDate(String dateString) {
    try {
      // Try parsing with different formats
      final formats = [
        DateFormat('M/d/yy'),
        DateFormat('M/d/yyyy'),
        DateFormat('MM/dd/yy'),
        DateFormat('MM/dd/yyyy'),
      ];

      for (final format in formats) {
        try {
          return format.parse(dateString);
        } catch (_) {
          continue;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Format DateTime to display format (e.g., "December 23, 2025")
  static String formatDateDisplay(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  /// Get current date formatted
  static String getCurrentDate() {
    return formatDate(DateTime.now());
  }

  /// Check if warranty is expiring soon (within 30 days)
  static bool isWarrantyExpiringSoon(DateTime warrantyDate) {
    final now = DateTime.now();
    final difference = warrantyDate.difference(now).inDays;
    return difference > 0 && difference <= 30;
  }

  /// Check if warranty has expired
  static bool isWarrantyExpired(DateTime warrantyDate) {
    return warrantyDate.isBefore(DateTime.now());
  }
}
