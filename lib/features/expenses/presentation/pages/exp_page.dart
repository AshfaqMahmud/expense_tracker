import 'package:expense_tracker/data/database/db_helper.dart';
import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/features/expenses/presentation/pages/add_expense_dialog.dart';
import 'package:expense_tracker/features/expenses/presentation/pages/exp_details_page.dart';
import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Expense> _expenses = [];

  // list and logic for selected expenses
  List<Expense> _selectedExpenses = [];
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final expenses = await _databaseHelper.getExpenses();
    setState(() => _expenses = expenses);
  }

  Future<void> _addNewExpense(Expense newExpense) async {
    await _databaseHelper.insertExpense(newExpense);
    setState(() => _expenses.insert(0, newExpense));
  }

  // Future<void> _updateExpense(Expense updatedExpense) async {
  //   await _databaseHelper.updateExpense(updatedExpense);
  //   setState(() {
  //     final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
  //     if (index != -1) {
  //       _expenses[index] = updatedExpense;
  //     }
  //   });
  // }

  Future<void> _deleteExpense(Expense expense) async {
    await _databaseHelper.deleteExpense(expense.id);
    setState(() {
      _expenses.removeWhere((e) => e.id == expense.id);
      _selectedExpenses.removeWhere((e) => e.id == expense.id);
      if (_selectedExpenses.isEmpty) _isSelecting = false;
    });
  }

  Future<void> _deleteSelected() async {
    for (final expense in _selectedExpenses) {
      await _databaseHelper.deleteExpense(expense.id);
    }
    setState(() {
      _expenses.removeWhere(
        (e) => _selectedExpenses.any((se) => se.id == e.id),
      );
      _selectedExpenses.clear();
      _isSelecting = false;
    });
  }

  void _toggleSelect(Expense expense) {
    setState(() {
      if (_selectedExpenses.any((e) => e.id == expense.id)) {
        _selectedExpenses.removeWhere((e) => e.id == expense.id);
        if (_selectedExpenses.isEmpty) _isSelecting = false;
      } else {
        _selectedExpenses.add(expense);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedExpenses.length == _expenses.length) {
        _selectedExpenses.clear();
        _isSelecting = false;
      } else {
        _selectedExpenses = List.from(_expenses);
      }
    });
  }

  void _openAddExpenseDialog({Expense? expenseToEdit}) async {
    final newExpense = await showModalBottomSheet<Expense>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddExpenseModal(expense: expenseToEdit),
    );

    if (newExpense != null) {
      if (expenseToEdit != null) {
        //await _updateExpense(newExpense);
      } else {
        await _addNewExpense(newExpense);
      }
    }
  }

  void _showExpenseDetail(Expense expense) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ExpenseDetailPage(expense: expense),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _isSelecting
            ? Text('${_selectedExpenses.length} selected')
            : const Text(
                'Expenses',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        centerTitle: true,
        elevation: 0,
        actions: _isSelecting
            ? [
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: _selectAll,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _selectedExpenses.isNotEmpty
                      ? _deleteSelected
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedExpenses.clear();
                      _isSelecting = false;
                    });
                  },
                ),
              ]
            : null,
      ),
      body: _buildBody(),
      floatingActionButton: _isSelecting
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.black,
              foregroundColor: Colors.redAccent,
              onPressed: _openAddExpenseDialog,
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: _expenses.isEmpty
              ? const Center(child: Text('No expenses yet. Tap + to add one!'))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),   // for iOS
                  itemCount: _expenses.length,
                  itemBuilder: (ctx, index) => Dismissible(
                    key: Key(_expenses[index].id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        await _deleteExpense(_expenses[index]);
                        return false;
                      } else {
                        _openAddExpenseDialog(expenseToEdit: _expenses[index]);
                        return false;
                      }
                    },
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _isSelecting = true;
                          _toggleSelect(_expenses[index]);
                        });
                      },
                      onTap: () {
                        if (_isSelecting) {
                          _toggleSelect(_expenses[index]);
                        } else {
                          _showExpenseDetail(_expenses[index]);
                        }
                      },
                      child: Container(
                        color:
                            _selectedExpenses.any(
                              (e) => e.id == _expenses[index].id,
                            )
                            ? Colors.blue[50]
                            : null,
                        child: ExpenseItem(
                          _expenses[index],
                          isSelected: _selectedExpenses.any(
                            (e) => e.id == _expenses[index].id,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final bool isSelected;

  const ExpenseItem(this.expense, {super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          expense.getCategoryIcon(),
          color: isSelected ? Colors.blue : Theme.of(context).primaryColor,
        ),
        title: Text(
          expense.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.blue : null,
          ),
        ),
        subtitle: Text(
          '${expense.formattedDate} • ${expense.paymentMethod}',
          style: TextStyle(
            color: isSelected ? Colors.blue[400] : Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) const Icon(Icons.check_circle, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              '-${expense.formattedAmount}',
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
