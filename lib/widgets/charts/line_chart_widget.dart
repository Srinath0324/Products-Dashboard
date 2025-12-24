import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/models/report_models.dart';
import 'package:intl/intl.dart';
import 'package:assets_dashboard/core/utils/responsive_helper.dart';

/// Reusable Line Chart Widget for timeline data
class LineChartWidget extends StatelessWidget {
  final List<TimelineDataPoint> data;
  final String? yAxisLabel;
  final double height;

  const LineChartWidget({
    super.key,
    required this.data,
    this.yAxisLabel,
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

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final dataPoint = data[spot.x.toInt()];
                    return LineTooltipItem(
                      '${dataPoint.label}\n${dataPoint.value.toInt()} assets',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _getMaxValue() / 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppColors.gray200,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: ResponsiveHelper.getAxisReservedSize(context),
                  interval: data.length > 6 ? (data.length / 6).ceilToDouble() : 1,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < data.length) {
                      final dataPoint = data[value.toInt()];
                      final fontSize = ResponsiveHelper.getChartLabelFontSize(context);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _formatDate(dataPoint.date),
                          style: TextStyle(fontSize: fontSize),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: ResponsiveHelper.getAxisReservedSize(context),
                  getTitlesWidget: (value, meta) {
                    final fontSize = ResponsiveHelper.getChartLabelFontSize(context);
                    return Text(
                      value.toInt().toString(),
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
            minX: 0,
            maxX: (data.length - 1).toDouble(),
            minY: 0,
            maxY: _getMaxValue() * 1.2,
            lineBarsData: [
              LineChartBarData(
                spots: _buildSpots(),
                isCurved: true,
                color: const Color(0xFF2563EB),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
  }

  double _getMaxValue() {
    if (data.isEmpty) return 10;
    return data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM yy').format(date);
  }
}
