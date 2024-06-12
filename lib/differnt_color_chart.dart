import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  final String? sunday;
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;

  const ChartScreen({
    Key? key,
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  }) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late SharedPreferences prefs;
  List<ChartData>? chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    loadChartDataFromSharedPreferences();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        String activity = chartData![pointIndex].activity;
        double distance = double.parse(chartData![pointIndex].distance);
        
        // Show the total distance for the tooltip
        double totalDistance = double.parse(chartData![pointIndex].distance);
         String tooltipText = '';

        if (seriesIndex == 0) {
          tooltipText = distance <= 10 ? '${distance.toStringAsFixed(2)} km ' : '${(10).toStringAsFixed(2)} km ';
        } else if (seriesIndex == 1) {
          tooltipText = distance > 10 ? (distance).toStringAsFixed(2) + ' km ' : '0.00 km ';
        } else {
          tooltipText = '${distance.toStringAsFixed(2)} km';
        }
       // String tooltipText = '${totalDistance.toStringAsFixed(2)} km';

        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Activity: $activity',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                'Distance: $tooltipText',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadChartDataFromSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    int currentDayIndex = DateTime.now().weekday % 7;

    List<ChartData> rearrangedData = [
      ChartData("Sun", "Sinamangal", widget.sunday ?? "0"),
      ChartData("Mon", "Palpa", widget.monday ?? "0"),
      ChartData("Tues", "Cycling", widget.tuesday ?? "0"),
      ChartData("Wed", "Swimming", widget.wednesday ?? "0"),
      ChartData("Thurs", "Hiking", widget.thursday ?? "0"),
      ChartData("Fri", "Yoga", widget.friday ?? "0"),
      ChartData("Sat", "Gym", widget.saturday ?? "0"),
    ];

    rearrangedData = List.from(rearrangedData.sublist(currentDayIndex + 1))
      ..addAll(rearrangedData.sublist(0, currentDayIndex + 1));

    setState(() {
      chartData = rearrangedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Distance')),
      body: chartData != null
          ? SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 50,
                labelFormat: "{value} km",
              ),
              tooltipBehavior: _tooltipBehavior,
              series: <CartesianSeries>[
// Red part of the bar for all days
StackedColumnSeries<ChartData, String>(
  dataSource: chartData!,
  xValueMapper: (ChartData ch, _) => ch.x,
  yValueMapper: (ChartData ch, _) {
    double distance = double.parse(ch.distance);
    return distance <= 10 ? distance : 10;
  },
  name: 'Distance Covered (Red)',
  color: Colors.red,
),

// Amber part of the bar for all days
StackedColumnSeries<ChartData, String>(
  dataSource: chartData!,
  xValueMapper: (ChartData ch, _) => ch.x,
  yValueMapper: (ChartData ch, _) {
    double distance = double.parse(ch.distance);
    return distance > 10 ? (distance - 10) : 0;
  },
  name: 'Distance Covered (Amber)',
  color: Colors.amber,
),

// Remaining days
StackedColumnSeries<ChartData, String>(
  dataSource: chartData!,
  xValueMapper: (ChartData ch, _) => ch.x,
  yValueMapper: (ChartData ch, _) => 0,
  name: 'Distance Covered (Other Days)',
  color: Colors.blue,
),


                // // Red part of the bar for Sunday
                // StackedColumnSeries<ChartData, String>(
                //   dataSource: chartData!,
                //   xValueMapper: (ChartData ch, _) => ch.x,
                //   yValueMapper: (ChartData ch, _) => ch.x == "Sun" ? double.parse(ch.distance) <= 10 ? double.parse(ch.distance) : 10 : 0,
                //   name: 'Distance Covered (Red)',
                //   color: Colors.red,
                // ),
                // // Amber part of the bar for Sunday
                // StackedColumnSeries<ChartData, String>(
                //   dataSource: chartData!,
                //   xValueMapper: (ChartData ch, _) => ch.x,
                //   yValueMapper: (ChartData ch, _) => ch.x == "Sun" && double.parse(ch.distance) > 10 ? double.parse(ch.distance) - 10 : 0,
                //   name: 'Distance Covered (Amber)',
                //   color: Colors.amber,
                // ),
                // // Remaining days
                // StackedColumnSeries<ChartData, String>(
                //   dataSource: chartData!,
                //   xValueMapper: (ChartData ch, _) => ch.x,
                //   yValueMapper: (ChartData ch, _) => ch.x != "Sun" ? double.parse(ch.distance) : 0,
                //   name: 'Distance Covered (Other Days)',
                //   color: Colors.blue,
               // ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ChartData {
  final String x;
  final String activity;
  final String distance;

  ChartData(this.x, this.activity, this.distance);
}
