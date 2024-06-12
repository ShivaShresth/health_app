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
//   late TooltipBehavior _tooltipBehavior; // Declare tooltipBehavior here

//   @override
//   void initState() {
//     super.initState();
//     loadChartDataFromSharedPreferences();
//     _tooltipBehavior = TooltipBehavior( // Initialize tooltipBehavior here
//       enable: true,
//       activationMode: ActivationMode.singleTap,
//       builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//         String activity = 'Unknown';
//         double distance = 0;
//         switch (pointIndex) {
//           case 0:
//             activity = 'Sinamangal';
//             distance = chartData![pointIndex].y1;
//             break;
//           case 1:
//             activity = 'Palpa';
//             distance = chartData![pointIndex].y1;
//             break;
//           case 2:
//             activity = 'Cycling';
//             distance = chartData![pointIndex].y1;
//             break;
//           case 3:
//             activity = 'Swimming';
//             distance = chartData![pointIndex].y1;
//             break;
//           case 4:
//             activity = 'Hiking';
//             distance = chartData![pointIndex].y1;
//             break;
//           case 5:
//             activity = 'Yoga';
//             distance = chartData![pointIndex].y1;
//             break;
//           case 6:
//             activity = 'Gym';
//             distance = chartData![pointIndex].y1;
//             break;
//         }
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
//     // Determine the current day of the week
//     int currentDayIndex = DateTime.now().weekday % 7;

//     // Rearrange the data so that the current day is moved to the last position
//     List<ChartData> rearrangedData = [
//       ChartData("Sun", double.tryParse(widget.sunday ?? "0") ?? 0, 0, 0, 0),
//       ChartData("Mon", double.tryParse(widget.monday ?? "0") ?? 0, 0, 0, 0),
//       ChartData("Tues", double.tryParse(widget.tuesday ?? "0") ?? 0, 0, 0, 0),
//       ChartData("Wed", double.tryParse(widget.wednesday ?? "0") ?? 0, 0, 0, 0),
//       ChartData("Thurs", double.tryParse(widget.thursday ?? "0") ?? 0, 0, 0, 0),
//       ChartData("Fri", double.tryParse(widget.friday ?? "0") ?? 0, 0, 0, 0),
//       ChartData("Sat", double.tryParse(widget.saturday ?? "0") ?? 0, 0, 0, 0),
//     ];

//     // Move the current day's data to the last position
//     ChartData currentDayData = rearrangedData.removeAt(currentDayIndex);
//     rearrangedData.add(currentDayData);

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
//               series: [
//                 StackedColumnSeries<ChartData, String>(
//                   dataSource: chartData!,
//                   xValueMapper: (ChartData ch, _) => ch.x,
//                   yValueMapper: (ChartData ch, _) => ch.y1,
//                   name: 'Distance Covered',
//                   enableTooltip: true,
//                   // Color based on Y1 value
//                   pointColorMapper: (ChartData data, _) {
//                     if (data.y1 >= 1 && data.y1 <= 10) {
//                       return Colors.red;
//                     } else {
//                       return Colors.amber;
//                     }
//                   },
//                 ),
//                 // Add other series as required
//               ],
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// class ChartData {
//   final String x;
//   final double y1;
//   final double y2;
//   final double y3;
//   final double y4;

//   ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
// }
