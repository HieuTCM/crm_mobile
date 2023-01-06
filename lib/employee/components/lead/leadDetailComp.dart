// ignore_for_file: must_be_immutable

import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/leadModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:crm_mobile/employee/pages/task/listAppointment.dart';
import 'package:crm_mobile/employee/pages/task/taskPage.dart';
import 'package:crm_mobile/employee/providers/lead/lead_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadDetailComp extends StatefulWidget {
  List<Appointment> listAppointments;
  // List<TaskDetail> listTaskDetails;
  Lead lead;
  List<LeadStatus> listStatus;
  LeadDetailComp(
      {super.key,
      required this.lead,
      required this.listStatus,
      // required this.listTaskDetails,
      required this.listAppointments});

  @override
  State<LeadDetailComp> createState() => _LeadDetailCompState();
}

class _LeadDetailCompState extends State<LeadDetailComp> {
  LeadStatus? leadStatus;
  bool updateStatus = false;
  String statusid = '';
  changeStatus(String leadID, String statusID) async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['leadID'] = leadID;
    data['status'] = statusID;
    await LeadProvider.updLeadstatus(data).then((value) {
      if (value == 'successful') {
        Fluttertoast.showToast(
            msg: "Change status Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TaskPage()));
      } else {
        Fluttertoast.showToast(
            msg: "Change status failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Row(
          children: [
            const Text('Lead\'s Name: '),
            const SizedBox(
              width: 20,
            ),
            Text(widget.lead.nameCall + '. ' + widget.lead.fullname)
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text('Lead\'s Type: '),
            const SizedBox(
              width: 20,
            ),
            Text(widget.lead.leadType)
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text('Email: '),
            const SizedBox(
              width: 20,
            ),
            Text(widget.lead.email)
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text('Phone: '),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
                onTap: () {
                  _makePhoneCall(widget.lead.phone);
                },
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.phone, color: Colors.blue),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.lead.phone,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text('Date Of birth: '),
            SizedBox(
              width: 20,
            ),
            Text(widget.lead.dob.toString().substring(0, 10))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text('Company: '),
            const SizedBox(
              width: 20,
            ),
            Text(widget.lead.companyName)
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text('Website: '),
            const SizedBox(
              width: 20,
            ),
            Text(widget.lead.website)
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text('Status: '),
            const SizedBox(
              width: 20,
            ),
            (!updateStatus)
                ? Text(widget.lead.leadStatus)
                : SizedBox(
                    child: DropdownButton2(
                      value: leadStatus,
                      hint: const Text('selected '),
                      dropdownMaxHeight: 300,
                      items: widget.listStatus
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Container(
                                width: 100,
                                alignment: Alignment.center,
                                child: Text(e.name),
                              )))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          leadStatus = value;
                          statusid = leadStatus!.id;
                        });
                        changeStatus(widget.lead.id, statusid);
                      },
                    ),
                  ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    updateStatus = true;
                  });
                },
                child: const Text('Change'))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  (widget.listAppointments.isEmpty)
                      ? null
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => listAppointment(
                                    listAppointments: widget.listAppointments,
                                  )));
                },
                child: Row(
                  children: [
                    Text(
                      (widget.listAppointments.isEmpty)
                          ? 'Loading...'
                          : (widget.listAppointments[0].appointmentStatus ==
                                  'NotFound')
                              ? 'Number of appointment: 0'
                              : 'Number of appointment:  ${widget.listAppointments.length}  (View more ..)',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    )
                  ],
                )),
          ],
        )
      ]),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (!await launchUrl(launchUri)) {
      throw 'Could not launch $launchUri';
    }
  }
}
