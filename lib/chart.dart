import 'package:app_budget/home.dart';
import 'package:app_budget/itemDetails.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  final double expense;
  final double maximum;

  MyHomePage(this.expense, this.maximum);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Budget', widget.maximum, Colors.cyan),
      ChartData('Expense', widget.expense, Colors.lightBlue[100]),
    ];
    return Container(
        child: SfCircularChart(series: <CircularSeries>[
      DoughnutSeries<ChartData, String>(
          dataSource: chartData,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelSettings: DataLabelSettings(isVisible: true))
    ]));
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}

class ChartBar extends StatelessWidget {
  final String day;
  final double amount;
  final double percentage;

  ChartBar({this.amount, this.day, this.percentage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          FittedBox(child: Text('450.0')),
          SizedBox(height: 5),
          Container(
            width: 10,
            height: 100,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FractionallySizedBox(
                    heightFactor: 50,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text('Monday')
        ]),
      ),
    );
  }
}

class HorizontalBar extends StatelessWidget {
  double percentage;

  HorizontalBar(this.percentage);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 15,
            width: 400,
            color: Colors.grey[200],
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)))),
                )
              ],
            ))
      ],
    );
  }
}

class Chart extends StatelessWidget {
  final List<Deyt> latestTransaction;

  Chart(this.latestTransaction);

  List<Map> get latestTransactionValue {
    return List.generate(7, (index) {
      final weekDay = pickdate.subtract(Duration(days: index));

      double totalSpentPerDay = 0.0;
      for (var i = 0; i < latestTransaction.length; i++) {
        if (weekDay.day == latestTransaction[i].deyt_date.day &&
            weekDay.month == latestTransaction[i].deyt_date.month &&
            weekDay.year == latestTransaction[i].deyt_date.year) {
          totalSpentPerDay += latestTransaction[i].deyt_amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSpentPerDay
      };
    }).reversed.toList();
  }

  double get total {
    double add = 0.0;
    for (int i = 0; i < latestTransaction.length; i++) {
      add += latestTransaction[i].deyt_amount;
    }
    return add;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: latestTransactionValue.map((trans) {
            return SafeArea(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: ChartBarExp(
                        day: trans['day'],
                        amount: trans['amount'],
                        percentage: total == 0
                            ? 0
                            : (trans['amount'] as double) / total)));
          }).toList(),
        ),
      ),
    );
  }
}

class ChartBarExp extends StatelessWidget {
  final String day;
  final double amount;
  final double percentage;

  ChartBarExp({this.amount, this.day, this.percentage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: <Widget>[
      FittedBox(child: Text('₱' + amount.toStringAsFixed(0))),
      Container(
        width: 10,
        height: 80,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              child: FractionallySizedBox(
                heightFactor: percentage,
                child: Container(
                  color: Colors.red[200],
                ),
              ),
            ),
          ],
        ),
      ),
      Text(day)
    ]));
  }
}
