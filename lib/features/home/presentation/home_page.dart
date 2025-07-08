import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/features/expenses/presentation/pages/add_expense_dialog.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Expense> _expenses = [];

  void _addNewExpense(Expense newExpense) {
    setState(() {
      _expenses.add(newExpense);
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
        title: Text('Home'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _expenses.isEmpty
          ? const Center(child: Text('No expenses yet, Tap + to add one!'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: _expenses.length,
                    itemBuilder: (ctx, index) => ExpenseItem(_expenses[index]),
                  ),

                  // Your balance card content here
                  // Your expenses summary
                  // Recent transactions list
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
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
      child: ListTile(
        leading: Icon(expense.getCategoryIcon()),
        title: Text(expense.title),
        subtitle: Text('${expense.formattedDate} • ${expense.paymentMethod}'),
        trailing: Text(
          expense.formattedAmount,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
