import 'package:flutter/material.dart';

class OpportunityDetail extends StatefulWidget {
  const OpportunityDetail({super.key});

  @override
  State<OpportunityDetail> createState() => _OpportunityDetailState();
}

class _OpportunityDetailState extends State<OpportunityDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Opportunity Detail Page')),
        body: SingleChildScrollView(child: Column(children: [])));
  }
}
