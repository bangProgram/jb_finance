import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/navigation/portfolio/models/portfolio_model.dart';
import 'package:jb_finance/navigation/portfolio/repos/portfolio_repo.dart';
import 'package:jb_finance/utils.dart';

class PortfolioVM extends AsyncNotifier<PortfolioModel> {
  late final Authentications _auth;
  late final PortfolioRepo _portfolioRepo;

  @override
  FutureOr<PortfolioModel> build() async {
    _auth = ref.read(authProvider);
    _portfolioRepo = ref.read(portfolioRepo);

    if (_auth.isLogin) {
      final userId = _auth.getUserId;
      final responseData = await _portfolioRepo.getPortAmount(userId);
      print('PortfolioVM : ${responseData['message']}');
      final portfolioData = responseData['portAmountData'];
      return PortfolioModel.fromJson(portfolioData);
    } else {
      return PortfolioModel.empty();
    }
  }

  Future<void> getPortfolio() async {
    final userId = _auth.getUserId;
    final responseData = await _portfolioRepo.getPortAmount(userId);
    final portfolioData = responseData['portAmountData'];
    state = AsyncValue.data(PortfolioModel.fromJson(portfolioData));
  }

  Future<void> updatePortfolio(
      BuildContext context, Map<String, dynamic> formData) async {
    state = const AsyncValue.loading();
    final userId = _auth.getUserId;
    state = await AsyncValue.guard(() async {
      final Map<String, dynamic> newForm = {
        ...formData,
        'userId': userId,
      };
      final result = await _portfolioRepo.updatePortfolio(newForm);
      //true 일경우 update 성공
      if (result) {
        final responseData = await _portfolioRepo.getPortAmount(userId);
        final portfolioData = responseData['portAmountData'];
        return PortfolioModel.fromJson(portfolioData);
      } else {
        throw Exception('VM data 오류');
      }
    });

    if (state.hasError) {
      serverMessage(context, '${state.error}');
    }
  }
}

final portfolioProvider = AsyncNotifierProvider<PortfolioVM, PortfolioModel>(
  () => PortfolioVM(),
);
