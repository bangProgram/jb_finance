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
            return Column(
              children: [
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
        );
  }
}
