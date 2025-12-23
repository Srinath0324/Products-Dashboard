import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assets_dashboard/data/models/settings_model.dart';
import 'package:assets_dashboard/data/services/firestore_service.dart';

/// Repository for Settings data operations
/// 
/// Handles settings CRUD operations using Firestore
class SettingsRepository {
  final FirestoreService _firestoreService = FirestoreService.instance;
  static const String _collectionPath = 'settings';
  static const String _documentId = 'app_settings';

  /// Get app settings
  Future<SettingsModel> getSettings() async {
    try {
      final doc = await _firestoreService.getDocument(_collectionPath, _documentId);
      if (doc.exists) {
        return SettingsModel.fromFirestore(doc);
      } else {
        // Return default settings if not found
        return SettingsModel.defaultSettings();
      }
    } catch (e) {
      throw Exception('Failed to get settings: $e');
    }
  }

  /// Stream app settings (real-time updates)
  Stream<SettingsModel> streamSettings() {
    return _firestoreService.streamDocument(_collectionPath, _documentId).map(
          (doc) => doc.exists
              ? SettingsModel.fromFirestore(doc)
              : SettingsModel.defaultSettings(),
        );
  }

  /// Update app settings
  Future<void> updateSettings(SettingsModel settings) async {
    try {
      await _firestoreService.setDocument(
        _collectionPath,
        _documentId,
        settings.toJson(),
        merge: true,
      );
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  /// Initialize default settings
  Future<void> initializeDefaultSettings() async {
    try {
      final doc = await _firestoreService.getDocument(_collectionPath, _documentId);
      if (!doc.exists) {
        final defaultSettings = SettingsModel.defaultSettings();
        await _firestoreService.setDocument(
          _collectionPath,
          _documentId,
          defaultSettings.toJson(),
        );
      }
    } catch (e) {
      throw Exception('Failed to initialize default settings: $e');
    }
  }

  /// Update asset categories
  Future<void> updateAssetCategories(List<String> categories) async {
    try {
      await _firestoreService.updateDocument(
        _collectionPath,
        _documentId,
        {'assetCategories': categories},
      );
    } catch (e) {
      throw Exception('Failed to update asset categories: $e');
    }
  }

  /// Update asset statuses
  Future<void> updateAssetStatuses(List<String> statuses) async {
    try {
      await _firestoreService.updateDocument(
        _collectionPath,
        _documentId,
        {'assetStatuses': statuses},
      );
    } catch (e) {
      throw Exception('Failed to update asset statuses: $e');
    }
  }
}
