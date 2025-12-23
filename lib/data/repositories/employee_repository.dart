import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assets_dashboard/data/models/employee_model.dart';
import 'package:assets_dashboard/data/services/firestore_service.dart';

/// Repository for Employee data operations
/// 
/// Handles all CRUD operations and queries for employees using Firestore
class EmployeeRepository {
  final FirestoreService _firestoreService = FirestoreService.instance;
  static const String _collectionPath = 'employees';

  /// Get all employees
  Future<List<EmployeeModel>> getAllEmployees() async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      return snapshot.docs
          .map((doc) => EmployeeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get employees: $e');
    }
  }

  /// Get employee by ID
  Future<EmployeeModel?> getEmployeeById(String id) async {
    try {
      final doc = await _firestoreService.getDocument(_collectionPath, id);
      if (doc.exists) {
        return EmployeeModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get employee: $e');
    }
  }

  /// Stream all employees (real-time updates)
  Stream<List<EmployeeModel>> streamEmployees() {
    return _firestoreService.streamDocuments(_collectionPath).map(
          (snapshot) => snapshot.docs
              .map((doc) => EmployeeModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Add new employee
  Future<String> addEmployee(EmployeeModel employee) async {
    try {
      final docRef = await _firestoreService.addDocument(
        _collectionPath,
        employee.toJson(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add employee: $e');
    }
  }

  /// Update existing employee
  Future<void> updateEmployee(String id, EmployeeModel employee) async {
    try {
      await _firestoreService.updateDocument(
        _collectionPath,
        id,
        employee.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update employee: $e');
    }
  }

  /// Delete employee
  Future<void> deleteEmployee(String id) async {
    try {
      await _firestoreService.deleteDocument(_collectionPath, id);
    } catch (e) {
      throw Exception('Failed to delete employee: $e');
    }
  }

  /// Get employees by branch
  Future<List<EmployeeModel>> getEmployeesByBranch(String branch) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'employeeBranch', isEqualTo: branch),
        ],
      );
      return snapshot.docs
          .map((doc) => EmployeeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get employees by branch: $e');
    }
  }

  /// Get employees by department
  Future<List<EmployeeModel>> getEmployeesByDepartment(String department) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'employeeDepartment', isEqualTo: department),
        ],
      );
      return snapshot.docs
          .map((doc) => EmployeeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get employees by department: $e');
    }
  }

  /// Get employees by type
  Future<List<EmployeeModel>> getEmployeesByType(String type) async {
    try {
      final snapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        filters: [
          QueryFilter(field: 'employeeType', isEqualTo: type),
        ],
      );
      return snapshot.docs
          .map((doc) => EmployeeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get employees by type: $e');
    }
  }

  /// Search employees by name
  Future<List<EmployeeModel>> searchEmployeesByName(String searchTerm) async {
    try {
      final snapshot = await _firestoreService.getDocuments(_collectionPath);
      final employees = snapshot.docs
          .map((doc) => EmployeeModel.fromFirestore(doc))
          .toList();

      // Filter by name (case-insensitive)
      return employees
          .where((employee) =>
              employee.employeeName.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search employees: $e');
    }
  }
}
