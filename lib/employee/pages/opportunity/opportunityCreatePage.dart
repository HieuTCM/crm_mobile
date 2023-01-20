import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class opportunityCreatePage extends StatefulWidget {
  const opportunityCreatePage({super.key});

  @override
  State<opportunityCreatePage> createState() => _opportunityCreatePageState();
}

class _opportunityCreatePageState extends State<opportunityCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opportunity Create Page')),
      body: Container(),
    );
  }
}
