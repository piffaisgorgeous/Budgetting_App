class Item {
  int id;
  String name;
  double amount;
  String date;
  int catId;

  itemMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['amount'] = amount;
    mapping['date'] = date;
    mapping['catId'] = catId;

    return mapping;
  }
}
