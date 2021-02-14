
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyHomePage extends StatefulWidget {

  final double expense;
  final double maximum;

  MyHomePage(this.expense,this.maximum);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 @override
    Widget build(BuildContext context) {
        final List<ChartData> chartData = [
            ChartData('Budget', widget.maximum, Color.fromRGBO(9,0,136,1)),
            ChartData('Expense', widget.expense, Color.fromRGBO(147,0,119,1)),
        ];
        return 
             Container(
                    child: SfCircularChart(
                        series: <CircularSeries>[
                            // Renders doughnut chart
                            DoughnutSeries<ChartData, String>(
                                dataSource: chartData,
                                pointColorMapper:(ChartData data,  _) => data.color,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                 dataLabelSettings: DataLabelSettings(
                                    isVisible: true)
                            )
                        ]
                    )
                )
            
        ;
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
          FittedBox(
              child: Text('450.0')),
          SizedBox(height:5), //way decimal naysu
          Container(
            width: 10,
            height: 100,
            color: Colors.white,
            child: Stack(
              //kani kay para pwede ra mag overlap ang mga widgets so sapaw sapaw
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FractionallySizedBox(
                    //Sometimes your design calls for dimensions that are relative.
                    //FractionallySizedBox allows you to size the child to a fraction
                    //of the total available space.
                    heightFactor: 50,
                    child: Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
   return Column
    (
      children: <Widget>[
        Container(
          height: 15,
          width: 400,
          color:Colors.grey[200],
          child:Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  widthFactor:percentage,
                  child:Container(
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(20)
                      )
                  )
                ),
              )
            ],
          )
        )
      ],
    );
  }
}



    