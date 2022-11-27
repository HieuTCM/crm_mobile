// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names

import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/pages/login/login.dart';
import 'package:crm_mobile/customer/pages/root/mainPage.dart';
import 'package:crm_mobile/customer/pages/user/registerPage.dart';
import 'package:crm_mobile/customer/providers/user/user_Provider.dart';
import 'package:crm_mobile/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class verifyOTP extends StatefulWidget {
  String phone;
  String verificationId;
  verifyOTP({super.key, required this.phone, required this.verificationId});

  @override
  State<verifyOTP> createState() => _verifyOTPState();
  final _formKey = GlobalKey<_verifyOTPState>();
}

final FirebaseAuth auth = FirebaseAuth.instance;

loginByPhoneNumber(String phone /*, String OTPCode*/) async {
  await auth.verifyPhoneNumber(
    phoneNumber: '+84$phone',
    codeSent: (String verificationId, int? resendToken) async {},
    codeAutoRetrievalTimeout: (String verificationId) {},
    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
    },
  );
}

String? pin1;
String? pin2;
String? pin3;
String? pin4;
String? pin5;
String? pin6;
UserObj user = UserObj();

class _verifyOTPState extends State<verifyOTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(0.0), // here the desired height
            child: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0.0,
              leading: const Padding(
                padding: EdgeInsets.only(
                  left: 18.0,
                  top: 12.0,
                  bottom: 12.0,
                  right: 12.0,
                ),
              ),
            )),
        body: Container(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 161, 159, 159)
                          .withOpacity(0),
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(12)),
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      size: 20,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                  ),
                ),
                const SizedBox(
                  height: 44,
                ),
                const Text("Verification Code",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 12,
                ),
                const Text("We have sent the code verification to",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      '+84${widget.phone.replaceRange(1, 5, '****')}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        'Change phone number ?',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
                Form(
                    key: widget._formKey,
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 55,
                                width: 55,
                                child: TextFormField(
                                  onChanged: ((value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                    if (value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    setState(() {
                                      pin1 = value;
                                    });
                                  }),
                                  style: Theme.of(context).textTheme.headline6,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                width: 55,
                                child: TextFormField(
                                  onChanged: ((value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                    if (value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    setState(() {
                                      pin2 = value;
                                    });
                                  }),
                                  style: Theme.of(context).textTheme.headline6,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                width: 55,
                                child: TextFormField(
                                  onChanged: ((value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                    if (value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    setState(() {
                                      pin3 = value;
                                    });
                                  }),
                                  style: Theme.of(context).textTheme.headline6,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                width: 55,
                                child: TextFormField(
                                  onChanged: ((value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                    if (value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    setState(() {
                                      pin4 = value;
                                    });
                                  }),
                                  style: Theme.of(context).textTheme.headline6,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                width: 55,
                                child: TextFormField(
                                  onChanged: ((value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                    if (value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    setState(() {
                                      pin5 = value;
                                    });
                                  }),
                                  style: Theme.of(context).textTheme.headline6,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                width: 55,
                                child: TextFormField(
                                  onChanged: ((value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                    if (value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    setState(() {
                                      pin6 = value;
                                    });
                                  }),
                                  style: Theme.of(context).textTheme.headline6,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: RawMaterialButton(
                              fillColor: const Color(0xFF0069FE),
                              elevation: 0.0,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () async {
                                String otp = '$pin1$pin2$pin3$pin4$pin5$pin6';

                                // Create a PhoneAuthCredential with the code
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: widget.verificationId,
                                        smsCode: otp);
                                // Sign the user in (or link) with the credential
                                await auth
                                    .signInWithCredential(credential)
                                    .then((valueSignIn) {
                                  userProviders
                                      .fetchUserLoginWithGoogle(valueSignIn
                                          .user!.phoneNumber
                                          .toString())
                                      .then((value) async {
                                    if (value.status == 'ACCOUNT_NOTFOUND') {
                                      user = UserObj(
                                          phoneNumber:
                                              valueSignIn.user!.phoneNumber,
                                          emailAddress:
                                              valueSignIn.user!.email);
                                      await Fluttertoast.showToast(
                                          msg: "You Are New User",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: const Color.fromARGB(
                                              255, 23, 252, 2),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterScreen(
                                                    user: user,
                                                  )));
                                    } else if (value.status == 'USER_INVALID' ||
                                        value.id == null) {
                                      await Fluttertoast.showToast(
                                          msg: "Login failed",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      GoogleSignIn googleSignIn =
                                          GoogleSignIn();
                                      await googleSignIn.signOut();
                                      await FirebaseAuth.instance.signOut();
                                    } else {
                                      user = value;
                                      await sharedPreferences.clear();
                                      await sharedPreferences.setString(
                                          'Token', value.authToken);
                                      await Fluttertoast.showToast(
                                          msg: "Login Successful",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: const Color.fromARGB(
                                              255, 23, 252, 2),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainPage()));
                                    }
                                  });
                                }).catchError((e) {
                                  Fluttertoast.showToast(
                                      msg: e.code,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          const Color.fromARGB(255, 252, 2, 2),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                              },
                              child: const Text(
                                'Verify OTP ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: GestureDetector(
                      onTap: () {
                        loginByPhoneNumber(widget.phone);
                      },
                      child: const Text(
                        'Send OTP again ?',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      )),
                )
              ],
            ),
          )),
        ));
  }
}
