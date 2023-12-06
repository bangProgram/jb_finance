import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_detail_vm.dart';

class PlanbookDetailScreen extends ConsumerStatefulWidget {
  final String corpCode;
  const PlanbookDetailScreen({super.key, required this.corpCode});

  @override
  ConsumerState<PlanbookDetailScreen> createState() =>
      _PlanbookDetailScreenState();
}

class _PlanbookDetailScreenState extends ConsumerState<PlanbookDetailScreen> {
  Future<void> _refreshState() async {
    await ref.read(planDetailProvider(widget.corpCode).notifier).refreshState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ref.watch(planDetailProvider(widget.corpCode)).when(
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
                return Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const FaIcon(
                                Icons.arrow_back_ios_new,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                          ),
                          title: Text(
                            data.corpName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: const Text(
                            '기업 업종구분',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                NumberFormat('#,###').format(data.befClsPrice),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                ),
                              ),
                              const Text(
                                '*전일 종가',
                                style: TextStyle(
                                  color: Color(0xFFA8A8A8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
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
                );
              },
            ));
  }
}
