import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/date_formatter.dart';
import 'package:assets_dashboard/data/models/vendor_model.dart';
import 'package:assets_dashboard/providers/vendor_provider.dart';
import 'package:assets_dashboard/screens/vendors/add_vendor_screen.dart';

/// Vendors Screen - Vendor Data Table
class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  @override
  void initState() {
    super.initState();
    // Load vendors on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorProvider>().streamVendors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          // Show loading indicator
          if (vendorProvider.isLoading && vendorProvider.vendors.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error message
          if (vendorProvider.error != null && vendorProvider.vendors.isEmpty) {
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
                    'Error loading vendors',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vendorProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      vendorProvider.loadVendors();
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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vendor List',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddVendorScreen(),
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
                      label: const Text('Add Vendor'),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.spacing32),

                // Data Table
                _buildDataTable(vendorProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataTable(VendorProvider vendorProvider) {
    final vendors = vendorProvider.vendors;

    if (vendors.isEmpty) {
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
                Icons.store_outlined,
                size: 64,
                color: AppColors.gray400,
              ),
              const SizedBox(height: 16),
              Text(
                'No vendors found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first vendor to get started',
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
            DataColumn(label: Text('Vendor Id')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Contact Person')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Products Offered')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('')), // Delete column
          ],
          rows: vendors.map((VendorModel vendor) {
            return DataRow(
              cells: [
                DataCell(Text(vendor.vendorId)),
                DataCell(Text(vendor.vendorName)),
                DataCell(Text(vendor.contactPersonName)),
                DataCell(Text(vendor.vendorPhoneNo)),
                DataCell(Text(vendor.vendorEmail)),
                DataCell(Text(vendor.vendorType)),
                DataCell(Text(vendor.productsOffered)),
                DataCell(Text(vendor.vendorStatus)),
                DataCell(
                  OutlinedButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Vendor'),
                          content: Text('Are you sure you want to delete ${vendor.vendorName}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && context.mounted) {
                        final success = await context.read<VendorProvider>().deleteVendor(vendor.id);
                        
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vendor deleted successfully')),
                          );
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.read<VendorProvider>().error ?? 'Failed to delete vendor',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing16,
                        vertical: AppSizes.spacing8,
                      ),
                      minimumSize: const Size(60, 32),
                    ),
                    child: const Text('Delete'),
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
