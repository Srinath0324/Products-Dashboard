import 'package:flutter/foundation.dart';
import 'package:assets_dashboard/models/dashboard_stats.dart';
import 'package:assets_dashboard/data/repositories/asset_repository.dart';
import 'package:assets_dashboard/data/repositories/branch_repository.dart';

/// Provider for Dashboard state management
/// 
/// Manages dashboard statistics and analytics
class DashboardProvider extends ChangeNotifier {
  final AssetRepository _assetRepository = AssetRepository();
  final BranchRepository _branchRepository = BranchRepository();

  List<DashboardStats> _stats = [];
  bool _isLoading = false;
  String? _error;
  String _selectedBranch = 'All Branches';

  // Getters
  List<DashboardStats> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedBranch => _selectedBranch;

  /// Load dashboard statistics
  Future<void> loadDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final assets = await _assetRepository.getAllAssets();

      // Calculate statistics
      final totalAssets = assets.length;
      final assignedAssets = assets.where((a) => a.status == 'Assigned').length;
      final availableAssets = assets.where((a) => a.status == 'Available').length;
      final assetsOnRepair = assets.where((a) => a.status == 'Under Repair').length;

      // Calculate warranty expiring soon (within 30 days)
      final now = DateTime.now();
      final thirtyDaysFromNow = now.add(const Duration(days: 30));
      final warrantyExpiring = assets.where((asset) {
        return asset.warranty.isAfter(now) &&
            asset.warranty.isBefore(thirtyDaysFromNow);
      }).length;

      _stats = [
        DashboardStats(title: 'Total Asset', value: totalAssets),
        DashboardStats(title: 'Assigned Asset', value: assignedAssets),
        DashboardStats(title: 'Upcoming Warranty Expires', value: warrantyExpiring),
        DashboardStats(title: 'Available Asset', value: availableAssets),
        DashboardStats(title: 'Asset on Repair', value: assetsOnRepair),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set selected branch filter
  void setSelectedBranch(String branch) {
    _selectedBranch = branch;
    notifyListeners();
    // Reload stats with branch filter if needed
    loadDashboardStats();
  }

  /// Get branch names for dropdown
  Future<List<String>> getBranchNames() async {
    try {
      final branches = await _branchRepository.getAllBranches();
      final branchNames = branches.map((b) => b.branchName).toList();
      return ['All Branches', ...branchNames];
    } catch (e) {
      return ['All Branches'];
    }
  }
}
