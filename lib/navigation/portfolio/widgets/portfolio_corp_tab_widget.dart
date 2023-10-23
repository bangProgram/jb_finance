import 'package:flutter/material.dart';

class PortfolioCorpTabWidget extends StatefulWidget {
  const PortfolioCorpTabWidget({
    super.key,
    required this.screenW,
  });

  final double screenW;

  @override
  State<PortfolioCorpTabWidget> createState() => _PortfolioCorpTabWidgetState();
}

class _PortfolioCorpTabWidgetState extends State<PortfolioCorpTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.screenW * 0.03,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                '종목이름',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: widget.screenW * 0.90,
                child: const Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text('평가손익'),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text('12124'),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text('보유주수'),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text('10000'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: widget.screenW * 0.90,
                child: const Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text('손익률'),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text('35.19%'),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text('평균단가'),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text('12000'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
