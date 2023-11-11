import 'package:flutter/material.dart';

class FinanceTabbarHeader extends SliverPersistentHeaderDelegate {
  final List<String> tabList;

  const FinanceTabbarHeader({required this.tabList});

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
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        unselectedLabelColor: Colors.black.withOpacity(0.3),
        tabs: [
          for (String tabNm in tabList)
            Tab(
              child: Text(
                tabNm,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
