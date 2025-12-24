import 'package:flutter/foundation.dart';
import 'package:assets_dashboard/data/models/asset_model.dart';
import 'package:assets_dashboard/data/repositories/asset_repository.dart';
import 'package:assets_dashboard/models/report_models.dart';

/// Provider for Reports and Analytics state management
/// 
/// Manages report data, calculations, and filtering
class ReportsProvider extends ChangeNotifier {
  final AssetRepository _repository = AssetRepository();

  List<AssetModel> _allAssets = [];
  List<AssetModel> _filteredAssets = [];
  bool _isLoading = false;
  String? _error;
  ReportFilters _filters = const ReportFilters();

  // Getters
  List<AssetModel> get assets => _filteredAssets.isEmpty && !_filters.hasFilters 
      ? _allAssets 
      : _filteredAssets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ReportFilters get filters => _filters;

  /// Load all assets and calculate reports
  Future<void> loadReportsData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allAssets = await _repository.getAllAssets();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream assets for real-time updates
  void streamReportsData() {
    _repository.streamAssets().listen(
      (assets) {
        _allAssets = assets;
        _applyFilters();
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Apply current filters to assets
  void _applyFilters() {
    _filteredAssets = _allAssets;

    // Date range filter
    if (_filters.startDate != null) {
      _filteredAssets = _filteredAssets
          .where((asset) => asset.date.isAfter(_filters.startDate!) || 
                           asset.date.isAtSameMomentAs(_filters.startDate!))
          .toList();
    }

    if (_filters.endDate != null) {
      _filteredAssets = _filteredAssets
          .where((asset) => asset.date.isBefore(_filters.endDate!) || 
                           asset.date.isAtSameMomentAs(_filters.endDate!))
          .toList();
    }

    // Category filter
    if (_filters.category != null && _filters.category!.isNotEmpty) {
      _filteredAssets = _filteredAssets
          .where((asset) => asset.category == _filters.category)
          .toList();
    }

    // Status filter
    if (_filters.status != null && _filters.status!.isNotEmpty) {
      _filteredAssets = _filteredAssets
          .where((asset) => asset.status == _filters.status)
          .toList();
    }

    // Condition filter
    if (_filters.condition != null && _filters.condition!.isNotEmpty) {
      _filteredAssets = _filteredAssets
          .where((asset) => asset.condition == _filters.condition)
          .toList();
    }
  }

  /// Set date range filter
  void setDateRange(DateTime? startDate, DateTime? endDate) {
    _filters = ReportFilters(
      startDate: startDate,
      endDate: endDate,
      category: _filters.category,
      status: _filters.status,
      condition: _filters.condition,
    );
    _applyFilters();
    notifyListeners();
  }

  /// Set category filter
  void setCategoryFilter(String? category) {
    _filters = ReportFilters(
      startDate: _filters.startDate,
      endDate: _filters.endDate,
      category: category,
      status: _filters.status,
      condition: _filters.condition,
    );
    _applyFilters();
    notifyListeners();
  }

  /// Set status filter
  void setStatusFilter(String? status) {
    _filters = ReportFilters(
      startDate: _filters.startDate,
      endDate: _filters.endDate,
      category: _filters.category,
      status: status,
      condition: _filters.condition,
    );
    _applyFilters();
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _filters = const ReportFilters();
    _applyFilters();
    notifyListeners();
  }

  /// Get asset value report
  AssetValueReport getAssetValueReport() {
    final currentAssets = assets;
    
    if (currentAssets.isEmpty) {
      return const AssetValueReport(
        totalValue: 0,
        averageValue: 0,
        totalAssets: 0,
        valueByCategory: {},
        topAssetsByValue: [],
      );
    }

    final totalValue = currentAssets.fold<double>(
      0.0,
      (sum, asset) => sum + asset.cost,
    );

    final averageValue = totalValue / currentAssets.length;

    // Calculate value by category
    final Map<String, double> valueByCategory = {};
    for (final asset in currentAssets) {
      valueByCategory[asset.category] = 
          (valueByCategory[asset.category] ?? 0) + asset.cost;
    }

    // Get top 5 assets by value
    final sortedAssets = List<AssetModel>.from(currentAssets)
      ..sort((a, b) => b.cost.compareTo(a.cost));
    
    final topAssets = sortedAssets.take(5).map((asset) => AssetValueItem(
      assetId: asset.assetId,
      name: asset.name,
      category: asset.category,
      value: asset.cost,
    )).toList();

    return AssetValueReport(
      totalValue: totalValue,
      averageValue: averageValue,
      totalAssets: currentAssets.length,
      valueByCategory: valueByCategory,
      topAssetsByValue: topAssets,
    );
  }

  /// Get asset distribution report
  AssetDistributionReport getDistributionReport() {
    final currentAssets = assets;

    if (currentAssets.isEmpty) {
      return const AssetDistributionReport(
        byStatus: {},
        byCategory: {},
        byCondition: {},
        assignmentRate: 0,
        assignedCount: 0,
        availableCount: 0,
      );
    }

    // Count by status
    final Map<String, int> byStatus = {};
    for (final asset in currentAssets) {
      byStatus[asset.status] = (byStatus[asset.status] ?? 0) + 1;
    }

    // Count by category
    final Map<String, int> byCategory = {};
    for (final asset in currentAssets) {
      byCategory[asset.category] = (byCategory[asset.category] ?? 0) + 1;
    }

    // Count by condition
    final Map<String, int> byCondition = {};
    for (final asset in currentAssets) {
      byCondition[asset.condition] = (byCondition[asset.condition] ?? 0) + 1;
    }

    // Calculate assignment metrics
    final assignedCount = currentAssets
        .where((asset) => asset.status.toLowerCase().contains('assigned'))
        .length;
    
    final availableCount = currentAssets
        .where((asset) => asset.status.toLowerCase().contains('available'))
        .length;

    final assignmentRate = currentAssets.isEmpty 
        ? 0.0 
        : (assignedCount / currentAssets.length) * 100;

    return AssetDistributionReport(
      byStatus: byStatus,
      byCategory: byCategory,
      byCondition: byCondition,
      assignmentRate: assignmentRate,
      assignedCount: assignedCount,
      availableCount: availableCount,
    );
  }

  /// Get warranty report
  WarrantyReport getWarrantyReport() {
    final currentAssets = assets;
    final now = DateTime.now();

    if (currentAssets.isEmpty) {
      return const WarrantyReport(
        expiredCount: 0,
        expiringSoon30Days: 0,
        expiringSoon60Days: 0,
        expiringSoon90Days: 0,
        activeWarranties: 0,
        expiringAssets: [],
      );
    }

    int expiredCount = 0;
    int expiringSoon30Days = 0;
    int expiringSoon60Days = 0;
    int expiringSoon90Days = 0;
    int activeWarranties = 0;
    final List<WarrantyItem> expiringAssets = [];

    for (final asset in currentAssets) {
      final daysRemaining = asset.warranty.difference(now).inDays;

      if (daysRemaining < 0) {
        expiredCount++;
      } else {
        activeWarranties++;
        
        if (daysRemaining <= 30) {
          expiringSoon30Days++;
          expiringAssets.add(WarrantyItem(
            assetId: asset.assetId,
            name: asset.name,
            warrantyDate: asset.warranty,
            daysRemaining: daysRemaining,
          ));
        } else if (daysRemaining <= 60) {
          expiringSoon60Days++;
        } else if (daysRemaining <= 90) {
          expiringSoon90Days++;
        }
      }
    }

    // Sort expiring assets by days remaining
    expiringAssets.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));

    return WarrantyReport(
      expiredCount: expiredCount,
      expiringSoon30Days: expiringSoon30Days,
      expiringSoon60Days: expiringSoon60Days,
      expiringSoon90Days: expiringSoon90Days,
      activeWarranties: activeWarranties,
      expiringAssets: expiringAssets,
    );
  }

  /// Get timeline data for asset acquisitions
  List<TimelineDataPoint> getAcquisitionTimeline({bool byMonth = true}) {
    final currentAssets = assets;

    if (currentAssets.isEmpty) {
      return [];
    }

    // Group assets by month or year
    final Map<String, int> grouped = {};

    for (final asset in currentAssets) {
      final key = byMonth
          ? '${asset.date.year}-${asset.date.month.toString().padLeft(2, '0')}'
          : '${asset.date.year}';
      grouped[key] = (grouped[key] ?? 0) + 1;
    }

    // Convert to timeline data points
    final points = grouped.entries.map((entry) {
      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final month = parts.length > 1 ? int.parse(parts[1]) : 1;
      
      return TimelineDataPoint(
        date: DateTime(year, month),
        value: entry.value.toDouble(),
        label: entry.key,
      );
    }).toList();

    // Sort by date
    points.sort((a, b) => a.date.compareTo(b.date));

    return points;
  }

  /// Get category breakdown with percentages
  List<CategoryBreakdown> getCategoryBreakdown() {
    final currentAssets = assets;

    if (currentAssets.isEmpty) {
      return [];
    }

    final Map<String, CategoryData> categoryData = {};
    final totalValue = currentAssets.fold<double>(0, (sum, asset) => sum + asset.cost);

    for (final asset in currentAssets) {
      if (!categoryData.containsKey(asset.category)) {
        categoryData[asset.category] = CategoryData(0, 0);
      }
      categoryData[asset.category]!.count++;
      categoryData[asset.category]!.totalValue += asset.cost;
    }

    final breakdowns = categoryData.entries.map((entry) {
      final percentage = totalValue > 0 
          ? (entry.value.totalValue / totalValue) * 100 
          : 0.0;
      
      return CategoryBreakdown(
        category: entry.key,
        count: entry.value.count,
        totalValue: entry.value.totalValue,
        percentage: percentage,
      );
    }).toList();

    // Sort by total value descending
    breakdowns.sort((a, b) => b.totalValue.compareTo(a.totalValue));

    return breakdowns;
  }

  /// Get recent activity (last 20 items)
  List<ActivityItem> getRecentActivity({int limit = 20}) {
    final currentAssets = List<AssetModel>.from(assets);

    // Sort by updatedAt descending
    currentAssets.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return currentAssets.take(limit).map((asset) {
      // Determine activity type based on timestamps
      String activityType = 'updated';
      String? details;

      final daysSinceCreation = DateTime.now().difference(asset.createdAt).inDays;
      if (daysSinceCreation <= 7) {
        activityType = 'created';
        details = 'New asset added';
      } else if (asset.status.toLowerCase().contains('assigned')) {
        activityType = 'assigned';
        details = 'Assigned to ${asset.assignedTo}';
      } else {
        activityType = 'status_change';
        details = 'Status: ${asset.status}';
      }

      return ActivityItem(
        assetId: asset.assetId,
        assetName: asset.name,
        activityType: activityType,
        timestamp: asset.updatedAt,
        details: details,
      );
    }).toList();
  }

  /// Get chart data for pie/donut charts
  List<ChartDataItem> getChartData(Map<String, int> data) {
    if (data.isEmpty) {
      return [];
    }

    final total = data.values.fold<int>(0, (sum, count) => sum + count);

    return data.entries.map((entry) {
      final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;
      return ChartDataItem(
        label: entry.key,
        value: percentage,
        count: entry.value,
      );
    }).toList();
  }

  /// Prepare export data as CSV string
  String exportAsCSV() {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('Asset ID,Name,Category,Status,Condition,Cost,Purchase Date,Warranty,Assigned To');
    
    // Data rows
    for (final asset in assets) {
      buffer.writeln(
        '${asset.assetId},${asset.name},${asset.category},${asset.status},'
        '${asset.condition},${asset.cost},${asset.date},${asset.warranty},${asset.assignedTo}'
      );
    }
    
    return buffer.toString();
  }
}

/// Helper class for category data aggregation
class CategoryData {
  int count;
  double totalValue;

  CategoryData(this.count, this.totalValue);
}
