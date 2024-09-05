import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';


class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState(); 
}

class _CompleteProfileState extends State<CompleteProfile> {
  // text editing controllers for each of the required details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _agecontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _emergencynamecontroller = TextEditingController();
  final TextEditingController _emergencyphonecontroller = TextEditingController();
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar with only simplified logo 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 3, 39),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset('assets/images/ologo.png',
            scale: 1.5,
            fit: BoxFit.fill,
          ),
        ),
        title: Text('Complete Profile',
           style: GoogleFonts.getFont(
                'Sora',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),  
            ),
        centerTitle: true,
      ),
      // enabling scrolling for the form to avoid pixel overflow
      body: SingleChildScrollView( 
        child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: Image.asset(
              'assets/images/bg.jpg',
            ).image,
          ),
        ),
        // form for user to enter details
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                 Padding(
                          padding: const EdgeInsets.all(10), 
                          child: TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: GoogleFonts.getFont(
                                'Sora',
                                color: const Color.fromARGB(255, 177, 177, 177),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: "Enter your full name...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(27, 29, 39, 1.0),
                            ),
                          ),
                        ),
                Padding(
                          padding: const EdgeInsets.all(10), 
                          child: TextFormField(
                            controller: _agecontroller,
                            style: const TextStyle(color: Colors.white),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              labelStyle: GoogleFonts.getFont(
                                'Sora',
                                color: const Color.fromARGB(255, 177, 177, 177),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: "Enter your age in years...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(27, 29, 39, 1.0),
                            ),
                          ),
                        ),
                Padding(
                          padding: const EdgeInsets.all(10), 
                          child: TextFormField(
                            controller: _addresscontroller,
                            style: const TextStyle(color: Colors.white),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              labelStyle: GoogleFonts.getFont(
                                'Sora',
                                color: const Color.fromARGB(255, 177, 177, 177),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: "Enter your address...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(27, 29, 39, 1.0),
                            ),
                          ),
                        ),
                Padding(
                          padding: const EdgeInsets.all(10), 
                          child: TextFormField(
                            controller: _phonecontroller,
                            style: const TextStyle(color: Colors.white),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: GoogleFonts.getFont(
                                'Sora',
                                color: const Color.fromARGB(255, 177, 177, 177),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: "Enter your phone number...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(27, 29, 39, 1.0),
                            ),
                          ),
                        ),
               Padding(
                          padding: const EdgeInsets.all(10), 
                          child: TextFormField(
                            controller: _emergencynamecontroller,
                            style: const TextStyle(color: Colors.white),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Emergency Contact Name',
                              labelStyle: GoogleFonts.getFont(
                                'Sora',
                                color: const Color.fromARGB(255, 177, 177, 177),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: "Enter full name...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(27, 29, 39, 1.0),
                            ),
                          ),
                        ),
               Padding(
                          padding: const EdgeInsets.all(10), 
                          child: TextFormField(
                            controller: _emergencyphonecontroller,
                            style: const TextStyle(color: Colors.white),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Emergency Contact Phone Number',
                              labelStyle: GoogleFonts.getFont(
                                'Sora',
                                color: const Color.fromARGB(255, 177, 177, 177),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: "Enter phone number...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(27, 29, 39, 1.0),
                            ),
                          ),
                        ),
                Padding(
                  // button to complete profile and push details to firestore 
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: ElevatedButton(
                     onPressed: () async {
                        final name = _nameController.text;
                        final age = _agecontroller.text;
                        final address = _addresscontroller.text;
                        final phone = _phonecontroller.text;
                        final emergencyname =
                            _emergencynamecontroller.text;
                        final emergencyphone =
                            _emergencyphonecontroller.text;
                        
                        // get the current user's email to store in firestore as a unique key for the user from which to fetch details
                        final String? email =
                            FirebaseAuth.instance.currentUser?.email;
                        CollectionReference collref =
                            FirebaseFirestore.instance
                                .collection("Users");
                        await collref.add({
                          "Age": age,
                          "Address": address,
                          "Emergency Name": emergencyname,
                          "Emergency Phone": emergencyphone,
                          "Name": name,
                          "Phone": phone,
                          "Email":email,
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration:
                                const Duration(milliseconds: 200),
                            reverseDuration:
                                const Duration(milliseconds: 200),
                            child: const Home(),
                          ),
                          (route) => false,
                        );
                      },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Color.fromRGBO(19, 36, 79, 1.0)),
                        minimumSize: WidgetStateProperty.resolveWith((states) => const Size(100, 50)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        ),
                      ),
                    child: Text(
                              "Complete Profile",
                              style: GoogleFonts.getFont(
                                'Sora',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                  )),
                ),
              ]
            )
          )
        )
      ))
      );
  }
}