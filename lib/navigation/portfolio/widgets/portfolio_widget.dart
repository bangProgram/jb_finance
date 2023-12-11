import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/portfolio/models/portfolio_model.dart';
import 'package:jb_finance/commons/widgets/piechart_widget.dart';

class PortfolioWidget extends StatefulWidget {
  final PortfolioModel data;
  final double size;

  const PortfolioWidget({
    super.key,
    required this.data,
    required this.size,
  });

  @override
  State<PortfolioWidget> createState() => _PortfolioWidgetState();
}

class _PortfolioWidgetState extends State<PortfolioWidget> {
  final GlobalKey<FormState> _portfolioKey = GlobalKey<FormState>();

  late double investAmount = widget.data.investAmount.toDouble();
  late double depositAmount = widget.data.depositAmount.toDouble();
  late double reserveAmount = widget.data.reserveAmount.toDouble();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Form(
            key: _portfolioKey,
            child: Row(
              children: [
                PiechartWidget(
                  size: widget.size,
                  values: [
                    PieChartSegment(investAmount, Colors.orange),
                    PieChartSegment(depositAmount, Colors.blue),
                    PieChartSegment(reserveAmount, Colors.red),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: widget.size,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 50,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            const Text('투자금'),
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                NumberFormat("#,###.##").format(investAmount),
                            decoration: const InputDecoration(),
                            enabled: false,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 50,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            const Text('예수금'),
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                NumberFormat("#,###.##").format(depositAmount),
                            enabled: false,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 50,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            const Text('예비금'),
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                NumberFormat("#,###.##").format(reserveAmount),
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
