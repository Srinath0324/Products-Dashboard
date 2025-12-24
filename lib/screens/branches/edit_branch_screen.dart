import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/date_formatter.dart';
import 'package:assets_dashboard/data/models/branch_model.dart';
import 'package:assets_dashboard/providers/branch_provider.dart';

/// Edit Branch Screen - Update existing branch
class EditBranchScreen extends StatefulWidget {
  final BranchModel branch;

  const EditBranchScreen({
    super.key,
    required this.branch,
  });

  @override
  State<EditBranchScreen> createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _branchIdController;
  late TextEditingController _branchNameController;
  late TextEditingController _branchCountryController;
  late TextEditingController _branchPhoneController;
  late TextEditingController _managerNameController;
  late TextEditingController _managerPhoneController;
  
  String? _selectedStatus;
  DateTime? _selectedDate;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _branchIdController = TextEditingController(text: widget.branch.branchId);
    _branchNameController = TextEditingController(text: widget.branch.branchName);
    _branchCountryController = TextEditingController(text: widget.branch.branchCountry);
    _branchPhoneController = TextEditingController(text: widget.branch.branchPhoneNo);
    _managerNameController = TextEditingController(text: widget.branch.managerName);
    _managerPhoneController = TextEditingController(text: widget.branch.managerPhoneNo);
    
    _selectedStatus = widget.branch.status;
    _selectedDate = widget.branch.date;
  }

  @override
  void dispose() {
    _branchIdController.dispose();
    _branchNameController.dispose();
    _branchCountryController.dispose();
    _branchPhoneController.dispose();
    _managerNameController.dispose();
    _managerPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateBranch() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate all required fields
    List<String> missingFields = [];
    
    if (_selectedStatus == null || _selectedStatus!.isEmpty) {
      missingFields.add('Status');
    }
    if (_selectedDate == null) {
      missingFields.add('Date');
    }

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in: ${missingFields.join(', ')}'),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedBranch = widget.branch.copyWith(
      branchId: _branchIdController.text.trim(),
      branchName: _branchNameController.text.trim(),
      branchCountry: _branchCountryController.text.trim(),
      branchPhoneNo: _branchPhoneController.text.trim(),
      managerName: _managerNameController.text.trim(),
      managerPhoneNo: _managerPhoneController.text.trim(),
      status: _selectedStatus,
      date: _selectedDate,
      updatedAt: DateTime.now(),
    );

    final success = await context.read<BranchProvider>().updateBranch(
      widget.branch.id,
      updatedBranch,
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Branch updated successfully')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<BranchProvider>().error ?? 'Failed to update branch',
          ),
        ),
      );
    }
  }

  Future<void> _deleteBranch() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Branch'),
        content: Text('Are you sure you want to delete ${widget.branch.branchName}?'),
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

      final success = await context.read<BranchProvider>().deleteBranch(widget.branch.id);

      setState(() {
        _isLoading = false;
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Branch deleted successfully')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<BranchProvider>().error ?? 'Failed to delete branch',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuses = ['Active', 'Inactive'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  'Edit Branch',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spacing32),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Row 1: Branch ID and Branch Name
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Branch Id',
                          controller: _branchIdController,
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
                        child: _buildTextField(
                          label: 'Branch Name',
                          controller: _branchNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing24),

                  // Row 2: Branch Country and Branch Phone No
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Branch Country',
                          controller: _branchCountryController,
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
                        child: _buildTextField(
                          label: 'Branch Phone No',
                          controller: _branchPhoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing24),

                  // Row 3: Manager Name and Manager Phone No
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Manager Name',
                          controller: _managerNameController,
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
                        child: _buildTextField(
                          label: 'Manager Phone No',
                          controller: _managerPhoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing24),

                  // Row 4: Status and Date
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
                          label: 'Date*',
                          selectedDate: _selectedDate,
                          onTap: () => _selectDate(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacing32),

                  // Action Buttons
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateBranch,
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
                        onPressed: _isLoading ? null : _deleteBranch,
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
              ),
            ),
          ],
        ),
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
