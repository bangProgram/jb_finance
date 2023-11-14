import 'package:flutter/material.dart';
import 'package:jb_finance/navigation/finance/widgets/naver_finance_crolling.dart';

class CorpDetailInfoPage extends StatefulWidget {
  const CorpDetailInfoPage({super.key});

  @override
  State<CorpDetailInfoPage> createState() => _CorpDetailInfoPageState();
}

class _CorpDetailInfoPageState extends State<CorpDetailInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [];
        },
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        color: Colors.red,
                        width: 200,
                        height: 100,
                      ),
                      Container(
                        color: Colors.blue,
                        width: 200,
                        height: 100,
                      ),
                      Container(
                        color: Colors.red,
                        width: 200,
                        height: 100,
                      ),
                      Container(
                        color: Colors.blue,
                        width: 200,
                        height: 100,
                      ),
                    ],
                  ),
                  const Column(
                    children: [
                      Row(
                        children: [
                          Text('매출액 / 영업이익 / 순이익'),
                          Text('년도/반기'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '2023년도',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '2022년도',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '2021년도',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '2020년도',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '2023년도',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '2022년도',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '2021년도',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '2020년도',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const NaverFinanceCrolling(),
              )),
              child: const Text('네이버크롤링 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
