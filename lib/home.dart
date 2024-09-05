
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finalproject/accdetails.dart';
import 'package:finalproject/heartrate.dart';
import 'package:finalproject/objectreco.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';  
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // get weekday and time and set used variables
  String? weekday = DateFormat('EEEE').format(DateTime.now());
  String? timestring = DateFormat('hh:mm a').format(DateTime.now());
  String? username;
  String name = "";
  int lastheartrate = 0;
  String lastobject = '';

  @override 
  void initState() {
    // get saved data from shared preferences
    getLastHeartRate();
    getLastObject();
    // get current time and update every second
    timestring = DateFormat('hh:mm a').format(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        timestring = DateFormat('hh:mm a').format(DateTime.now());
      });
    });
    super.initState();
    _getUsername();
  }

  _getUsername() async {
    try {
      // Get the current user's email
      String? user = FirebaseAuth.instance.currentUser?.email;
      print(user);
      if (user == null) {
        print("User email is null");
        return;
      }
      // Query Firestore for the user's document based on email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("Email", isEqualTo: user)
          .get();
      if (querySnapshot.docs.isEmpty) {
        print("No documents found for the user email");
        return;
      }
      // Process the documents returned by the query
      querySnapshot.docs.forEach((doc) {
        name = doc['Name'] as String;
      });
    } catch (e) {
      print("An error occurred: $e");
    }

  }

  void getLastHeartRate() async {
    // get last heart rate from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastheartrate = prefs.getInt('heartRate') ?? 0;
  }

  void getLastObject() async {
    // get last object detected from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastobject = prefs.getString('object') ?? '';
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 21, 22, 30),
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 22, 30),
        automaticallyImplyLeading: false,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/logo.png',
            width: 140,
            height: 50,
            fit: BoxFit.fill,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
              size: 50,
            ),
            onPressed: () async {
              // navigate to account details screen when profile icon is clicked
              Navigator.push(context, MaterialPageRoute(builder: (context) => AccDetails()));
            },
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),

      body: SafeArea(
        top: true, 
        // avoids bottom overflow when keyboard is displayed
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.92,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 6,
                            color: Color(0x4B1A1F24),
                            offset: Offset(
                              0.0,
                              2,
                            ),
                          )
                        ],
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5D8BBF), Color(0xFF23395B)],
                          stops: [0, 1],
                          begin: AlignmentDirectional(0.94, -1),
                          end: AlignmentDirectional(-0.94, 1),
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "Welcome, ",
                                    style: GoogleFonts.getFont(
                                    'Sora',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                  Text(
                                    // display user's name
                                      name,
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Icon(
                                    Icons.access_time_rounded,
                                    color: Color.fromARGB(255, 169, 173, 198),
                                    size: 24,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                      // display current time
                                      "$timestring",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: Text(
                                      "",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.transparent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                )),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0, 2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Text(
                                      // display current weekday
                                      "$weekday",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.45,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 27, 29, 39),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromARGB(255, 27, 29, 39),
                          width: 0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                      "Last Detected Heartrate",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                )),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Icon(
                                    Icons.monitor_heart_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                 Text(
                                      // display last detected heart rate
                                      "$lastheartrate BPM ",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 8,
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ), 

                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.45,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 27, 29, 39),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x3F14181B),
                            offset: Offset(
                              0.0,
                              3,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                      "Last Seen Object",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                )),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(
                                  Icons.emoji_objects_sharp,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child:  Text(
                                    // display last detected object
                                      lastobject,
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 8,
                                )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 27, 29, 39),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                      "Quick Actions",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                )),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                //  navigate to heart rate screen when button is clicked
                                onPressed: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => heartRate()));
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
                                      "Track Heart Rate",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 16,
                                )),
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                // navigate to object detection screen when button is clicked
                                onPressed: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Objectreco()));
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
                                      "Detect Objects",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: Colors.white,
                                        fontSize: 16,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))
            ]
          )
        )
      )

      );
  }
}