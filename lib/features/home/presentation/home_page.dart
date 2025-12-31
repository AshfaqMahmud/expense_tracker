import 'package:expense_tracker/core/widgets/premium_chart_v2.dart';
import 'package:expense_tracker/data/chart/chart_data_service.dart';
import 'package:expense_tracker/data/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/testmonthlychart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalMonthlyExpense = 0;
  double totalYearlyExpense = 0;
  String? totalAmount;
  late final ChartDataService _chartService;
  final _currencyFormat = NumberFormat.currency(decimalDigits: 1, symbol: '');

  @override
  void initState() {
    super.initState();
    _chartService = ChartDataService(DatabaseHelper());
    _loadTotalExpenses();
  }

  Future<void> _loadTotalExpenses() async {
    try {
      final monthlyExpense = await _chartService.getMonthlyExpense();
      final yearlyExpense = await _chartService.getYearlyExpense();
      setState(() {
        totalMonthlyExpense = monthlyExpense;
        totalYearlyExpense = yearlyExpense;
        totalAmount = totalMonthlyExpense.toString();
        print(totalAmount);
      });
    } catch (e) {
      print('Error loading expenses: $e');
      setState(() {
        totalMonthlyExpense = 0;
        totalYearlyExpense = 0; // Fallback value
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ), // Added const
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Spent',
              //textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildTotalMonthly(),
            Divider(thickness: 2),
            _buildTotalYearly(),
            PremiumChartV2(),
            //MonthlyChartWidget(),
          ],
        ),

        //
      ),
    );
  }

  Widget _buildTotalMonthly() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Card(
        color: Colors.limeAccent,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total in this month',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '  $totalMonthlyExpense BDT',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalYearly() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total in this Year',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                '  ${_currencyFormat.format(totalYearlyExpense)} BDT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
