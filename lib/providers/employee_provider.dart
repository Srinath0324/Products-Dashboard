import 'package:flutter/foundation.dart';
import 'package:assets_dashboard/data/models/employee_model.dart';
import 'package:assets_dashboard/data/repositories/employee_repository.dart';

/// Provider for Employee state management
/// 
/// Manages employee data state and provides methods for CRUD operations
class EmployeeProvider extends ChangeNotifier {
  final EmployeeRepository _repository = EmployeeRepository();

  List<EmployeeModel> _employees = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<EmployeeModel> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all employees
  Future<void> loadEmployees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _employees = await _repository.getAllEmployees();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream employees (real-time updates)
  void streamEmployees() {
    _repository.streamEmployees().listen(
      (employees) {
        _employees = employees;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Add new employee
  Future<bool> addEmployee(EmployeeModel employee) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.addEmployee(employee);
      await loadEmployees();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update employee
  Future<bool> updateEmployee(String id, EmployeeModel employee) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateEmployee(id, employee);
      await loadEmployees();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete employee
  Future<bool> deleteEmployee(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteEmployee(id);
      await loadEmployees();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get employee by ID
  EmployeeModel? getEmployeeById(String id) {
    try {
      return _employees.firstWhere((employee) => employee.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get employee names for dropdown
  List<String> getEmployeeNames() {
    return _employees.map((employee) => employee.employeeName).toList();
  }

  /// Get employees by branch
  List<EmployeeModel> getEmployeesByBranch(String branch) {
    return _employees
        .where((employee) => employee.employeeBranch == branch)
        .toList();
  }
}
