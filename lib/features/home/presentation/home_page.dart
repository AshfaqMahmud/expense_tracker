import 'package:expense_tracker/core/widgets/premium_chart_v2.dart';
import 'package:expense_tracker/data/chart/chart_data_service.dart';
import 'package:expense_tracker/data/database/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalMonthlyExpense = 0;
  String? totalAmount;
  late final ChartDataService _chartService;

  @override
  void initState() {
    super.initState();
    _chartService = ChartDataService(DatabaseHelper());
    _loadTotalExpenses();
  }

  Future<void> _loadTotalExpenses() async {
    try {
      final monthlyExpense = await _chartService.getMonthlyExpense();
      setState(() {
        totalMonthlyExpense = monthlyExpense;
        totalAmount = totalMonthlyExpense.toString();
        print(totalAmount);
      });
    } catch (e) {
      print('Error loading expenses: $e');
      setState(() {
        totalMonthlyExpense = 0; // Fallback value
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
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Card(
                color: const Color.fromARGB(255, 178, 231, 255),
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PremiumChartV2(),
          ],
        ),

        //
      ),
    );
  }
}
