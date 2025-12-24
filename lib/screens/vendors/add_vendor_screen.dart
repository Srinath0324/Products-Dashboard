import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/data/models/vendor_model.dart';
import 'package:assets_dashboard/providers/vendor_provider.dart';

/// Create new vendor
class AddVendorScreen extends StatefulWidget {
  const AddVendorScreen({super.key});

  @override
  State<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vendorIdController = TextEditingController();
  final _vendorNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _vendorPhoneController = TextEditingController();
  final _vendorEmailController = TextEditingController();
  final _vendorTypeController = TextEditingController();
  final _productsOfferedController = TextEditingController();
  
  String? _selectedStatus;
  bool _isLoading = false;

  @override
  void dispose() {
    _vendorIdController.dispose();
    _vendorNameController.dispose();
    _contactPersonController.dispose();
    _vendorPhoneController.dispose();
    _vendorEmailController.dispose();
    _vendorTypeController.dispose();
    _productsOfferedController.dispose();
    super.dispose();
  }

  Future<void> _saveVendor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate all required fields
    if (_selectedStatus == null || _selectedStatus!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in: Vendor Status'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final vendor = VendorModel(
      id: '',
      vendorId: _vendorIdController.text.trim(),
      vendorName: _vendorNameController.text.trim(),
      contactPersonName: _contactPersonController.text.trim(),
      vendorPhoneNo: _vendorPhoneController.text.trim(),
      vendorEmail: _vendorEmailController.text.trim(),
      vendorType: _vendorTypeController.text.trim(),
      productsOffered: _productsOfferedController.text.trim(),
      vendorStatus: _selectedStatus ?? 'Active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await context.read<VendorProvider>().addVendor(vendor);

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vendor added successfully')),
      );
      Navigator.pop(context);
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
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  'Vendors Add Data',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing32),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Vendor Id', _vendorIdController)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildTextField('Vendor Name', _vendorNameController)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Contact Person Name', _contactPersonController)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildTextField('Vendor Phone No', _vendorPhoneController)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Vendor Email', _vendorEmailController)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildTextField('Vendor Type', _vendorTypeController)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Products Offered', _productsOfferedController, maxLines: 3)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildDropdown('Vendor Status*', _selectedStatus, statuses)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveVendor,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Save'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Placeholder',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text('Placeholder'),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (val) => setState(() => _selectedStatus = val),
          ),
        ),
      ],
    );
  }
}
