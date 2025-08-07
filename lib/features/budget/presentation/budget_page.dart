import 'package:expense_tracker/data/database/db_helper.dart';
import 'package:expense_tracker/data/models/budget_model.dart';
import 'package:expense_tracker/features/budget/presentation/create_budget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  List<BudgetItem> currentBudgets = [];
  List<BudgetItem> archivedBudgets = [];
  double totalBudget = 0;
  double totalSpent = 0;
  int selectedYear = DateTime.now().year;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    final db = DatabaseHelper();
    final currentMonth = DateFormat('MM-yyyy').format(DateTime.now());

    print('Loading budgets for month: $currentMonth'); // Debug

    try {
      final current = await db.getBudgetsForMonth(currentMonth);
      final archived = await db.getYearlyData(selectedYear);

      print('Found ${current.length} current budgets'); // Debug
      print('Found ${archived.length} archived budgets'); // Debug

      setState(() {
        currentBudgets = current;
        archivedBudgets = archived;
        _calculateTotals();
      });
    } catch (e) {
      print('Error loading budgets: $e'); // Debug
    }
  }

  void _calculateTotals() {
    totalBudget = currentBudgets.fold(
      0,
      (sum, item) => sum + item.plannedAmount,
    );
    totalSpent = currentBudgets
        .where((item) => item.isCompleted)
        .fold(0, (sum, item) => sum + item.plannedAmount);
  }

  // Add this new method for analytics filtering
  void _updateFilters(int? year, String? category) {
    setState(() {
      selectedYear = year ?? selectedYear;
      selectedCategory = category;
      _loadBudgets(); // Reload with new filters
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _showAnalyticsDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Budget Summary Card (same as before)
          // Budget Items List (same as before)

          // Add Analytics Section
          if (selectedCategory != null || selectedYear != DateTime.now().year)
            _buildAnalyticsSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateBudget(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    final filteredBudgets = archivedBudgets.where((budget) {
      final matchesYear =
          DateFormat('yyyy').format(budget.monthYear) ==
          selectedYear.toString();
      final matchesCategory =
          selectedCategory == null || budget.category == selectedCategory;
      return matchesYear && matchesCategory;
    }).toList();

    return Expanded(
      child: Column(
        children: [
          const Text(
            'Historical Data',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Add charts or comparison tables here
          DataTable(
            columns: const [
              DataColumn(label: Text('Month')),
              DataColumn(label: Text('Planned')),
              DataColumn(label: Text('Actual')),
            ],
            rows: filteredBudgets
                .map(
                  (budget) => DataRow(
                    cells: [
                      DataCell(
                        Text(DateFormat('MMM').format(budget.monthYear)),
                      ),
                      DataCell(Text(budget.plannedAmount.toStringAsFixed(2))),
                      DataCell(Text(budget.actualAmount.toStringAsFixed(2))),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Analytics Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<int>(
              value: selectedYear,
              items: List.generate(5, (index) => DateTime.now().year - index)
                  .map(
                    (year) => DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (year) => _updateFilters(year, selectedCategory),
            ),
            DropdownButton<String?>(
              value: selectedCategory,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...currentBudgets
                    .map((e) => e.category)
                    .toSet()
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    ),
              ],
              onChanged: (category) => _updateFilters(selectedYear, category),
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToCreateBudget(BuildContext context) async {
    final newBudget = await Navigator.push<BudgetItem>(
      context,
      MaterialPageRoute(builder: (context) => const CreateBudgetPage()),
    );

    if (newBudget != null) {
      final db = DatabaseHelper();

      // Insert into database
      await db.insertBudget(newBudget);

      // Reload data
      setState(() {
        currentBudgets.add(newBudget);
        _calculateTotals();
      });
    }
  }
}
// class BudgetListItem extends StatelessWidget {
//   final BudgetItem item;
//   final Function(int) onToggle;

//   const BudgetListItem({super.key, required this.item, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: ListTile(
//         title: Text(item.category),
//         subtitle: Text(
//           '${item.plannedAmount.toStringAsFixed(2)} • ${DateFormat('MM-yyyy').format(item.monthYear)}',
//         ),
//         trailing: Checkbox(
//           value: item.isCompleted,
//           onChanged: (value) => onToggle(item.id),
//           activeColor: Colors.redAccent,
//         ),
//       ),
//     );
//   }
// }

