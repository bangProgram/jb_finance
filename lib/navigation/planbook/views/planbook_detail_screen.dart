import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlanbookDetailScreen extends ConsumerStatefulWidget {
  final String corpCode;
  const PlanbookDetailScreen({super.key, required this.corpCode});

  @override
  ConsumerState<PlanbookDetailScreen> createState() => _PlanbookDetailScreenState();
}

class _PlanbookDetailScreenState extends ConsumerState<PlanbookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              
            ],
          )
        ],
      ),
    );
  }
}
