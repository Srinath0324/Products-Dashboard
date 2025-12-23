import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/date_formatter.dart';
import 'package:assets_dashboard/data/models/asset_model.dart';
import 'package:assets_dashboard/providers/asset_provider.dart';
import 'package:assets_dashboard/providers/settings_provider.dart';
import 'package:assets_dashboard/providers/employee_provider.dart';

/// Edit Asset Screen - Update existing asset
class EditAssetScreen extends StatefulWidget {
  final AssetModel asset;

  const EditAssetScreen({
    super.key,
    required this.asset,
  });

  @override
  State<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends State<EditAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _assetIdController;
  late TextEditingController _nameController;
  late TextEditingController _costController;
  
  String? _selectedCategory;
  String? _selectedAssignedTo;
  String? _selectedStatus;
  String? _selectedCondition;
  DateTime? _selectedDate;
  DateTime? _selectedWarranty;

  bool _isLoading = false;
  bool _showOverview = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _assetIdController = TextEditingController(text: widget.asset.assetId);
    _nameController = TextEditingController(text: widget.asset.name);
    _costController = TextEditingController(text: widget.asset.cost.toString());
    
    _selectedCategory = widget.asset.category;
    _selectedAssignedTo = widget.asset.assignedTo;
    _selectedStatus = widget.asset.status;
    _selectedCondition = widget.asset.condition;
    _selectedDate = widget.asset.date;
    _selectedWarranty = widget.asset.warranty;

    // Load employees for assignee dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeProvider>().loadEmployees();
    });
  }

  @override
  void dispose() {
    _assetIdController.dispose();
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isWarranty) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isWarranty ? _selectedWarranty ?? DateTime.now() : _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isWarranty) {
          _selectedWarranty = picked;
        } else {
          _selectedDate = picked;
        }
      });
    }
  }

  Future<void> _updateAsset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _selectedWarranty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and warranty')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedAsset = widget.asset.copyWith(
      assetId: _assetIdController.text.trim(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      assignedTo: _selectedAssignedTo,
      date: _selectedDate,
      cost: double.tryParse(_costController.text.trim()) ?? 0.0,
      status: _selectedStatus,
      warranty: _selectedWarranty,
      condition: _selectedCondition,
      updatedAt: DateTime.now(),
    );

    final success = await context.read<AssetProvider>().updateAsset(
      widget.asset.id,
      updatedAsset,
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asset updated successfully')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<AssetProvider>().error ?? 'Failed to update asset',
          ),
        ),
      );
    }
  }

  Future<void> _deleteAsset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: Text('Are you sure you want to delete ${widget.asset.name}?'),
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

    if (confirmed == true && mounted) {
      setState(() {
        _isLoading = true;
      });

      final success = await context.read<AssetProvider>().deleteAsset(widget.asset.id);

      setState(() {
        _isLoading = false;
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset deleted successfully')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<AssetProvider>().error ?? 'Failed to delete asset',
            ),
          ),
        );
      }
    }
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
            // Header with tabs
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showOverview = true;
                    });
                  },
                  child: Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: _showOverview ? FontWeight.bold : FontWeight.normal,
                      color: _showOverview ? AppColors.textPrimary : AppColors.gray600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showOverview = false;
                    });
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: !_showOverview ? FontWeight.bold : FontWeight.normal,
                      color: !_showOverview ? AppColors.textPrimary : AppColors.gray600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spacing32),

            // Content
            _showOverview ? _buildOverview() : _buildEditForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.asset.name} Overview',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: AppSizes.spacing32),

        // Overview Grid
        Container(
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
            children: [
              _buildOverviewRow('Name', widget.asset.name, 'Condition', widget.asset.condition, 'Warranty', DateFormatter.isWarrantyExpired(widget.asset.warranty) ? 'Expired' : 'Valid'),
              const SizedBox(height: AppSizes.spacing24),
              _buildOverviewRow('Category', widget.asset.category, 'Cost', '\$${widget.asset.cost.toStringAsFixed(0)}', 'Assigned To', widget.asset.assignedTo),
              const SizedBox(height: AppSizes.spacing24),
              _buildOverviewRow('Branch', 'Banglore', 'Service Date', DateFormatter.formatDate(widget.asset.date), '', ''),
            ],
          ),
        ),

        const SizedBox(height: AppSizes.spacing32),

        // Linked Accounts Section
        Text(
          'Linked Accounts',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
              ),
        ),
      ],
    );
  }

  Widget _buildOverviewRow(String label1, String value1, String label2, String value2, String label3, String value3) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        if (label2.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value2,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        if (label3.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label3,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value3,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Consumer2<SettingsProvider, EmployeeProvider>(
        builder: (context, settingsProvider, employeeProvider, child) {
          final categories = settingsProvider.assetCategories;
          final statuses = settingsProvider.assetStatuses;
          final employees = employeeProvider.getEmployeeNames();
          final conditions = ['Good', 'Fair', 'Poor'];

          return Column(
            children: [
              // Row 1: Asset ID and Category
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Asset Id*',
                      controller: _assetIdController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing24),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Category*',
                      value: _selectedCategory,
                      items: categories,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spacing24),

              // Row 2: Name and Assigned To
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Name*',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing24),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Assigned To*',
                      value: _selectedAssignedTo,
                      items: employees,
                      onChanged: (value) {
                        setState(() {
                          _selectedAssignedTo = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spacing24),

              // Row 3: Date and Cost
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'Date*',
                      selectedDate: _selectedDate,
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing24),
                  Expanded(
                    child: _buildTextField(
                      label: 'Cost*',
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spacing24),

              // Row 4: Status and Warranty
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Status*',
                      value: _selectedStatus,
                      items: statuses,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing24),
                  Expanded(
                    child: _buildDateField(
                      label: 'Warranty*',
                      selectedDate: _selectedWarranty,
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spacing24),

              // Row 5: Condition
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Condition*',
                      value: _selectedCondition,
                      items: conditions,
                      onChanged: (value) {
                        setState(() {
                          _selectedCondition = value;
                        });
                      },
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),

              const SizedBox(height: AppSizes.spacing32),

              // Action Buttons
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateAsset,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacing32,
                          vertical: AppSizes.spacing16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Update',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: _isLoading ? null : _deleteAsset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing32,
                        vertical: AppSizes.spacing16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
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
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing16,
            vertical: AppSizes.spacing4,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border,
              width: AppSizes.borderThin,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: DropdownButton<String>(
            value: items.contains(value) ? value : null,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text('Select'),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing16,
              vertical: AppSizes.spacing12,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.border,
                width: AppSizes.borderThin,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormatter.formatDate(selectedDate)
                      : 'Select date',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selectedDate != null
                            ? AppColors.textPrimary
                            : AppColors.gray600,
                      ),
                ),
                const Icon(Icons.calendar_today, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
