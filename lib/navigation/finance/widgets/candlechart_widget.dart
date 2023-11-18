import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandlechartWidget extends StatefulWidget {
  const CandlechartWidget({Key? key}) : super(key: key);

  @override
  CandlechartWidgetState createState() => CandlechartWidgetState();
}

class CandlechartWidgetState extends State<CandlechartWidget> {
  late TrackballBehavior _trackballBehavior;

  List<CandleData> getCandleData() {
    return <CandleData>[
      CandleData(DateTime(2023, 11, 1), 4500, 10000, 4500, 4500),
      CandleData(DateTime(2023, 11, 2), 4500, 10000, 4000, 4500),
      CandleData(DateTime(2023, 11, 3), 4500, 10000, 5500, 6000),
      CandleData(DateTime(2023, 11, 4), 4500, 10000, 9000, 3000),
      CandleData(DateTime(2023, 11, 5), 4500, 10000, 3500, 6000),
      CandleData(DateTime(2023, 11, 6), 4500, 10000, 6000, 5500),
      CandleData(DateTime(2023, 11, 7), 4500, 10000, 5500, 4500),
      CandleData(DateTime(2023, 11, 8), 4500, 10000, 4500, 3500),
      CandleData(DateTime(2023, 11, 9), 4500, 10000, 3500, 7500),
      CandleData(DateTime(2023, 11, 10), 4500, 10000, 7500, 8005),
      CandleData(DateTime(2023, 11, 11), 4500, 10000, 6500, 8005),
      CandleData(DateTime(2023, 11, 12), 4500, 10000, 5500, 7005),
      CandleData(DateTime(2023, 11, 13), 4500, 10000, 6000, 8000),
      CandleData(DateTime(2023, 11, 14), 4500, 10000, 6500, 8005),
      // 추가적인 데이터도 필요하다면 이어서 추가할 수 있습니다.
    ];
  }

  @override
  void initState() {
    super.initState();
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true, // 스크롤 활성화
              enablePinching: true, // 줌 활성화
              enableDoubleTapZooming: true, // 더블 탭으로 확대
            ),
            trackballBehavior: _trackballBehavior,
            // Candle 차트를 사용하도록 설정합니다.
            series: <ChartSeries>[
              CandleSeries<CandleData, DateTime>(
                dataSource: getCandleData(),
                xValueMapper: (CandleData data, _) => data.date,
                lowValueMapper: (CandleData data, _) => data.low,
                highValueMapper: (CandleData data, _) => data.high,
                openValueMapper: (CandleData data, _) => data.open,
                closeValueMapper: (CandleData data, _) => data.close,
                bullColor: Colors.red,
                bearColor: Colors.blue,
                xAxisName: '일자',
                yAxisName: '주가',
              ),
            ],
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.yMd(),
              majorGridLines: const MajorGridLines(
                width: 0,
              ),
            ),
            primaryYAxis: NumericAxis(
              minimum: 1000,
              maximum: 12000,
              interval: 2 * 1000,
              numberFormat: NumberFormat(),
            ),
          ),
        ),
      ),
    );
  }
}

class CandleData {
  CandleData(this.date, this.low, this.high, this.open, this.close);

  final DateTime date;
  final double open;
  final double close;
  final double high;
  final double low;
}
