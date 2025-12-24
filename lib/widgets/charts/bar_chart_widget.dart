import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/utils/responsive_helper.dart';
import 'dart:math' as math;

/// Reusable Bar Chart Widget for category comparisons
class BarChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final String? valuePrefix;
  final String? valueSuffix;
  final double height;

  const BarChartWidget({
    super.key,
    required this.data,
    this.valuePrefix,
    this.valueSuffix,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: AppColors.gray600),
          ),
        ),
      );
    }

    final maxValue = _getMaxValue();
    final interval = _calculateNiceInterval(maxValue);
    final adjustedMaxY = (maxValue / interval).ceil() * interval;

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: adjustedMaxY.toDouble(),
            minY: 0,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final label = data.keys.elementAt(groupIndex);
                  final value = rod.toY;
                  return BarTooltipItem(
                    '$label\n${valuePrefix ?? ''}${value.toStringAsFixed(0)}${valueSuffix ?? ''}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < data.length) {
                      final label = data.keys.elementAt(value.toInt());
                      final fontSize = ResponsiveHelper.getChartLabelFontSize(context);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          label.length > 10 ? '${label.substring(0, 10)}...' : label,
                          style: TextStyle(fontSize: fontSize),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: ResponsiveHelper.getAxisReservedSize(context),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: interval.toDouble(),
                  reservedSize: ResponsiveHelper.getAxisReservedSize(context, defaultSize: 50),
                  getTitlesWidget: (value, meta) {
                    final fontSize = ResponsiveHelper.getChartLabelFontSize(context);
                    return Text(
                      '${valuePrefix ?? ''}${_formatAxisValue(value)}${valueSuffix ?? ''}',
                      style: TextStyle(fontSize: fontSize),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
                left: BorderSide(color: AppColors.border),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval.toDouble(),
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppColors.gray200,
                  strokeWidth: 1,
                );
              },
            ),
            barGroups: _buildBarGroups(),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: const Color(0xFF2563EB),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  double _getMaxValue() {
    if (data.isEmpty) return 100;
    return data.values.reduce((a, b) => a > b ? a : b);
  }

  /// Calculate a nice interval for Y-axis labels
  /// Returns evenly spaced, round numbers
  int _calculateNiceInterval(double maxValue) {
    // Handle edge cases
    if (maxValue == 0 || maxValue.isNaN || maxValue.isInfinite) return 1;
    if (maxValue < 0) maxValue = maxValue.abs();
    
    // For small integer values (like asset counts), use interval of 1
    if (maxValue <= 10) return 1;
    
    // Target 4-6 intervals
    final roughInterval = maxValue / 5;
    
    // Handle very small values
    if (roughInterval < 1) {
      return 1;
    }
    
    // Get the magnitude (power of 10)
    final logValue = math.log(roughInterval) / math.ln10;
    if (logValue.isNaN || logValue.isInfinite) return 1;
    
    final magnitude = math.pow(10, logValue.floor()).toInt();
    if (magnitude == 0) return 1;
    
    // Normalize the interval to a value between 1 and 10
    final normalized = roughInterval / magnitude;
    
    // Round to nice numbers: 1, 2, 5, or 10
    int niceNormalized;
    if (normalized <= 1) {
      niceNormalized = 1;
    } else if (normalized <= 2) {
      niceNormalized = 2;
    } else if (normalized <= 5) {
      niceNormalized = 5;
    } else {
      niceNormalized = 10;
    }
    
    final result = niceNormalized * magnitude;
    return result > 0 ? result : 1;
  }

  /// Format axis value to avoid unnecessary decimals
  String _formatAxisValue(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}
