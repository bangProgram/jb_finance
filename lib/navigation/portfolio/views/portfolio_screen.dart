import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/navigation/portfolio/view_models/portfolio_vm.dart';
import 'package:jb_finance/navigation/portfolio/views/portfolio_edit_screen.dart';
import 'package:jb_finance/navigation/portfolio/widgets/portfolio_widget.dart';
import 'package:jb_finance/utils.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  static const String routeName = "portfolio";
  static const String routeURL = "/portfolio";

  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  void goPortfolioEdit() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PortfolioEditScreen(),
    ));
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
                        loading: () => SizedBox(
                          height: screenW / 2,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stackTrace) => Container(
                          child: Text('error $error'),
                        ),
                        data: (data) {
                          return Stack(
                            children: [
                              PortfolioWidget(
                                data: data,
                                size: screenW / 2,
                              ),
                            ],
                          );
                        },
                      ),
                ),
                const SliverToBoxAdapter(
                  child: Text('두개가 추가 될까?'),
                ),
              ];
            },
            body: Container(),
          ),
        ),
      ),
    );
  }
}
