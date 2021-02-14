import 'package:app_budget/category.dart';
import 'package:app_budget/categoryService.dart';
import 'package:app_budget/chart.dart';
import 'package:app_budget/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:developer';

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
 
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Home();
              Navigator.push(
                  context, MaterialPageRoute(builder: (contex) => Home()));
            }),
        title: Text('Category Details'),
      ),
     
    ));
  }
}