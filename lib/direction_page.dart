import 'package:crm_mobile/customer/pages/login/login.dart' as customer;
import 'package:crm_mobile/employee/pages/login/login.dart' as employee;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DirectonPage extends StatefulWidget {
  const DirectonPage({super.key});

  @override
  State<DirectonPage> createState() => _DirectonPageState();
}

class _DirectonPageState extends State<DirectonPage> {
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose method Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                height: 60,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(width: 3),
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.blue,
                        Colors.blueAccent.shade700,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.5, 0.9],
                      tileMode: TileMode.clamp,
                    )),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const customer.LoginScreen()));
                  },
                  child: Row(children: const [
                    FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Login for Customer',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                height: 60,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(width: 3),
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.blue,
                        Colors.blueAccent.shade700,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.5, 0.9],
                      tileMode: TileMode.clamp,
                    )),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const employee.LoginScreen()));
                  },
                  child: Row(children: const [
                    FaIcon(
                      FontAwesomeIcons.idCard,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Login for Employee',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ]),
                ),
              ),
            ],
          ),
        )
        // Center(
        //     child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Container(
        //       alignment: Alignment.center,
        //       width: 450,
        //       height: 50,
        //       child: GestureDetector(
        //         onTap: () {},
        //         child: Row(children: const [
        //           FaIcon(
        //             FontAwesomeIcons.user,
        //             size: 30,
        //             color: Colors.blue,
        //           ),
        //           SizedBox(
        //             width: 30,
        //           ),
        //           Text(
        //             'Login for Customer',
        //             style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        //           )
        //         ]),
        //       ),
        //     )
        //   ],
        // )),

        );
  }
}
