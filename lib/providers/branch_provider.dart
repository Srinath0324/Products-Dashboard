import 'package:flutter/foundation.dart';
import 'package:assets_dashboard/data/models/branch_model.dart';
import 'package:assets_dashboard/data/repositories/branch_repository.dart';

/// Provider for Branch state management
/// 
/// Manages branch data state and provides methods for CRUD operations
class BranchProvider extends ChangeNotifier {
  final BranchRepository _repository = BranchRepository();

  List<BranchModel> _branches = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<BranchModel> get branches => _branches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all branches
  Future<void> loadBranches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _branches = await _repository.getAllBranches();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream branches (real-time updates)
  void streamBranches() {
    _repository.streamBranches().listen(
      (branches) {
        _branches = branches;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Add new branch
  Future<bool> addBranch(BranchModel branch) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.addBranch(branch);
      await loadBranches();
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

  /// Update branch
  Future<bool> updateBranch(String id, BranchModel branch) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateBranch(id, branch);
      await loadBranches();
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

  /// Delete branch
  Future<bool> deleteBranch(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteBranch(id);
      await loadBranches();
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

  /// Get branch by ID
  BranchModel? getBranchById(String id) {
    try {
      return _branches.firstWhere((branch) => branch.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get branch names for dropdown
  List<String> getBranchNames() {
    return _branches.map((branch) => branch.branchName).toList();
  }
}
