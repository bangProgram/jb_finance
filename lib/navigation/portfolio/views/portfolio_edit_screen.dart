import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/portfolio/view_models/portfolio_vm.dart';
import 'package:jb_finance/navigation/portfolio/widgets/portfolio_widget.dart';

class PortfolioEditScreen extends ConsumerStatefulWidget {
  static const String routeName = "portfolioEdit";
  static const String routeURL = "/portfolioEdit";

  const PortfolioEditScreen({super.key});

  @override
  ConsumerState<PortfolioEditScreen> createState() =>
      _PortfolioEditScreenState();
}

class _PortfolioEditScreenState extends ConsumerState<PortfolioEditScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  Map<String, dynamic> formData = {};

  void updatePortfolio() async {
    await ref
        .read(portfolioProvider.notifier)
        .updatePortfolio(context, formData);
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('포트폴리오 수정'),
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: updatePortfolio,
            icon: const FaIcon(
              FontAwesomeIcons.check,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: ref.watch(portfolioProvider).when(
            loading: () => Container(),
            error: (error, stackTrace) => Container(),
            data: (data) => SingleChildScrollView(
              child: Form(
                key: _globalKey,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      PortfolioWidget(
                        data: data,
                        size: screenW / 2,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: const Text('예수금'),
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: NumberFormat("#,###.##")
                                  .format(data.investAmount),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                              ),
                              onSaved: (newValue) {
                                formData['depositAmount'] = newValue;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: const Text('예비금'),
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: NumberFormat("#,###.##")
                                  .format(data.investAmount),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                              ),
                              onSaved: (newValue) {
                                formData['reserveAmount'] = newValue;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
