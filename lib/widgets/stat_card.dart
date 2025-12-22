import 'package:flutter/material.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/models/dashboard_stats.dart';

/// Reusable statistics card widget
class StatCard extends StatelessWidget {
  final DashboardStats stats;

  const StatCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
            stats.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: AppSizes.spacing12),
          
          // Value
          Text(
            stats.displayValue,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Subtitle (if any)
          if (stats.subtitle != null) ...[
            const SizedBox(height: AppSizes.spacing8),
            Text(
              stats.subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
