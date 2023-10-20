import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/navigation/portfolio/models/portfolio_model.dart';
import 'package:jb_finance/navigation/portfolio/view_models/portfolio_vm.dart';
import 'package:jb_finance/navigation/portfolio/widgets/portfolio_widget.dart';
import 'package:jb_finance/utils.dart';

class PortfolioEditScreen extends ConsumerStatefulWidget {
  static const String routeName = "portfolioEdit";
  static const String routeURL = "/portfolioEdit";

  final PortfolioModel data;

  const PortfolioEditScreen({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<PortfolioEditScreen> createState() =>
      _PortfolioEditScreenState();
}

class _PortfolioEditScreenState extends ConsumerState<PortfolioEditScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  late final TextEditingController _depositEditing =
      TextEditingController(text: widget.data.depositAmount.toString());
  late final TextEditingController _reserveEditing =
      TextEditingController(text: widget.data.reserveAmount.toString());

  Map<String, dynamic> formData = {};

  void updatePortfolio() {
    print('이거 실행돼?');
    final state = _globalKey.currentState;
    if (state != null) {
      state.save();
      ref.read(portfolioProvider.notifier).updatePortfolio(context, formData);
    }
    Navigator.of(context).pop();
  }

  void clearForm(TextEditingController controller) {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => focusOut(context),
      child: Scaffold(
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _globalKey,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      PortfolioWidget(
                        data: widget.data,
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
                              controller: _depositEditing,
                              // initialValue: '1',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => clearForm(_depositEditing),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.xmark,
                                    color: Colors.black,
                                    size: 15,
                                  ),
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
                              controller: _reserveEditing,
                              // initialValue: '1',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => clearForm(_reserveEditing),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.xmark,
                                    color: Colors.black,
                                    size: 15,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
