import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/config/firebase_config.dart';
import 'package:assets_dashboard/core/theme/app_theme.dart';
import 'package:assets_dashboard/widgets/sidebar_navigation.dart';
import 'package:assets_dashboard/screens/home/home_screen.dart';
import 'package:assets_dashboard/screens/assets/assets_screen.dart';
import 'package:assets_dashboard/screens/branches/branches_screen.dart';
import 'package:assets_dashboard/screens/employees/employees_screen.dart';
import 'package:assets_dashboard/screens/vendors/vendors_screen.dart';
import 'package:assets_dashboard/screens/reports/reports_screen.dart';
import 'package:assets_dashboard/screens/settings/settings_screen.dart';
import 'package:assets_dashboard/providers/asset_provider.dart';
import 'package:assets_dashboard/providers/branch_provider.dart';
import 'package:assets_dashboard/providers/employee_provider.dart';
import 'package:assets_dashboard/providers/vendor_provider.dart';
import 'package:assets_dashboard/providers/settings_provider.dart';
import 'package:assets_dashboard/providers/dashboard_provider.dart';
import 'package:assets_dashboard/providers/reports_provider.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: FirebaseConfig.apiKey,
      appId: FirebaseConfig.appId,
      messagingSenderId: FirebaseConfig.messagingSenderId,
      projectId: FirebaseConfig.projectId,
      storageBucket: FirebaseConfig.storageBucket,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssetProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
      ],
      child: MaterialApp(
        title: 'Assets Dashboard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainLayout(),
      ),
    );
  }
}

/// Main layout with sidebar and content area
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          SidebarNavigation(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          
          // Main Content Area
          Expanded(
            child: _getSelectedScreen(),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const AssetsScreen();
      case 2:
        return const BranchesScreen();
      case 3:
        return const EmployeesScreen();
      case 4:
        return const VendorsScreen();
      case 5:
        return const ReportsScreen();
      case 6:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }

  Widget _buildPlaceholderScreen(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(
          //   Icons.construction_outlined,
          //   size: 64,
          //   color: Colors.grey[400],
          // ),
          const SizedBox(height: 16),
          Text(
            '$title Page',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          // Text(
          //   'Coming in Phase 2',
          //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //     color: Colors.grey[600],
          //   ),
          // ),
        ],
      ),
    );
  }
}
