import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/components/appointment/listappoitmentcomp.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:flutter/material.dart';

class AppointmentLeadPage extends StatefulWidget {
  List<Appointment> listAppointments;
  AppointmentLeadPage({super.key, required this.listAppointments});

  @override
  State<AppointmentLeadPage> createState() => _AppointmentLeadPageState();
}

class _AppointmentLeadPageState extends State<AppointmentLeadPage> {
  UserObj user = UserObj();
  getUserinfo() async {
    userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment Page')),
      body: ListAppointment(
          listAppointments: widget.listAppointments, user: user),
    );
  }
}
