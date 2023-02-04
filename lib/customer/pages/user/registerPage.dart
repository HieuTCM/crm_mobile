// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/pages/login/login.dart';
import 'package:crm_mobile/customer/providers/user/user_Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  UserObj user;
  RegisterScreen({super.key, required this.user});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String urlImg =
      'https://i.pinimg.com/474x/3d/b7/9e/3db79e59b9052890ea1ffbef0f3970cc.jpg';

  bool male = true;
  bool female = false;
  bool gender = false;

  DateTime _dateTime = DateTime.now();

  String? valideName;
  String? valideEmail;
  String? validePhone;
  String? valideConfirmPass;
  final _nameCon = TextEditingController();
  final _emailCon = TextEditingController();
  final _emailavaliabkeCon = TextEditingController();
  final _phoneCon = TextEditingController();
  final _phoneavaliableCon = TextEditingController();
  final _passCon = TextEditingController();
  final _confirmPassCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserObj userData = widget.user;
    setState(() {
      _phoneavaliableCon.text =
          userData.phoneNumber.toString().replaceRange(0, 3, '0');
      _emailavaliabkeCon.text = userData.emailAddress.toString();
    });
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Register Profile'),
          backgroundColor: Colors.blue,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                  key: widget.formKey,
                  child: Column(
                    children: [
                      Center(
                          child: CircleAvatar(
                        radius: 48, // Image radius
                        backgroundImage: NetworkImage(urlImg),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          const Text(
                            "Name: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormField(
                                onChanged: ((value) {
                                  setState(() {
                                    valideName = validateName(value);
                                  });
                                }),
                                decoration: InputDecoration(
                                    errorText: valideName,
                                    labelText: "Your Full Name"),
                                controller: _nameCon,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "E-mail: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                readOnly: (userData.emailAddress != null)
                                    ? true
                                    : false,
                                onChanged: (value) {
                                  setState(() {
                                    valideEmail = validateEmail(value);
                                  });
                                },
                                decoration: InputDecoration(
                                    errorText: valideEmail,
                                    labelText: "Example@gmail.com"),
                                controller: (userData.emailAddress != null)
                                    ? _emailavaliabkeCon
                                    : _emailCon,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Phone: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    validePhone = validatePhone(value);
                                  });
                                },
                                keyboardType: TextInputType.number,
                                readOnly: (userData.phoneNumber != null)
                                    ? true
                                    : false,
                                decoration: InputDecoration(
                                    errorText: validePhone,
                                    hintMaxLines: 10,
                                    labelText: "Your Phone"),
                                controller: (userData.phoneNumber != null)
                                    ? _phoneavaliableCon
                                    : _phoneCon,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Gender: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "Male: ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Expanded(
                              child: Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: male,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      male = value!;
                                      female = !male;
                                      gender = true;
                                    });
                                  })),
                          const Text(
                            "Female: ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Expanded(
                              child: Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: female,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      female = value!;
                                      male = !female;
                                      gender = false;
                                    });
                                  }))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Date of birth: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: (() {
                                showDatePicker(
                                        context: context,
                                        initialDate:
                                            DateTime(DateTime.now().year),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(DateTime.now().year))
                                    .then((value) {
                                  setState(() {
                                    _dateTime = value!;
                                  });
                                });
                              }),
                              icon: const FaIcon(
                                FontAwesomeIcons.clock,
                                color: Colors.blue,
                                size: 30,
                              )),
                          Text(
                            DateFormat('dd-MM-yyyy').format(_dateTime),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Password: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                    labelText: "Your Password"),
                                controller: _passCon,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: FlutterPwValidator(
                                  uppercaseCharCount: 1,
                                  normalCharCount: 1,
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  minLength: 8,
                                  onSuccess: () {},
                                  controller: _passCon),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Confirm Password: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    valideConfirmPass =
                                        validateConfirmPass(value);
                                  });
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    errorText: valideConfirmPass,
                                    labelText: "Confirm Password"),
                                controller: _confirmPassCon,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: ElevatedButton(
                              child: const Text("Register"),
                              onPressed: () {
                                if (validateName(_nameCon.text) != null ||
                                    validateEmail(
                                            (userData.emailAddress != null)
                                                ? _emailavaliabkeCon.text
                                                : _emailCon.text) !=
                                        null ||
                                    validatePhone((userData.phoneNumber != null)
                                            ? _phoneavaliableCon.text
                                            : _phoneCon.text) !=
                                        null ||
                                    validateConfirmPass(_confirmPassCon.text) !=
                                        null) {
                                  Fluttertoast.showToast(
                                      msg: "Input not valid",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  UserObj useData = UserObj(
                                      emailAddress:
                                          (userData.emailAddress != null)
                                              ? _emailavaliabkeCon.text
                                              : _emailCon.text,
                                      phoneNumber:
                                          (userData.phoneNumber != null)
                                              ? _phoneavaliableCon.text
                                              : _phoneCon.text,
                                      password: _passCon.text,
                                      fullName: _nameCon.text,
                                      gender: male,
                                      dob: DateFormat('yyyy-MM-dd')
                                          .format(_dateTime));

                                  userProviders
                                      .registerCustomerAccount(useData)
                                      .then((value) {
                                    if (value.isEmpty) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    } else if (value != null) {
                                      for (String status in value) {
                                        if (status == 'Email existed') {
                                          setState(() {
                                            valideEmail = status;
                                          });
                                        }
                                        if (status == 'Phone existed') {
                                          setState(() {
                                            validePhone = status;
                                          });
                                        }
                                      }
                                    }
                                  });
                                }
                              }))
                    ],
                  ))),
        ));
  }

  String? validateName(String value) {
    RegExp regExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    bool check = regExp.hasMatch(value);
    if (value.isEmpty) {
      return 'Enter your name';
    } else if (check) {
      return 'Enter a Valid name';
    } else if (value.length < 3) {
      return 'Name more than 3 characters';
    } else if (value.length >= 50) {
      return 'Name no more than 50 characters';
    } else {
      return (!regExp.hasMatch(value)) ? null : 'Name Invald';
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Enter your name';
    } else {
      return EmailValidator.validate(value) ? null : 'Email Invald';
    }
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

  String? validateConfirmPass(String value) {
    if (value.isEmpty) {
      return 'Please enter Confirm Password';
    } else if (value != _passCon.text) {
      return 'Confirm Password not Equal';
    }
    return null;
  }
}
