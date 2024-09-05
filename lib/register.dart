import 'package:finalproject/completeprofile.dart';
import 'package:finalproject/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
   State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // initialize text controllers for email, password, and confirm password
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmcontroller = TextEditingController();

  // initialize boolean for password visibility
  late bool _passvisible;
  
  @override
  void initState() {
    super.initState();
    // set password visibility to false initially
    _passvisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 6, 1, 53),
      body: SingleChildScrollView(
        child:  Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SingleChildScrollView(
            child: Container(
             width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: Image.asset(
                      'assets/images/bg.jpg',
                    ).image,
                  ),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(18), 
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 170,
                                height: 60,
                                fit: BoxFit.fitWidth,
                              ),
                            ]
                          ), 
                      ),
                      Padding(
                                padding:
                                    const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                     "Get Started!",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                     "Create an account below to continue.",
                                      style: GoogleFonts.getFont(
                                        'Sora',
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),       
                      Padding(
                          padding: const EdgeInsets.all(10), 
                          child: TextFormField(
                            controller: emailcontroller,
                            style: const TextStyle(color: Colors.white),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: GoogleFonts.getFont(
                                'Sora',
                                color: const Color.fromARGB(255, 177, 177, 177),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: "Enter your email...",
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
                              fillColor: Color.fromRGBO(27, 29, 39, 1.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10), 
                          child: TextFormField(
                            controller: passwordcontroller,
                            style: const TextStyle(color: Colors.white),
                            obscureText: !_passvisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.getFont(
                                'Sora',
                                color: const Color.fromARGB(255, 177, 177, 177),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: "Enter your password...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(27, 29, 39, 1.0),
                              // add suffix icon to show/hide password on toggle 
                              suffixIcon: IconButton( 
                                icon: Icon(_passvisible ? Icons.visibility : Icons.visibility_off, 
                                            color: Colors.black),
                                onPressed: () { 
                                  setState(() {
                                    _passvisible = !_passvisible;
                                  });
                                },)
                              )
                            ),
                          ),
                          Padding(
                          padding: const EdgeInsets.all(10), 
                          child: TextFormField(
                            controller: confirmcontroller,
                            style: const TextStyle(color: Colors.white),
                            obscureText: !_passvisible,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: GoogleFonts.getFont(
                                'Sora',
                                color: const Color.fromARGB(255, 177, 177, 177),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: "Enter your password again...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(27, 29, 39, 1.0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(27, 29, 39, 1.0),
                              suffixIcon: IconButton( 
                                icon: Icon(_passvisible ? Icons.visibility : Icons.visibility_off, 
                                            color: Colors.black),
                                onPressed: () { 
                                  setState(() {
                                    _passvisible = !_passvisible;
                                  });
                                },)
                              )
                            ),
                          ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // create new account with email and password and navigate to complete profile page if no errors
                                    FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                      email: emailcontroller.text,
                                      password: passwordcontroller.text)
                                      .then((value) {
                                    print("Created new account");
                                    print(value.user?.email);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteProfile()));
                                  }).onError(
                                        (error, stackTrace) {
                                      print("Error ${error.toString()}");
                                    });
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
                                    "Create Account",
                                    style: GoogleFonts.getFont(
                                      'Sora',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ), 
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(10, 12, 20, 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // navigate to login page if user already has an account
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.arrow_back_rounded,
                                            color: Color.fromARGB(255, 168, 177, 255),
                                            size: 24,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    4, 0, 24, 0),
                                            child: Text(
                                              "Login",
                                              style: GoogleFonts.getFont(
                                                'Sora',
                                                color: const Color.fromARGB(255, 168, 177, 255),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Already have an account?",

                                            style: GoogleFonts.getFont(
                                              'Sora',
                                              color: const Color.fromARGB(255, 177, 177, 177),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]
                                      )
                                    )
                                  )
                                ]
                              )
                            ]
                          )
                          )
                        )
        )]
                    ))
    );
  }
}