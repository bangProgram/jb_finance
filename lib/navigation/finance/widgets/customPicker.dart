import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final String period;
  final Function(String, String, String?) setPeriodData;
  final List<String> yearList;
  final List<int> halfCntList;
  final Map<String, dynamic> curData;

  const CustomPicker({
    super.key,
    required this.period,
    required this.setPeriodData,
    required this.yearList,
    required this.halfCntList,
    required this.curData,
  });

  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  List halfNm = ['전체', '상반기', '하반기'];

  List halfCd = [null, '0302', '0301'];

  int halfCnt = 3;

  late String curYear = widget.curData['p${widget.period}Year'];
  late String? curHalf = widget.curData['p${widget.period}Half'];
  late Map<String, dynamic> curData = widget.curData;

  void onChange(String year) {
    final index = widget.yearList.indexOf(year);
    setState(() {
      halfCnt = widget.halfCntList[index];
      curHalf = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffDCDEE0),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<String?>(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            borderRadius: BorderRadius.circular(15),
            underline: Container(),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            value: curYear == '' ? '2016' : curYear,
            onChanged: (newValue) {
              if (newValue != null) {
                int edYear = int.parse(curData['pEdYear']);
                if (widget.period == 'St') {
                  if (int.parse(newValue) <= edYear) {
                    widget.setPeriodData('Year', widget.period, newValue);
                    widget.setPeriodData('Half', widget.period, null);
                    onChange(newValue);
                    setState(() {
                      curYear = newValue;
                    });
                  }
                } else {
                  widget.setPeriodData('Year', widget.period, newValue);
                  widget.setPeriodData('Half', widget.period, null);
                  onChange(newValue);
                  setState(() {
                    curYear = newValue;
                  });
                }
              }
            },
            items: List.generate(
              widget.yearList.length,
              (index) => DropdownMenuItem<String?>(
                value: widget.yearList[index],
                child: Text(widget.yearList[index]),
              ),
            ),
          ),
        ),
        Container(
          width: 90,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffDCDEE0),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<String?>(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            borderRadius: BorderRadius.circular(15),
            underline: Container(),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            value: curHalf,
            onChanged: (newValue) {
              if (newValue != null) {
                widget.setPeriodData('Half', widget.period, newValue);
                setState(() {
                  curHalf = newValue;
                });
              }
            },
            items: List.generate(
              halfCnt,
              (index) => DropdownMenuItem<String?>(
                value: halfCd[index],
                child: Text('${halfNm[index]}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
