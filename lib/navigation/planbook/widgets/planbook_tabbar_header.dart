import 'package:flutter/material.dart';

class PlanbookTabbarHeader extends SliverPersistentHeaderDelegate {
  final double screenH;
  final String headerData;

  const PlanbookTabbarHeader({required this.screenH, required this.headerData});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final screenH = MediaQuery.of(context).size.height;
    print('headerData : $headerData');
    return Container(
      height: screenH * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(headerData),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('추정 EPS'),
                          Text('3463'),
                          Text('추정 CAGR'),
                          Text('0.84'),
                        ],
                      ),
                      const Text('평균 성장률'),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('매출'),
                          Text('7.16'),
                          Text('영업이익'),
                          Text('22.69'),
                          Text('순이익'),
                          Text('22.47'),
                        ],
                      ),
                    ],
                  ),
                  FractionallySizedBox(
                    heightFactor: 1,
                    widthFactor: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('목표'),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                Text(headerData),
                              ],
                            ),
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('상세보기'),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: Colors.grey.shade400,
            dividerColor: Colors.grey.shade400,
            tabs: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                child: Text('단기'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                child: Text('중기'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                child: Text('장기'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => screenH * 0.3;

  @override
  double get minExtent => screenH * 0.3;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
