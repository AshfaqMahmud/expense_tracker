import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> _monthlyData = [
    {'month': 1, 'total': 45000.0},
    {'month': 2, 'total': 32000.0},
    {'month': 3, 'total': 51000.0},
    {'month': 4, 'total': 28000.0},
    {'month': 5, 'total': 39000.0},
    {'month': 6, 'total': 47000.0},
    {'month': 7, 'total': 55000.0},
    {'month': 8, 'total': 42000.0},
    {'month': 9, 'total': 38000.0},
    {'month': 10, 'total': 49000.0},
    {'month': 11, 'total': 33000.0},
    {'month': 12, 'total': 52000.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(
            'MONTHLY SPENDING',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 300, // Fixed height for chart
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: _buildMonthlyChart(),
        ),
      ],
    );
  }

  Widget _buildMonthlyChart() {
    if (_monthlyData.isEmpty) {
      return Center(child: Text('No data available'));
    }

    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // Find max value for scaling
    double maxValue = 0;
    for (var data in _monthlyData) {
      final value = (data['total'] as num).toDouble();
      if (value > maxValue) maxValue = value;
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(

            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final monthIndex = group.x.toInt();
              final monthName = monthNames[monthIndex];
              final value = rod.toY.toInt();
              return BarTooltipItem(
                '$monthName\nBDT ${value.toStringAsFixed(0)}',
                TextStyle(color: Colors.white, fontSize: 12),
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
                final index = value.toInt();
                if (index >= 0 && index < _monthlyData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      monthNames[index],
                      style: TextStyle(fontSize: 10),
                    ),
                  );
                }
                return Container();
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    'BDT ${(value ~/ 1000)}K',
                    style: TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200],
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            left: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        barGroups: _monthlyData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final value = (data['total'] as num).toDouble();

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: Colors.blueAccent,
                width: 16,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }).toList(),
        maxY: maxValue * 1.2, // Add 20% padding on top
      ),
    );
  }
}