import 'package:crm_mobile/employee/components/appointment/appointmentDetailcomp.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/pages/appointment/appointmentPage.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:crm_mobile/employee/models/feedback/feedback_model.dart';
import 'package:crm_mobile/employee/components/lead/leadTab.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:crm_mobile/employee/providers/feedback/feedbback_provider.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:xen_popup_card/xen_card.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<Feedbackmodel> listFeedback = [];
  bool Waiting = true;
  UserObj user = UserObj();

  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "6"});
  final TextEditingController _searchController = TextEditingController();

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

  getLead(String searchValue) async {
    setState(() {
      Waiting = true;
      mapParam["sort"] = '1;false';
    });
    if (searchValue.isNotEmpty) {
      mapParam["searchString"] = searchValue;
    } else {
      mapParam.remove('searchString');
    }

    await feedbackProvider.fetchFeedback(mapParam).then((value) {
      setState(() {
        listFeedback = value;
        Waiting = false;
        totalRow = value[0].totalRow;
        totalpage = totalRow ~/ 6;
        if (totalRow % 6 != 0) {
          totalpage++;
        }
      });
    });
  }

  @override
  void initState() {
    getUserinfo();
    getLead('');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Feedback Page')),
        body: SingleChildScrollView(
          child: Column(children: [
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
                    items: List<int>.generate(
                            totalpage, (int index) => index + 1,
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
                        await getLead(_searchController.text);
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              margin: const EdgeInsets.all(12),
              child: (Waiting)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: listFeedback.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              OverlayLoadingProgress.start(context);
                              appointmentProvider
                                  .fetchAppointmentsById(
                                      listFeedback[index].appointmentId)
                                  .then((value) {
                                OverlayLoadingProgress.stop(context);
                                showDialog(
                                    context: context,
                                    builder: (builder) => StatefulBuilder(
                                        builder: ((context, setState) =>
                                            XenPopupCard(
                                                gutter: CardGutter(
                                                    value.appointmentStatus,
                                                    value),
                                                body: AppointmentDetail(
                                                  user: user,
                                                  appointment: value,
                                                )))));
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.25,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Column(children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Center(
                                    child: Text(
                                      'Rating',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0;
                                          i < listFeedback[index].rate;
                                          i++) ...[
                                        const Spacer(),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 35,
                                        ),
                                        const Spacer()
                                      ]
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Center(
                                    child: Text(
                                      'Message',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: (listFeedback[index]
                                            .content
                                            .toString()
                                            .isEmpty)
                                        ? const Text('No message')
                                        : Text(listFeedback[index].content),
                                  )
                                ]),
                              ),
                            ));
                      },
                    ),
            )
          ]),
        ));
  }

  XenCardGutter? CardGutter(String value, Appointment appointment) {
    XenCardGutter gutter = XenCardGutter(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 15, 84, 187)),
                onPressed: () {
                  (appointment.isFeedback)
                      ? showDialog(
                          context: context,
                          builder: (builder) => StatefulBuilder(
                              builder: ((context, setState) => AlertDialog(
                                    content: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 200,
                                      child: Column(children: [
                                        const Center(
                                          child: Text(
                                            'Rating',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            for (var i = 0;
                                                i < appointment.feedback.rate;
                                                i++) ...[
                                              const Spacer(),
                                              const Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 40,
                                              ),
                                              const Spacer()
                                            ]
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Center(
                                          child: Text(
                                            'Message',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: (appointment.feedback.content
                                                  .toString()
                                                  .isEmpty)
                                              ? const Text('No message')
                                              : Text(
                                                  appointment.feedback.content),
                                        )
                                      ]),
                                    ),
                                  ))))
                      : showDialog(
                          context: context,
                          builder: (builder) => StatefulBuilder(
                              builder: ((context, setState) => AlertDialog(
                                    content: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 200,
                                      child: Column(children: const [
                                        Center(
                                          child: Text(
                                            'Lead have not rating for you yet !!! ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                    ),
                                  ))));
                },
                child: const Text('Feedback'),
              ))
            ],
          )),
    );
    return gutter;
  }
}
