import 'package:crm_mobile/employee/components/lead/leadTab.dart';
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
                return LeadTab(
                  // listTaskDetails: widget.listTaskDetails,
                  lead: listLead[index],
                  // TaskDetails: widget.listTaskDetails[index],
                );
              },
            ),
    );
  }
}
