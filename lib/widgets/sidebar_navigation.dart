import 'package:flutter/material.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';

/// Sidebar navigation widget
class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          right: BorderSide(
            color: AppColors.border,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo/Profile Section
          Container(
            height: AppSizes.headerHeight,
            padding: const EdgeInsets.all(AppSizes.spacing24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: AppColors.gray600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(
                  child: Text(
                    'Assets',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  index: 0,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.inventory_2_outlined,
                  label: 'Assets',
                  index: 1,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.account_tree_outlined,
                  label: 'Branches',
                  index: 2,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_outline,
                  label: 'Employees',
                  index: 3,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.store_outlined,
                  label: 'Vendors',
                  index: 4,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.assessment_outlined,
                  label: 'Reports',
                  index: 5,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  index: 6,
                ),
              ],
            ),
          ),
          
          // Profile Section at Bottom
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.gray600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Profile',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // Text(
                      //   'admin@company.com',
                      //   style: Theme.of(context).textTheme.bodySmall,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    
    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing12,
          vertical: AppSizes.spacing4,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gray100 : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSizes.iconLarge,
              color: isSelected ? AppColors.primary : AppColors.gray600,
            ),
            const SizedBox(width: AppSizes.spacing12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
