// ignore_for_file: file_names, camel_case_types, must_be_immutable, use_build_context_synchronously

import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:crm_mobile/employee/pages/task/taskDetailPage.dart';
import 'package:crm_mobile/employee/providers/task/task_Provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class TaskTab extends StatefulWidget {
  Task task;
  UserObj user;
  TaskTab({
    super.key,
    required this.task,
    required this.user,
  });

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
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
      width: MediaQuery.of(context).size.width,
      height: 110,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue, width: 3)),
      child: InkWell(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskDetailPage(
                          listTaskDetails: widget.task.taskDetails,
                        )));
          },
          child: Column(children: [
            Row(
              children: [
                const Text('Name: '),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.task.name),
                Spacer(),
                Text('Date: ${widget.task.createDate}')
              ],
            ),
            Row(
              children: [
                const Text('Creater: '),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.task.creater.fullname)
              ],
            ),
            Row(
              children: [
                const Text('Number of Task: '),
                const SizedBox(
                  width: 10,
                ),
                Text('${widget.task.taskDetails.length}'),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actions: [
                            ElevatedButton(
                                onPressed: (widget.task.isDone)
                                    ? null
                                    : () {
                                        OverlayLoadingProgress.start(context);
                                        TaskProvider.updTaskAsDone(
                                                widget.task.id)
                                            .then((value) {
                                          Navigator.pop(context);
                                          OverlayLoadingProgress.stop(context);
                                          if (value == 'Successful') {
                                            Fluttertoast.showToast(
                                                msg: " Update ${value}",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: " ${value}",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        });
                                      },
                                child: const Text('Done'))
                          ],
                          content: (widget.task.isDone)
                              ? const Text('Task is Done')
                              : const Text('Check Task Done ?'),
                        ),
                      );
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.check,
                      color: (widget.task.isDone) ? Colors.green : Colors.black,
                      size: 30,
                    ))
              ],
            ),
          ])),
    );
  }
}
