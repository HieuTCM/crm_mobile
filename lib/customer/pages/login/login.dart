import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/pages/login/verifyOTP.dart';
import 'package:crm_mobile/customer/pages/root/mainPage.dart';
import 'package:crm_mobile/customer/pages/user/profile_Screen.dart';
import 'package:crm_mobile/customer/providers/user/user_Provider.dart';
import 'package:crm_mobile/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn
        .disconnect()
        .catchError((e) {})
        .onError((error, stackTrace) => null);
    _googleSignIn.isSignedIn().then((value) async {
      await _googleSignIn.signOut().onError((error, stackTrace) => null);
      await FirebaseAuth.instance.signOut();
    });
    GoogleSignInAccount? googleUser = await new GoogleSignIn().signIn();
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

  // static Future<User?> loginUsigEmailPassword(
  //     {required String email,
  //     required String password,
  //     required BuildContext context}) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user;
  //   try {
  //     UserCredential userCredential = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     user = userCredential.user;
  //     await Fluttertoast.showToast(
  //         msg: "Login Successful",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: const Color.fromARGB(255, 72, 255, 0),
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == "invalid-email") {
  //       // print("No user found for this email");
  //     }
  //   }
  //   return user;
  // }
  UserObj user = new UserObj();
  loginbyEmailandPass(String email, String pass) async {
    userProviders.fetchUserLogin(email, pass).then((value) async {
      if (value.id == null) {
        Fluttertoast.showToast(
            msg: "Login failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        user = value;
        Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 23, 252, 2),
            textColor: Colors.white,
            fontSize: 16.0);
        await sharedPreferences.setString('Token', value.authToken);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()));
      }
    });
  }

  loginWithGoogle() {
    signInWithGoogle().then((Uservalue) async {
      userProviders
          .fetchUserLoginWithGoogle(Uservalue.user!.email.toString())
          .then((value) async {
        if (value.status == 'ACCOUNT_NOTFOUND') {
          user = UserObj(emailAddress: Uservalue.user!.email);
          await Fluttertoast.showToast(
              msg: "You Are New User",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(255, 23, 252, 2),
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileScreen(
                    user: user,
                  )));
        } else if (value.status == 'USER_INVALID' || value.id == null) {
          await Fluttertoast.showToast(
              msg: "Login failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          GoogleSignIn _googleSignIn = GoogleSignIn();
          await _googleSignIn.signOut();
          await FirebaseAuth.instance.signOut();
        } else {
          user = value;
          await sharedPreferences.clear();
          await sharedPreferences.setString('Token', value.authToken);
          await Fluttertoast.showToast(
              msg: "Login Successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(255, 23, 252, 2),
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainPage()));
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
    // TODO: implement dispose
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

  bool _switchValue = true;
  String? errorphone;
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _phoneController = TextEditingController();

    //final isKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
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
                  children: [
                    Text(
                      (!_switchValue)
                          ? 'Login By Username'
                          : 'Login By Phone Number',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoSwitch(
                        value: _switchValue,
                        onChanged: (value) {
                          setState(() {
                            _switchValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                (!_switchValue)
                    ? SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  errorText: null,
                                  hintText: "User Email",
                                  prefixIcon:
                                      Icon(Icons.mail, color: Colors.black)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const SizedBox(
                              height: 26,
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  hintText: "User Password",
                                  prefixIcon: Icon(Icons.security,
                                      color: Colors.black)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 150,
                        alignment: Alignment.center,
                        child: Center(
                            child: TextField(
                          controller: _phoneController,
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
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const Text('Forget your password ?',
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        UserObj user = UserObj();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                      user: user,
                                    )));
                      },
                      child: const Text('Register new Account ?',
                          style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: const Color(0xFF0069FE),
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () async {
                      if (_switchValue) {
                        if (validatePhone(_phoneController.text) != null) {
                          setState(() {
                            errorphone = validatePhone(_phoneController.text);
                          });
                        } else {
                          loginByPhoneNumber(_phoneController.text
                              .substring(1, _phoneController.text.length));
                        }
                      } else {
                        loginbyEmailandPass(
                            _emailController.text, _passwordController.text);
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
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
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
