import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/member/login/view_models/login_vm.dart';
import 'package:jb_finance/navigation/finance/views/finance_screen.dart';
import 'package:jb_finance/navigation/profile/views/profile_screen.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  static const String routeName = "portfolio";
  static const String routeURL = "/portfolio";

  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  void goProfileScreen() {
    context.pushNamed(ProfileScreen.routeName);
  }

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
                      SliverAppBar(
                        title: const Text('포트폴리오'),
                        actions: [
                          IconButton(
                            onPressed: goProfileScreen,
                            icon: const FaIcon(FontAwesomeIcons.gear),
                          ),
                        ],
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
