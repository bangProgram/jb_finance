import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PlanbookDetailScreen extends ConsumerStatefulWidget {
  final String corpCode;
  const PlanbookDetailScreen({super.key, required this.corpCode});

  @override
  ConsumerState<PlanbookDetailScreen> createState() =>
      _PlanbookDetailScreenState();
}

class _PlanbookDetailScreenState extends ConsumerState<PlanbookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const FaIcon(
                        Icons.arrow_back_ios_new,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                  ),
                  title: Text(
                    widget.corpCode,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    '기업 업종구분',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NumberFormat('#,###').format(73000),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        '*전일 종가',
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
