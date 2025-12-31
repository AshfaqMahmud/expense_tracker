import 'package:expense_tracker/data/chart/chart_data_service.dart';
import 'package:expense_tracker/data/database/db_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PremiumChartV2 extends StatefulWidget {
  const PremiumChartV2({super.key});
  @override
  State<StatefulWidget> createState() => _CategoryChartState();
}

class _CategoryChartState extends State<PremiumChartV2>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> _categoryData = [];
  List<Map<String, dynamic>> _monthlyData = [];
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late final ChartDataService _chartService;

  @override
  void initState() {
    super.initState();
    _chartService = ChartDataService(DatabaseHelper());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linearToEaseOut,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final categoryData = await _chartService.getCategoryData();
    final monthlyData = await _chartService.getMonthlyData();
    if (mounted) {
      setState(() {
        _categoryData = categoryData;
        _monthlyData = monthlyData;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          _buildAnimatedChartCard(
            title: 'SPENDING BY CATEGORY',
            color: Colors.blue,
            child: _categoryData.isEmpty
                ? const Center(child: Text('No Data to Show'))
                : _buildCategoryChart(),
          ),
          const SizedBox(height: 40),
          _buildChartCard(
            title: 'MONTHLY SPENDING',
            color: Colors.lightBlueAccent,
            child: _monthlyData.isEmpty
                ? const Center(child: Text('No Data to Show'))
                : _buildMonthlyChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedChartCard({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Transform.scale(
          scale: _animation.value,
          child: _buildChartCard(title: title, color: color, child: child),
        );
      },
    );
  }

  Widget _buildChartCard({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 220, child: child),
            if (title.contains('CATEGORY')) _buildCategoryLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 60,
        sections: _categoryData.map((data) {
          final value = (data['total'] as num).toDouble();
          return PieChartSectionData(
            color: _getCategoryColor(data['category']),
            value: value.isFinite ? value : 0,
            title: value.isFinite
                ? '${(value / 1000).toStringAsFixed(1)}K'
                : '0',
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            radius: 24,
            badgeWidget: _buildCategoryBadge(data['category']),
          );
        }).toList(),
      ),
    );
  }

  // Widget _buildMonthlyChart() {
  //   final maxValue = _monthlyData.fold<double>(0.0, (max, item) {
  //     try {
  //       final value = (item['total'] as num).toDouble();
  //       return value.isFinite ? (value > max ? value : max) : max;
  //     } catch (e) {
  //       return max;
  //     }
  //   });
  //
  //   // Define month names
  //   final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  //     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  //
  //
  //   return BarChart(
  //     BarChartData(
  //       alignment: BarChartAlignment.spaceEvenly,
  //       barTouchData: BarTouchData(
  //         enabled: true,
  //         touchTooltipData: BarTouchTooltipData(
  //           getTooltipItem: (group, groupIndex, rod, rodIndex) {
  //
  //             final monthIndex = group.x.toInt();
  //             final monthName = monthIndex < monthNames.length
  //                 ? monthNames[monthIndex]
  //                 : 'M${monthIndex + 1}';
  //             final value = rod.toY;
  //             return BarTooltipItem(
  //               // value.isFinite
  //               //     ? '\$${(value / 1000).toStringAsFixed(1)}K'
  //               //     : '\$0',
  //               '${monthName}\nBDT ${value.toInt()}',
  //               const TextStyle(color: Colors.black),
  //             );
  //           },
  //         ),
  //       ),
  //       titlesData: FlTitlesData(
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             getTitlesWidget: (value, meta) {
  //
  //               final index = value.toInt();
  //               if (index < 0 || index >= _monthlyData.length) {
  //                 return Container();
  //               }
  //
  //               String monthText;
  //               // Check if your data contains month information
  //               if (_monthlyData[index].containsKey('month')) {
  //                 // If data has month number (1-12)
  //                 final monthNum = _monthlyData[index]['month'];
  //                 if (monthNum is num) {
  //                   monthText = monthNames[(monthNum.toInt() - 1) % 12];
  //                 } else {
  //                   monthText = 'M${index + 1}';
  //                 }
  //               } else {
  //                 // Use short month names based on index
  //                 monthText = index < monthNames.length
  //                     ? monthNames[index]
  //                     : 'M${index + 1}';
  //               }
  //               return Padding(
  //                 padding: const EdgeInsets.only(top: 8.0),
  //                 child: Text(
  //                   //'M${value.toInt() + 1}',
  //                     monthText,
  //                   style: const TextStyle(fontSize: 11),
  //                 ),
  //               );
  //             },
  //             reservedSize: 20, // Adjusted to accommodate text
  //           ),
  //         ),
  //         rightTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             getTitlesWidget: (value, meta) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(left: 8.0),
  //                 child: Text(
  //                   value.isFinite ? 'BDT ${value.toInt()}' : '\$0',
  //                   style: const TextStyle(fontSize: 10),
  //                 ),
  //               );
  //             },
  //             reservedSize: 50,
  //           ),
  //         ),
  //         leftTitles: const AxisTitles(),
  //         topTitles: const AxisTitles(),
  //       ),
  //       gridData: const FlGridData(show: false),
  //       borderData: FlBorderData(show: false),
  //       barGroups: _monthlyData.map((data) {
  //         final value = (data['total'] as num).toDouble();
  //         return BarChartGroupData(
  //           x: _monthlyData.indexOf(data),
  //           barRods: [
  //             BarChartRodData(
  //               toY: value.isFinite ? value : 0,
  //               color: Colors.black,
  //               width: 18,
  //               borderRadius: BorderRadius.circular(6),
  //               backDrawRodData: BackgroundBarChartRodData(
  //                 show: true,
  //                 toY: maxValue > 0 ? maxValue * 1.1 : 1,
  //                 color: Colors.grey[200],
  //               ),
  //             ),
  //           ],
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _buildMonthlyChart() {
    // First, debug print the data
    print('=== MONTHLY DATA DEBUG ===');
    print('Number of months: ${_monthlyData.length}');

    if (_monthlyData.isEmpty) {
      return Center(
        child: Text('No monthly data available', style: TextStyle(color: Colors.grey)),
      );
    }

    for (int i = 0; i < _monthlyData.length; i++) {
      print('Month ${i + 1}: ${_monthlyData[i]}');
    }

    // Calculate max value
    double maxValue = 0;
    for (var data in _monthlyData) {
      try {
        final value = (data['total'] as num).toDouble();
        if (value.isFinite && value > maxValue) {
          maxValue = value;
        }
      } catch (e) {
        print('Error parsing value: $e');
      }
    }

    print('Max value: $maxValue');

    // Define month names
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // If maxValue is 0, set a default scale
    if (maxValue <= 0) {
      maxValue = 1000; // Default scale
    }

    return Container(
      height: 220, // Fixed height for the chart container
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: maxValue * 1.2, // Add 20% padding at top
          minY: 0,

          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final monthIndex = group.x.toInt();
                final monthName = monthIndex < monthNames.length
                    ? monthNames[monthIndex]
                    : 'M${monthIndex + 1}';
                final value = rod.toY;
                return BarTooltipItem(
                  '$monthName\nBDT ${value.toInt()}',
                  const TextStyle(color: Colors.white),
                );
              },
              //getTooltipColor: (group, groupIndex, rod, rodIndex) => Colors.black87,
            ),
          ),

          titlesData: FlTitlesData(
            show: true,

            // Bottom titles (months)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < _monthlyData.length) {
                    String monthText;

                    // Try to get month name from data
                    if (_monthlyData[index].containsKey('month')) {
                      final monthNum = _monthlyData[index]['month'];
                      if (monthNum is num) {
                        final monthIndex = (monthNum.toInt() - 1) % 12;
                        monthText = monthNames[monthIndex];
                      } else {
                        monthText = monthNames[index % 12];
                      }
                    } else {
                      monthText = monthNames[index % 12];
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        monthText,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
                reservedSize: 30,
              ),
            ),

            // Left titles (Y-axis values)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value >= 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        'BDT ${value.toInt()}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
                interval: maxValue / 5, // Show about 5 labels
                reservedSize: 40,
              ),
            ),

            // Remove right titles since we have left titles
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),

          // Enable grid for better visibility
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

          // Enable border
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey[400]!, width: 1),
              left: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
          ),

          // Bar groups
          barGroups: _monthlyData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;

            double value;
            try {
              value = (data['total'] as num).toDouble();
              if (!value.isFinite) value = 0;
            } catch (e) {
              print('Error converting value for index $index: $e');
              value = 0;
            }

            print('Bar group $index: value = $value');

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: Colors.blueAccent,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getCategoryColor(category),
      ),
      child: Icon(_getCategoryIcon(category), size: 16, color: Colors.white),
    );
  }

  Widget _buildCategoryLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: _categoryData.map((data) {
        final value = (data['total'] as num).toDouble();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getCategoryColor(data['category']),
              ),
            ),
            const SizedBox(width: 6),
            Text(data['category'], style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              value.isFinite
                  ? 'BDT ${(value / 1000).toStringAsFixed(1)}K'
                  : '\$0',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Food': Colors.amber,
      'Transport': Colors.blue,
      'Shopping': Colors.purple,
      'Entertainment': Colors.red,
      'Utilities': Colors.green,
    };
    return colors[category] ?? Colors.grey;
  }

  IconData _getCategoryIcon(String category) {
    const icons = {
      'Food': Icons.restaurant,
      'Transport': Icons.directions_car,
      'Shopping': Icons.shopping_bag,
      'Entertainment': Icons.movie,
      'Utilities': Icons.bolt,
    };
    return icons[category] ?? Icons.money;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
