
import 'package:assets_dashboard/models/dashboard_stats.dart';
import 'package:assets_dashboard/models/asset_model.dart';

/// Demo data for the dashboard
class DemoData {
  // Dashboard Statistics matching the PDF design
  static List<DashboardStats> getDashboardStats() {
    return const [
      DashboardStats(
        title: 'Total Asset',
        value: 40,
      ),
      DashboardStats(
        title: 'Assigned Asset',
        value: 20,
      ),
      DashboardStats(
        title: 'Upcoming Warranty Expires',
        value: 5,
      ),
      DashboardStats(
        title: 'Available Asset',
        value: 60,
      ),
      DashboardStats(
        title: 'Asset on Repair',
        value: 20,
      ),
    ];
  }
  
  // Branch names for dropdown
  static List<String> getBranches() {
    return [
      'All Branches',
      'Main Office',
      'Branch 1',
      'Branch 2',
      'Branch 3',
    ];
  }
  
  // Asset demo data matching the design image
  static List<AssetModel> getAssets() {
    return const [
      AssetModel(
        assetId: '100',
        name: 'Laptop',
        category: 'IT asset',
        assignedTo: 'Yaswanth',
        date: '12/3/25',
        cost: '\$60,000',
        status: 'Assigned',
        warranty: '12/3/27',
        condition: 'Good',
      ),
      AssetModel(
        assetId: '101',
        name: 'Chair',
        category: 'Non IT',
        assignedTo: 'Benjamin',
        date: '5/7/25',
        cost: '\$20,000',
        status: 'Available',
        warranty: '12/3/27',
        condition: 'Fair',
      ),
      AssetModel(
        assetId: '102',
        name: 'Printer',
        category: 'IT asset',
        assignedTo: 'Shardul',
        date: '10/8/25',
        cost: '\$40,000',
        status: 'Under Repair',
        warranty: '10/8/27',
        condition: 'Poor',
      ),
    ];
  }
  
  // Categories for filter dropdown
  static List<String> getCategories() {
    return [
      'Select One',
      'IT asset',
      'Non IT',
    ];
  }
}
