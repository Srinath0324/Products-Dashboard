import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for branch data with Firebase serialization
class BranchModel {
  final String id; // Firestore document ID
  final String branchId; // User-facing branch ID
  final String branchName;
  final String branchCountry;
  final String branchPhoneNo;
  final String managerName;
  final String managerPhoneNo;
  final String status;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BranchModel({
    required this.id,
    required this.branchId,
    required this.branchName,
    required this.branchCountry,
    required this.branchPhoneNo,
    required this.managerName,
    required this.managerPhoneNo,
    required this.status,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create BranchModel from Firestore document
  factory BranchModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BranchModel(
      id: doc.id,
      branchId: data['branchId'] as String? ?? '',
      branchName: data['branchName'] as String? ?? '',
      branchCountry: data['branchCountry'] as String? ?? '',
      branchPhoneNo: data['branchPhoneNo'] as String? ?? '',
      managerName: data['managerName'] as String? ?? '',
      managerPhoneNo: data['managerPhoneNo'] as String? ?? '',
      status: data['status'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create BranchModel from JSON map
  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as String? ?? '',
      branchId: json['branchId'] as String? ?? '',
      branchName: json['branchName'] as String? ?? '',
      branchCountry: json['branchCountry'] as String? ?? '',
      branchPhoneNo: json['branchPhoneNo'] as String? ?? '',
      managerName: json['managerName'] as String? ?? '',
      managerPhoneNo: json['managerPhoneNo'] as String? ?? '',
      status: json['status'] as String? ?? '',
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate()
          : DateTime.parse(json['date'] as String? ?? DateTime.now().toIso8601String()),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert BranchModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'branchCountry': branchCountry,
      'branchPhoneNo': branchPhoneNo,
      'managerName': managerName,
      'managerPhoneNo': managerPhoneNo,
      'status': status,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  BranchModel copyWith({
    String? id,
    String? branchId,
    String? branchName,
    String? branchCountry,
    String? branchPhoneNo,
    String? managerName,
    String? managerPhoneNo,
    String? status,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BranchModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      branchCountry: branchCountry ?? this.branchCountry,
      branchPhoneNo: branchPhoneNo ?? this.branchPhoneNo,
      managerName: managerName ?? this.managerName,
      managerPhoneNo: managerPhoneNo ?? this.managerPhoneNo,
      status: status ?? this.status,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'BranchModel(id: $id, branchId: $branchId, branchName: $branchName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BranchModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
