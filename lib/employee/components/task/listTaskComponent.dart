// ignore_for_file: file_names, camel_case_types, must_be_immutable

import 'package:crm_mobile/employee/components/task/taskTab.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class listTaskComp extends StatefulWidget {
  String wherecall;
  List<Task> listTask;
  UserObj user;
  listTaskComp(
      {super.key,
      required this.listTask,
      required this.user,
      required this.wherecall});

  @override
  State<listTaskComp> createState() => _listTaskCompState();
}

class _listTaskCompState extends State<listTaskComp> {
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
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.listTask.length,
        itemBuilder: (context, index) {
          return TaskTab(
            task: widget.listTask[index],
            user: widget.user,
          );
        },
      ),
    );
  }
}
