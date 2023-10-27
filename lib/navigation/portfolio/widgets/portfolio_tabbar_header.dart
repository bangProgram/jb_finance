import 'package:flutter/material.dart';

class PortfolioTabbarHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
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
            child: Text('자산평가'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Text('거래내역'),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
