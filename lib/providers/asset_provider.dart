import 'package:flutter/foundation.dart';
import 'package:assets_dashboard/data/models/asset_model.dart';
import 'package:assets_dashboard/data/repositories/asset_repository.dart';

/// Provider for Asset state management
/// 
/// Manages asset data state and provides methods for CRUD operations
class AssetProvider extends ChangeNotifier {
  final AssetRepository _repository = AssetRepository();

  List<AssetModel> _assets = [];
  List<AssetModel> _filteredAssets = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedStatus;

  // Getters
  List<AssetModel> get assets => _filteredAssets.isEmpty && _searchQuery.isEmpty && _selectedCategory == null && _selectedStatus == null
      ? _assets
      : _filteredAssets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get selectedStatus => _selectedStatus;

  /// Load all assets
  Future<void> loadAssets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _assets = await _repository.getAllAssets();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream assets (real-time updates)
  void streamAssets() {
    _repository.streamAssets().listen(
      (assets) {
        _assets = assets;
        _applyFilters();
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Add new asset
  Future<bool> addAsset(AssetModel asset) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.addAsset(asset);
      await loadAssets();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update asset
  Future<bool> updateAsset(String id, AssetModel asset) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateAsset(id, asset);
      await loadAssets();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete asset
  Future<bool> deleteAsset(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteAsset(id);
      await loadAssets();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Search assets by name
  void searchAssets(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Filter by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Filter by status
  void filterByStatus(String? status) {
    _selectedStatus = status;
    _applyFilters();
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedStatus = null;
    _applyFilters();
    notifyListeners();
  }

  /// Apply filters to assets list
  void _applyFilters() {
    _filteredAssets = _assets;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      _filteredAssets = _filteredAssets
          .where((asset) =>
              asset.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              asset.assetId.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty && _selectedCategory != 'Select One') {
      _filteredAssets = _filteredAssets
          .where((asset) => asset.category == _selectedCategory)
          .toList();
    }

    // Apply status filter
    if (_selectedStatus != null && _selectedStatus!.isNotEmpty) {
      _filteredAssets = _filteredAssets
          .where((asset) => asset.status == _selectedStatus)
          .toList();
    }
  }

  /// Get asset by ID
  AssetModel? getAssetById(String id) {
    try {
      return _assets.firstWhere((asset) => asset.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get assets count by status
  Map<String, int> getAssetCountByStatus() {
    final Map<String, int> statusCount = {};
    for (final asset in _assets) {
      statusCount[asset.status] = (statusCount[asset.status] ?? 0) + 1;
    }
    return statusCount;
  }

  /// Get total asset value
  double getTotalAssetValue() {
    return _assets.fold<double>(0.0, (total, asset) => total + asset.cost);
  }
}
