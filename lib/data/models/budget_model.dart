import 'package:intl/intl.dart';

class BudgetItem {
  final int? id;
  final String category;
  final double plannedAmount;
  double actualAmount;
  bool isCompleted;
  final DateTime monthYear;
  bool isArchived;

  BudgetItem({
    this.id,
    required this.category,
    required this.plannedAmount,
    this.actualAmount = 0,
    this.isCompleted = false,
    required this.monthYear,
    this.isArchived = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'plannedAmount': plannedAmount,
      'actualAmount': actualAmount,
      'isCompleted': isCompleted ? 1 : 0,
      'isArchived': isArchived ? 1 : 0,
      'monthYear': DateFormat('MM-yyyy').format(monthYear),
    };
  }

  factory BudgetItem.fromMap(Map<String, dynamic> map) {
    return BudgetItem(
      id: map['id'],
      category: map['category'],
      plannedAmount: map['plannedAmount'],
      actualAmount: map['actualAmount'],
      isCompleted: map['isCompleted'] == 1,
      isArchived: map['isArchived'] == 1,
      monthYear: DateFormat('MM-yyyy').parse(map['monthYear']),
    );
  }
}
