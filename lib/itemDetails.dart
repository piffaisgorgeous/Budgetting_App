import 'package:app_budget/category.dart';
import 'package:app_budget/categoryService.dart';
import 'package:app_budget/chart.dart';
import 'package:app_budget/home.dart';
import 'package:app_budget/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String ddate;

class ItemDetail extends StatefulWidget {
  final int id;
  final double maximum;
  final double amount;
  final String name;

  ItemDetail(this.id, this.maximum, this.amount, this.name);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  var nameController = TextEditingController();
  var amountController = TextEditingController();
  var dateController = TextEditingController();
  var editNameController = TextEditingController();
  var editAmountController = TextEditingController();
  var editDateController = TextEditingController();
  var totalItem;
  var forBarE, forBarM;

  var itm;
  var _item = Item();
  var forAmount = Category();
  var _categoryService = categoryService();

  List<Deyt> _itemList = List<Deyt>();

  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  getAllItems() async {
    _itemList = List<Deyt>();
    var items = await categoryService().readItemWithId(widget.id);
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

  editItem(BuildContext context, itemId) async {
    itm = await categoryService().readItemById(itemId);
    setState(() {
      editNameController.text = itm[0]['name'] ?? 'No Name';
      editAmountController.text =
          (itm[0]['amount']).toString() ?? 'No Maximum Amount';
      editDateController.text = itm[0]['date'].toString() ?? 'No Name';
    });
    _editItemDialog(context);
  }

  _editItemDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  color: Colors.lightBlue[100],
                  onPressed: () async {
                    if (double.parse(editAmountController.text) <=
                            widget.maximum &&
                        widget.amount <= widget.maximum) {
                      _item.id = itm[0]['id'];
                      _item.name = editNameController.text;
                      _item.amount = double.parse(editAmountController.text);
                      _item.date = itm[0]['date'];
                      _item.catId = widget.id;
                      await _categoryService.updateItem(_item);
                      Navigator.pop(context);
                      getAllItems();
                      computeTotalItems();
                    } else {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (param) {
                            return AlertDialog(
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Okay'),
                                    color: Colors.red)
                              ],
                              title: Text('lapas nakas budget dzai'),
                            );
                          });
                    }
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
            title: Text('Update Item'),
            content: SingleChildScrollView(
                child: Column(children: <Widget>[
              TextField(
                  controller: editNameController,
                  decoration: InputDecoration(labelText: 'Name of Item'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: editAmountController,
                decoration: InputDecoration(labelText: 'Maximum Amount'),
                style: TextStyle(fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
              )
            ])),
          );
        });
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
                    if (nameController.text != '' &&
                        amountController.text != '' &&
                        ddate != '') {
                      if (double.parse(amountController.text) <= widget.maximum) {
                        _item.name = nameController.text;
                        _item.amount = double.parse(amountController.text);
                        _item.catId = widget.id;
                        _item.date = ddate;
                        await _categoryService.saveItem(_item);
                        computeTotalItems();
                        setState(() {});
                        Navigator.pop(context);
                        getAllItems();

                        ddate='';
                        nameController.text='';
                        amountController.text='';

                      } else {
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
                                title: Text('lapas nakas budget dzai'),
                              );
                            });
                        amountController.text='';
                      }
                    } else {
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

                        ddate='';
                        nameController.text='';
                        amountController.text='';
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.black),
                  ),
                  color: Colors.lightBlue[100]),
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
              ),
            ],
            title: Text(
              'Add Items',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Name of Item'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(hintText: 'Enter Amount'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                ),
                DatePicker(),
              ],
            )),
          );
        });
  }

  _deleteFormDialog(BuildContext context, itemId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    getAllItems();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                  color: Colors.lightBlue[100]),
              FlatButton(
                  onPressed: () async {
                    await _categoryService.deleteItem(itemId);
                    setState(() {
                      getAllItems();
                      computeTotalItems();
                      Home();
                    });

                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                  color: Colors.red)
            ],
            title: Text('Are you sure you want to delete?'),
          );
        });
  }

  computeTotalItems() async {
    var total = 0.0;
    var items = await categoryService().readItemWithId(widget.id);
    if (items.length != 0) {
      items.forEach(
        (item) {
          setState(() {
            total += item['amount'];
          });
          totalItem = total;
          updateAmountCategory(totalItem);
        },
      );
    } else {
      setState(() {
        totalItem = 0.0;
        updateAmountCategory(totalItem);
      });
    }
  }

  updateAmountCategory(double totalItem) async {
    forAmount.amount = totalItem;
    forAmount.id = widget.id;
    forAmount.maximum = widget.maximum;
    forAmount.name = widget.name;
    await _categoryService.updateAmountCategory(forAmount);
    setState(() {
      forBarE = totalItem;
      forBarM = widget.maximum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Home();
              Navigator.push(
                  context, MaterialPageRoute(builder: (contex) => Home()));
            }),
        title: Text('Category Details'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showFormDialog(context);
              })
        ],
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: [
              Colors.grey[200],
              Colors.pink[200],
            ])),
        child: Column(
          children: <Widget>[
            Container(
              child: forBarE == null && forBarM == null
                  ? MyHomePage(widget.amount, widget.maximum)
                  : MyHomePage(forBarE, forBarM),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: ListTile(
                  leading: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        editItem(context, _itemList[index].deyt_id);
                      }),
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _itemList[index].deyt_name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${_itemList[index].deyt_amount}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ]),
                  subtitle:
                      Text(DateFormat.yMd().format(_itemList[index].deyt_date)),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _deleteFormDialog(context, _itemList[index].deyt_id);
                    },
                  ),
                ));
              },
            )),
          ],
        ),
      ),
    ));
  }
}

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  String dateone;
  DateTime datetwo;
  DateFormat formatter = DateFormat('yMd');
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Text(
          dateone == null ? 'No Chosen Date' : dateone,
          style: TextStyle(fontSize: 14),
        ),
      ),
      SizedBox(
        width: 110,
        child: RaisedButton(
            child: Text(
              'Choose Date',
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2025))
                  .then((date) {
                setState(() {
                  dateone = formatter.format(date);
                  ddate = date.toString();
                });
              });
            }),
      ),
    ]);
  }
}

class Deyt {
  int deyt_id;
  String deyt_name;
  double deyt_amount;
  int deyt_catId;
  DateTime deyt_date;

  itemMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = deyt_id;
    mapping['name'] = deyt_name;
    mapping['amount'] = deyt_amount;
    mapping['date'] = deyt_date;
    mapping['catId'] = deyt_catId;
    return mapping;
  }
}
