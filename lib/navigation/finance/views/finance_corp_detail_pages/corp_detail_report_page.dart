import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';
import 'package:jb_finance/navigation/finance/widgets/dart_report_crolling.dart';

class CorpDetailReportPage extends StatefulWidget {
  final String corpCd;
  const CorpDetailReportPage({super.key, required this.corpCd});

  @override
  State<CorpDetailReportPage> createState() => _CorpDetailReportPageState();
}

class _CorpDetailReportPageState extends State<CorpDetailReportPage> {
  String reportTy = "";

  Future<List<dynamic>> getCorpReportList() async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/dart/reportList"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'corpCd': widget.corpCd, 'reportTy': reportTy}),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> reportMap = json.decode(response.body);
      final List<dynamic> reportList = reportMap['dartReportList'];
      print('reportList : ${reportMap['dartReportList']}');
      return reportList;
    } else {
      throw Exception('리포트 불러오기 실패');
    }
  }

  void goReportDetail(String reportCd) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DartReportCrolling(reportCd: reportCd),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: FutureBuilder(
          future: getCorpReportList(),
          builder: (context, snapshot) {
            final reportList = snapshot.data;
            if (reportList != null) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                reportTy = '';
                              });
                            },
                            child: const Text('전체'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                reportTy = 'A';
                              });
                            },
                            child: const Text('실적보고서'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('공시대상'),
                      Text('보고서명'),
                      Text('접수일자'),
                    ],
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: reportList.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) {
                        final report = reportList[index];
                        String reportNo = report['reportNo'];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(report['corpNm']),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => goReportDetail(reportNo),
                                child: Text(
                                  report['reportNm'],
                                  style: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(report['reportDt']),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                child: const Text('공시정보 없음'),
              );
            }
          },
        ),
      ),
    );
  }
}
