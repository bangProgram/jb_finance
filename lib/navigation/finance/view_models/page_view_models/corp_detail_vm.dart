import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/finance/models/page_models/candel_model.dart';
import 'package:jb_finance/navigation/finance/models/page_models/report_model.dart';
import 'package:jb_finance/navigation/finance/repos/page_repos/corp_detail_repo.dart';

class CorpDetailReportVM
    extends FamilyAsyncNotifier<List<ReportModel>?, String> {
  late final CorpDetailRepo _corpDetailRepo;
  late final String corpCode;

  @override
  FutureOr<List<ReportModel>?> build(String arg) async {
    _corpDetailRepo = ref.read(corpDetailRepo);
    corpCode = arg;
    final List<dynamic> reportList = await _corpDetailRepo
        .getCorpReportList({'corpCd': corpCode, 'reportTy': ''});
    final result = reportList.map((report) {
      return ReportModel.fromJson(report);
    });
    return result.toList();
  }

  Future<void> getReport(String type) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final List<dynamic> reportList = await _corpDetailRepo
          .getCorpReportList({'corpCd': corpCode, 'reportTy': type});
      final result = reportList.map((report) {
        return ReportModel.fromJson(report);
      });
      return result.toList();
    });
  }
}

final corpDetailReportProvider = AsyncNotifierProvider.family<
    CorpDetailReportVM, List<ReportModel>?, String>(
  () => CorpDetailReportVM(),
);

class CorpDetailCandleVM extends FamilyAsyncNotifier<List<dynamic>?, String> {
  late final CorpDetailRepo _corpDetailRepo;
  late final String corpCode;

  @override
  FutureOr<List<dynamic>?> build(String arg) async {
    _corpDetailRepo = ref.read(corpDetailRepo);
    corpCode = arg;
    final List<dynamic> reportData =
        await _corpDetailRepo.getCorpStockPrice({'corpCode': corpCode});
    return reportData;
  }

  Future<void> getStockPrice(String type) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final List<dynamic> reportData =
          await _corpDetailRepo.getCorpStockPrice({'corpCode': corpCode});
      return reportData;
    });
  }
}

final corpDetailCandleProvider =
    AsyncNotifierProvider.family<CorpDetailCandleVM, List<dynamic>?, String>(
  () => CorpDetailCandleVM(),
);

class CorpDetailPerformVM
    extends FamilyAsyncNotifier<Map<String, dynamic>?, String> {
  late final CorpDetailRepo _corpDetailRepo;
  late final String corpCode;

  @override
  FutureOr<Map<String, dynamic>?> build(String arg) async {
    _corpDetailRepo = ref.read(corpDetailRepo);
    corpCode = arg;
    final Map<String, dynamic> reportData =
        await _corpDetailRepo.getCorpPerform({'pCorpCode': corpCode});
    return reportData;
  }

  Future<void> getCorpPerform() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final Map<String, dynamic> reportData =
          await _corpDetailRepo.getCorpPerform({'pCorpCode': corpCode});
      return reportData;
    });
  }
}

final corpDetailPerformProvider = AsyncNotifierProvider.family<
    CorpDetailPerformVM, Map<String, dynamic>?, String>(
  () => CorpDetailPerformVM(),
);

class CorpDetailNewsVM extends FamilyAsyncNotifier<dynamic, String> {
  late final CorpDetailRepo _corpDetailRepo;
  late final String corpCode;

  @override
  FutureOr<dynamic> build(String arg) async {
    _corpDetailRepo = ref.read(corpDetailRepo);
    corpCode = arg;
    final dynamic reportData = await _corpDetailRepo.getNaverNews(corpCode);
    return reportData;
  }

  Future<void> getNaverNews() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dynamic reportData = await _corpDetailRepo.getNaverNews(corpCode);
      return reportData;
    });
  }
}

final corpDetailNewsProvider =
    AsyncNotifierProvider.family<CorpDetailNewsVM, dynamic, String>(
  () => CorpDetailNewsVM(),
);
