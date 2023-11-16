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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '배당수익률',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            '주당 배당금',
                            style: TextStyle(
                              color: Color(0xFFA8A8A8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '1,416원',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '배당 수익률',
                            style: TextStyle(
                              color: Color(0xFFA8A8A8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '3.70%',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 8,
              color: Color(0xFFF4F4F4),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('매출액 / 영업이익 / 순이익'),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 10,
                              ),
                              child: Column(
                                children: [
                                  const Text('2023년'),
                                  const Divider(
                                    thickness: 1,
                                    color: Color(0xFFF4F4F4),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Container()),
                                            const Expanded(child: Text('총합')),
                                            const Expanded(child: Text('하반기')),
                                            const Expanded(child: Text('상반기')),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Expanded(child: Text('매출')),
                                            Expanded(child: Text('3.9조')),
                                            Expanded(child: Text('3.9조')),
                                            Expanded(child: Text('3.9조')),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Expanded(child: Text('영업이익')),
                                            Expanded(child: Text('3.9조')),
                                            Expanded(child: Text('3.9조')),
                                            Expanded(child: Text('3.9조')),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Expanded(child: Text('순이익')),
                                            Expanded(child: Text('3.9조')),
                                            Expanded(child: Text('3.9조')),
                                            Expanded(child: Text('3.9조')),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
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
