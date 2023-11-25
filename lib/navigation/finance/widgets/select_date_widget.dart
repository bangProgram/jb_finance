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
          color: const Color(0xFFEFEFEF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '',
        style: TextStyle(
          color: diffCnt == thisCnt && selType == type
              ? Colors.white
              : const Color(0xFF333333),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
