import 'package:crm_mobile/customer/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/components/task/listTaskComponent.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:crm_mobile/employee/providers/task/task_Provider.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool waiting = true;
  UserObj user = UserObj();
  List<Task> listTask = [];
  List<TaskDetail> listTaskDetails = [];

  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "6"});

  int totalRow = 0;
  int pageNumber = 1;
  int pageCurrent = 1;

  int totalpage = 1;

  getUserinfo() async {
    userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  getListTask() async {
    setState(() {
      waiting = true;
      mapParam["sort"] = '1;false';
    });

    await TaskProvider.fetchTask(mapParam).then((value) {
      setState(() {
        listTask = value;
        waiting = false;
        totalRow = value[0].totalRow;
        totalpage = totalRow ~/ 6;
        if (totalRow % 6 != 0) {
          totalpage++;
        }
      });
    });
  }

  String? filterSelected;
  @override
  void initState() {
    getUserinfo();
    getListTask();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Page')),
      body: Column(children: [
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              child: const Text('Page: '),
            ),
            SizedBox(
              child: DropdownButton2(
                value: pageCurrent,
                dropdownMaxHeight: 300,
                items: List<int>.generate(totalpage, (int index) => index + 1,
                        growable: true)
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text(e.toString()),
                        )))
                    .toList(),
                onChanged: (value) {
                  setState(() async {
                    pageCurrent = value!;
                    mapParam.update('pageNumber',
                        (value) => value = pageCurrent.toString());
                    await getListTask();
                  });
                },
              ),
            ),
            const SizedBox(
              width: 30,
            )
          ],
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            margin: const EdgeInsets.all(12),
            child: (waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (listTask.isEmpty || listTask[0].id == 'NotFound')
                    ? const Center(
                        child: Text('Task not found'),
                      )
                    : listTaskComp(
                        listTask: listTask,
                        user: user,
                        wherecall: 'TaskPage',
                      ))
      ]),
    );
  }
}
