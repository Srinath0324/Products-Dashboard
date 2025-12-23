import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/providers/settings_provider.dart';

/// Settings Screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _branchMapping = true;
  bool _vendorLinking = true;
  bool _beforeAssigning = false;
  bool _disposingAsset = false;
  bool _agreeTerms = false;

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
            Text(
              'Settings',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 32),

            // Asset Categories
            _buildSectionTitle(context, 'Asset Categories'),
            const SizedBox(height: 8),
            _buildDropdown(context, 'Placeholder'),

            const SizedBox(height: 24),

            // Asset Status
            _buildSectionTitle(context, 'Asset Status'),
            const SizedBox(height: 8),
            _buildRadioOption(context, 'Active', true),
            _buildRadioOption(context, 'InActive', false),
            _buildRadioOption(context, 'Assigned', false),
            _buildRadioOption(context, 'Returned', false),

            const SizedBox(height: 24),

            // Notification
            _buildSectionTitle(context, 'Notification'),
            const SizedBox(height: 8),
            _buildTextField(context, 'Placeholder'),

            const SizedBox(height: 24),

            // Branch/Department Mapping
            _buildSectionTitle(context, 'Branch/Department Mapping'),
            const SizedBox(height: 4),
            Text(
              'Map The Branch or Document Together',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue),
            ),
            const SizedBox(height: 8),
            _buildToggleOption(context, 'Yes', true, _branchMapping, (val) => setState(() => _branchMapping = val)),
            _buildToggleOption(context, 'No', false, _branchMapping, (val) => setState(() => _branchMapping = val)),

            const SizedBox(height: 24),

            // Vendor/Supplier Linking
            _buildSectionTitle(context, 'Vendor/ Supplier Linking'),
            const SizedBox(height: 4),
            Text(
              'Link The Vendor or Suplier Together',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue),
            ),
            const SizedBox(height: 8),
            _buildToggleOption(context, 'Yes', true, _vendorLinking, (val) => setState(() => _vendorLinking = val)),
            _buildToggleOption(context, 'No', false, _vendorLinking, (val) => setState(() => _vendorLinking = val)),

            const SizedBox(height: 24),

            // Depreciation/Financial Rule
            _buildSectionTitle(context, 'Depreciation/Financial Rule'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque. Duis vulputate commodo lectus, ac blandit elit tincidunt id. Sed rhoncus, tortor sed eleifend tristique, tortor mauris molestie elit, et lacinia ipsum quam nec dui.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),

            const SizedBox(height: 16),

            _buildCheckbox(context, 'Agree To Terms and Conditions Applied', _agreeTerms, (val) => setState(() => _agreeTerms = val ?? false)),

            const SizedBox(height: 24),

            // Approval Workflow
            _buildSectionTitle(context, 'Approval Workflow'),
            const SizedBox(height: 8),
            _buildCheckbox(context, 'Before Assigning', _beforeAssigning, (val) => setState(() => _beforeAssigning = val ?? false)),
            const SizedBox(height: 8),
            _buildCheckbox(context, 'Disposing Asset', _disposingAsset, (val) => setState(() => _disposingAsset = val ?? false)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildDropdown(BuildContext context, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildTextField(BuildContext context, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(hint, style: TextStyle(color: AppColors.gray400)),
    );
  }

  Widget _buildRadioOption(BuildContext context, String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            size: 20,
            color: selected ? Colors.blue : AppColors.gray600,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildToggleOption(BuildContext context, String label, bool value, bool currentValue, Function(bool) onChanged) {
    final isSelected = currentValue == value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onChanged(value),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.transparent,
                border: Border.all(color: isSelected ? Colors.blue : AppColors.gray400, width: 2),
              ),
              child: isSelected
                  ? const Icon(Icons.circle, size: 12, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: isSelected ? Colors.blue : AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context, String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label),
      ],
    );
  }
}
