import 'package:flutter/material.dart';

class Expense {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final String? description;
  final String paymentMethod;
  final String currency;

  Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
    this.currency = 'BDT',
    this.paymentMethod = 'Cash',
  });

  // convert Expense to Map for DB operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'paymentMethod': paymentMethod,
      'currency': currency,
    };
  }

  // create Expense from Map for DB retrieval

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      description: map['description'],
      paymentMethod: map['paymentMethod'] ?? 'Cash',
      currency: map['currency'] ?? 'BDT',
    );
  }
  // Copy with method for easy updates
  Expense copyWith({
    String? id,
    String? title,
    String? category,
    double? amount,
    DateTime? date,
    String? description,
    String? paymentMethod,
    String? currency,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      currency: currency ?? this.currency,
    );
  }

  IconData getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.bolt;
      case 'healthcare':
        return Icons.medical_services;
      default:
        return Icons.money;
    }
  }


  // Formatted date string
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Formatted amount with currency
  String get formattedAmount {
    return '$currency ${amount.toStringAsFixed(2)}';
  }
}
