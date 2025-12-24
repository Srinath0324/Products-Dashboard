import 'package:flutter/material.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/responsive_helper.dart';
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
    final isMobile = ResponsiveHelper.isMobile(context);
    final cardPadding = isMobile ? 12.0 : AppSizes.spacing24;
    final valueFontSize = isMobile ? 24.0 : 36.0;
    final spacing = isMobile ? 6.0 : AppSizes.spacing12;
    
    return Container(
      padding: EdgeInsets.all(cardPadding),
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
          Flexible(
            child: Text(
              stats.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 12 : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          SizedBox(height: spacing),
          
          // Value
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                stats.displayValue,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Subtitle (if any)
          if (stats.subtitle != null) ...[
            SizedBox(height: spacing / 2),
            Flexible(
              child: Text(
                stats.subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: isMobile ? 10 : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
