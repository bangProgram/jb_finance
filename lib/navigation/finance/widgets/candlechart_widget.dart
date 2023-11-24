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
  late ChartSeriesController _seriesController;
  late ZoomPanBehavior _zoomPanBehavior;

  double _befDx = 0;
  int lcnt = 0;
  int rcnt = 0;
  int stindex = 0;
  int edindex = 29;

  late List<CandleModel> initCandelModels =
      widget.candleModels.take(30).toList();
  late List<CandleModel> totalcandleModels = widget.candleModels;
  late double minPrice = widget.minPrice;
  late double maxPrice = widget.maxPrice;
  late double interval = widget.interval;

  @override
  void initState() {
    super.initState();
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      hideDelay: 2000,
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
    );
  }

  @override
  void dispose() {
    _seriesController.seriesRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          child: SfCartesianChart(
            zoomPanBehavior: _zoomPanBehavior,
            trackballBehavior: _trackballBehavior,
            // Candle 차트를 사용하도록 설정합니다.

            onChartTouchInteractionMove: (tapArgs) {
              double curDx = tapArgs.position.dx;

              print('tapArgs. : ${tapArgs.position.dx}');

              if (_befDx > curDx) {
                lcnt++;
                rcnt = 0;
              } else {
                rcnt++;
                lcnt = 0;
              }

              if (lcnt == 5) {
                lcnt = 0;
                print('최근데이터1 update : ${initCandelModels.length}');

                if (stindex - 1 >= 0) {
                  stindex--;
                  edindex--;

                  print('$stindex - $edindex = ${edindex - stindex}');
                  List<CandleModel> extracted =
                      totalcandleModels.sublist(stindex, edindex);
                  initCandelModels = extracted;

                  setState(() {});
                } else {
                  return;
                }
              } else if (rcnt == 5) {
                rcnt = 0;
                print('과거데이터1 update ${initCandelModels.length}');

                if (edindex + 1 < totalcandleModels.length) {
                  stindex++;
                  edindex++;
                  print('$stindex - $edindex = ${edindex - stindex}');
                  List<CandleModel> extracted =
                      totalcandleModels.sublist(stindex, edindex);
                  initCandelModels = extracted;
                  setState(() {});
                } else {
                  return;
                }
              }

              //left : dx 내려감
              //right : dx 올라감
              // print('$_befDx ?? ${tapArgs.position.dx}');
              _befDx = tapArgs.position.dx;
            },
            series: <ChartSeries>[
              CandleSeries<CandleModel, DateTime>(
                onRendererCreated: (controller) {
                  _seriesController = controller;
                },
                dataSource: initCandelModels,
                xValueMapper: (CandleModel data, _) => data.date,
                lowValueMapper: (CandleModel data, _) => data.low,
                highValueMapper: (CandleModel data, _) => data.high,
                openValueMapper: (CandleModel data, _) => data.open,
                closeValueMapper: (CandleModel data, _) => data.close,
                enableSolidCandles: true,
                bullColor: Colors.red,
                bearColor: Colors.blue,
                xAxisName: '일자',
                yAxisName: '주가',
              ),
            ],
            primaryXAxis: DateTimeCategoryAxis(
              isInversed: true,
              dateFormat: DateFormat.yMd(),
              majorGridLines: const MajorGridLines(width: 1),
            ),
            primaryYAxis: NumericAxis(
              minimum: widget.minPrice,
              maximum: widget.maxPrice,
              interval: widget.interval,
              numberFormat: NumberFormat(),
              opposedPosition: true,
            ),
          ),
        ),
      ),
    );
  }
}
