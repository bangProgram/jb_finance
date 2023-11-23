import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/finance/models/page_models/candel_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandlechartWidget extends StatefulWidget {
  final List<CandleModel> candleModels;
  final double minPrice;
  final double maxPrice;
  final double interval;

  const CandlechartWidget(
      {Key? key,
      required this.candleModels,
      required this.minPrice,
      required this.maxPrice,
      required this.interval})
      : super(key: key);

  @override
  CandlechartWidgetState createState() => CandlechartWidgetState();
}

class CandlechartWidgetState extends State<CandlechartWidget> {
  late TrackballBehavior _trackballBehavior;

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
              CandleSeries<CandleModel, DateTime>(
                dataSource: widget.candleModels,
                xValueMapper: (CandleModel data, _) => data.date,
                lowValueMapper: (CandleModel data, _) => data.low,
                highValueMapper: (CandleModel data, _) => data.high,
                openValueMapper: (CandleModel data, _) => data.open,
                closeValueMapper: (CandleModel data, _) => data.close,
                bullColor: Colors.red,
                bearColor: Colors.blue,
                xAxisName: '일자',
                yAxisName: '주가',
              ),
            ],
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.d(),
            ),
            primaryYAxis: NumericAxis(
              minimum: widget.minPrice,
              maximum: widget.maxPrice,
              interval: widget.interval,
              numberFormat: NumberFormat(),
            ),
          ),
        ),
      ),
    );
  }
}
