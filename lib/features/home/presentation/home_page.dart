import 'package:expense_tracker/data/database/db_helper.dart';
import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/features/expenses/presentation/pages/add_expense_dialog.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final expenses = await _databaseHelper.getExpenses();
    setState(() => _expenses = expenses);
  }

  void _addNewExpense(Expense newExpense) async {
    await _databaseHelper.insertExpense(newExpense);
    //_loadExpenses();
    setState(() {
      _expenses.insert(0, newExpense); // Add new expenses at the top
    });
  }

  void _openAddExpenseDialog() async {
    final newExpense = await showDialog<Expense>(
      context: context,
      builder: (context) => const AddExpenseDialog(),
    );

    if (newExpense != null) {
      _addNewExpense(newExpense);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'), // Added const
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Add any header widgets here
        Expanded(
          child: _expenses.isEmpty
              ? const Center(child: Text('No expenses yet. Tap + to add one!'))
              : ListView.builder(
                  // Removed shrinkWrap since we're using Expanded
                  physics: const BouncingScrollPhysics(), // Better for iOS
                  itemCount: _expenses.length,
                  itemBuilder: (ctx, index) => ExpenseItem(_expenses[index]),
                ),
        ),
      ],
    );
  }
}

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  const ExpenseItem(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2, // Added slight elevation
      child: ListTile(
        leading: Icon(
          expense.getCategoryIcon(),
          color: Theme.of(context).primaryColor, // Themed icon color
        ),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${expense.formattedDate} • ${expense.paymentMethod}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '-${expense.formattedAmount}', // Added '-' to show it's an expense
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
