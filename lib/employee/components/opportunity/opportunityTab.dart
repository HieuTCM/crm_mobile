import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_mobile/employee/models/opportunity/opportunityModel.dart';
import 'package:crm_mobile/employee/pages/opportunity/opportunityDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OpportunityTab extends StatefulWidget {
  // List<TaskDetail> listTaskDetails;
  Opportunity opportunity;
  // TaskDetail TaskDetails;
  OpportunityTab({
    super.key,
    required this.opportunity,
    // required this.TaskDetails,
    // required this.listTaskDetails
  });

  @override
  State<OpportunityTab> createState() => _OpportunityTabState();
}

class _OpportunityTabState extends State<OpportunityTab> {
  var f = NumberFormat("###,###,###.0#", "en_US");
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
      height: 150,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue, width: 3)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OpportunityDetail(
                        opportunity: widget.opportunity,
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: AutoSizeText(widget.opportunity.name,
                    style: const TextStyle(fontSize: 16)),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 0.35,
                child: AutoSizeText(widget.opportunity.opportunityStatus,
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                'Create Date: ',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: AutoSizeText(widget.opportunity.createDate,
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                'Listed Price: ',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: AutoSizeText(
                    '${f.format(widget.opportunity.listedPrice)}  VND',
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: AutoSizeText(widget.opportunity.description,
                    style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
