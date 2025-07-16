import 'package:expense_tracker/data/database/db_helper.dart';
import 'package:intl/intl.dart';

class ChartDataService {
  final DatabaseHelper _databaseHelper;
  ChartDataService(this._databaseHelper);

  // 1. Category-wise expenses
  Future<List<Map<String, dynamic>>> getCategoryData() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('''
      SELECT category, SUM(amount) as total 
      FROM expenses 
      GROUP BY category
      
    ''');
    return result;
  }

  // 2. Monthly spending data
  Future<List<Map<String, dynamic>>> getMonthlyData() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('''
      SELECT strftime('%m', date) as month, 
             strftime('%Y', date) as year,
             SUM(amount) as total
      FROM expenses
      GROUP BY year, month
      
    ''');
    return result;
  }

  Future<double> getMonthlyExpense() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('''
        SELECT SUM(amount) as total
        FROM expenses
        WHERE strftime('%m', date) = strftime('%m', 'now')
    AND strftime('%Y', date) = strftime('%Y', 'now')
        
    ''');
    // Handle the case when there are no expenses (SUM returns NULL)
    final total = result.first['total'] as double?;
    return total ?? 0;
  }
  Future<double> getYearlyExpense() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('''
        SELECT SUM(amount) as total
        FROM expenses
        WHERE strftime('%Y', date) = strftime('%Y', 'now')
    ''');
    // Handle the case when there are no expenses (SUM returns NULL)
    final total = result.first['total'] as double?;
    return total ?? 0;
  }

  String formatMonth(int month) {
    return DateFormat('MMM').format(DateTime(2023, month));
  }
}
