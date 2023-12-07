import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_detail_vm.dart';
import 'package:jb_finance/navigation/planbook/views/pages/plan_detail_info_page.dart';
import 'package:jb_finance/navigation/planbook/views/pages/plan_detail_memo_page.dart';

class PlanbookDetailScreen extends ConsumerStatefulWidget {
  final String corpCode;
  final String corpName;
  final int befClsPrice;
  const PlanbookDetailScreen({
    super.key,
    required this.corpCode,
    required this.corpName,
    required this.befClsPrice,
  });

  @override
  ConsumerState<PlanbookDetailScreen> createState() =>
      _PlanbookDetailScreenState();
}

class _PlanbookDetailScreenState extends ConsumerState<PlanbookDetailScreen> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  widget.corpName,
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
                      NumberFormat('#,###').format(widget.befClsPrice),
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
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                PlanDetailInfoPage(corpCode: widget.corpCode),
                PlanDetailMemoPage(corpCode: widget.corpCode)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
