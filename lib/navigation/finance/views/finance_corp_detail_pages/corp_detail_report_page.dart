import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';
import 'package:jb_finance/navigation/finance/view_models/page_view_models/corp_detail_vm.dart';
import 'package:jb_finance/navigation/finance/widgets/dart_report_crolling.dart';

class CorpDetailReportPage extends ConsumerStatefulWidget {
  final String corpCd;
  const CorpDetailReportPage({super.key, required this.corpCd});

  @override
  ConsumerState<CorpDetailReportPage> createState() =>
      _CorpDetailReportPageState();
}

class _CorpDetailReportPageState extends ConsumerState<CorpDetailReportPage> {
  String reportTy = "";

  late Map<String, dynamic> param = {'corpCd': widget.corpCd, 'reportTy': ''};

  void goReportDetail(String reportCd) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DartReportCrolling(reportCd: reportCd),
      ),
    );
  }

  void getReport() async {
    print('reportTy : $reportTy');
    await ref
        .read(corpDetailReportProvider(widget.corpCd).notifier)
        .getReport(reportTy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ref.watch(corpDetailReportProvider(widget.corpCd)).when(
                error: (error, stackTrace) => Center(
                  child: Text('error : $error'),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                data: (data) {
                  final reportList = data;
                  if (reportList != null) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      reportTy = '';
                                      getReport();
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: reportTy == ''
                                          ? const Color(0xFF333333)
                                          : const Color(0xFFE7E7E7),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Text(
                                      '전체',
                                      style: TextStyle(
                                        color: reportTy == ''
                                            ? Colors.white
                                            : const Color(0xFFB1B1B1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      reportTy = 'A';
                                      getReport();
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: reportTy == 'A'
                                          ? const Color(0xFF333333)
                                          : const Color(0xFFE7E7E7),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Text(
                                      '실적보고서',
                                      style: TextStyle(
                                        color: reportTy == 'A'
                                            ? Colors.white
                                            : const Color(0xFFB1B1B1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            color: Color(0xfff6f6f6),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '보고서명',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xffa7a7a7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '접수일자',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xffa7a7a7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: reportList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemBuilder: (context, index) {
                              final report = reportList[index];
                              String reportNo = report.reportNo;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 17,
                                  horizontal: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: GestureDetector(
                                        onTap: () => goReportDetail(reportNo),
                                        child: Text(
                                          report.reportNm,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        report.reportDt,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
              )),
    );
  }
}
