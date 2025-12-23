import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assets_dashboard/data/models/vendor_model.dart';
import 'package:assets_dashboard/data/services/firestore_service.dart';

/// Repository for Vendor data operations
/// 
/// Handles all CRUD operations and queries for vendors using Firestore
class VendorRepository {
  final FirestoreService _firestoreService = FirestoreService.instance;
  static const String _collectionPath = 'vendors';

  /// Get all vendors
  Future<List<VendorModel>> getAllVendors() async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      return snapshot.docs
          .map((doc) => VendorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get vendors: $e');
    }
  }

  /// Get vendor by ID
  Future<VendorModel?> getVendorById(String id) async {
    try {
      final doc = await _firestoreService.getDocument(_collectionPath, id);
      if (doc.exists) {
        return VendorModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get vendor: $e');
    }
  }

  /// Stream all vendors (real-time updates)
  Stream<List<VendorModel>> streamVendors() {
    return _firestoreService.streamDocuments(_collectionPath).map(
          (snapshot) => snapshot.docs
              .map((doc) => VendorModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Add new vendor
  Future<String> addVendor(VendorModel vendor) async {
    try {
      final docRef = await _firestoreService.addDocument(
        _collectionPath,
        vendor.toJson(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add vendor: $e');
    }
  }

  /// Update existing vendor
  Future<void> updateVendor(String id, VendorModel vendor) async {
    try {
      await _firestoreService.updateDocument(
        _collectionPath,
        id,
        vendor.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update vendor: $e');
    }
  }

  /// Delete vendor
  Future<void> deleteVendor(String id) async {
    try {
      await _firestoreService.deleteDocument(_collectionPath, id);
    } catch (e) {
      throw Exception('Failed to delete vendor: $e');
    }
  }

  /// Get vendors by status
  Future<List<VendorModel>> getVendorsByStatus(String status) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'vendorStatus', isEqualTo: status),
        ],
      );
      return snapshot.docs
          .map((doc) => VendorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get vendors by status: $e');
    }
  }

  /// Get vendors by type
  Future<List<VendorModel>> getVendorsByType(String type) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'vendorType', isEqualTo: type),
        ],
      );
      return snapshot.docs
          .map((doc) => VendorModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get vendors by type: $e');
    }
  }

  /// Search vendors by name
  Future<List<VendorModel>> searchVendorsByName(String searchTerm) async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      final vendors = snapshot.docs
          .map((doc) => VendorModel.fromFirestore(doc))
          .toList();

      // Filter by name (case-insensitive)
      return vendors
          .where((vendor) =>
              vendor.vendorName.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search vendors: $e');
    }
  }
}
