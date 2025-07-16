// import 'package:expense_tracker/data/models/expense_model.dart';
// import 'package:flutter/material.dart';

// class AddExpenseModal extends StatefulWidget {
//   const AddExpenseModal({super.key});

//   @override
//   State<AddExpenseModal> createState() => _AddExpenseModalState();
// }

// class _AddExpenseModalState extends State<AddExpenseModal> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _amountController = TextEditingController();
//   String _selectedCategory = 'Food';
//   String _selectedPaymentMethod = 'Cash';
//   DateTime _selectedDate = DateTime.now();

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: MediaQuery.of(
//         context,
//       ).viewInsets, // To move up when keyboard opens
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Add New Expense',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 TextFormField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a title';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _amountController,
//                   decoration: const InputDecoration(labelText: 'Amount'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter an amount';
//                     }
//                     if (double.tryParse(value) == null) {
//                       return 'Please enter a valid number';
//                     }
//                     return null;
//                   },
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: _selectedCategory,
//                   items: const [
//                     DropdownMenuItem(value: 'Food', child: Text('Food')),
//                     DropdownMenuItem(
//                       value: 'Transport',
//                       child: Text('Transport'),
//                     ),
//                     DropdownMenuItem(
//                       value: 'Shopping',
//                       child: Text('Shopping'),
//                     ),
//                     DropdownMenuItem(
//                       value: 'Entertainment',
//                       child: Text('Entertainment'),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCategory = value!;
//                     });
//                   },
//                   decoration: const InputDecoration(labelText: 'Category'),
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: _selectedPaymentMethod,
//                   items: const [
//                     DropdownMenuItem(value: 'Cash', child: Text('Cash')),
//                     DropdownMenuItem(
//                       value: 'Credit Card',
//                       child: Text('Credit Card'),
//                     ),
//                     DropdownMenuItem(
//                       value: 'Debit Card',
//                       child: Text('Debit Card'),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedPaymentMethod = value!;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Payment Method',
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   "Select Date:",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 CalendarDatePicker(
//                   initialDate: _selectedDate,
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                   onDateChanged: (date) {
//                     setState(() {
//                       _selectedDate = date;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Cancel'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           final newExpense = Expense(
//                             id: DateTime.now().toString(),
//                             title: _titleController.text,
//                             category: _selectedCategory,
//                             amount: double.parse(_amountController.text),
//                             date: _selectedDate,
//                             paymentMethod: _selectedPaymentMethod,
//                           );
//                           Navigator.pop(context, newExpense);
//                         }
//                       },
//                       child: const Text('Add'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:intl/intl.dart';

class AddExpenseModal extends StatefulWidget {
  final Expense? expense;

  const AddExpenseModal({super.key, this.expense});

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  //late TextEditingController _notesController;
  late String _selectedCategory;
  late String _selectedPaymentMethod;
  late DateTime _selectedDate;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Education',
    'Other',
  ];

  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Digital Wallet',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _titleController = TextEditingController(text: expense?.title ?? '');
    _amountController = TextEditingController(
      text: expense?.amount.toStringAsFixed(2) ?? '',
    );
    //_notesController = TextEditingController(text: expense?.notes ?? '');
    _selectedCategory = expense?.category ?? _categories[0];
    _selectedPaymentMethod = expense?.paymentMethod ?? _paymentMethods[0];
    _selectedDate = expense?.date ?? DateTime.now();
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    //_notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newExpense = Expense(
        id: widget.expense?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        paymentMethod: _selectedPaymentMethod,
        date: _selectedDate,
        //notes: _notesController.text,
      );
      Navigator.of(context).pop(newExpense);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.expense == null ? 'Add New Expense' : 'Edit Expense',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: _paymentMethods.map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              // TextFormField(
              //   controller: _notesController,
              //   decoration: const InputDecoration(
              //     labelText: 'Notes (Optional)',
              //     border: OutlineInputBorder(),
              //     contentPadding: EdgeInsets.symmetric(
              //       horizontal: 12,
              //       vertical: 12,
              //     ),
              //   ),
              //   maxLines: 2,
              // ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      widget.expense == null ? 'Add Expense' : 'Update',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
