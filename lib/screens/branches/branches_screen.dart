import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/date_formatter.dart';
import 'package:assets_dashboard/core/utils/responsive_helper.dart';
import 'package:assets_dashboard/data/models/branch_model.dart';
import 'package:assets_dashboard/providers/branch_provider.dart';
import 'package:assets_dashboard/screens/branches/add_branch_screen.dart';
import 'package:assets_dashboard/screens/branches/edit_branch_screen.dart';

/// Branches Screen - Branch Data Table
class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  @override
  void initState() {
    super.initState();
    // Load branches on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BranchProvider>().streamBranches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<BranchProvider>(
        builder: (context, branchProvider, child) {
          // Show loading indicator
          if (branchProvider.isLoading && branchProvider.branches.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error message
          if (branchProvider.error != null && branchProvider.branches.isEmpty) {
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
                    'Error loading branches',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    branchProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      branchProvider.loadBranches();
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
                // Header
                _buildHeader(),

                SizedBox(height: ResponsiveHelper.getSpacing(context)),

                // Data Table
                _buildDataTable(branchProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final titleFontSize = ResponsiveHelper.getTitleFontSize(context);

    if (isMobile) {
      // Stack layout for mobile
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Branches List',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBranchScreen(),
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
            label: const Text('Add Branch'),
          ),
        ],
      );
    }

    // Desktop/Tablet layout
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Branches List',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
        ),
        OutlinedButton.icon(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddBranchScreen(),
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
          label: const Text('Add Branch'),
        ),
      ],
    );
  }


  Widget _buildDataTable(BranchProvider branchProvider) {
    final branches = branchProvider.branches;

    if (branches.isEmpty) {
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
                Icons.business_outlined,
                size: 64,
                color: AppColors.gray400,
              ),
              const SizedBox(height: 16),
              Text(
                'No branches found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first branch to get started',
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
            DataColumn(label: Text('Branch Id')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Country')),
            DataColumn(label: Text('Phone Number')),
            DataColumn(label: Text('Manager Name')),
            DataColumn(label: Text('Phone Number')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('')), // Edit column
          ],
          rows: branches.map((BranchModel branch) {
            return DataRow(
              cells: [
                DataCell(Text(branch.branchId)),
                DataCell(Text(branch.branchName)),
                DataCell(Text(branch.branchCountry)),
                DataCell(Text(branch.branchPhoneNo)),
                DataCell(Text(branch.managerName)),
                DataCell(Text(branch.managerPhoneNo)),
                DataCell(Text(DateFormatter.formatDate(branch.date))),
                DataCell(Text(branch.status)),
                DataCell(
                  OutlinedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBranchScreen(branch: branch),
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
