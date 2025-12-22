
import 'package:assets_dashboard/models/dashboard_stats.dart';

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
}
