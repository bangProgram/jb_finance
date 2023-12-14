import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/transaction/view_models/transaction_vm.dart';
import 'package:jb_finance/navigation/transaction/views/trans_corp_detail_screen.dart';

class TransCorpPage extends ConsumerStatefulWidget {
  const TransCorpPage({super.key});

  @override
  ConsumerState<TransCorpPage> createState() => _TransCorpPageState();
}

class _TransCorpPageState extends ConsumerState<TransCorpPage> {
  void goTransCorpDetail(String corpName) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TransCorpDetailScreen(corpName: corpName),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ref.watch(transCorpListProvider).when(
              error: (error, stackTrace) => Center(
                    child: Text('error : $error'),
                  ),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
              data: (data) {
                final corpList = data;
                if (corpList == null) {
                  return const Center(
                    child: Text('등록된 기업이 없습니다.'),
                  );
                } else {
                  return ListView.separated(
                    itemCount: 10,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemBuilder: (context, index) {
                      final corpData = corpList[index];
                      return GestureDetector(
                        onTap: () => goTransCorpDetail(corpData.corpName),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text('$index. ${corpData.corpName}'),
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ],
    );
  }
}
