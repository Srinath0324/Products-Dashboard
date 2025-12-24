/// Models for Reports and Analytics
/// 
/// Contains data structures for various report types and analytics

/// Asset value and financial analytics
class AssetValueReport {
  final double totalValue;
  final double averageValue;
  final int totalAssets;
  final Map<String, double> valueByCategory;
  final List<AssetValueItem> topAssetsByValue;

  const AssetValueReport({
    required this.totalValue,
    required this.averageValue,
    required this.totalAssets,
    required this.valueByCategory,
    required this.topAssetsByValue,
  });
}

/// Individual asset value item for top assets list
class AssetValueItem {
  final String assetId;
  final String name;
  final String category;
  final double value;

  const AssetValueItem({
    required this.assetId,
    required this.name,
    required this.category,
    required this.value,
  });
}

/// Asset distribution by status, category, and condition
class AssetDistributionReport {
  final Map<String, int> byStatus;
  final Map<String, int> byCategory;
  final Map<String, int> byCondition;
  final double assignmentRate;
  final int assignedCount;
  final int availableCount;

  const AssetDistributionReport({
    required this.byStatus,
    required this.byCategory,
    required this.byCondition,
    required this.assignmentRate,
    required this.assignedCount,
    required this.availableCount,
  });
}

/// Warranty tracking and expiration data
class WarrantyReport {
  final int expiredCount;
  final int expiringSoon30Days;
  final int expiringSoon60Days;
  final int expiringSoon90Days;
  final int activeWarranties;
  final List<WarrantyItem> expiringAssets;

  const WarrantyReport({
    required this.expiredCount,
    required this.expiringSoon30Days,
    required this.expiringSoon60Days,
    required this.expiringSoon90Days,
    required this.activeWarranties,
    required this.expiringAssets,
  });
}

/// Individual warranty item
class WarrantyItem {
  final String assetId;
  final String name;
  final DateTime warrantyDate;
  final int daysRemaining;

  const WarrantyItem({
    required this.assetId,
    required this.name,
    required this.warrantyDate,
    required this.daysRemaining,
  });
}

/// Timeline data point for charts
class TimelineDataPoint {
  final DateTime date;
  final double value;
  final String label;

  const TimelineDataPoint({
    required this.date,
    required this.value,
    required this.label,
  });
}

/// Category breakdown with count and value
class CategoryBreakdown {
  final String category;
  final int count;
  final double totalValue;
  final double percentage;

  const CategoryBreakdown({
    required this.category,
    required this.count,
    required this.totalValue,
    required this.percentage,
  });
}

/// Recent activity item
class ActivityItem {
  final String assetId;
  final String assetName;
  final String activityType; // 'created', 'updated', 'assigned', 'status_change'
  final DateTime timestamp;
  final String? details;

  const ActivityItem({
    required this.assetId,
    required this.assetName,
    required this.activityType,
    required this.timestamp,
    this.details,
  });
}

/// Report filters state
class ReportFilters {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? category;
  final String? status;
  final String? condition;

  const ReportFilters({
    this.startDate,
    this.endDate,
    this.category,
    this.status,
    this.condition,
  });

  ReportFilters copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? status,
    String? condition,
  }) {
    return ReportFilters(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
      status: status ?? this.status,
      condition: condition ?? this.condition,
    );
  }

  bool get hasFilters =>
      startDate != null ||
      endDate != null ||
      category != null ||
      status != null ||
      condition != null;

  void clear() {
    // This will be handled by the provider
  }
}

/// Chart data for pie/donut charts
class ChartDataItem {
  final String label;
  final double value;
  final int count;

  const ChartDataItem({
    required this.label,
    required this.value,
    required this.count,
  });
}
