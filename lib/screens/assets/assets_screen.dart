import 'package:flutter/material.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/data/demo_data.dart';
import 'package:assets_dashboard/models/asset_model.dart';

/// Assets Page Screen - Asset Data Table
class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'Select One';
  final categories = DemoData.getCategories();
  final assets = DemoData.getAssets();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              'Asset Data',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: AppSizes.spacing32),

            // Filter Section
            _buildFilterSection(),

            const SizedBox(height: AppSizes.spacing32),

            // Data Table
            _buildDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Filter" label
        Text(
          'Filter',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
        ),

        const SizedBox(height: AppSizes.spacing16),

        // Filter controls row
        Wrap(
          spacing: AppSizes.spacing16,
          runSpacing: AppSizes.spacing16,
          children: [
            // Search field
            SizedBox(
              width: 250,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.gray600,
                    size: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing16,
                    vertical: AppSizes.spacing12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: AppSizes.borderThin,
                    ),
                  ),
                ),
              ),
            ),

            // Category dropdown
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing16,
                vertical: AppSizes.spacing12,
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
                value: selectedCategory,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
              ),
            ),

            // Search button
            OutlinedButton(
              onPressed: () {
                // Search functionality
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing24,
                  vertical: AppSizes.spacing12,
                ),
              ),
              child: const Text('Search'),
            ),

            // Reset button
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  selectedCategory = 'Select One';
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing24,
                  vertical: AppSizes.spacing12,
                ),
              ),
              child: const Text('Reset'),
            ),

            // Add button
            OutlinedButton.icon(
              onPressed: () {
                // Add asset functionality
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing24,
                  vertical: AppSizes.spacing12,
                ),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: AppColors.border,
          width: AppSizes.borderThin,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.gray100),
          dataRowColor: WidgetStateProperty.all(AppColors.background),
          border: TableBorder.all(
            color: AppColors.border,
            width: AppSizes.borderThin,
          ),
          headingTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          dataTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue,
              ),
          columns: const [
            DataColumn(label: Text('Asset Id')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Assigned to')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Cost')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Warranty')),
            DataColumn(label: Text('Condition')),
            DataColumn(label: Text('')), // Edit column
          ],
          rows: assets.map((asset) {
            return DataRow(
              cells: [
                DataCell(Text(asset.assetId)),
                DataCell(Text(asset.name)),
                DataCell(Text(asset.category)),
                DataCell(Text(asset.assignedTo)),
                DataCell(Text(asset.date)),
                DataCell(Text(asset.cost)),
                DataCell(Text(asset.status)),
                DataCell(Text(asset.warranty)),
                DataCell(Text(asset.condition)),
                DataCell(
                  OutlinedButton(
                    onPressed: () {
                      // Edit functionality
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing16,
                        vertical: AppSizes.spacing8,
                      ),
                      minimumSize: const Size(60, 32),
                    ),
                    child: const Text('Edit'),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
