import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/date_formatter.dart';
import 'package:assets_dashboard/data/models/asset_model.dart';
import 'package:assets_dashboard/providers/asset_provider.dart';
import 'package:assets_dashboard/providers/settings_provider.dart';
import 'package:assets_dashboard/screens/assets/add_asset_screen.dart';
import 'package:assets_dashboard/screens/assets/edit_asset_screen.dart';

/// Assets Page Screen - Asset Data Table
class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load assets and settings on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetProvider>().streamAssets();
      context.read<SettingsProvider>().loadSettings();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AssetProvider>(
        builder: (context, assetProvider, child) {
          // Show loading indicator
          if (assetProvider.isLoading && assetProvider.assets.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error message
          if (assetProvider.error != null && assetProvider.assets.isEmpty) {
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
                    'Error loading assets',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    assetProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      assetProvider.loadAssets();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
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
                _buildFilterSection(assetProvider),

                const SizedBox(height: AppSizes.spacing32),

                // Data Table
                _buildDataTable(assetProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(AssetProvider assetProvider) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final categories = ['Select One', ...settingsProvider.assetCategories];
        final selectedCategory = assetProvider.selectedCategory ?? 'Select One';

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
                    onChanged: (value) {
                      // Search as user types
                      assetProvider.searchAssets(value);
                    },
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
                    value: categories.contains(selectedCategory)
                        ? selectedCategory
                        : 'Select One',
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
                        assetProvider.filterByCategory(
                          newValue == 'Select One' ? null : newValue,
                        );
                      }
                    },
                  ),
                ),

                // Search button
                OutlinedButton(
                  onPressed: () {
                    assetProvider.searchAssets(_searchController.text);
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
                    });
                    assetProvider.clearFilters();
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
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAssetScreen(),
                      ),
                    );
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
      },
    );
  }

  Widget _buildDataTable(AssetProvider assetProvider) {
    final assets = assetProvider.assets;

    if (assets.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: AppColors.border,
            width: AppSizes.borderThin,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: AppColors.gray400,
              ),
              const SizedBox(height: 16),
              Text(
                'No assets found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first asset to get started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray600,
                    ),
              ),
            ],
          ),
        ),
      );
    }

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
          rows: assets.map((AssetModel asset) {
            return DataRow(
              cells: [
                DataCell(Text(asset.assetId)),
                DataCell(Text(asset.name)),
                DataCell(Text(asset.category)),
                DataCell(Text(asset.assignedTo)),
                DataCell(Text(DateFormatter.formatDate(asset.date))),
                DataCell(Text('\$${asset.cost.toStringAsFixed(0)}')),
                DataCell(Text(asset.status)),
                DataCell(Text(DateFormatter.formatDate(asset.warranty))),
                DataCell(Text(asset.condition)),
                DataCell(
                  OutlinedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAssetScreen(asset: asset),
                        ),
                      );
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
