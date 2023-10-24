import 'package:flutter/material.dart';

class PlanbookScreen extends StatefulWidget {
  static const String routeName = "planbook";
  static const String routeURL = "/planbook";

  const PlanbookScreen({super.key});

  @override
  State<PlanbookScreen> createState() => _PlanbookScreenState();
}

class _PlanbookScreenState extends State<PlanbookScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('플랜북'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('test1'),
              ),
              Tab(
                child: Text('test2'),
              ),
              Tab(
                child: Text('test3'),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.blue,
          ),
          Container(
            color: Colors.green,
          ),
        ]),
      ),
    );
  }
}
