import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_detail_vm.dart';

class PlanDetailInfoPage extends ConsumerStatefulWidget {
  final String corpCode;
  const PlanDetailInfoPage({super.key, required this.corpCode});

  @override
  ConsumerState<PlanDetailInfoPage> createState() => _PlanDetailInfoPageState();
}

class _PlanDetailInfoPageState extends ConsumerState<PlanDetailInfoPage> {
  Future<void> _refreshState() async {
    await ref
        .read(planDetailInfoProvider(widget.corpCode).notifier)
        .refreshState();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(planDetailInfoProvider(widget.corpCode)).when(
          error: (error, stackTrace) => RefreshIndicator(
            onRefresh: _refreshState,
            child: Stack(
              children: [
                Center(
                  child: Text('error : $error'),
                ),
                Positioned.fill(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) => Container(),
                  ),
                ),
              ],
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          data: (data) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffEFEFEF),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFCFCFC),
                                      border: Border(
                                        right: BorderSide(
                                            color: Color(0xffefefef),
                                            width: 1.5),
                                      ),
                                    ),
                                    child: const Text('주식수량'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    NumberFormat('#,###')
                                        .format(data.sharesAmount),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFCFCFC),
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffefefef),
                                          width: 1.5,
                                        ),
                                        right: BorderSide(
                                            color: Color(0xffefefef),
                                            width: 1.5),
                                      ),
                                    ),
                                    child: const Text('시가총액'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    NumberFormat('#,###')
                                        .format(data.marketCapital),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                            color: Color(0xffEFEFEF),
                            thickness: 1.5,
                          ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFCFCFC),
                                      border: Border(
                                        right: BorderSide(
                                            color: Color(0xffefefef),
                                            width: 1.5),
                                      ),
                                    ),
                                    child: const Text('거래량'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    NumberFormat('#,###')
                                        .format(data.tradeVolume),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFCFCFC),
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffefefef),
                                          width: 1.5,
                                        ),
                                        right: BorderSide(
                                          color: Color(0xffefefef),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('거래금액'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    NumberFormat('#,###')
                                        .format(data.tradeAmount),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xffe9e9e7),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: const Color(0xffF6F6F6),
                                    padding: const EdgeInsets.all(9),
                                    child: const Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '추정 EPS',
                                            style: TextStyle(
                                              color: Color(0xffA7A7A7),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.error_outline,
                                            color: Color(0xffa7a7a7),
                                            size: 19,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: '추정값',
                                        hintStyle: TextStyle(
                                          fontSize: 10,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xffe9e9e7),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: const Color(0xffF6F6F6),
                                    padding: const EdgeInsets.all(9),
                                    child: const Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '추정 PER',
                                            style: TextStyle(
                                              color: Color(0xffA7A7A7),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.error_outline,
                                            color: Color(0xffa7a7a7),
                                            size: 19,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: '추정값',
                                        hintStyle: TextStyle(
                                          fontSize: 10,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffe9e9e7),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            color: const Color(0xffF6F6F6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Text('per'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: '추정값',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('per'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('per'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('per'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('per'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                            color: Color(0xffe9e9e7),
                            thickness: 1.5,
                          ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF6F6F6),
                                    ),
                                    child: const Text('상태'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('매수'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('비중확대'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('중립'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('비중축소'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Color(0xffE9E9E7),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: const Text('매도'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(data.periodNm),
                    Text('주식수량 : ${data.sharesAmount}'),
                    Text('시가총액 : ${data.marketCapital}'),
                    Text('거래량 : ${data.tradeVolume}'),
                    Text('거래금액 : ${data.tradeAmount}'),
                    Text('시가 : ${data.stPrice}'),
                    Text('고가 : ${data.hgPrice}'),
                    Text('저가 : ${data.lwPrice}'),
                    Text('추정 eps : ${data.estimateEps}'),
                    Text('추정 per : ${data.estimatePer}'),
                    Text('추정 cagr : ${data.estimateCagr}'),
                  ],
                ),
              ),
            );
          },
        );
  }
}
