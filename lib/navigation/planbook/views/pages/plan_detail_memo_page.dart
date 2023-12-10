import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_detail_vm.dart';

class PlanDetailMemoPage extends ConsumerStatefulWidget {
  final String corpCode;
  const PlanDetailMemoPage({super.key, required this.corpCode});

  @override
  ConsumerState<PlanDetailMemoPage> createState() => _PlanDetailMemoPageState();
}

class _PlanDetailMemoPageState extends ConsumerState<PlanDetailMemoPage> {
  final TextEditingController _textEditingController = TextEditingController();

  String memo = '';

  void onClear() {
    _textEditingController.clear();
    setState(() {
      memo = '';
    });
  }

  void addPlanMemo() async {
    String text = _textEditingController.text;
    if (text != '') {
      _textEditingController.clear();
      await ref
          .read(planDetailMemoProvider(widget.corpCode).notifier)
          .addPlanMemo(memo);
      setState(() {
        memo = '';
      });
    } else {
      return;
    }
  }

  void delPlanMemo(int seq) async {
    await ref
        .read(planDetailMemoProvider(widget.corpCode).notifier)
        .delPlanMemo(seq);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ref
                      .watch(planDetailMemoProvider(widget.corpCode))
                      .when(
                        error: (error, stackTrace) => Center(
                          child: Text('error : $error'),
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        data: (data) {
                          final memoList = data;
                          if (memoList != null) {
                            return Container(
                              padding: const EdgeInsets.only(
                                bottom: 65,
                              ),
                              child: ListView.builder(
                                itemCount: memoList.length,
                                itemBuilder: (context, index) {
                                  final memoData = memoList[index];
                                  final date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                              memoData.createDt)
                                          .toString()
                                          .split(" ")
                                          .first;
                                  List<String> memoDate = date.split('-');
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${memoDate[0]}.${memoDate[1]}.${memoDate[2]}',
                                                style: const TextStyle(
                                                  color: Color(0xff9d9d9d),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            // const MoreWidget(),
                                            PopupMenuButton(
                                              constraints: const BoxConstraints(
                                                maxWidth: 80,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              offset: const Offset(20, 0),
                                              icon: SvgPicture.asset(
                                                'assets/svgs/icons/Icon_more.svg',
                                                height: 20,
                                                width: 20,
                                              ),
                                              itemBuilder: (context) {
                                                return [
                                                  /* 
                                                  const PopupMenuItem(
                                                    enabled: true,
                                                    child: Text('수정'),
                                                  ),
                                                  */
                                                  PopupMenuItem(
                                                    enabled: true,
                                                    onTap: () => delPlanMemo(
                                                        memoData.seq),
                                                    child: const Text('삭제'),
                                                  ),
                                                ];
                                              },
                                            )
                                          ],
                                        ),
                                        Text(
                                          memoData.memo,
                                          style: const TextStyle(
                                            color: Color(0xff333333),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 0,
          child: BottomAppBar(
            child: Container(
              height: 65,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 5,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffC8C8C8),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        onChanged: (value) {
                          setState(() {
                            memo = value;
                            print('memo : $memo');
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 15,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: '메모를 남겨주세요',
                          hintStyle: const TextStyle(
                            color: Color(0xffcacaca),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          suffixIcon: memo != ''
                              ? IconButton(
                                  onPressed: onClear,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.xmark,
                                    color: Color(0xffbbbbbb),
                                  ),
                                )
                              : null,
                        ),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    GestureDetector(
                      onTap: addPlanMemo,
                      child: Container(
                        alignment: Alignment.center,
                        height: 65,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: memo == ''
                              ? const Color(0xffF5F5F5)
                              : const Color(0xff333333),
                        ),
                        child: Text(
                          '등록',
                          style: TextStyle(
                            color: memo == ''
                                ? const Color(0xffbbbbbb)
                                : Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MoreWidget extends StatefulWidget {
  const MoreWidget({
    super.key,
  });

  @override
  State<MoreWidget> createState() => _MoreWidgetState();
}

class _MoreWidgetState extends State<MoreWidget> {
  final GlobalKey<State<StatefulWidget>> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: globalKey,
      onTap: () {
        RenderBox? renderBox =
            globalKey.currentContext?.findRenderObject() as RenderBox?;

        Offset offset = renderBox!.localToGlobal(Offset.zero);
        print('offset : $offset');
        print(
            '${MediaQuery.of(context).size.width} / ${MediaQuery.of(context).size.height}');
        print('${offset.dx} / ${offset.dy}');
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, "return value");
                        },
                        child: const Text("삭제"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: SvgPicture.asset(
        'assets/svgs/icons/Icon_more.svg',
        height: 20,
        width: 20,
      ),
    );
  }
}
