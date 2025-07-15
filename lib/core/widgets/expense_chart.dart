import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryChart extends StatelessWidget {
  final List<Map<String, dynamic>> categoryData;

  const CategoryChart({super.key, required this.categoryData});

  @override
  Widget build(Object context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            //tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '\$${rod.toY.toStringAsFixed(0)}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              //getTitlesWidget: rightTitles,
              reservedSize: 50,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              //getTitlesWidget: bottomTitles,
            ),
          ),
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: categoryData.map((data) {
          return BarChartGroupData(
            x: categoryData.indexOf(data),
            barRods: [
              BarChartRodData(
                toY: (data['total'] as num).toDouble(),
                color: Colors.blue[400],
                width: 30,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class MonthlyChart extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;
  const MonthlyChart({super.key, required this.monthlyData});
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: monthlyData.asMap().entries.map((entry) {
          final idx = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: idx,
            barRods: [
              BarChartRodData(
                toY: (data['total'] as num).toDouble(),
                color: Colors.blueAccent,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final month = monthlyData[value.toInt()]['month'];
                return Text(
                  month.padLeft(2, '0'), // Formats as "01", "02" etc.
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
