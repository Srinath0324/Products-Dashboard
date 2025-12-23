import 'package:cloud_firestore/cloud_firestore.dart';

/// Base Firestore service providing common database operations
/// 
/// This service provides generic CRUD operations for Firestore collections
/// and can be extended by specific repository classes.
class FirestoreService {
  // Singleton pattern
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  /// Get Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get Firestore instance
  FirebaseFirestore get firestore => _firestore;

  /// Get a collection reference
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  /// Get a document reference
  DocumentReference<Map<String, dynamic>> document(String path) {
    return _firestore.doc(path);
  }

  /// Add a document to a collection
  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    try {
      // Add timestamps
      final timestamp = FieldValue.serverTimestamp();
      data['createdAt'] = timestamp;
      data['updatedAt'] = timestamp;

      return await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      throw Exception('Failed to add document: $e');
    }
  }

  /// Set a document in a collection (with custom ID)
  Future<void> setDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    try {
      // Add timestamps
      final timestamp = FieldValue.serverTimestamp();
      if (!data.containsKey('createdAt')) {
        data['createdAt'] = timestamp;
      }
      data['updatedAt'] = timestamp;

      await _firestore
          .collection(collectionPath)
          .doc(documentId)
          .set(data, SetOptions(merge: merge));
    } catch (e) {
      throw Exception('Failed to set document: $e');
    }
  }

  /// Update a document
  Future<void> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      // Add update timestamp
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection(collectionPath)
          .doc(documentId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  /// Delete a document
  Future<void> deleteDocument(
    String collectionPath,
    String documentId,
  ) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  /// Get a single document
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collectionPath,
    String documentId,
  ) async {
    try {
      return await _firestore.collection(collectionPath).doc(documentId).get();
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  /// Get all documents from a collection
  Future<QuerySnapshot<Map<String, dynamic>>> getDocuments(
    String collectionPath,
  ) async {
    try {
      return await _firestore.collection(collectionPath).get();
    } catch (e) {
      throw Exception('Failed to get documents: $e');
    }
  }

  /// Stream a single document
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(
    String collectionPath,
    String documentId,
  ) {
    return _firestore.collection(collectionPath).doc(documentId).snapshots();
  }

  /// Stream all documents from a collection
  Stream<QuerySnapshot<Map<String, dynamic>>> streamDocuments(
    String collectionPath,
  ) {
    return _firestore.collection(collectionPath).snapshots();
  }

  /// Query documents with filters
  Future<QuerySnapshot<Map<String, dynamic>>> queryDocuments(
    String collectionPath, {
    List<QueryFilter>? filters,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

      // Apply filters
      if (filters != null) {
        for (final filter in filters) {
          query = query.where(
            filter.field,
            isEqualTo: filter.isEqualTo,
            isNotEqualTo: filter.isNotEqualTo,
            isLessThan: filter.isLessThan,
            isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
            isGreaterThan: filter.isGreaterThan,
            isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
            arrayContains: filter.arrayContains,
            arrayContainsAny: filter.arrayContainsAny,
            whereIn: filter.whereIn,
            whereNotIn: filter.whereNotIn,
            isNull: filter.isNull,
          );
        }
      }

      // Apply ordering
      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      return await query.get();
    } catch (e) {
      throw Exception('Failed to query documents: $e');
    }
  }

  /// Stream documents with filters
  Stream<QuerySnapshot<Map<String, dynamic>>> streamQueryDocuments(
    String collectionPath, {
    List<QueryFilter>? filters,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

    // Apply filters
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(
          filter.field,
          isEqualTo: filter.isEqualTo,
          isNotEqualTo: filter.isNotEqualTo,
          isLessThan: filter.isLessThan,
          isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
          isGreaterThan: filter.isGreaterThan,
          isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
          arrayContains: filter.arrayContains,
          arrayContainsAny: filter.arrayContainsAny,
          whereIn: filter.whereIn,
          whereNotIn: filter.whereNotIn,
          isNull: filter.isNull,
        );
      }
    }

    // Apply ordering
    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }

    // Apply limit
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots();
  }

  /// Batch write operations
  WriteBatch batch() {
    return _firestore.batch();
  }

  /// Run a transaction
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler,
  ) async {
    return await _firestore.runTransaction(transactionHandler);
  }
}

/// Query filter class for building Firestore queries
class QueryFilter {
  final String field;
  final Object? isEqualTo;
  final Object? isNotEqualTo;
  final Object? isLessThan;
  final Object? isLessThanOrEqualTo;
  final Object? isGreaterThan;
  final Object? isGreaterThanOrEqualTo;
  final Object? arrayContains;
  final List<Object?>? arrayContainsAny;
  final List<Object?>? whereIn;
  final List<Object?>? whereNotIn;
  final bool? isNull;

  QueryFilter({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}
