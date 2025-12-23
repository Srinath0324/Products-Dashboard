import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assets_dashboard/data/models/asset_model.dart';
import 'package:assets_dashboard/data/services/firestore_service.dart';

/// Repository for Asset data operations
/// 
/// Handles all CRUD operations and queries for assets using Firestore
class AssetRepository {
  final FirestoreService _firestoreService = FirestoreService.instance;
  static const String _collectionPath = 'assets';

  /// Get all assets
  Future<List<AssetModel>> getAllAssets() async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      return snapshot.docs
          .map((doc) => AssetModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get assets: $e');
    }
  }

  /// Get asset by ID
  Future<AssetModel?> getAssetById(String id) async {
    try {
      final doc = await _firestoreService.getDocument(_collectionPath, id);
      if (doc.exists) {
        return AssetModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get asset: $e');
    }
  }

  /// Stream all assets (real-time updates)
  Stream<List<AssetModel>> streamAssets() {
    return _firestoreService.streamDocuments(_collectionPath).map(
          (snapshot) => snapshot.docs
              .map((doc) => AssetModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Stream asset by ID (real-time updates)
  Stream<AssetModel?> streamAssetById(String id) {
    return _firestoreService.streamDocument(_collectionPath, id).map(
          (doc) => doc.exists ? AssetModel.fromFirestore(doc) : null,
        );
  }

  /// Add new asset
  Future<String> addAsset(AssetModel asset) async {
    try {
      final docRef = await _firestoreService.addDocument(
        _collectionPath,
        asset.toJson(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add asset: $e');
    }
  }

  /// Update existing asset
  Future<void> updateAsset(String id, AssetModel asset) async {
    try {
      await _firestoreService.updateDocument(
        _collectionPath,
        id,
        asset.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update asset: $e');
    }
  }

  /// Delete asset
  Future<void> deleteAsset(String id) async {
    try {
      await _firestoreService.deleteDocument(_collectionPath, id);
    } catch (e) {
      throw Exception('Failed to delete asset: $e');
    }
  }

  /// Get assets by category
  Future<List<AssetModel>> getAssetsByCategory(String category) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'category', isEqualTo: category),
        ],
      );
      return snapshot.docs
          .map((doc) => AssetModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get assets by category: $e');
    }
  }

  /// Get assets by status
  Future<List<AssetModel>> getAssetsByStatus(String status) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'status', isEqualTo: status),
        ],
      );
      return snapshot.docs
          .map((doc) => AssetModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get assets by status: $e');
    }
  }

  /// Get assets assigned to a specific employee
  Future<List<AssetModel>> getAssetsByAssignee(String assignedTo) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'assignedTo', isEqualTo: assignedTo),
        ],
      );
      return snapshot.docs
          .map((doc) => AssetModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get assets by assignee: $e');
    }
  }

  /// Get assets with warranty expiring soon (within 30 days)
  Future<List<AssetModel>> getAssetsWithExpiringWarranty() async {
    try {
      final now = DateTime.now();
      final thirtyDaysFromNow = now.add(const Duration(days: 30));

      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(
            field: 'warranty',
            isGreaterThan: Timestamp.fromDate(now),
          ),
          QueryFilter(
            field: 'warranty',
            isLessThanOrEqualTo: Timestamp.fromDate(thirtyDaysFromNow),
          ),
        ],
      );
      return snapshot.docs
          .map((doc) => AssetModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get assets with expiring warranty: $e');
    }
  }

  /// Search assets by name
  Future<List<AssetModel>> searchAssetsByName(String searchTerm) async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      final assets = snapshot.docs
          .map((doc) => AssetModel.fromFirestore(doc))
          .toList();

      // Filter by name (case-insensitive)
      return assets
          .where((asset) =>
              asset.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search assets: $e');
    }
  }

  /// Get asset count by status
  Future<Map<String, int>> getAssetCountByStatus() async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      final assets = snapshot.docs
          .map((doc) => AssetModel.fromFirestore(doc))
          .toList();

      final Map<String, int> statusCount = {};
      for (final asset in assets) {
        statusCount[asset.status] = (statusCount[asset.status] ?? 0) + 1;
      }

      return statusCount;
    } catch (e) {
      throw Exception('Failed to get asset count by status: $e');
    }
  }

  /// Get total asset value
  Future<double> getTotalAssetValue() async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      final assets = snapshot.docs
          .map((doc) => AssetModel.fromFirestore(doc))
          .toList();

      return assets.fold<double>(0.0, (total, asset) => total + asset.cost);
    } catch (e) {
      throw Exception('Failed to get total asset value: $e');
    }
  }
}
