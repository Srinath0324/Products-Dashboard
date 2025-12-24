import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/models/report_models.dart';
import 'package:assets_dashboard/core/utils/responsive_helper.dart';

/// Reusable Pie/Donut Chart Widget for distribution data
class PieChartWidget extends StatelessWidget {
  final List<ChartDataItem> data;
  final bool isDonut;
  final double? size;

  const PieChartWidget({
    super.key,
    required this.data,
    this.isDonut = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final chartSize = size ?? ResponsiveHelper.getChartSize(context);
    final isVerySmall = ResponsiveHelper.isVerySmallScreen(context);
    
    if (data.isEmpty) {
      return SizedBox(
        height: chartSize,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: AppColors.gray600),
          ),
        ),
      );
    }

    return SizedBox(
      height: chartSize,
      child: isVerySmall
          ? Column(
              children: [
                // Chart on top for very small screens
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: _buildSections(context),
                      centerSpaceRadius: isDonut ? chartSize * 0.25 : 0,
                      sectionsSpace: 2,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Legend below
                SizedBox(
                  height: 100,
                  child: _buildLegend(context),
                ),
              ],
            )
          : Row(
              children: [
                // Chart
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sections: _buildSections(context),
                      centerSpaceRadius: isDonut ? chartSize * 0.25 : 0,
                      sectionsSpace: 2,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Legend
                Expanded(
                  flex: 1,
                  child: _buildLegend(context),
                ),
              ],
            ),
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    final colors = _getColors();
    final isMobile = ResponsiveHelper.isMobile(context);
    final radius = isDonut ? (isMobile ? 40.0 : 50.0) : (isMobile ? 60.0 : 80.0);
    final fontSize = isMobile ? 10.0 : 12.0;
    
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      
      return PieChartSectionData(
        value: item.value,
        title: '${item.value.toStringAsFixed(1)}%',
        color: colors[index % colors.length],
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(BuildContext context) {
    final colors = _getColors();
    final isMobile = ResponsiveHelper.isMobile(context);
    final fontSize = isMobile ? 11.0 : 12.0;
    final subFontSize = isMobile ? 9.0 : 10.0;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: isMobile ? 12 : 16,
                  height: isMobile ? 12 : 16,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item.count} items',
                        style: TextStyle(
                          fontSize: subFontSize,
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Color> _getColors() {
    return [
      const Color(0xFF2563EB), // Blue
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEC4899), // Pink
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFF97316), // Orange
    ];
  }
}
