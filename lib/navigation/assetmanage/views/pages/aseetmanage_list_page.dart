import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/page_view_models/aseetmanage_page_vm.dart';

class AssetmanageListPage extends ConsumerStatefulWidget {
  const AssetmanageListPage({
    super.key,
    required this.screenW,
  });

  final double screenW;

  @override
  ConsumerState<AssetmanageListPage> createState() =>
      _AssetmanageListPageState();
}

class _AssetmanageListPageState extends ConsumerState<AssetmanageListPage> {
  void getAssetList() async {
    await ref.read(assetListProvider.notifier).getAssetList();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(assetListProvider).when(
          error: (error, stackTrace) => Center(
            child: Text('error : $error'),
          ),
          loading: () {
            getAssetList();
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          data: (data) {
            final assetList = data;
            return ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: assetList.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                final assetData = assetList[index];
                if (assetData.corpCode == "") {
                  return const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 40,
                    ),
                    child: Center(child: Text('포트폴리오에 보유중인 종목이 없습니다.')),
                  );
                } else {
                  return Container(
                    height: 135,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            assetData.corpName,
                            style: const TextStyle(
                              color: Color(0xff333333),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${assetData.holdQuantity} 주',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: Text(
                                          '보유주수',
                                          style: TextStyle(
                                            color: Color(0xffC4C4C4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(flex: 2, child: Container()),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${NumberFormat('#,###').format(assetData.valPrice)} 원',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: Text(
                                          '평가손익',
                                          style: TextStyle(
                                            color: Color(0xffC4C4C4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          assetData.holdQuantity == 0
                                              ? '-- %'
                                              : '${NumberFormat('#,###.##').format(((assetData.befClsPrice / assetData.avgPrice) - 1) * 100)} %',
                                          style: TextStyle(
                                            color: assetData.holdQuantity == 0
                                                ? Colors.black
                                                : ((assetData.befClsPrice /
                                                                    assetData
                                                                        .avgPrice) -
                                                                1) *
                                                            100 >
                                                        0
                                                    ? Colors.red
                                                    : Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: Text(
                                          '손익률',
                                          style: TextStyle(
                                            color: Color(0xffC4C4C4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${NumberFormat('#,###').format(assetData.befClsPrice)} 원',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: Text(
                                          '전일종가',
                                          style: TextStyle(
                                            color: Color(0xffC4C4C4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${NumberFormat('#,###').format(assetData.avgPrice)} 원',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: Text(
                                          '평균단가',
                                          style: TextStyle(
                                            color: Color(0xffC4C4C4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        );
  }
}
