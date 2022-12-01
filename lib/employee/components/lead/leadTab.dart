import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/leadModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:crm_mobile/employee/pages/appointment/appointmentLeadPage.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LeadTab extends StatefulWidget {
  Lead lead;
  TaskDetail TaskDetails;
  LeadTab({super.key, required this.lead, required this.TaskDetails});

  @override
  State<LeadTab> createState() => _LeadTabState();
}

class _LeadTabState extends State<LeadTab> {
  List<Appointment> listAppointments = [];
  getListAppointment() async {
    await appointmentProvider
        .fetchAppointmentsByLeadId(widget.lead.id)
        .then((value) {
      setState(() {
        listAppointments = value;
      });
    });
  }

  @override
  void initState() {
    getListAppointment();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 110,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue, width: 3)),
      child: InkWell(
        onTap: () {
          (listAppointments.isEmpty)
              ? Fluttertoast.showToast(
                  msg: "Appointment is loading...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0)
              : (listAppointments[0].appointmentStatus == 'NotFound')
                  ? Fluttertoast.showToast(
                      msg: "Lead have not send appointment yet",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentLeadPage(
                                listAppointments: listAppointments,
                              )));
        },
        child: Column(children: [
          Row(
            children: [
              const Text(
                'Name: ',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.lead.fullname, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              Text(
                widget.TaskDetails.leadStatus,
                style: TextStyle(
                    color: (widget.TaskDetails.leadStatus == 'Qualified')
                        ? Colors.blue
                        : Colors.red,
                    fontSize: 17),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text('Email: ', style: TextStyle(fontSize: 18)),
              const SizedBox(
                width: 10,
              ),
              Text(widget.lead.email, style: const TextStyle(fontSize: 16))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text('Phone: ', style: TextStyle(fontSize: 18)),
              const SizedBox(
                width: 10,
              ),
              Text(widget.lead.phone, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              Text((listAppointments.isEmpty)
                  ? 'Loading...'
                  : (listAppointments[0].appointmentStatus == 'NotFound')
                      ? 'Number of appointment: 0'
                      : 'Number of appointment:  ${listAppointments.length}')
            ],
          )
        ]),
      ),
    );
  }
}
