// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class ChartScreen extends StatefulWidget {
//   final String? sunday;
//   final String? monday;
//   final String? tuesday;
//   final String? wednesday;
//   final String? thursday;
//   final String? friday;
//   final String? saturday;

//   const ChartScreen({
//     Key? key,
//     this.sunday,
//     this.monday,
//     this.tuesday,
//     this.wednesday,
//     this.thursday,
//     this.friday,
//     this.saturday,
//   }) : super(key: key);

//   @override
//   State<ChartScreen> createState() => _ChartScreenState();
// }

// class _ChartScreenState extends State<ChartScreen> {
//   late SharedPreferences prefs;
//   List<ChartData>? chartData;
//   late TooltipBehavior _tooltipBehavior;

//   @override
//   void initState() {
//     super.initState();
//     loadChartDataFromSharedPreferences();
//     _tooltipBehavior = TooltipBehavior(
//       enable: true,
//       activationMode: ActivationMode.singleTap,
//       builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//         String activity = chartData![pointIndex].activity;
//         double distance = double.parse(chartData![pointIndex].distance);
//         return Container(
//           padding: EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Activity: $activity',
//                 style: TextStyle(color: Colors.white),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 'Distance: ${distance.toStringAsFixed(2)} km',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> loadChartDataFromSharedPreferences() async {
//     prefs = await SharedPreferences.getInstance();
//     int currentDayIndex = DateTime.now().weekday % 7;

//     List<ChartData> rearrangedData = [
//       ChartData("Sun", "Sinamangal", widget.sunday ?? "0", 0, 0, 0),
//       ChartData("Mon", "Palpa", widget.monday ?? "0", 0, 0, 0),
//       ChartData("Tues", "Cycling", widget.tuesday ?? "0", 0, 0, 0),
//       ChartData("Wed", "Swimming", widget.wednesday ?? "0", 0, 0, 0),
//       ChartData("Thurs", "Hiking", widget.thursday ?? "0", 0, 0, 0),
//       ChartData("Fri", "Yoga", widget.friday ?? "0", 0, 0, 0),
//       ChartData("Sat", "Gym", widget.saturday ?? "0", 0, 0, 0),
//     ];

//     rearrangedData = List.from(rearrangedData.sublist(currentDayIndex + 1))
//       ..addAll(rearrangedData.sublist(0, currentDayIndex + 1));

//     setState(() {
//       chartData = rearrangedData;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Distance')),
//       body: chartData != null
//           ? SfCartesianChart(
//               primaryXAxis: CategoryAxis(),
//               primaryYAxis: NumericAxis(
//                 minimum: 0,
//                 maximum: 50,
//                 labelFormat: "{value} km",
//               ),
//               tooltipBehavior: _tooltipBehavior,
//               series: <CartesianSeries>[
//                 StackedColumnSeries<ChartData, String>(
//                   dataSource: chartData!,
//                   xValueMapper: (ChartData ch, _) => ch.x,
//                   yValueMapper: (ChartData ch, _) => double.parse(ch.distance),
//                   name: 'Distance Covered',
//                   enableTooltip: true,
//                   // Assigning colors based on conditions
//                   pointColorMapper: (ChartData data, _) {
//                     if (double.parse(data.distance) >= 1 && double.parse(data.distance) <= 10) {
//                       return Colors.red;
//                     } else {
//                       return Colors.amber;
//                     }
//                   },
//                 ),
//               ],
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// class ChartData {
//   final String x;
//   final String activity;
//   final String distance;
//   final double y2;
//   final double y3;
//   final double y4;

//   ChartData(this.x, this.activity, this.distance, this.y2, this.y3, this.y4);
// }
