import 'package:flutter/material.dart';

class AssetmanageTabbarHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
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
            child: TabBar(
              unselectedLabelColor: Colors.grey.shade400,
              dividerColor: Colors.grey.shade400,
              tabs: const [
                Tab(
                  child: Text('자산평가'),
                ),
                Tab(
                  child: Text('거래내역'),
                ),
              ],
              indicator: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
