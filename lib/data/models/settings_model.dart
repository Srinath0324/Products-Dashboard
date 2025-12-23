import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for app settings with Firebase serialization
class SettingsModel {
  final String id; // Firestore document ID (typically 'app_settings')
  final List<String> assetCategories;
  final List<String> assetStatuses;
  final String notificationSettings;
  final bool branchDepartmentMapping;
  final bool vendorSupplierLinking;
  final bool depreciationRuleAccepted;
  final Map<String, bool> approvalWorkflow;
  final DateTime updatedAt;

  const SettingsModel({
    required this.id,
    required this.assetCategories,
    required this.assetStatuses,
    required this.notificationSettings,
    required this.branchDepartmentMapping,
    required this.vendorSupplierLinking,
    required this.depreciationRuleAccepted,
    required this.approvalWorkflow,
    required this.updatedAt,
  });

  /// Default settings
  factory SettingsModel.defaultSettings() {
    return SettingsModel(
      id: 'app_settings',
      assetCategories: ['IT asset', 'Non IT', 'Furniture', 'Equipment'],
      assetStatuses: ['Active', 'Inactive', 'Assigned', 'Returned', 'Under Repair'],
      notificationSettings: '',
      branchDepartmentMapping: true,
      vendorSupplierLinking: true,
      depreciationRuleAccepted: false,
      approvalWorkflow: {
        'submitReassigning': false,
        'disposingAsset': false,
      },
      updatedAt: DateTime.now(),
    );
  }

  /// Create SettingsModel from Firestore document
  factory SettingsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SettingsModel(
      id: doc.id,
      assetCategories: List<String>.from(data['assetCategories'] as List? ?? []),
      assetStatuses: List<String>.from(data['assetStatuses'] as List? ?? []),
      notificationSettings: data['notificationSettings'] as String? ?? '',
      branchDepartmentMapping: data['branchDepartmentMapping'] as bool? ?? true,
      vendorSupplierLinking: data['vendorSupplierLinking'] as bool? ?? true,
      depreciationRuleAccepted: data['depreciationRuleAccepted'] as bool? ?? false,
      approvalWorkflow: Map<String, bool>.from(data['approvalWorkflow'] as Map? ?? {}),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create SettingsModel from JSON map
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['id'] as String? ?? 'app_settings',
      assetCategories: List<String>.from(json['assetCategories'] as List? ?? []),
      assetStatuses: List<String>.from(json['assetStatuses'] as List? ?? []),
      notificationSettings: json['notificationSettings'] as String? ?? '',
      branchDepartmentMapping: json['branchDepartmentMapping'] as bool? ?? true,
      vendorSupplierLinking: json['vendorSupplierLinking'] as bool? ?? true,
      depreciationRuleAccepted: json['depreciationRuleAccepted'] as bool? ?? false,
      approvalWorkflow: Map<String, bool>.from(json['approvalWorkflow'] as Map? ?? {}),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert SettingsModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'assetCategories': assetCategories,
      'assetStatuses': assetStatuses,
      'notificationSettings': notificationSettings,
      'branchDepartmentMapping': branchDepartmentMapping,
      'vendorSupplierLinking': vendorSupplierLinking,
      'depreciationRuleAccepted': depreciationRuleAccepted,
      'approvalWorkflow': approvalWorkflow,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  SettingsModel copyWith({
    String? id,
    List<String>? assetCategories,
    List<String>? assetStatuses,
    String? notificationSettings,
    bool? branchDepartmentMapping,
    bool? vendorSupplierLinking,
    bool? depreciationRuleAccepted,
    Map<String, bool>? approvalWorkflow,
    DateTime? updatedAt,
  }) {
    return SettingsModel(
      id: id ?? this.id,
      assetCategories: assetCategories ?? this.assetCategories,
      assetStatuses: assetStatuses ?? this.assetStatuses,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      branchDepartmentMapping: branchDepartmentMapping ?? this.branchDepartmentMapping,
      vendorSupplierLinking: vendorSupplierLinking ?? this.vendorSupplierLinking,
      depreciationRuleAccepted: depreciationRuleAccepted ?? this.depreciationRuleAccepted,
      approvalWorkflow: approvalWorkflow ?? this.approvalWorkflow,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SettingsModel(id: $id, assetCategories: ${assetCategories.length}, assetStatuses: ${assetStatuses.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
