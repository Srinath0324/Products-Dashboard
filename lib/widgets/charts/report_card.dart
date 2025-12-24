import 'package:flutter/material.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/responsive_helper.dart';

/// Reusable card container for report sections
class ReportCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? action;
  final double? minHeight;

  const ReportCard({
    super.key,
    required this.title,
    required this.child,
    this.action,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getCardPadding(context);
    
    return Container(
      constraints: minHeight != null 
          ? BoxConstraints(minHeight: minHeight!)
          : null,
      padding: padding,
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
        children: [
          // Header with title and optional action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (action != null) action!,
            ],
          ),
          SizedBox(height: ResponsiveHelper.getCardSpacing(context)),
          // Content
          Expanded(child: child),
        ],
      ),
    );
  }
}
