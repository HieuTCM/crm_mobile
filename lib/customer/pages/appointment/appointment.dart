import 'package:crm_mobile/customer/components/NavBar/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  bool watting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appoitment List')),
      body: SingleChildScrollView(
          child: Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        child: Column(children: []),
      )),
      bottomNavigationBar: const NavBar(),
    );
  }
}
