import 'package:flutter/material.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/data/demo_data.dart';
import 'package:assets_dashboard/widgets/stat_card.dart';
import 'package:assets_dashboard/widgets/chart_placeholder.dart';

/// Home Dashboard Screen - Main content area
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedBranch = 'All Branches';
  final stats = DemoData.getDashboardStats();
  final branches = DemoData.getBranches();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            
            const SizedBox(height: AppSizes.spacing32),
            
            // Statistics Cards Section
            _buildStatsSection(),
            
            const SizedBox(height: AppSizes.spacing32),
            
            // Branch Comparison Chart Section
            const ChartPlaceholder(
              title: 'Branch Comparison',
              height: 350,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dashboard Title
        Text(
          'DashBoard',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 32,
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
            value: selectedBranch,
            underline: const SizedBox(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textPrimary,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            items: branches.map((String branch) {
              return DropdownMenuItem<String>(
                value: branch,
                child: Text(branch),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedBranch = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive grid
          final crossAxisCount = constraints.maxWidth > 1200 ? 3 : 2;
          
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 2.2,
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
    );
  }
}
