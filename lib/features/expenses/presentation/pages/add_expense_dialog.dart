import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:flutter/material.dart';

class AddExpenseModal extends StatefulWidget {
  const AddExpenseModal({super.key});

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  String _selectedPaymentMethod = 'Cash';
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(
        context,
      ).viewInsets, // To move up when keyboard opens
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Expense',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: const [
                    DropdownMenuItem(value: 'Food', child: Text('Food')),
                    DropdownMenuItem(
                      value: 'Transport',
                      child: Text('Transport'),
                    ),
                    DropdownMenuItem(
                      value: 'Shopping',
                      child: Text('Shopping'),
                    ),
                    DropdownMenuItem(
                      value: 'Entertainment',
                      child: Text('Entertainment'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  items: const [
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem(
                      value: 'Credit Card',
                      child: Text('Credit Card'),
                    ),
                    DropdownMenuItem(
                      value: 'Debit Card',
                      child: Text('Debit Card'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Select Date:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newExpense = Expense(
                            id: DateTime.now().toString(),
                            title: _titleController.text,
                            category: _selectedCategory,
                            amount: double.parse(_amountController.text),
                            date: _selectedDate,
                            paymentMethod: _selectedPaymentMethod,
                          );
                          Navigator.pop(context, newExpense);
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
