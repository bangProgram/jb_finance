import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SliverTabbarHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
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
        unselectedLabelColor: Colors.grey.shade400,
        dividerColor: Colors.grey.shade400,
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 24,
            ),
            child: Icon(
              Icons.grid_4x4_sharp,
              size: 18,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 24,
            ),
            child: FaIcon(
              FontAwesomeIcons.heart,
              size: 18,
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
