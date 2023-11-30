import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/finance/models/page_models/candel_model.dart';
import 'package:jb_finance/navigation/finance/widgets/candlechart_widget.dart';
import 'package:jb_finance/navigation/finance/widgets/naver_finance_crolling_app.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';
import 'package:jb_finance/navigation/finance/widgets/naver_finance_crolling_web.dart';
import 'package:jb_finance/platforms.dart';
import 'package:jb_finance/utils.dart';

class CorpDetailInfoPage extends ConsumerStatefulWidget {
  final String corpCd;
  final Map<String, dynamic> corpDetail;
  const CorpDetailInfoPage(
      {super.key, required this.corpCd, required this.corpDetail});

  @override
  ConsumerState<CorpDetailInfoPage> createState() => _CorpDetailInfoPageState();
}

class _CorpDetailInfoPageState extends ConsumerState<CorpDetailInfoPage> {
  Future<List<dynamic>> getCorpStockPrice() async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/report/getStockPrice"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'corpCode': widget.corpCd}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> cnadleData = json.decode(response.body);
      return cnadleData['value'];
    } else {
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> getCorpPerform() async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/corp/perform"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'pCorpCode': widget.corpCd}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> resData = json.decode(response.body);
      print('resData1 : ${resData['performList']}');
      print('resData2 : ${resData['performYear']}');
      return resData;
    } else {
      throw Exception('못가져옴');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '배당수익률',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '주당 배당금',
                              style: TextStyle(
                                color: Color(0xFFA8A8A8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              '${widget.corpDetail['allocationAmount']}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              '배당 수익률',
                              style: TextStyle(
                                color: Color(0xFFA8A8A8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              '${widget.corpDetail['allocationAvg']}%',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 8,
                color: Color(0xFFF4F4F4),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 228,
                      child: FutureBuilder(
                        future: getCorpStockPrice(),
                        builder: (context, snapshot) {
                          final chartDataList = snapshot.data;
                          print('chartDataList :$chartDataList');
                          print('============================================');

                          if (chartDataList != null) {
                            List<CandleModel> candleModels = [];
                            double minPrice = 99999999;
                            double maxPrice = 0;
                            double interval = 0;

                            for (var item in chartDataList) {
                              double stckLwpr = double.parse(item['stck_lwpr']);
                              double stckHgpr = double.parse(item['stck_hgpr']);

                              candleModels.add(
                                CandleModel(
                                  date: DateTime.parse(item['stck_bsop_date']),
                                  low: stckLwpr,
                                  high: stckHgpr,
                                  open: double.parse(item['stck_oprc']),
                                  close: double.parse(item['stck_clpr']),
                                ),
                              );

                              if (minPrice > stckLwpr) {
                                minPrice = stckLwpr;
                              }
                              if (maxPrice < stckHgpr) {
                                maxPrice = stckHgpr;
                              }
                            }
                            // -stck_bsop_date	주식 영업 일자	String	Y	8	주식 영업 일자
                            // -stck_clpr	주식 종가	String	Y	10	주식 종가
                            // -stck_oprc	주식 시가	String	Y	10	주식 시가
                            // -stck_hgpr	주식 최고가	String	Y	10	주식 최고가
                            // -stck_lwpr	주식 최저가	String	Y	10	주식 최저가
                            // -flng_cls_code	락 구분 코드	String	Y	2	00:해당사항없음(락이 발생안한 경우)
                            // 01:권리락
                            // 02:배당락
                            // 03:분배락
                            // 04:권배락
                            // 05:중간(분기)배당락
                            // 06:권리중간배당락
                            // 07:권리분기배당락
                            interval = (maxPrice - minPrice) / 5;
                            print('$minPrice / $maxPrice / $interval');

                            print('chartData : ${candleModels.length}');
                            return CandlechartWidget(
                              candleModels: candleModels,
                              minPrice: minPrice - interval,
                              maxPrice: maxPrice + interval,
                              interval: interval,
                            );
                          } else {
                            return Container(
                              child: const Center(
                                child: Text('주가정보 없음'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 8,
                color: Color(0xFFF4F4F4),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '실적',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      height: 190,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                ),
                                const Text(
                                  '매출',
                                  style: TextStyle(
                                    color: Color(0xFF949494),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  '영업이익',
                                  style: TextStyle(
                                    color: Color(0xFF949494),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  '순이익',
                                  style: TextStyle(
                                    color: Color(0xFF949494),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'EPS',
                                  style: TextStyle(
                                    color: Color(0xFF949494),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: getCorpPerform(),
                              builder: (context, snapshot) {
                                final resData = snapshot.data;
                                if (resData != null) {
                                  List<dynamic> yearList =
                                      resData['performYear'];
                                  List<dynamic> performList =
                                      resData['performList'];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 15),
                                      itemCount: yearList.length,
                                      itemBuilder: (context, index) {
                                        String curentYear =
                                            '${yearList[index]['BSNS_YEAR']}';

                                        return SizedBox(
                                          width: 150,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$curentYear년',
                                                style: const TextStyle(
                                                  color: Color(0xffA8A8A8),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const Divider(
                                                color: Color(0xffD9D9D9),
                                                thickness: 1,
                                              ),
                                              const Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '종합',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffA8A8A8),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '상반기',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffA8A8A8),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '하반기',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffA8A8A8),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              for (int i = 0;
                                                  i < performList.length;
                                                  i++)
                                                if (performList[i]
                                                        ['bsnsYear'] ==
                                                    curentYear)
                                                  if (performList[i]
                                                          ['accoutId'] ==
                                                      'ifrs-full_Revenue')
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountTotal'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountTotal'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountHalf'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountHalf'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountYear'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountYear'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              for (int i = 0;
                                                  i < performList.length;
                                                  i++)
                                                if (performList[i]
                                                        ['bsnsYear'] ==
                                                    curentYear)
                                                  if (performList[i]
                                                          ['accoutId'] ==
                                                      'dart_OperatingIncomeLoss')
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountTotal'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountTotal'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountHalf'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountHalf'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountYear'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountYear'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              for (int i = 0;
                                                  i < performList.length;
                                                  i++)
                                                if (performList[i]
                                                        ['bsnsYear'] ==
                                                    curentYear)
                                                  if (performList[i]
                                                          ['accoutId'] ==
                                                      'ifrs-full_ProfitLoss')
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountTotal'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountTotal'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountHalf'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountHalf'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountYear'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountYear'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              for (int i = 0;
                                                  i < performList.length;
                                                  i++)
                                                if (performList[i]
                                                        ['bsnsYear'] ==
                                                    curentYear)
                                                  if (performList[i]
                                                          ['accoutId'] ==
                                                      'ifrs-full_BasicEarningsLossPerShare')
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountTotal'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountTotal'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountHalf'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountHalf'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            performList[i][
                                                                        'amountYear'] !=
                                                                    null
                                                                ? amountTrans(
                                                                    performList[
                                                                            i][
                                                                        'amountYear'])
                                                                : '미공시',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: Text('조회중입니다'),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 8,
                color: Color(0xFFF4F4F4),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return Platforms.accessDevice == 'web'
                                      ? const NaverFinanceCrollingWeb()
                                      : const NaverFinanceCrollingApp();
                                },
                              ),
                            ),
                            child: Container(
                              height: 58,
                              decoration: BoxDecoration(
                                color: const Color(0xFF333333),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '더 자세하게 보기',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 9,
                                    right: 10,
                                    child: Image.asset(
                                        'assets/images/buttons/naverFadein.png'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFFE9E9EC),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '거래일지 작성하기',
                              style: TextStyle(
                                color: Color(0xFF444447),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFFE9E9EC),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '목표관리 작성하기',
                              style: TextStyle(
                                color: Color(0xFF444447),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: getCorpPerform,
                child: const Text('기간별 주가정보 가져오기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
