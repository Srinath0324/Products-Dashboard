import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for asset data with Firebase serialization
class AssetModel {
  final String id; // Firestore document ID
  final String assetId; // User-facing asset ID
  final String name;
  final String category;
  final String assignedTo; // Employee ID or name
  final DateTime date;
  final double cost;
  final String status;
  final DateTime warranty;
  final String condition;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssetModel({
    required this.id,
    required this.assetId,
    required this.name,
    required this.category,
    required this.assignedTo,
    required this.date,
    required this.cost,
    required this.status,
    required this.warranty,
    required this.condition,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create AssetModel from Firestore document
  factory AssetModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AssetModel(
      id: doc.id,
      assetId: data['assetId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? '',
      assignedTo: data['assignedTo'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      cost: (data['cost'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? '',
      warranty: (data['warranty'] as Timestamp?)?.toDate() ?? DateTime.now(),
      condition: data['condition'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create AssetModel from JSON map
  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] as String? ?? '',
      assetId: json['assetId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      assignedTo: json['assignedTo'] as String? ?? '',
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate()
          : DateTime.parse(json['date'] as String? ?? DateTime.now().toIso8601String()),
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      warranty: json['warranty'] is Timestamp
          ? (json['warranty'] as Timestamp).toDate()
          : DateTime.parse(json['warranty'] as String? ?? DateTime.now().toIso8601String()),
      condition: json['condition'] as String? ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert AssetModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'assetId': assetId,
      'name': name,
      'category': category,
      'assignedTo': assignedTo,
      'date': Timestamp.fromDate(date),
      'cost': cost,
      'status': status,
      'warranty': Timestamp.fromDate(warranty),
      'condition': condition,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  AssetModel copyWith({
    String? id,
    String? assetId,
    String? name,
    String? category,
    String? assignedTo,
    DateTime? date,
    double? cost,
    String? status,
    DateTime? warranty,
    String? condition,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssetModel(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      name: name ?? this.name,
      category: category ?? this.category,
      assignedTo: assignedTo ?? this.assignedTo,
      date: date ?? this.date,
      cost: cost ?? this.cost,
      status: status ?? this.status,
      warranty: warranty ?? this.warranty,
      condition: condition ?? this.condition,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'AssetModel(id: $id, assetId: $assetId, name: $name, category: $category, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssetModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
