import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/navigation/planbook/widgets/planbook_tabbar_header.dart';

class PlanbookScreen extends StatefulWidget {
  static const String routeName = "planbook";
  static const String routeURL = "/planbook";

  const PlanbookScreen({super.key});

  @override
  State<PlanbookScreen> createState() => _PlanbookScreenState();
}

class _PlanbookScreenState extends State<PlanbookScreen> {
  Widget rowWidget = Container(
    padding: const EdgeInsets.all(10),
    height: 60,
    color: Colors.amber,
    child: const Row(
      children: [
        Text('컬럼아무거나1'),
        Text('컬럼아무거나2'),
        Text('컬럼아무거나3'),
        Text('컬럼아무거나4'),
        Text('컬럼아무거나5'),
        Text('컬럼아무거나6'),
      ],
    ),
  );

  String headerData = "";

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    print('planbook rebuild?');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  centerTitle: true,
                  title: const Text('플랜북'),
                  elevation: 0,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.penToSquare,
                      ),
                    ),
                  ],
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PlanbookTabbarHeader(
                    screenH: screenH,
                    headerData: headerData,
                  ),
                )
              ];
            },
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        for (int i = 0; i < 20; i++)
                          GestureDetector(
                              onTap: () {
                                print('$i 번째 클릭');
                                headerData = '$i 번째 데이터';
                                setState(() {});
                              },
                              child: rowWidget)
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.blue,
                ),
              ],
            )),
      ),
    );
  }
}
