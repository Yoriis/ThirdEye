import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finalproject/home.dart';
import 'package:finalproject/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  // initialize text controllers for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // initialize boolean for password visibility
  late bool _passvisible;

  @override
  void initState() {
    // initialize password visibility to false
    super.initState();
    _passvisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // avoid bottom inset for keyboard
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 8, 2, 59),
      body: SingleChildScrollView ( child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 1,
            decoration: BoxDecoration(
              image: DecorationImage(
                // fills the screen with the bg image
                image: Image.asset('assets/images/bg.jpg').image,
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Hero(
                            tag: 'logo',
                            transitionOnUserGestures: true,
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 260,
                              height: 100,
                              fit: BoxFit.fill),
                          )
                         ),
                        )
                    ],
                  ), 
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Welcome Back!',
                                style: GoogleFonts.getFont(
                                  'Sora',
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16), 
                          child: TextFormField(
                            controller: emailController,
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
                          padding: const EdgeInsets.all(16), 
                          child: TextFormField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.white),
                            // obscure text for password until toggled
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
                              // suffix icon for password visibility toggle
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(alignment: const AlignmentDirectional(1, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: ElevatedButton(
                                  onPressed: () async {
                                  // sign in with email and password then navigate to home page if no errors
                                  FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text
                                  ).then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Home()),
                                    );
                                  }).catchError((error, stackTrace) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $error'),
                                      ),
                                    );
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(Color.fromRGBO(19, 36, 79, 1.0)),
                                  minimumSize: WidgetStateProperty.resolveWith((states) => const Size(100, 50)),
                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    
                                  )),
                                  
                                 child: Text(
                                   'Login',
                                   style: GoogleFonts.getFont(
                                     'Sora',
                                     color: Colors.white,
                                     fontSize: 14,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 )))
                                 ),
                            ],),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,

                                  onTap: () async {
                                    // navigate to register page whenever inkwell is tapped
                                    Navigator.push(context, 
                                    MaterialPageRoute(builder: (context) => const RegisterPage()));
                                  },

                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width * 0.8,
                                    height: 44, 
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(10, 12, 20, 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Don\'t have an account?',
                                            style: GoogleFonts.getFont(
                                              'Sora',
                                              color: const Color.fromARGB(255, 177, 177, 177),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ), 
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 4, 0),
                                            child: Text("Register",
                                              style: GoogleFonts.getFont(
                                              'Sora',
                                              color: const Color.fromARGB(255, 168, 177, 255),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            )
                                          ), 
                                          const Icon(Icons.arrow_forward_rounded, color: Color.fromARGB(255, 168, 177, 255), size: 24)
                                        ],)
                                      ))
                                )
                              ]
                            )
                      ],
                    ),
                  )
                ],
              ),
            )
          )
        ],
      ))
    );
  }
}
