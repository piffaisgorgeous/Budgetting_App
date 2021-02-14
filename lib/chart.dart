import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      ChartData('Budget', widget.maximum, Color.fromRGBO(9, 0, 136, 1)),
      ChartData('Expense', widget.expense, Color.fromRGBO(147, 0, 119, 1)),
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
                    color: Colors.blue,
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
