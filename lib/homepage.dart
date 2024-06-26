import 'dart:io';

import 'package:distances/differnt_color_chart.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:distances/chart_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<HealthDataPoint> _healthDataList = [];

final iosTypes = [
  HealthDataType.WEIGHT,
  HealthDataType.STEPS,
  HealthDataType.HEIGHT,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.WORKOUT,
  HealthDataType.HEART_RATE,
  HealthDataType.NUTRITION,
  HealthDataType.DISTANCE_WALKING_RUNNING,
  HealthDataType.WATER,
];
final androidTypes = [
  HealthDataType.WEIGHT,
  HealthDataType.STEPS,
  HealthDataType.HEIGHT,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.WORKOUT,
  HealthDataType.HEART_RATE,
  HealthDataType.NUTRITION,
  HealthDataType.WATER,
  HealthDataType.DISTANCE_DELTA,
];
// All types available depending on platform (iOS ot Android).
List<HealthDataType> get types => (Platform.isAndroid)
    ? androidTypes
    : (Platform.isIOS)
        ? iosTypes
        : [];
// // Or specify specific types

// Set up corresponding permissions
// READ And Write
List<HealthDataAccess> get permissions =>
    types.map((e) => HealthDataAccess.READ_WRITE).toList();

/// Authorize, i.e. get permissionRs to access relevant health data.
authorize() async {
  // If we are trying to read Step Count, Workout, Sleep or other data that requires
  // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
  // This requires a special request authorization call.
  //
  // The location permission is requested for Workouts using the Distance information.

  // Check if we have health permissions
  bool? hasPermissions =
      await Health().hasPermissions(types, permissions: permissions);

  // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
  // Hence, we have to request with WRITE as well.
  hasPermissions = false;
  bool authorized = false;
  if (!hasPermissions) {
    // requesting access to the data types before reading them
    try {
      authorized =
          await Health().requestAuthorization(types, permissions: permissions);
    } catch (error) {
      debugPrint("Exception in authorize: $error");
    }
  }
}

class _HomePageState extends State<HomePage> {
  bool sundayEnabled = true;
  bool mondayEnabled = true;
  bool tuesdayEnabled = true;
  bool wednesdayEnabled = true;
  bool thursdayEnabled = true;
  bool fridayEnabled = true;
  bool saturdayEnabled = true;

  late TextEditingController sundController;
  late TextEditingController monController;
  late TextEditingController tuesController;
  late TextEditingController wedController;
  late TextEditingController thusController;
  late TextEditingController friController;
  late TextEditingController satController;

  @override
  void initState() {
    super.initState();
    sundController = TextEditingController();
    monController = TextEditingController();
    tuesController = TextEditingController();
    wedController = TextEditingController();
    thusController = TextEditingController();
    friController = TextEditingController();
    satController = TextEditingController();
    
    loadFromSharedPreferences();
  }

//// Fetch steps from the health plugin and show them in the app.
  Future<void> fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool stepsPermission =
        await Health().hasPermissions([HealthDataType.STEPS]) ?? false;

    if (!stepsPermission) {
      stepsPermission =
          await Health().requestAuthorization([HealthDataType.STEPS]);
    }
    // bool stepsPermission = true;
    if (stepsPermission) {
      try {
        steps = await Health().getTotalStepsInInterval(midnight, now);
      } catch (error) {
        debugPrint("Exception in getTotalStepsInInterval: $error");
      }
    } else {
      debugPrint("Authorization not granted - error in authorization");
      // setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
    print('todays steps $steps');
  }

  Future<void> loadFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sundController.text = prefs.getInt("sunday")?.toString() ?? '';
      monController.text = prefs.getInt("monday")?.toString() ?? '';
      tuesController.text = prefs.getInt("tuesday")?.toString() ?? '';
      wedController.text = prefs.getInt("wednesday")?.toString() ?? '';
      thusController.text = prefs.getInt("thursday")?.toString() ?? '';
      friController.text = prefs.getInt("friday")?.toString() ?? '';
      satController.text = prefs.getInt("saturday")?.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Enter The Distance You Have Run",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: sundController,
                  keyboardType: TextInputType.number,
                  enabled: sundayEnabled,
                  decoration: InputDecoration(
                    label: Text("Enter the Distance you have run in Sunday"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: monController,
                  keyboardType: TextInputType.number,
                  enabled: mondayEnabled,
                  decoration: InputDecoration(
                    label: Text("Enter the Distance you have run in Monday"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: tuesController,
                  keyboardType: TextInputType.number,
                  enabled: tuesdayEnabled,
                  decoration: InputDecoration(
                    label: Text("Enter the Distance you have run in Tuesday"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: wedController,
                  keyboardType: TextInputType.number,
                  enabled: wednesdayEnabled,
                  decoration: InputDecoration(
                    label: Text("Enter the Distance you have run in Wednesday"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: thusController,
                  keyboardType: TextInputType.number,
                  enabled: thursdayEnabled,
                  decoration: InputDecoration(
                    label: Text("Enter the Distance you have run in Thursday"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: friController,
                  keyboardType: TextInputType.number,
                  enabled: fridayEnabled,
                  decoration: InputDecoration(
                    label: Text("Enter the Distance you have run in Friday"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: satController,
                  keyboardType: TextInputType.number,
                  enabled: saturdayEnabled,
                  decoration: InputDecoration(
                    label: Text("Enter the Distance you have run in Saturday"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.red,
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt("sunday",
                            int.tryParse(sundController.text.trim()) ?? 0);
                        prefs.setInt("monday",
                            int.tryParse(monController.text.trim()) ?? 0);
                        prefs.setInt("tuesday",
                            int.tryParse(tuesController.text.trim()) ?? 0);
                        prefs.setInt("wednesday",
                            int.tryParse(wedController.text.trim()) ?? 0);
                        prefs.setInt("thursday",
                            int.tryParse(thusController.text.trim()) ?? 0);
                        prefs.setInt("friday",
                            int.tryParse(friController.text.trim()) ?? 0);
                        prefs.setInt("saturday",
                            int.tryParse(satController.text.trim()) ?? 0);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChartScreen(
                              sunday: sundController.text,
                              monday: monController.text,
                              tuesday: tuesController.text,
                              wednesday: wedController.text,
                              thursday: thusController.text,
                              friday: friController.text,
                              saturday: satController.text,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
