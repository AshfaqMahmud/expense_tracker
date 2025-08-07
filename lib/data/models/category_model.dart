class BudgetCategory {
  late String? categoryName;
  double price;
  bool isDone;

  BudgetCategory({this.categoryName, this.price = 0, this.isDone = false});

  Map<String, dynamic> toMap() {
    return {'categortyName': categoryName, 'price': price, 'isDone': isDone};
  }

  factory BudgetCategory.fromMap(Map<String, dynamic> map) {
    return BudgetCategory(
      categoryName: map['categoryName'],
      price: map['price'],
      isDone: map['isDone'],
    );
  }
}
 