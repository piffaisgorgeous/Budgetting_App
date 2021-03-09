import 'package:app_budget/category.dart';
import 'package:app_budget/categoryService.dart';
import 'package:app_budget/chart.dart';
import 'package:app_budget/itemDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dateChosen;
List<Deyt> _itemList = List<Deyt>();
DateTime pickdate = DateTime.now();

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
            actions: [
              FlatButton(
                onPressed: () async {
                  if (nameController.text == '' && maxController.text == '') {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (param) {
                          return AlertDialog(
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Okay',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  color: Colors.red[200])
                            ],
                            title: Text('empty ang uban fields si pwede'),
                          );
                        });

                    nameController.text = '';
                    maxController.text = '';
                  } else {
                    _category.name = nameController.text;
                    _category.maximum = double.parse(maxController.text);
                    _category.amount = 0.0;
                    var result = await _categoryService.saveCategory(_category);
                    Navigator.pop(context);
                    getAllCategories();
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                color: Colors.red[200],
              ),
            ],
            title: Text(
              'Add Categories',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Name of Category'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: maxController,
                  decoration: InputDecoration(hintText: 'Maximum Amount'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
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
                  color: Colors.lightBlue[100],
                  onPressed: () async {
                    _category.id = cat[0]['id'];
                    _category.name = editNameController.text;
                    _category.amount = cat[0]['amount'];
                    _category.maximum = double.parse(editMaxController.text);
                    var result =
                        await _categoryService.updateCategory(_category);
                    Navigator.pop(context);
                    getAllCategories();
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
            title: Text(
              'Update Categories',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(children: <Widget>[
              TextField(
                controller: editNameController,
                decoration: InputDecoration(labelText: 'Name of Category'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: editMaxController,
                decoration: InputDecoration(labelText: 'Maximum Amount'),
                style: TextStyle(fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
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
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                  color: Colors.lightBlue[100]),
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
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
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
                title: Text(
                  'Budget App',
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _showFormDialog(context);
                    },
                  )
                ],
                backgroundColor: Colors.lightBlue),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey[200], Colors.lightBlue[100]])),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 8.0, right: 8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: Offset(0, 2),
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Text(
                                pickdate == null
                                    ? "'No Date Selected'"
                                    : 'Picked Date: ' +
                                        DateFormat.yMd().format(pickdate),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              RaisedButton(
                                color: Colors.red[100],
                                child: Text(
                                  'Choose Date',
                                ),
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
                              Chart(_itemList)
                            ],
                          ),
                        )),
                    SizedBox(height: 15),
                    Expanded(
                      child: _categoryList.isEmpty
                          ? Text(
                              'No Data',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          : ListView.builder(
                              itemCount: _categoryList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  child: Card(
                                      child: ListTile(
                                    leading: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
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
                                              Text(
                                                _categoryList[index].name ==
                                                        null
                                                    ? 'No data'
                                                    : _categoryList[index].name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${_categoryList[index].amount}/${_categoryList[index].maximum}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.0),
                                          HorizontalBar(
                                              _categoryList[index].amount /
                                                  _categoryList[index].maximum),
                                        ]),
                                    trailing: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
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
                ),
              ),
            )));
  }
}
