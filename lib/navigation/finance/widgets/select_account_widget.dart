import 'package:flutter/material.dart';

class SelectAccountWidget extends StatelessWidget {
  final String text;
  final String thisAccount;
  final List<String> accountList;

  const SelectAccountWidget({
    super.key,
    required this.text,
    required this.thisAccount,
    required this.accountList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: accountList.contains(thisAccount)
            ? const Color(0xFF333333)
            : Colors.white,
        border: Border.all(
          color: const Color(0xFFEFEFEF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: accountList.contains(thisAccount)
              ? Colors.white
              : const Color(0xFF333333),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
