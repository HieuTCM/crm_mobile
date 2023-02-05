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
import 'package:intl/intl.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:xen_popup_card/xen_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<Feedbackmodel> listFeedback = [];
  bool Waiting = true;
  bool WaitingRating = true;
  UserObj user = UserObj();
  Rating rating = Rating();

  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "6"});
  final TextEditingController _searchController = TextEditingController();

  int totalRow = 0;
  int pageNumber = 1;
  int pageCurrent = 1;
  int totalpage = 1;
  double avenge = 0.0;
  int totalRating = 0;
  var f = NumberFormat("#.0#", "en_US");
  getUserinfo() async {
    userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  getRating() async {
    feedbackProvider.fetchRating().then((value) {
      setState(() {
        rating = value;

        avenge = double.parse(f.format(rating.average));
        totalRating = rating.rate_1 +
            rating.rate_2 +
            rating.rate_3 +
            rating.rate_4 +
            rating.rate_5;

        WaitingRating = false;
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
    getRating();
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
        appBar: AppBar(
          title: const Text('Feedback Page'),
          actions: [
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
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            (WaitingRating)
                ? const SizedBox(
                    height: 10,
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 160,
                        child: CircularPercentIndicator(
                          radius: 70,
                          lineWidth: 13,
                          animation: true,
                          percent: avenge / 5,
                          center: Text(
                            '${avenge}/5',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          footer: const Text(
                            "Rating",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.blue,
                        ),
                      ),
                      Row(
                        children: [
                          const Text('5'),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 50,
                            animation: true,
                            barRadius: const Radius.circular(12),
                            lineHeight: 10.0,
                            animationDuration: 500,
                            percent: rating.rate_5 / totalRating,
                            center: Text(''),
                            progressColor: Colors.yellow,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('4'),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 50,
                            animation: true,
                            barRadius: const Radius.circular(12),
                            lineHeight: 10.0,
                            animationDuration: 500,
                            percent: rating.rate_4 / totalRating,
                            center: Text(''),
                            progressColor: Colors.yellow,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('3'),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 50,
                            animation: true,
                            barRadius: const Radius.circular(12),
                            lineHeight: 10.0,
                            animationDuration: 500,
                            percent: rating.rate_3 / totalRating,
                            center: Text(''),
                            progressColor: Colors.yellow,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('2'),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 50,
                            animation: true,
                            barRadius: const Radius.circular(12),
                            lineHeight: 10.0,
                            animationDuration: 500,
                            percent: rating.rate_2 / totalRating,
                            center: Text(''),
                            progressColor: Colors.yellow,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('1'),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 50,
                            animation: true,
                            barRadius: const Radius.circular(12),
                            lineHeight: 10.0,
                            animationDuration: 500,
                            percent: rating.rate_1 / totalRating,
                            center: Text(''),
                            progressColor: Colors.yellow,
                          ),
                        ],
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
                  : (listFeedback[0].id == null)
                      ? const Center(
                          child: Text('Feedback not found'),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Column(children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Center(
                                        child: Text(
                                          'Rating',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Spacer(),
                                          for (var i = 0;
                                              i < listFeedback[index].rate;
                                              i++) ...[
                                            const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 35,
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            )
                                          ],
                                          const Spacer()
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
