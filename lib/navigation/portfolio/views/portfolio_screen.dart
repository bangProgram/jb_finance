import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/portfolio/models/portfolio_model.dart';
import 'package:jb_finance/navigation/portfolio/view_models/portfolio_vm.dart';
import 'package:jb_finance/navigation/portfolio/views/portfolio_edit_screen.dart';
import 'package:jb_finance/navigation/portfolio/widgets/portfolio_widget.dart';
import 'package:jb_finance/navigation/portfolio/widgets/sliver_tabbar_header.dart';
import 'package:jb_finance/utils.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  static const String routeName = "portfolio";
  static const String routeURL = "/portfolio";

  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  late PortfolioModel _modelData;

  void goPortfolioEdit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PortfolioEditScreen(data: _modelData),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => focusOut(context),
          child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    centerTitle: true,
                    title: const Text('포트폴리오'),
                    elevation: 0,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    actions: [
                      IconButton(
                        onPressed: goPortfolioEdit,
                        icon: const FaIcon(
                          FontAwesomeIcons.penToSquare,
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: ref.watch(portfolioProvider).when(
                          loading: () => PortfolioWidget(
                            data: PortfolioModel.empty(),
                            size: screenW / 2,
                          ),
                          error: (error, stackTrace) => Container(
                            child: Text('error $error'),
                          ),
                          data: (data) {
                            _modelData = data;
                            final totalReturn =
                                (data.evaluationAmount / data.investAmount) *
                                        100 -
                                    100;

                            return Column(
                              children: [
                                PortfolioWidget(
                                  data: data,
                                  size: screenW / 2,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: screenW * 0.90,
                                            child: Flex(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              direction: Axis.horizontal,
                                              children: [
                                                const Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text('평가수익률'),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    '${NumberFormat("#,###.##").format(totalReturn)}%',
                                                    style: TextStyle(
                                                      color: totalReturn > 0
                                                          ? Colors.red
                                                          : Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                const Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text('총평가손익'),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                      '${data.evaluationProfit}',
                                                      style: TextStyle(
                                                        color: totalReturn > 0
                                                            ? Colors.red
                                                            : Colors.blue,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: screenW * 0.90,
                                            child: Flex(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              direction: Axis.horizontal,
                                              children: [
                                                const Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text('총매입금액'),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    '${data.investAmount}',
                                                    maxLines: 3,
                                                  ),
                                                ),
                                                const Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text('총평가금액'),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                      '${data.evaluationAmount}'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverTabbarHeader(),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenW * 0.90,
                            child: const Flex(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Text('종목'),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Text('보유주수'),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Text('평가손익'),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Text('손익률'),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Text('평균단가'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: 20,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: screenW * 0.90,
                                  child: const Flex(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text('종목'),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text('보유주식'),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.blue,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
