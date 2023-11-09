import 'package:flutter/material.dart';

class SelectDateWidget extends StatelessWidget {
  final int thisYear;
  final int diffYear;

  const SelectDateWidget({
    super.key,
    required this.thisYear,
    required this.diffYear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: diffYear == thisYear ? const Color(0xFF333333) : Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '최근 $thisYear년',
        style: TextStyle(
          color: diffYear == thisYear ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
