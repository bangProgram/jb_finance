import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jb_finance/commons/widgets/piechart_widget.dart';

class AssetmanageProportionPage extends StatefulWidget {
  const AssetmanageProportionPage({super.key});

  @override
  State<AssetmanageProportionPage> createState() =>
      _AssetmanageProportionPageState();
}

class _AssetmanageProportionPageState extends State<AssetmanageProportionPage> {
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('보유주식 비중'),
          ],
        ),
        PiechartWidget(
          size: screenW * (2 / 3),
          values: [
            PieChartSegment(1902475, Colors.orange),
            PieChartSegment(1661700, Colors.blue),
            PieChartSegment(1271250, Colors.red),
          ],
        )
      ],
    );
  }
}
