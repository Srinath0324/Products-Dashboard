import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for vendor data with Firebase serialization
class VendorModel {
  final String id; // Firestore document ID
  final String vendorId; // User-facing vendor ID
  final String vendorName;
  final String contactPersonName;
  final String vendorPhoneNo;
  final String vendorEmail;
  final String vendorType;
  final String productsOffered;
  final String vendorStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VendorModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.contactPersonName,
    required this.vendorPhoneNo,
    required this.vendorEmail,
    required this.vendorType,
    required this.productsOffered,
    required this.vendorStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create VendorModel from Firestore document
  factory VendorModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return VendorModel(
      id: doc.id,
      vendorId: data['vendorId'] as String? ?? '',
      vendorName: data['vendorName'] as String? ?? '',
      contactPersonName: data['contactPersonName'] as String? ?? '',
      vendorPhoneNo: data['vendorPhoneNo'] as String? ?? '',
      vendorEmail: data['vendorEmail'] as String? ?? '',
      vendorType: data['vendorType'] as String? ?? '',
      productsOffered: data['productsOffered'] as String? ?? '',
      vendorStatus: data['vendorStatus'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create VendorModel from JSON map
  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as String? ?? '',
      vendorId: json['vendorId'] as String? ?? '',
      vendorName: json['vendorName'] as String? ?? '',
      contactPersonName: json['contactPersonName'] as String? ?? '',
      vendorPhoneNo: json['vendorPhoneNo'] as String? ?? '',
      vendorEmail: json['vendorEmail'] as String? ?? '',
      vendorType: json['vendorType'] as String? ?? '',
      productsOffered: json['productsOffered'] as String? ?? '',
      vendorStatus: json['vendorStatus'] as String? ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert VendorModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'vendorName': vendorName,
      'contactPersonName': contactPersonName,
      'vendorPhoneNo': vendorPhoneNo,
      'vendorEmail': vendorEmail,
      'vendorType': vendorType,
      'productsOffered': productsOffered,
      'vendorStatus': vendorStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  VendorModel copyWith({
    String? id,
    String? vendorId,
    String? vendorName,
    String? contactPersonName,
    String? vendorPhoneNo,
    String? vendorEmail,
    String? vendorType,
    String? productsOffered,
    String? vendorStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      contactPersonName: contactPersonName ?? this.contactPersonName,
      vendorPhoneNo: vendorPhoneNo ?? this.vendorPhoneNo,
      vendorEmail: vendorEmail ?? this.vendorEmail,
      vendorType: vendorType ?? this.vendorType,
      productsOffered: productsOffered ?? this.productsOffered,
      vendorStatus: vendorStatus ?? this.vendorStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'VendorModel(id: $id, vendorId: $vendorId, vendorName: $vendorName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VendorModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
