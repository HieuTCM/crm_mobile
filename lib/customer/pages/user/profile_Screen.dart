import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  UserObj user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('login success'),
      ),
    );
  }
}
