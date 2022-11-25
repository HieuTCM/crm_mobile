// ignore_for_file: file_names

import 'package:crm_mobile/customer/pages/appointment/appointment.dart';
import 'package:crm_mobile/customer/pages/product/followPgae.dart';
import 'package:crm_mobile/customer/pages/product/recentPage.dart';
import 'package:crm_mobile/customer/pages/root/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

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
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FollowPage()));
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.access_time, color: Colors.white),
                tooltip: 'History ',
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecentPage()));
                },
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
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
