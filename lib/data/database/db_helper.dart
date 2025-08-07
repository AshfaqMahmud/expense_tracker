// lib/data/local/database_helper.dart
import 'package:expense_tracker/data/models/budget_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:expense_tracker/data/models/expense_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'expenses.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id TEXT PRIMARY KEY,
            title TEXT,
            category TEXT,
            amount REAL,
            date TEXT,
            description TEXT,
            paymentMethod TEXT,
            currency TEXT
          )
        ''');
        await _createBudgetItemsTable(db); // Add this line
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createBudgetItemsTable(db);
        }
      },
    );
  }
Future<void> _createBudgetItemsTable(Database db) async {
    await db.execute('''
    CREATE TABLE budget_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category TEXT,
      plannedAmount REAL,
      actualAmount REAL DEFAULT 0,
      isCompleted INTEGER DEFAULT 0,
      isArchived INTEGER DEFAULT 0,
      monthYear TEXT
    )
  ''');
  }
  // Insert expense
  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert('expenses', expense.toMap());
  }

  // Get all expenses
  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final maps = await db.query('expenses', orderBy: 'date DESC');
    return maps.map((map) => Expense.fromMap(map)).toList();
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Budget Segment

   // Querying Archived Data

  static Future<List<BudgetItem>> getCategoryHistory(String category) async {
    final db = await _instance.database;
    final maps = await db.query(
      'budget_items',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'monthYear DESC',
    );
    return maps.map((map) => BudgetItem.fromMap(map)).toList();
  }
Future<List<BudgetItem>> getBudgetsForMonth(String monthYear) async {
    final db = await database;
    try {
      final maps = await db.query(
        'budget_items',
        where: 'monthYear = ? AND isArchived = 0',
        whereArgs: [monthYear],
      );
      print('Fetched ${maps.length} budgets for $monthYear'); // Debug
      return maps.map((map) => BudgetItem.fromMap(map)).toList();
    } catch (e) {
      print('Error in getBudgetsForMonth: $e');
      return [];
    }
  }

  Future<void> markBudgetAsPaid(int id) async {
    final db = await database;
    await db.update(
      'budget_items',
      {'isCompleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> archiveOldBudgets() async {
    final db = await database;
    final currentMonth = DateFormat('MM-yyyy').format(DateTime.now());
    await db.update(
      'budget_items',
      {'isArchived': 1},
      where: 'monthYear != ?',
      whereArgs: [currentMonth],
    );
  }

  Future<List<BudgetItem>> getYearlyData(int year) async {
    final db = await database;
    final maps = await db.rawQuery(
      '''
    SELECT * FROM budget_items 
    WHERE strftime("%Y", monthYear) = ? 
    ORDER BY monthYear DESC
  ''',
      [year.toString()],
    );
    return maps.map((map) => BudgetItem.fromMap(map)).toList();
  }

  Future<List<String>> getBudgetCategories() async {
    final db = await database;
    final maps = await db.rawQuery('''
    SELECT DISTINCT category FROM budget_items
  ''');
    return maps.map((map) => map['category'] as String).toList();
  }

  Future<void> insertBudget(BudgetItem budget) async {
    final db = await database;
    try {
      await db.insert(
        'budget_items',
        budget.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Successfully inserted budget: ${budget.category}'); // Debug
    } catch (e) {
      print('Error inserting budget: $e');
    }
  }
}

// Budget segment
