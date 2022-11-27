// ignore_for_file: must_be_immutable, file_names, unnecessary_null_comparison, unused_field

import 'dart:io';

import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/providers/user/user_Provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}

class _ProfilePageState extends State<ProfilePage> {
  UserObj userData = UserObj();
  bool waiting = true;
  getUserinfo() async {
    await userProviders.fetchUserInfor().then((value) {
      setState(() {
        userData = value;
        waiting = false;
        _dateTime = DateFormat('dd-MM-yyyy').parse(value.dob.toString());
        _phoneCon.text = userData.phoneNumber.toString();
        _emailCon.text = userData.emailAddress.toString();
        _nameCon.text = userData.fullName.toString();
      });
    });
  }

  final ImagePicker _picker = ImagePicker();
  // Pick an image
  // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  String urlImg =
      'https://i.pinimg.com/474x/3d/b7/9e/3db79e59b9052890ea1ffbef0f3970cc.jpg';

  bool male = true;
  bool female = false;
  bool gender = false;

  DateTime _dateTime = DateTime.now();

  String? valideName;
  TextEditingController _nameCon = TextEditingController();
  TextEditingController _emailCon = TextEditingController();
  TextEditingController _phoneCon = TextEditingController();

  File _image = File('');

  Future _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    File? img = File(image.path);
    setState(() {
      _image = img;
      // Navigator.pop(context);
      userProviders.updImageAccount(_image);
    });
  }

  @override
  void initState() {
    getUserinfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Profile Page'),
        ),
        body: (waiting)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
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
                            (_image == null)
                                ? Center(
                                    child: CircleAvatar(
                                    radius: 48, // Image radius
                                    backgroundImage: NetworkImage(
                                        (userData.image!.toString().isEmpty)
                                            ? urlImg
                                            : userData.image),
                                  ))
                                : Center(
                                    child: CircleAvatar(
                                    radius: 48, // Image radius
                                    backgroundImage: FileImage(_image!),
                                  )),
                            Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      _pickImage(ImageSource.gallery);
                                    },
                                    child: const Text('Upload Image'))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                const Text(
                                  "Name: ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: TextFormField(
                                      autofocus: false,
                                      controller: _nameCon,
                                      onChanged: ((value) {
                                        setState(() {
                                          valideName = validateName(value);
                                        });
                                      }),
                                      decoration: InputDecoration(
                                          errorText: valideName,
                                          labelText: "Your Full Name"),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      readOnly: (userData.emailAddress != null)
                                          ? true
                                          : false,
                                      onChanged: (value) {},
                                      decoration: const InputDecoration(
                                          errorText: null,
                                          labelText: "Example@gmail.com"),
                                      controller: _emailCon,
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      keyboardType: TextInputType.number,
                                      readOnly: (userData.phoneNumber != null)
                                          ? true
                                          : false,
                                      decoration: const InputDecoration(
                                          errorText: null,
                                          hintMaxLines: 10,
                                          labelText: "Your Phone"),
                                      controller: _phoneCon,
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
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
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
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
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    onPressed: (() {
                                      showDatePicker(
                                              context: context,
                                              initialDate:
                                                  DateTime(_dateTime.year),
                                              firstDate: DateTime(1950),
                                              lastDate: DateTime(
                                                  DateTime.now().year + 1))
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
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: ElevatedButton(
                                    child: const Text("Update"),
                                    onPressed: () {
                                      if (validateName(_nameCon.text) != null) {
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
                                            emailAddress: _emailCon.text,
                                            phoneNumber: _phoneCon.text,
                                            fullName: _nameCon.text,
                                            gender: male,
                                            dob: DateFormat('yyyy-MM-dd')
                                                .format(_dateTime));

                                        userProviders
                                            .updCustomerAccount(useData)
                                            .then((value) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage()));
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
}
