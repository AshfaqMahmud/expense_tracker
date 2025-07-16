import 'package:flutter/material.dart';
import 'package:expense_tracker/data/models/expense_model.dart';

class ExpenseDetailPage extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailPage({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              icon: expense.getCategoryIcon(),
              title: 'Category',
              value: expense.category,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              icon: Icons.title,
              title: 'Title',
              value: expense.title,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              icon: Icons.attach_money,
              title: 'Amount',
              value: '-${expense.formattedAmount}',
              valueColor: Colors.red,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              icon: Icons.date_range,
              title: 'Date',
              value: expense.formattedDate,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              icon: Icons.credit_card,
              title: 'Payment Method',
              value: expense.paymentMethod,
            ),
            // if (expense.notes.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   _buildDetailCard(
            //     icon: Icons.notes,
            //     title: 'Notes',
            //     value: expense.notes,
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.blueGrey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: valueColor ?? Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
