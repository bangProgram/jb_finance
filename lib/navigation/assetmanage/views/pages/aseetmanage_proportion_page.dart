import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  List<Color> colorList = List<Color>.generate(30, (index) {
    Random random = Random();
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    return Color.fromRGBO(r, g, b, 1.0);
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: ref.watch(assetProportionProvider).when(
            error: (error, stackTrace) => Center(
              child: Text('error : $error'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
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
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (int i = 0; i < proportionList.length; i++)
                          ProportionTextWidget(
                              color: colorList[i],
                              text: proportionList[i].indutyName),
                      ],
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
  const ProportionTextWidget({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: 8,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
