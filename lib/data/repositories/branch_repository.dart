import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assets_dashboard/data/models/branch_model.dart';
import 'package:assets_dashboard/data/services/firestore_service.dart';

/// Repository for Branch data operations
/// 
/// Handles all CRUD operations and queries for branches using Firestore
class BranchRepository {
  final FirestoreService _firestoreService = FirestoreService.instance;
  static const String _collectionPath = 'branches';

  /// Get all branches
  Future<List<BranchModel>> getAllBranches() async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      return snapshot.docs
          .map((doc) => BranchModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get branches: $e');
    }
  }

  /// Get branch by ID
  Future<BranchModel?> getBranchById(String id) async {
    try {
      final doc = await _firestoreService.getDocument(_collectionPath, id);
      if (doc.exists) {
        return BranchModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get branch: $e');
    }
  }

  /// Stream all branches (real-time updates)
  Stream<List<BranchModel>> streamBranches() {
    return _firestoreService.streamDocuments(_collectionPath).map(
          (snapshot) => snapshot.docs
              .map((doc) => BranchModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Add new branch
  Future<String> addBranch(BranchModel branch) async {
    try {
      final docRef = await _firestoreService.addDocument(
        _collectionPath,
        branch.toJson(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add branch: $e');
    }
  }

  /// Update existing branch
  Future<void> updateBranch(String id, BranchModel branch) async {
    try {
      await _firestoreService.updateDocument(
        _collectionPath,
        id,
        branch.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update branch: $e');
    }
  }

  /// Delete branch
  Future<void> deleteBranch(String id) async {
    try {
      await _firestoreService.deleteDocument(_collectionPath, id);
    } catch (e) {
      throw Exception('Failed to delete branch: $e');
    }
  }

  /// Get branches by status
  Future<List<BranchModel>> getBranchesByStatus(String status) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'status', isEqualTo: status),
        ],
      );
      return snapshot.docs
          .map((doc) => BranchModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get branches by status: $e');
    }
  }

  /// Get branches by country
  Future<List<BranchModel>> getBranchesByCountry(String country) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'branchCountry', isEqualTo: country),
        ],
      );
      return snapshot.docs
          .map((doc) => BranchModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get branches by country: $e');
    }
  }

  /// Search branches by name
  Future<List<BranchModel>> searchBranchesByName(String searchTerm) async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      final branches = snapshot.docs
          .map((doc) => BranchModel.fromFirestore(doc))
          .toList();

      // Filter by name (case-insensitive)
      return branches
          .where((branch) =>
              branch.branchName.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search branches: $e');
    }
  }
}
