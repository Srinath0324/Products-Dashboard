import 'package:flutter/material.dart';
import 'package:assets_dashboard/core/theme/app_theme.dart';
import 'package:assets_dashboard/widgets/sidebar_navigation.dart';
import 'package:assets_dashboard/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assets Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainLayout(),
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
        return _buildPlaceholderScreen('Assets');
      case 2:
        return _buildPlaceholderScreen('Branches');
      case 3:
        return _buildPlaceholderScreen('Employees');
      case 4:
        return _buildPlaceholderScreen('Vendors');
      case 5:
        return _buildPlaceholderScreen('Reports');
      case 6:
        return _buildPlaceholderScreen('Settings');
      default:
        return const HomeScreen();
    }
  }

  Widget _buildPlaceholderScreen(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '$title Page',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming in Phase 2',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
