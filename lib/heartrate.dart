// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:finalproject/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finalproject/MQTT.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class heartRate extends StatefulWidget {
  const heartRate({super.key});

  @override
  State<heartRate> createState() => _heartRateState();
}

class _heartRateState extends State<heartRate> {
  // initialize needed details
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  int heartRate = 0;
  int lastmessage = 0;
  String topic = 'hr';
  String message = '';
  String result = 'normal';
  int count = 1;

  // initialize spots for graph
  List<FlSpot> spots = [];

  void adjustMessage(int heartRate) {
    // adjust message displayed onscreen based on heartrate range
    if (heartRate > 50 && heartRate < 90) {
      message = "Your heart rate is normal.";
      result = 'normal';
    } else if (heartRate < 50) {
      message = "Your heart rate is too low.";
      result = 'low';
    } else if (heartRate > 90 && heartRate < 105) {
      message = "Your heart rate is elevated, please try to rest.";
      result = 'elevated';
    }
    else {
      message = "Your heart rate is too high, please rest immediately.";
      result = 'high';  
    }
  }

  List<FlSpot> getSpots(int heartRate) {
    // get spots for graph whenever a new heart rate is received
    spots.add(FlSpot(count.toDouble(), heartRate.toDouble()));
    count++;
    return spots;
  }

  void saveData() async {
    // save last heart rate to shared preferences to display in home screen
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('heartRate', lastmessage);
  }

  @override
  void initState() {
    super.initState();
    // prepare mqtt client and set on message function
    mqttClientWrapper.prepareMqttClient();
    mqttClientWrapper.onMessage = (String message) {
      setState(() {
        try {
          // make sure message is a number and within a valid range
          if (int.parse(message) > 50 && int.parse(message) < 150) {
            heartRate = int.parse(message);
            // adjust message based on heart rate and save last message
            adjustMessage(heartRate);
            lastmessage = heartRate; 
          }
        } catch (e) {
          print(e);
        }
      });
    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 30),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13244F),
        // avoids back button when refreshing
        automaticallyImplyLeading: false,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            // save last heart rate and navigate back to home screen
            saveData();
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          },
          child: const Icon(
            Icons.chevron_left_outlined,
            color: Color.fromARGB(255, 172, 171, 189),
            size: 24,
          ),
        ),
        title: Text(
          "Track Heart Rate",
          style: GoogleFonts.getFont(
            'Sora',
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // display heart rate
                Align(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                    "$heartRate BPM",
                    style: GoogleFonts.getFont(
                      'Sora',
                      color: const Color.fromARGB(255, 243, 238, 238),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),)
                ),
              ],
            ),
          ),
         Padding(
          padding: const EdgeInsets.all(20), 
          // put linechart within container within padding to avoid pixel overflow
          child: Container(
            width: 600,
            height: 250,
            child: Center(
              child: LineChart(
              LineChartData(
                // display data on axes
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.getFont(
                            'Sora',
                            color: const Color.fromARGB(255, 243, 238, 238),
                            fontSize: 8,
                          ),
                        );
                      },
                    )
                  )
                ),
                minX: 0,
                // show grids and borders
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                backgroundColor: const Color.fromARGB(255, 21, 22, 30),
                // actual data displayed on graph
                lineBarsData: [
                  LineChartBarData(
                    spots:getSpots(lastmessage),
                    isCurved: true,
                    color: const Color.fromARGB(255, 85, 178, 221),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    // gradient for area below line
                    belowBarData: BarAreaData(
                     show: true,
                     gradient: LinearGradient(colors: [
                      const Color(0xff9DCEFF).withOpacity(0.4),
                      const Color(0xff92A3FD).withOpacity(0.1),
                    ]      
                    ),)
                  ),
                ],
              )),
            )
          ),
         ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              textAlign: TextAlign.center,
              message,
              style: GoogleFonts.getFont(
                'Sora',
                color: const Color.fromARGB(255, 243, 238, 238),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          )),
          const SizedBox(height: 100),
          SizedBox(
                width: 200,
                height: 100,
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Please press here and place your finger on the sensor to begin tracking.",
                    style: GoogleFonts.getFont(
                      'Sora',
                      color: const Color.fromARGB(255, 243, 238, 238),
                      fontSize: 12,
                    ),
              ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    // subscribe to mqtt topic only when button is pressed
                      mqttClientWrapper.subscribe('hr');
                  },
                  style: 
                      ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 142, 168, 195),
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  child: Text(
                        "Begin Tracking",
                        style: GoogleFonts.getFont(
                          'Sora',
                          color: Colors.white,
                          fontSize: 16,
                  )),
                ),
              ),
        ],
      ),
      
    );
  }
}