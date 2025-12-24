import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/responsive_helper.dart';
import 'package:assets_dashboard/providers/dashboard_provider.dart';
import 'package:assets_dashboard/providers/branch_provider.dart';
import 'package:assets_dashboard/widgets/stat_card.dart';
import 'package:assets_dashboard/widgets/chart_placeholder.dart';

/// Home Dashboard Screen - Main content area
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data and branches on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboardStats();
      context.read<BranchProvider>().loadBranches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<DashboardProvider>(
        builder: (context, dashboardProvider, child) {
          // Show loading indicator
          if (dashboardProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error message
          if (dashboardProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading dashboard',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dashboardProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      dashboardProvider.loadDashboardStats();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelper.getPadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(),
                
                SizedBox(height: ResponsiveHelper.getSpacing(context)),
                
                // Statistics Cards Section
                _buildStatsSection(dashboardProvider),
                
                SizedBox(height: ResponsiveHelper.getSpacing(context)),
                
                // Branch Comparison Chart Section
                const ChartPlaceholder(
                  title: 'Branch Comparison',
                  height: 350,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer2<DashboardProvider, BranchProvider>(
      builder: (context, dashboardProvider, branchProvider, child) {
        // Get branch names including "All Branches"
        final branchNames = ['All Branches', ...branchProvider.getBranchNames()];
        final selectedBranch = dashboardProvider.selectedBranch;
        final isMobile = ResponsiveHelper.isMobile(context);
        final titleFontSize = ResponsiveHelper.getTitleFontSize(context);

        if (isMobile) {
          // Stack layout for mobile
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Title
              Text(
                'DashBoard',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              // Branch Filter Dropdown
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing16,
                  vertical: AppSizes.spacing8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(
                    color: AppColors.border,
                    width: AppSizes.borderThin,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: DropdownButton<String>(
                  value: branchNames.contains(selectedBranch) 
                      ? selectedBranch 
                      : 'All Branches',
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textPrimary,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  items: branchNames.map((String branch) {
                    return DropdownMenuItem<String>(
                      value: branch,
                      child: Text(branch),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      dashboardProvider.setSelectedBranch(newValue);
                    }
                  },
                ),
              ),
            ],
          );
        }

        // Desktop/Tablet layout
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dashboard Title
            Text(
              'DashBoard',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            
            // Branch Filter Dropdown
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing16,
                vertical: AppSizes.spacing8,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(
                  color: AppColors.border,
                  width: AppSizes.borderThin,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: DropdownButton<String>(
                value: branchNames.contains(selectedBranch) 
                    ? selectedBranch 
                    : 'All Branches',
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                items: branchNames.map((String branch) {
                  return DropdownMenuItem<String>(
                    value: branch,
                    child: Text(branch),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    dashboardProvider.setSelectedBranch(newValue);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsSection(DashboardProvider dashboardProvider) {
    final stats = dashboardProvider.stats;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: AppColors.border,
          width: AppSizes.borderThin,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSizes.spacing16),
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate responsive grid
              final isMobile = ResponsiveHelper.isMobile(context);
              final crossAxisCount = constraints.maxWidth > 1200 ? 3 : 2;
              // Adjust aspect ratio for mobile to give more height
              final aspectRatio = isMobile ? 1.8 : 2.2;
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: AppSizes.spacing16,
                  mainAxisSpacing: AppSizes.spacing16,
                ),
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  return StatCard(stats: stats[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
