import 'package:flutter/foundation.dart';
import 'package:assets_dashboard/data/models/vendor_model.dart';
import 'package:assets_dashboard/data/repositories/vendor_repository.dart';

/// Provider for Vendor state management
/// 
/// Manages vendor data state and provides methods for CRUD operations
class VendorProvider extends ChangeNotifier {
  final VendorRepository _repository = VendorRepository();

  List<VendorModel> _vendors = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<VendorModel> get vendors => _vendors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all vendors
  Future<void> loadVendors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _vendors = await _repository.getAllVendors();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream vendors (real-time updates)
  void streamVendors() {
    _repository.streamVendors().listen(
      (vendors) {
        _vendors = vendors;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Add new vendor
  Future<bool> addVendor(VendorModel vendor) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.addVendor(vendor);
      await loadVendors();
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

  /// Update vendor
  Future<bool> updateVendor(String id, VendorModel vendor) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateVendor(id, vendor);
      await loadVendors();
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

  /// Delete vendor
  Future<bool> deleteVendor(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteVendor(id);
      await loadVendors();
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

  /// Get vendor by ID
  VendorModel? getVendorById(String id) {
    try {
      return _vendors.firstWhere((vendor) => vendor.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get vendor names for dropdown
  List<String> getVendorNames() {
    return _vendors.map((vendor) => vendor.vendorName).toList();
  }
}
