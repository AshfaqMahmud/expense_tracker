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
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
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
                ? const Center(child: CircularProgressIndicator())
                : _buildCategoryChart(),
          ),
          const SizedBox(height: 24),
          _buildChartCard(
            title: 'MONTHLY SPENDING',
            color: Colors.lightBlueAccent,
            child: _monthlyData.isEmpty
                ? const Center(child: CircularProgressIndicator())
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
            colors: [
              const Color.fromARGB(26, 192, 191, 191),
              const Color.fromARGB(179, 231, 230, 230),
            ],
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

  Widget _buildMonthlyChart() {
    final maxValue = _monthlyData.fold<double>(0.0, (max, item) {
      try {
        final value = (item['total'] as num).toDouble();
        return value.isFinite ? (value > max ? value : max) : max;
      } catch (e) {
        return max;
      }
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final value = rod.toY;
              return BarTooltipItem(
                value.isFinite
                    ? '\$${(value / 1000).toStringAsFixed(1)}K'
                    : '\$0',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'M${value.toInt() + 1}',
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },
              reservedSize: 20, // Adjusted to accommodate text
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    value.isFinite ? '\$${value.toInt()}K' : '\$0',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 50,
            ),
          ),
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: _monthlyData.map((data) {
          final value = (data['total'] as num).toDouble();
          return BarChartGroupData(
            x: _monthlyData.indexOf(data),
            barRods: [
              BarChartRodData(
                toY: value.isFinite ? value : 0,
                color: Colors.black,
                width: 18,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxValue > 0 ? maxValue * 1.1 : 1,
                  color: Colors.grey[200],
                ),
              ),
            ],
          );
        }).toList(),
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
                  ? '\$${(value / 1000).toStringAsFixed(1)}K'
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
