import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/member/login/view_models/login_vm.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  static const String routeName = "portfolio";
  static const String routeURL = "/portfolio";

  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ref.read(loginVMProvider).when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text('error : $error'),
              ),
              data: (data) {
                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      const SliverAppBar(
                        centerTitle: true,
                        title: Text('포트폴리오'),
                        elevation: 0,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.transparent,
                      )
                    ];
                  },
                  body: const Column(),
                );
              },
            ),
      ),
    );
  }
}
