import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/date_formatter.dart';
import 'package:assets_dashboard/core/utils/responsive_helper.dart';
import 'package:assets_dashboard/providers/reports_provider.dart';
import 'package:assets_dashboard/widgets/charts/pie_chart_widget.dart';
import 'package:assets_dashboard/widgets/charts/bar_chart_widget.dart';
import 'package:assets_dashboard/widgets/charts/line_chart_widget.dart';
import 'package:assets_dashboard/widgets/charts/report_card.dart';

/// Dynamic Reports and Analytics Screen
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedDateFilter = 'All Time';
  final List<String> _dateFilterOptions = [
    'All Time',
    'Last 30 Days',
    'Last 90 Days',
    'Last 6 Months',
    'Last Year',
  ];

  @override
  void initState() {
    super.initState();
    // Load reports data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsProvider>().streamReportsData();
    });
  }

  void _applyDateFilter(String filter) {
    final provider = context.read<ReportsProvider>();
    final now = DateTime.now();
    DateTime? startDate;

    switch (filter) {
      case 'Last 30 Days':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 'Last 90 Days':
        startDate = now.subtract(const Duration(days: 90));
        break;
      case 'Last 6 Months':
        startDate = DateTime(now.year, now.month - 6, now.day);
        break;
      case 'Last Year':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = null;
    }

    provider.setDateRange(startDate, null);
    setState(() {
      _selectedDateFilter = filter;
    });
  }

  void _exportData() {
    final provider = context.read<ReportsProvider>();
    final csvData = provider.exportAsCSV();
    
    // Show export dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('CSV data is ready for export.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${provider.assets.length} assets will be exported',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, this would trigger file download
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export functionality ready (CSV data prepared)'),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Download CSV'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ReportsProvider>(
        builder: (context, reportsProvider, child) {
          // Show loading indicator
          if (reportsProvider.isLoading && reportsProvider.assets.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error message
          if (reportsProvider.error != null && reportsProvider.assets.isEmpty) {
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
                    'Error loading reports',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reportsProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      reportsProvider.loadReportsData();
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

                // Financial Overview Cards
                _buildFinancialOverview(reportsProvider),

                SizedBox(height: ResponsiveHelper.getSpacing(context)),

                // Distribution Charts Section
                _buildDistributionSection(reportsProvider),

                SizedBox(height: ResponsiveHelper.getSpacing(context)),

                // Timeline Analysis
                _buildTimelineSection(reportsProvider),

                SizedBox(height: ResponsiveHelper.getSpacing(context)),

                // Top Assets and Category Breakdown
                _buildTopAssetsSection(reportsProvider),

                SizedBox(height: ResponsiveHelper.getSpacing(context)),

                // Warranty Alerts
                _buildWarrantySection(reportsProvider),

                SizedBox(height: ResponsiveHelper.getSpacing(context)),

                // Recent Activity
                _buildActivitySection(reportsProvider),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports and Analytics',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Date filter dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(
                      color: AppColors.border,
                      width: AppSizes.borderThin,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedDateFilter,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textPrimary,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    items: _dateFilterOptions.map((String filter) {
                      return DropdownMenuItem<String>(
                        value: filter,
                        child: Text(filter),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _applyDateFilter(newValue);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Export button
              OutlinedButton.icon(
                onPressed: _exportData,
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Export'),
              ),
            ],
          ),
        ],
      );
    }
    
    // Desktop/Tablet layout
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Reports and Analytics',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            // Date filter dropdown
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing16,
                vertical: AppSizes.spacing8,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(
                  color: AppColors.border,
                  width: AppSizes.borderThin,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: DropdownButton<String>(
                value: _selectedDateFilter,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                items: _dateFilterOptions.map((String filter) {
                  return DropdownMenuItem<String>(
                    value: filter,
                    child: Text(filter),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _applyDateFilter(newValue);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            // Export button
            OutlinedButton.icon(
              onPressed: _exportData,
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Export'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialOverview(ReportsProvider provider) {
    final valueReport = provider.getAssetValueReport();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = ResponsiveHelper.getColumnCount(context, maxColumns: 3);
        final spacing = ResponsiveHelper.getCardSpacing(context);
        final availableWidth = constraints.maxWidth;
        final totalSpacing = spacing * (columnCount - 1);
        final cardWidth = (availableWidth - totalSpacing) / columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                'Total Asset Value',
                '\$${valueReport.totalValue.toStringAsFixed(0)}',
                Icons.account_balance_wallet,
                Colors.blue,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                'Average Asset Value',
                '\$${valueReport.averageValue.toStringAsFixed(0)}',
                Icons.analytics,
                Colors.green,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                'Total Assets',
                '${valueReport.totalAssets}',
                Icons.inventory_2,
                Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    final iconSize = ResponsiveHelper.getIconSize(context);
    
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionSection(ReportsProvider provider) {
    final distribution = provider.getDistributionReport();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asset Distribution',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columnCount = ResponsiveHelper.getColumnCount(context, maxColumns: 3);
            final spacing = ResponsiveHelper.getCardSpacing(context);
            final chartHeight = ResponsiveHelper.getChartHeight(context, defaultHeight: 350);
            final availableWidth = constraints.maxWidth;
            final totalSpacing = spacing * (columnCount - 1);
            final cardWidth = (availableWidth - totalSpacing) / columnCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                // Status Distribution
                SizedBox(
                  width: cardWidth,
                  height: chartHeight,
                  child: ReportCard(
                    title: 'Assets by Status',
                    child: PieChartWidget(
                      data: provider.getChartData(distribution.byStatus),
                      isDonut: false,
                    ),
                  ),
                ),
                // Category Distribution
                SizedBox(
                  width: cardWidth,
                  height: chartHeight,
                  child: ReportCard(
                    title: 'Assets by Category',
                    child: BarChartWidget(
                      data: distribution.byCategory.map(
                        (key, value) => MapEntry(key, value.toDouble()),
                      ),
                    ),
                  ),
                ),
                // Condition Distribution
                SizedBox(
                  width: cardWidth,
                  height: chartHeight,
                  child: ReportCard(
                    title: 'Assets by Condition',
                    child: PieChartWidget(
                      data: provider.getChartData(distribution.byCondition),
                      isDonut: true,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimelineSection(ReportsProvider provider) {
    final timeline = provider.getAcquisitionTimeline();
    final chartHeight = ResponsiveHelper.getChartHeight(context, defaultHeight: 350);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline Analysis',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: chartHeight,
          child: ReportCard(
            title: 'Asset Acquisition Timeline',
            child: LineChartWidget(
              data: timeline,
              yAxisLabel: 'Assets',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopAssetsSection(ReportsProvider provider) {
    final valueReport = provider.getAssetValueReport();
    final categoryBreakdown = provider.getCategoryBreakdown();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columnCount = ResponsiveHelper.getColumnCount(context, maxColumns: 2);
            final spacing = ResponsiveHelper.getCardSpacing(context);
            final chartHeight = ResponsiveHelper.getChartHeight(context, defaultHeight: 400);
            final availableWidth = constraints.maxWidth;
            final totalSpacing = spacing * (columnCount - 1);
            final cardWidth = (availableWidth - totalSpacing) / columnCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                // Top 5 Assets by Value
                SizedBox(
                  width: cardWidth,
                  height: chartHeight,
                  child: ReportCard(
                    title: 'Top 5 Assets by Value',
                    child: valueReport.topAssetsByValue.isEmpty
                        ? Center(
                            child: Text(
                              'No assets available',
                              style: TextStyle(color: AppColors.gray600),
                            ),
                          )
                        : ListView.builder(
                            itemCount: valueReport.topAssetsByValue.length,
                            itemBuilder: (context, index) {
                              final asset = valueReport.topAssetsByValue[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.gray100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2563EB).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2563EB),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            asset.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${asset.assetId} • ${asset.category}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.gray600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '\$${asset.value.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
                // Category Value Breakdown
                SizedBox(
                  width: cardWidth,
                  height: chartHeight,
                  child: ReportCard(
                    title: 'Value by Category',
                    child: categoryBreakdown.isEmpty
                        ? Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(color: AppColors.gray600),
                            ),
                          )
                        : BarChartWidget(
                            data: Map.fromEntries(
                              categoryBreakdown.map(
                                (cb) => MapEntry(cb.category, cb.totalValue),
                              ),
                            ),
                            valuePrefix: '\$',
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildWarrantySection(ReportsProvider provider) {
    final warrantyReport = provider.getWarrantyReport();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Warranty Alerts',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = ResponsiveHelper.isMobile(context);
            final columnCount = isMobile ? 2 : 4; // 2x2 grid on mobile, 4 columns on desktop
            final spacing = ResponsiveHelper.getCardSpacing(context);
            final availableWidth = constraints.maxWidth;
            final totalSpacing = spacing * (columnCount - 1);
            final cardWidth = (availableWidth - totalSpacing) / columnCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _buildWarrantyCard(
                    'Expired',
                    warrantyReport.expiredCount,
                    Colors.red,
                    Icons.warning,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildWarrantyCard(
                    'Expiring in 30 Days',
                    warrantyReport.expiringSoon30Days,
                    Colors.orange,
                    Icons.schedule,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildWarrantyCard(
                    'Expiring in 60 Days',
                    warrantyReport.expiringSoon60Days,
                    Colors.amber,
                    Icons.access_time,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildWarrantyCard(
                    'Active Warranties',
                    warrantyReport.activeWarranties,
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
              ],
            );
          },
        ),
        if (warrantyReport.expiringAssets.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: ReportCard(
              title: 'Assets with Expiring Warranties (30 Days)',
              child: ListView.builder(
                itemCount: warrantyReport.expiringAssets.length,
                itemBuilder: (context, index) {
                  final item = warrantyReport.expiringAssets[index];
                  return ListTile(
                    leading: Icon(
                      Icons.warning_amber,
                      color: item.daysRemaining <= 7 ? Colors.red : Colors.orange,
                    ),
                    title: Text(item.name),
                    subtitle: Text(
                      '${item.assetId} • Expires: ${DateFormatter.formatDate(item.warrantyDate)}',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: item.daysRemaining <= 7
                            ? Colors.red.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${item.daysRemaining} days',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: item.daysRemaining <= 7 ? Colors.red : Colors.orange,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWarrantyCardWrapper(int columnCount, Widget child) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = ResponsiveHelper.getPadding(context);
    final spacing = ResponsiveHelper.getCardSpacing(context);
    final availableWidth = screenWidth - (padding * 2);
    final totalSpacing = spacing * (columnCount - 1);
    final cardWidth = (availableWidth - totalSpacing) / columnCount;

    return SizedBox(
      width: cardWidth,
      child: child,
    );
  }

  Widget _buildWarrantyCard(String title, int count, Color color, IconData icon) {
    final iconSize = ResponsiveHelper.getIconSize(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
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
          Icon(icon, color: color, size: iconSize),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(ReportsProvider provider) {
    final activities = provider.getRecentActivity(limit: 10);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 400,
          child: ReportCard(
            title: 'Latest Asset Updates',
            child: activities.isEmpty
                ? Center(
                    child: Text(
                      'No recent activity',
                      style: TextStyle(color: AppColors.gray600),
                    ),
                  )
                : ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return ListTile(
                        leading: _getActivityIcon(activity.activityType),
                        title: Text(activity.assetName),
                        subtitle: Text(
                          '${activity.assetId} • ${activity.details ?? activity.activityType}',
                        ),
                        trailing: Text(
                          DateFormatter.formatDate(activity.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gray600,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _getActivityIcon(String activityType) {
    IconData icon;
    Color color;

    switch (activityType) {
      case 'created':
        icon = Icons.add_circle;
        color = Colors.green;
        break;
      case 'assigned':
        icon = Icons.person_add;
        color = Colors.blue;
        break;
      case 'status_change':
        icon = Icons.sync;
        color = Colors.orange;
        break;
      default:
        icon = Icons.update;
        color = Colors.grey;
    }

    return Icon(icon, color: color);
  }
}
