import 'package:app_budget/category.dart';
import 'package:app_budget/categoryService.dart';
import 'package:app_budget/chart.dart';
import 'package:app_budget/itemDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dateChosen;
List<Deyt> _itemList = List<Deyt>();
DateTime pickdate = null;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var nameController = TextEditingController();
  var maxController = TextEditingController();
  var editNameController = TextEditingController();
  var editMaxController = TextEditingController();

  var _category = Category();
  var _categoryService = categoryService();
  var cat;
  List<Category> _categoryList = List<Category>();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await categoryService().readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.maximum = category['maximum'];
        categoryModel.id = category['id'];
        categoryModel.amount = category['amount'];
        _categoryList.add(categoryModel);
      });
    });
  }

  editCategory(BuildContext context, catId) async {
    cat = await categoryService().readCategoryById(catId);
    setState(() {
      editNameController.text = cat[0]['name'] ?? 'No Name';
      editMaxController.text =
          (cat[0]['maximum']).toString() ?? 'No Maximum Amount';
    });
    _editFormDialog(context);
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  _category.name = nameController.text;
                  _category.maximum = double.parse(maxController.text);
                  _category.amount = 0.0;
                  var result = await _categoryService.saveCategory(_category);
                  print(_category.amount);
                  Navigator.pop(context);
                  getAllCategories();
                },
                child: Text('Save'),
                color: Colors.green,
              ),
            ],
            title: Text('Add Categories'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Name of Category'),
                ),
                TextField(
                  controller: maxController,
                  decoration: InputDecoration(hintText: 'Maximum Amount'),
                )
              ],
            )),
          );
        });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    _category.id = cat[0]['id'];
                    _category.name = editNameController.text;
                    _category.amount = cat[0]['amount'];
                    _category.maximum = double.parse(editMaxController.text);
                    var result =
                        await _categoryService.updateCategory(_category);
                    print(result);
                    Navigator.pop(context);
                    getAllCategories();
                  },
                  child: Text('Update'))
            ],
            title: Text('Update Categories'),
            content: SingleChildScrollView(
                child: Column(children: <Widget>[
              TextField(
                  controller: editNameController,
                  decoration: InputDecoration(labelText: 'Name of Category')),
              TextField(
                controller: editMaxController,
                decoration: InputDecoration(labelText: 'Maximum Amount'),
              )
            ])),
          );
        });
  }

  _deleteFormDialog(BuildContext context, catId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    getAllCategories();
                  },
                  child: Text('Cancel'),
                  color: Colors.green),
              FlatButton(
                  onPressed: () async {
                    var result = await _categoryService.deleteCategory(catId);
                    var resultone =
                        await _categoryService.deleteItemHome(catId);
                    setState(() {
                      getAllCategories();
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Delete'),
                  color: Colors.red)
            ],
            title: Text('Are you sure you want to delete?'),
          );
        });
  }

  getAllItems() async {
    _itemList = List<Deyt>();
    var total = 0.0;
    var items = await categoryService().readItemWithDate();
    items.forEach((item) {
      setState(() {
        var itemModel = Deyt();
        itemModel.deyt_name = item['name'];
        itemModel.deyt_amount = item['amount'];
        itemModel.deyt_id = item['id'];
        itemModel.deyt_catId = item['catId'];
        itemModel.deyt_date = DateTime.parse(item['date']);
        _itemList.add(itemModel);
      });
    });
  }

  String dateone;
  DateFormat formatter = DateFormat('yMd');
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Budget App'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _showFormDialog(context);
                  },
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                Container(
                    // color: Colors.red,
                    // height:200,
                    //  width:400,
                    child: Column(
                  children: [
                    Text(pickdate == null
                        ? "'No Date Selected'"
                        : 'Picked Date: ' + pickdate.toString()),
                    RaisedButton(
                      child: Text('Choose Date'),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025))
                            .then((date) {
                          setState(() {
                            dateChosen = date.toString();
                            dateone = formatter.format(date);
                            dateone = dateChosen;
                            pickdate = DateTime.parse(dateChosen);
                            getAllItems();
                          });
                        });
                      },
                    ),
                    Text("bar graph nani diri")
                    // Chart(_itemList)
                  ],
                )),
                Expanded(
                  child: _categoryList.isEmpty
                      ? Text('No Data')
                      : ListView.builder(
                          itemCount: _categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: Card(
                                  child: ListTile(
                                leading: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      editCategory(
                                          context, _categoryList[index].id);
                                    }),
                                title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(_categoryList[index].name == null
                                              ? 'No data'
                                              : _categoryList[index].name),
                                          Text(
                                              '${_categoryList[index].amount}/${_categoryList[index].maximum}'),
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                      HorizontalBar(
                                          _categoryList[index].amount /
                                              _categoryList[index].maximum),
                                    ]),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    print(_categoryList[index].name);
                                    _deleteFormDialog(
                                        context, _categoryList[index].id);
                                  },
                                ),
                              )),
                              onTap: () {
                                var id = _categoryList[index].id;
                                var maximum = _categoryList[index].maximum;
                                var amount = _categoryList[index].amount;
                                var name = _categoryList[index].name;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) => ItemDetail(
                                            id, maximum, amount, name)));
                              },
                            );
                          },
                        ),
                )
              ],
            )));
  }
}
