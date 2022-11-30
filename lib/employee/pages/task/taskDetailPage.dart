import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/leadModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:crm_mobile/employee/providers/lead/lead_provider.dart';
import 'package:flutter/material.dart';

class TaskDetailPage extends StatefulWidget {
  List<TaskDetail> listTaskDetails;
  TaskDetailPage({super.key, required this.listTaskDetails});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  List<Lead> listLead = [];
  bool Waiting = true;

  getLead(String value) async {
    await LeadProvider.fetchLeadByID(value).then((value) {
      setState(() {
        listLead.add(value);
        Waiting = false;
      });
    });
  }

  @override
  void initState() {
    for (int i = 0; i < widget.listTaskDetails.length; i++) {
      getLead(widget.listTaskDetails[i].leadId);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail Page')),
      body: (Waiting)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: listLead.length,
              itemBuilder: (context, index) {
                List<Appointment> listAppointments = [];
                appointmentProvider
                    .fetchAppointmentsByLeadId(listLead[index].id)
                    .then((value) {
                  setState(() {
                    listAppointments = value;
                  });
                });
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
                    onTap: () {},
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
                          Text(listLead[index].fullname,
                              style: const TextStyle(fontSize: 16)),
                          const Spacer(),
                          Text(
                            widget.listTaskDetails[index].leadStatus,
                            style: TextStyle(
                                color:
                                    (widget.listTaskDetails[index].leadStatus ==
                                            'Qualified')
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
                          Text(listLead[index].email,
                              style: const TextStyle(fontSize: 16))
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
                          Text(listLead[index].phone,
                              style: const TextStyle(fontSize: 16)),
                          const Spacer(),
                          Text(
                              'Number of appointment:  ${listAppointments.length.toString()}')
                        ],
                      )
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
