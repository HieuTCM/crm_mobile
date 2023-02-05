// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print

import 'package:crm_mobile/direction_page.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/pages/login/verifyOTP.dart';
import 'package:crm_mobile/employee/pages/root/mainPage.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:crm_mobile/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn
        .disconnect()
        .catchError((e) {})
        .onError((error, stackTrace) => null);
    googleSignIn.isSignedIn().then((value) async {
      await googleSignIn.signOut().onError((error, stackTrace) => null);
      await FirebaseAuth.instance.signOut();
    });
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    String? token1 = googleAuth?.idToken.toString().substring(0, 500);
    String? token2 = googleAuth?.idToken
        .toString()
        .substring(500, googleAuth.idToken!.length);
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: "$token1$token2",
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  UserObj user = UserObj();

  loginWithGoogle() {
    signInWithGoogle().then((Uservalue) async {
      userProviders
          .fetchUserLoginWithGoogle(Uservalue.user!.email.toString())
          .then((value) async {
        if (value.status == 'ACCOUNT_NOTFOUND') {
          user = UserObj(
              fullName: Uservalue.user!.displayName,
              emailAddress: Uservalue.user!.email,
              phoneNumber: Uservalue.user!.phoneNumber);
          await Fluttertoast.showToast(
              msg: "You do not have permission to access this",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromARGB(255, 23, 252, 2),
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (value.status == 'USER_INVALID' || value.id == null) {
          await Fluttertoast.showToast(
              msg: "Login failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
          await FirebaseAuth.instance.signOut();
        } else if (value.role != 'Employee') {
          user = UserObj(
              fullName: Uservalue.user!.displayName,
              emailAddress: Uservalue.user!.email,
              phoneNumber: Uservalue.user!.phoneNumber);
          await Fluttertoast.showToast(
              msg: "You do not have permission to access this",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromARGB(255, 23, 252, 2),
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          user = value;
          await sharedPreferences.clear();
          await sharedPreferences.setString('Token', value.authToken);
          await Fluttertoast.showToast(
              msg: "Login Successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromARGB(255, 23, 252, 2),
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainPage()));
        }
      });
    });
  }

  loginByPhoneNumber(String phone) async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+84$phone',
      timeout: const Duration(seconds: 120),
      codeSent: (String verificationId, int? resendToken) async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => verifyOTP(
                  phone: phone,
                  verificationId: verificationId,
                )));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? validatePhone(String value) {
    RegExp regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10}$)');
    if (value.isEmpty) {
      return 'Please enter phone number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid phone number';
    }
    return (regExp.hasMatch(value)) ? null : "Invalid mobile";
  }

  String? errorphone;
  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    //final isKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        appBar: AppBar(
            // title: const Text('Employee Login'),
            // actions: [
            //   ElevatedButton(
            //       onPressed: () {
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (context) => DirectonPage()));
            //       },
            //       child: const Text('Switch'))
            // ],
            ),
        body: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CRM Real Estate ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const Text("Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 44,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 44,
                ),
                Row(
                  children: const [
                    Text(
                      'Login By Phone Number',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Container(
                  height: 150,
                  alignment: Alignment.center,
                  child: Center(
                      child: TextField(
                    autofocus: false,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    // obscureText: true,
                    decoration: InputDecoration(
                        errorText: errorphone,
                        hintText: "Phone number",
                        prefixIcon:
                            const Icon(Icons.phone, color: Colors.black)),
                  )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightBlue.shade200,
                        Colors.blue.shade800,
                        Colors.blueAccent.shade700,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.4, 0.9],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: Colors.transparent,
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () async {
                      if (validatePhone(phoneController.text) != null) {
                        setState(() {
                          errorphone = validatePhone(phoneController.text);
                        });
                      } else {
                        loginByPhoneNumber(phoneController.text
                            .substring(1, phoneController.text.length));
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: Container(
                    width: 450,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlue.shade200,
                          Colors.blue.shade800,
                          Colors.blueAccent.shade700,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 0.4, 0.9],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          foregroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundColor: Colors.transparent,
                          maximumSize: const Size(double.infinity, 50)),
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Sign In with Google',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: () {
                        loginWithGoogle();
                      },
                    ),
                  ),
                )
              ],
            ),
          )),
        ));
  }
}
