import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/commons/widgets/piechart_widget.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/page_view_models/aseetmanage_page_vm.dart';

class AssetmanageProportionPage extends ConsumerStatefulWidget {
  const AssetmanageProportionPage({super.key});

  @override
  ConsumerState<AssetmanageProportionPage> createState() =>
      _AssetmanageProportionPageState();
}

class _AssetmanageProportionPageState
    extends ConsumerState<AssetmanageProportionPage> {
  List<Color> colorList = [
    const Color(0xffF4364C),
    const Color(0xff333333),
    const Color(0xff477EEA),
    const Color(0xffFFC84D),
    const Color(0xff2DB400),
    const Color(0xffFFB7B7),
    const Color(0xffAADFF7),
    const Color(0xffA0E7E5),
    const Color(0xff92A8D1),
    const Color(0xffA8D8B9),
    const Color(0xffFB9FB9),
    const Color(0xff39A420),
    const Color(0xffB5E7A0),
    const Color(0xffD9B3FF),
    const Color(0xff9370DB),
    const Color(0xffD8BFD8),
    const Color(0xff9932CC),
    const Color(0xff5C6F93),
    const Color(0xff9370DB),
    const Color(0xffE77D00),
  ];

  void getAssetProportion() async {
    await ref.read(assetProportionProvider.notifier).getAssetProportion({});
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: ref.watch(assetProportionProvider).when(
            error: (error, stackTrace) => Center(
              child: Text('error : $error'),
            ),
            loading: () {
              getAssetProportion();
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            data: (data) {
              final proportionList = data;
              if (proportionList == null) {
                return const Center(
                  child: Text('비중정보가 없습니다.'),
                );
              } else {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 15,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '보유주식 비중',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    PiechartWidget(
                      size: screenW * (2 / 3),
                      values: [
                        for (int i = 0; i < proportionList.length; i++)
                          PieChartSegment(
                              proportionList[i].totalAmount.toDouble(),
                              colorList[i]),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i < proportionList.length; i++)
                                  ProportionTextWidget(
                                    color: colorList[i],
                                    text: proportionList[i].indutyName,
                                    rate: double.parse(
                                        proportionList[i].amountRate),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
            },
          ),
    );
  }
}

class ProportionTextWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double rate;
  const ProportionTextWidget({
    super.key,
    required this.color,
    required this.text,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${NumberFormat('#,###.##').format(rate)} %',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
