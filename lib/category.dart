class Category {
  int id;
  String name;
  double amount;
  double maximum;

  categoryMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['amount'] = amount;
    mapping['maximum'] = maximum;

    return mapping;
  }
}
