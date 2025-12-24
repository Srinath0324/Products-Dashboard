import 'package:intl/intl.dart';

/// Utility class for date formatting operations
class DateFormatter {

  DateFormatter._();


  static String formatDate(DateTime date) {
    return DateFormat('M/d/yy').format(date);
  }


  static String formatDateFull(DateTime date) {
    return DateFormat('M/d/yyyy').format(date);
  }

  /// Parse string date to DateTime
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

  /// Format DateTime to display format
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
