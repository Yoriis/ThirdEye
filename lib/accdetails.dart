import 'package:flutter/material.dart'; 
import 'package:finalproject/login.dart';
import 'package:finalproject/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccDetails extends StatefulWidget {
  const AccDetails({super.key});

  @override
  State<AccDetails> createState() => _AccDetailsState();
}

class _AccDetailsState extends State<AccDetails> {
  // Set up strings for user details
  String name = "";
  String age = "";
  String address = "";
  String phone = "";
  String emergencyname = "";
  String emergencyphone = "";

  _getusername() async {
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
        age = doc['Age'] as String;
        address = doc['Address'] as String;
        phone = doc['Phone'] as String;
        emergencyname = doc['Emergency Name'] as String;
        emergencyphone = doc['Emergency Phone'] as String;
        print("Saved all the data");
      });
    } catch (e) {
      print("An error occurred: $e");
    }

    // updates screen with fetched details
    setState(() {
      name = name;
      age = age;
      address = address;
      phone = phone;
      emergencyname = emergencyname;
      emergencyphone = emergencyphone;
    });
  }

  @override
  void initState() {
    // gets details to display
    _getusername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 30),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Header with logo and gradient
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
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
                      colors: [Color(0xFF161925), Color(0xFF23395B)],
                      stops: [0, 1],
                      begin: AlignmentDirectional(0.94, -1),
                      end: AlignmentDirectional(-0.94, 1),
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          'assets/images/ologo.png',
                          width: 150,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                // Column with mini appbar (inkwell) with back button
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                            },
                            child: const Icon(
                              Icons.chevron_left,
                              color: Color.fromARGB(255, 101, 123, 171),
                              size: 24,
                            ),
                          ),
                          Opacity(
                            opacity: 0,
                            child: Container(
                              width: 200,
                              height: 29,
                              decoration: const BoxDecoration(
                                color:  Color.fromARGB(255, 21, 22, 30),
                              ),
                            ),
                          ),
                          Text(
                            "My Account",
                            style: GoogleFonts.getFont(
                              'Sora',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // column with user details
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          textAlign: TextAlign.left,
                          "Name",
                          style: GoogleFonts.getFont(
                            'Sora',
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 21, 22, 30),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color.fromARGB(255, 96, 99, 121),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.getFont(
                                    'Sora',
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // every user detail is an inkwell within a padding within a column
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          textAlign: TextAlign.left,
                          "Age",
                          style: GoogleFonts.getFont(
                            'Sora',
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 21, 22, 30),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromARGB(255, 96, 99, 121),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 4, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    age,
                                    style: GoogleFonts.getFont(
                                      'Sora',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          textAlign: TextAlign.left,
                          "Address",
                          style: GoogleFonts.getFont(
                            'Sora',
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 21, 22, 30),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromARGB(255, 96, 99, 121),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 4, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    address,
                                    style: GoogleFonts.getFont(
                                      'Sora',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          textAlign: TextAlign.left,
                          "Phone Number",
                          style: GoogleFonts.getFont(
                            'Sora',
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 21, 22, 30),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromARGB(255, 96, 99, 121),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 4, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    phone,
                                    style: GoogleFonts.getFont(
                                      'Sora',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          textAlign: TextAlign.left,
                          "Emergency Contact Name",
                          style: GoogleFonts.getFont(
                            'Sora',
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 21, 22, 30),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromARGB(255, 96, 99, 121),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 4, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    emergencyname,
                                    style: GoogleFonts.getFont(
                                      'Sora',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          textAlign: TextAlign.left,
                          "Emergency Contact Phone Number",
                          style: GoogleFonts.getFont(
                            'Sora',
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 21, 22, 30),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromARGB(255, 96, 99, 121),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 4, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    emergencyphone,
                                    style: GoogleFonts.getFont(
                                      'Sora',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // inkwell with remove account and logout buttons
                InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: ElevatedButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: const Color.fromARGB(255, 22, 25, 37),
                            title: Text(
                                  "Remove Account?",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                                )),
                            content: Text(
                                  "Are you sure you want to permanently remove your account?",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 14,
                                )),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                )),
                              ),
                              TextButton(
                                onPressed: () async => {
                                    FirebaseAuth.instance.currentUser!.delete().onError(
                                      (error, stackTrace) {
                                       print("Error ${error}");
                                },
                              )
                },
                                child: Text(
                                  "Remove Account",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                )),
                              ),
                            ],
                          ),
                        ),
                        style:
                            // giving the button a red color to indicate danger of permanently deleting account 
                            ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 109, 109),
                            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        child: Text(
                                  "Remove Account",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 22, 25, 37),
                                  fontSize: 12,
                                )),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: ElevatedButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: const Color.fromARGB(255, 22, 25, 37),
                            title: Text(
                                  "Log out?",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                                )),
                            content: Text(
                                  "Are you sure you want to log out?",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 14,
                                )),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                )),
                              ),
                              TextButton(
                                onPressed: () async => {
                                  FirebaseAuth.instance.signOut().then((value) {
                                    print("Signed out successfully");
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => LoginPage()));
                                  })
                                },
                                child: Text(
                                  "Log out",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                )),
                              ),
                            ],
                          ),
                        ),
                        style: 
                            ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 84, 114, 168),
                            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        child: Text(
                                  "Log Out",
                                  style: GoogleFonts.getFont(
                                  'Sora',
                                  color: const Color.fromARGB(255, 22, 25, 37),
                                  fontSize: 12,
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
      ),
    );
  }
}
