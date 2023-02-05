import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/providers/user/user_Provider.dart';
import 'package:crm_mobile/employee/models/kpi/kpiModel.dart';
import 'package:crm_mobile/employee/providers/kpi/kpiProvider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class KPIPage extends StatefulWidget {
  const KPIPage({super.key});

  @override
  State<KPIPage> createState() => _KPIPageState();
}

class _KPIPageState extends State<KPIPage> {
  var f = NumberFormat("###,###,###", "en_US");
  bool waiting = true;
  List<kpiPeriod> listPeriod = [];
  kpiPeriod? period;
  String namePerid = '';
  kpi KPI = kpi();
  getPeriod() async {
    await KPIProvider.fetchkpiPeriod().then((value) {
      setState(() {
        listPeriod = value;
        period = listPeriod[0];
        getKPI(listPeriod[0].id);
      });
    });
  }

  getKPI(String id) async {
    await KPIProvider.fetchkpi(id).then((value) {
      setState(() {
        KPI = value;
        waiting = false;
      });
    });
  }

  @override
  void initState() {
    getPeriod();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KPI Page')),
      body: SingleChildScrollView(
          child: (waiting)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: const Text('Period: '),
                        ),
                        SizedBox(
                          child: DropdownButton2(
                            value: period,
                            hint: const Text('KPI Period',
                                style: TextStyle(fontSize: 16)),
                            dropdownMaxHeight: 300,
                            items: listPeriod
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Container(
                                      width: 200,
                                      alignment: Alignment.center,
                                      child: Text(e.period),
                                    )))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                period = period;
                                namePerid = value!.period;
                                waiting = true;
                                getKPI(value!.id);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Name : ${KPI.name}',
                          style: TextStyle(fontSize: 15),
                        ),
                        const Spacer(),
                        Text('Employee : ${KPI.employeeName}',
                            style: TextStyle(fontSize: 15)),
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        CircularPercentIndicator(
                          radius: 70.0,
                          lineWidth: 13.0,
                          animation: true,
                          percent: KPI.actualCall / KPI.expectedCall,
                          center: Text(
                            "${KPI.actualCall}/${KPI.expectedCall}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          footer: const Text(
                            "Call",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.purple,
                        ),
                        const Spacer(),
                        CircularPercentIndicator(
                          radius: 70.0,
                          lineWidth: 13.0,
                          animation: true,
                          percent: KPI.actualMeeting / KPI.expectedMeeting,
                          center: Text(
                            "${KPI.actualMeeting}/${KPI.expectedMeeting}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          footer: const Text(
                            "Meeting",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.purple,
                        ),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        CircularPercentIndicator(
                          radius: 70.0,
                          lineWidth: 13.0,
                          animation: true,
                          percent:
                              KPI.actualLeadConvert / KPI.expectedLeadConvert,
                          center: Text(
                            "${KPI.actualLeadConvert}/${KPI.expectedLeadConvert}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          footer: const Text(
                            "Lead Convert",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.purple,
                        ),
                        const Spacer(),
                        CircularPercentIndicator(
                          radius: 70.0,
                          lineWidth: 13.0,
                          animation: true,
                          percent: KPI.actualSales / KPI.expectedSales,
                          center: Text(
                            "${KPI.actualSales}/${KPI.expectedSales}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          footer: const Text(
                            "Sales",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.purple,
                        ),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircularPercentIndicator(
                          radius: 100.0,
                          lineWidth: 13.0,
                          animation: true,
                          percent: KPI.actualRevenue / KPI.expectedRevenue,
                          center: SizedBox(
                            width: 90,
                            child: AutoSizeText(
                              maxLines: 2,
                              "${KPI.actualRevenue}/${f.format(KPI.expectedRevenue)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          ),
                          footer: const Text(
                            "Revenue",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.purple,
                        ),
                      ],
                    )
                  ],
                )),
    );
  }
}
