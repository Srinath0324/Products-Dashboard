import 'package:flutter/foundation.dart';
import 'package:assets_dashboard/data/models/settings_model.dart';
import 'package:assets_dashboard/data/repositories/settings_repository.dart';

/// Provider for Settings state management
/// 
/// Manages app settings state and provides methods for updates
class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repository = SettingsRepository();

  SettingsModel _settings = SettingsModel.defaultSettings();
  bool _isLoading = false;
  String? _error;

  // Getters
  SettingsModel get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get assetCategories => _settings.assetCategories;
  List<String> get assetStatuses => _settings.assetStatuses;

  /// Load settings
  Future<void> loadSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _settings = await _repository.getSettings();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream settings (real-time updates)
  void streamSettings() {
    _repository.streamSettings().listen(
      (settings) {
        _settings = settings;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Update settings
  Future<bool> updateSettings(SettingsModel settings) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateSettings(settings);
      _settings = settings;
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

  /// Initialize default settings
  Future<void> initializeDefaultSettings() async {
    try {
      await _repository.initializeDefaultSettings();
      await loadSettings();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Update asset categories
  Future<bool> updateAssetCategories(List<String> categories) async {
    try {
      await _repository.updateAssetCategories(categories);
      await loadSettings();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update asset statuses
  Future<bool> updateAssetStatuses(List<String> statuses) async {
    try {
      await _repository.updateAssetStatuses(statuses);
      await loadSettings();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
