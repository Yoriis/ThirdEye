import 'package:flutter/material.dart';
import 'package:finalproject/MQTT.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finalproject/home.dart';

class Objectreco extends StatefulWidget {
  const Objectreco({super.key});

  @override
  State<Objectreco> createState() => _ObjectrecoState();
}

class _ObjectrecoState extends State<Objectreco> {
  // initialize needed details and mqtt client wrapper
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  String topic1 = 'object';
  String topic2 = 'distance';
  String object = '';
  String lastobject = '';
  double distance = 0;
  double accdistance = 0;

  // list of detected objects
  List<String> objects = [];

  void saveData() async {
    // save last detected object to shared preferences to display in home screen
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('object', lastobject);
  }

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
    mqttClientWrapper.onMessage = (String message) {
      setState(() {
        // ensure that the message is not empty (no object detected) before adding to list and updating last object
        if (message != "[]") {
          object = message;
          objects.add(object);
          lastobject = object;
        }
      });
    };   
  }

  // get list of detected objects by looping through object list
  List<Widget> _widgetList() {
    List<Widget> widgets = [];
    for (int i = 0; i < objects.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(8),
          child:
          ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                objects[i],
                style: GoogleFonts.getFont(
                  'Sora',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              tileColor: const Color.fromARGB(255, 142, 168, 195)),
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 30),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            // save last detected object and navigate back to home screen
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
          "Detect Objects",
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
      body: Center(
        child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  // begin tracking button to subscribe to object topic
                  onPressed: () async {
                      mqttClientWrapper.subscribe('object');
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              // display detected object
              'Object Detected: $object',
              style: GoogleFonts.getFont(
                'Sora',
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  // get list of detected objects
                  children: _widgetList(),
                ),
              ),
            ),
        ],
      )),
    );
  }
}