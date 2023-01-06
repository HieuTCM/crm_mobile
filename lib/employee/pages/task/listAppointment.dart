import 'package:crm_mobile/employee/components/appointment/listappoitmentcomp.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:flutter/material.dart';

class listAppointment extends StatefulWidget {
  List<Appointment> listAppointments;
  listAppointment({super.key, required this.listAppointments});

  @override
  State<listAppointment> createState() => _listAppointmentState();
}

class _listAppointmentState extends State<listAppointment> {
  getUserinfo() async {
    userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  UserObj user = UserObj();
  @override
  void initState() {
    getUserinfo();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('List Appointment')),
        body: Container(
            margin: const EdgeInsets.all(10),
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                margin: const EdgeInsets.all(12),
                child: ListAppointment(
                  listAppointments: widget.listAppointments,
                  user: user,
                ),
              )
            ])));
  }
}
