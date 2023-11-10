import 'package:flutter/material.dart';

class SelectDateWidget extends StatelessWidget {
  final String type;
  final int thisCnt;
  final int diffCnt;
  final String selType;

  const SelectDateWidget({
    super.key,
    required this.type,
    required this.thisCnt,
    required this.diffCnt,
    required this.selType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: diffCnt == thisCnt && selType == type
            ? const Color(0xFF333333)
            : Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '최근 $thisCnt$type',
        style: TextStyle(
          color: diffCnt == thisCnt && selType == type
              ? Colors.white
              : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
