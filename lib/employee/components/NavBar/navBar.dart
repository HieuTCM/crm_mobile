// ignore_for_file: file_names

import 'package:crm_mobile/employee/pages/appointment/appointmentPage.dart';
import 'package:crm_mobile/employee/pages/root/mainPage.dart';
import 'package:crm_mobile/employee/pages/user/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
      child: BottomAppBar(
        color: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                tooltip: 'Home',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (Route<dynamic> route) => false);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.heart, color: Colors.white),
                tooltip: 'Follow',
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.access_time, color: Colors.white),
                tooltip: 'History ',
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.calendarCheck,
                    color: Colors.white),
                tooltip: 'Appointment ',
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppointmentPage()));
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                tooltip: 'More',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
