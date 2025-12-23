import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for employee data with Firebase serialization
class EmployeeModel {
  final String id; // Firestore document ID
  final String employeeId; // User-facing employee ID
  final String employeeName;
  final DateTime employeeDOB;
  final String employeePhoneNo;
  final String employeeEmail;
  final String employeeDepartment;
  final String employeeDesignation;
  final String employeeBranch;
  final String employeeType;
  final DateTime employeeDateOfJoining;
  final double employeeSalary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EmployeeModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeDOB,
    required this.employeePhoneNo,
    required this.employeeEmail,
    required this.employeeDepartment,
    required this.employeeDesignation,
    required this.employeeBranch,
    required this.employeeType,
    required this.employeeDateOfJoining,
    required this.employeeSalary,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create EmployeeModel from Firestore document
  factory EmployeeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return EmployeeModel(
      id: doc.id,
      employeeId: data['employeeId'] as String? ?? '',
      employeeName: data['employeeName'] as String? ?? '',
      employeeDOB: (data['employeeDOB'] as Timestamp?)?.toDate() ?? DateTime.now(),
      employeePhoneNo: data['employeePhoneNo'] as String? ?? '',
      employeeEmail: data['employeeEmail'] as String? ?? '',
      employeeDepartment: data['employeeDepartment'] as String? ?? '',
      employeeDesignation: data['employeeDesignation'] as String? ?? '',
      employeeBranch: data['employeeBranch'] as String? ?? '',
      employeeType: data['employeeType'] as String? ?? '',
      employeeDateOfJoining: (data['employeeDateOfJoining'] as Timestamp?)?.toDate() ?? DateTime.now(),
      employeeSalary: (data['employeeSalary'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create EmployeeModel from JSON map
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      employeeName: json['employeeName'] as String? ?? '',
      employeeDOB: json['employeeDOB'] is Timestamp
          ? (json['employeeDOB'] as Timestamp).toDate()
          : DateTime.parse(json['employeeDOB'] as String? ?? DateTime.now().toIso8601String()),
      employeePhoneNo: json['employeePhoneNo'] as String? ?? '',
      employeeEmail: json['employeeEmail'] as String? ?? '',
      employeeDepartment: json['employeeDepartment'] as String? ?? '',
      employeeDesignation: json['employeeDesignation'] as String? ?? '',
      employeeBranch: json['employeeBranch'] as String? ?? '',
      employeeType: json['employeeType'] as String? ?? '',
      employeeDateOfJoining: json['employeeDateOfJoining'] is Timestamp
          ? (json['employeeDateOfJoining'] as Timestamp).toDate()
          : DateTime.parse(json['employeeDateOfJoining'] as String? ?? DateTime.now().toIso8601String()),
      employeeSalary: (json['employeeSalary'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert EmployeeModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeeDOB': Timestamp.fromDate(employeeDOB),
      'employeePhoneNo': employeePhoneNo,
      'employeeEmail': employeeEmail,
      'employeeDepartment': employeeDepartment,
      'employeeDesignation': employeeDesignation,
      'employeeBranch': employeeBranch,
      'employeeType': employeeType,
      'employeeDateOfJoining': Timestamp.fromDate(employeeDateOfJoining),
      'employeeSalary': employeeSalary,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  EmployeeModel copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    DateTime? employeeDOB,
    String? employeePhoneNo,
    String? employeeEmail,
    String? employeeDepartment,
    String? employeeDesignation,
    String? employeeBranch,
    String? employeeType,
    DateTime? employeeDateOfJoining,
    double? employeeSalary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeDOB: employeeDOB ?? this.employeeDOB,
      employeePhoneNo: employeePhoneNo ?? this.employeePhoneNo,
      employeeEmail: employeeEmail ?? this.employeeEmail,
      employeeDepartment: employeeDepartment ?? this.employeeDepartment,
      employeeDesignation: employeeDesignation ?? this.employeeDesignation,
      employeeBranch: employeeBranch ?? this.employeeBranch,
      employeeType: employeeType ?? this.employeeType,
      employeeDateOfJoining: employeeDateOfJoining ?? this.employeeDateOfJoining,
      employeeSalary: employeeSalary ?? this.employeeSalary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'EmployeeModel(id: $id, employeeId: $employeeId, employeeName: $employeeName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmployeeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
