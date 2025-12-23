import 'package:flutter/material.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';

/// Reports and Analytics Screen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reports and Analytics',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export functionality coming soon')),
                    );
                  },
                  child: const Text('Export'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Asset Categories Section
            Text(
              'Asset Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: 16),

            // Charts Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Section
                Expanded(
                  flex: 1,
                  child: _buildFilterCard(context),
                ),
                const SizedBox(width: 16),
                // Asset Performance Chart
                Expanded(
                  flex: 2,
                  child: _buildChartPlaceholder(context, 'Asset Performance', 300),
                ),
                const SizedBox(width: 16),
                // Top 5 Assets
                Expanded(
                  flex: 2,
                  child: _buildTopAssetsCard(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Second Row - Depreciation and Status
            Row(
              children: [
                Expanded(
                  child: _buildChartPlaceholder(context, 'Asset Depreciation Over Time', 250),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildChartPlaceholder(context, 'Asset Status', 250),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Asset Activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Asset Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export functionality coming soon')),
                    );
                  },
                  child: const Text('Export'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildActivityList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter By Date', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _buildDropdown(context, 'Placeholder'),
          const SizedBox(height: 16),
          Text('Filter By Month', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _buildDropdown(context, 'Placeholder'),
        ],
      ),
    );
  }

  Widget _buildTopAssetsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top 5 asset By Value', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _buildDropdown(context, 'Placeholder'),
          const SizedBox(height: 16),
          Text('Recent Asset Activity', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            height: 150,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(child: Text('Activity placeholder text', style: TextStyle(fontSize: 12))),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(BuildContext context, String title, double height) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 48, color: AppColors.gray400),
                  const SizedBox(height: 8),
                  Text('Chart Placeholder', style: TextStyle(color: AppColors.gray600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    final activities = [
      {'name': 'Assertt Rititigoins', 'value': '10%'},
      {'name': 'Sirroiloines', 'value': ''},
      {'name': 'Assertt Meldoar', 'value': '10%'},
      {'name': 'Artuels', 'value': ''},
      {'name': 'Dolpided Eraptions', 'value': '50%'},
      {'name': 'Steence', 'value': '80%'},
      {'name': 'Mssol', 'value': ''},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top 5 Assets by Value', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ...activities.map((activity) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.gray600, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(activity['name']!, style: TextStyle(color: AppColors.gray600))),
                    if (activity['value']!.isNotEmpty) Text(activity['value']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: TextStyle(color: AppColors.gray400)),
          Icon(Icons.arrow_drop_down, color: AppColors.gray600),
        ],
      ),
    );
  }
}
