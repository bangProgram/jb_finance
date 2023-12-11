import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/planbook/models/plan_detail_info_param_model.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_detail_vm.dart';

class PlanDetailInfoPage extends ConsumerStatefulWidget {
  final String corpCode;
  final int befClsPrice;
  const PlanDetailInfoPage(
      {super.key, required this.corpCode, required this.befClsPrice});

  @override
  ConsumerState<PlanDetailInfoPage> createState() => _PlanDetailInfoPageState();
}

class _PlanDetailInfoPageState extends ConsumerState<PlanDetailInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _perEditController = TextEditingController();
  Future<void> _refreshState() async {
    await ref
        .read(planDetailInfoProvider(widget.corpCode).notifier)
        .refreshState();
  }

  late Map<String, dynamic> param = {
    'corpCode': widget.corpCode,
    'opinionAmount1': '',
    'opinionAmount2': '',
    'opinionAmount3': '',
    'opinionAmount4': '',
    'opinionAmount5': '',
    'initPeriodGubn': '',
    'periodGubn': null,
    'estimateEps': '',
    'estimatePer': '',
  };

  late final DetailInfoParamModel _paramModel =
      DetailInfoParamModel.fromJson(param);

  void selPeriod(String? val) {
    setState(() {
      param['periodGubn'] = val;
      _paramModel.periodGubn = val;
    });
  }

  void mergePlaninfo() async {
    await ref
        .read(planDetailInfoProvider(widget.corpCode).notifier)
        .mergePlaninfo(_paramModel);
  }

/* 
  @override
  void deactivate() {
    //mergePlaninfo();
    print('PlanDetailInfo deactivate !!!!!!!!');
    super.deactivate();
  }
 */
  @override
  void dispose() {
    // mergePlaninfo();
    print('PlanDetailInfo Dispose !!!!!!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(planDetailInfoProvider(widget.corpCode)).when(
          error: (error, stackTrace) => RefreshIndicator(
            onRefresh: _refreshState,
            child: Stack(
              children: [
                Center(
                  child: Text('error : $error'),
                ),
                Positioned.fill(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) => Container(),
                  ),
                ),
              ],
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          data: (data) {
            _paramModel.initPeriodGubn = data.periodGubn;

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //기간구분
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xffe9e9e7),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  color: const Color(0xffF6F6F6),
                                  padding: const EdgeInsets.all(9),
                                  child: const Text(
                                    '기간',
                                    style: TextStyle(
                                      color: Color(0xffA7A7A7),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  alignment: Alignment.center,
                                  child: DropdownButton<String>(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    borderRadius: BorderRadius.circular(15),
                                    underline: Container(),
                                    elevation: 0,
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded),
                                    value: param['periodGubn'] ??
                                        data.periodGubn ??
                                        '',
                                    items: const [
                                      DropdownMenuItem(
                                        value: '',
                                        child: Text('미정'),
                                      ),
                                      DropdownMenuItem(
                                        value: '0601',
                                        child: Text('단기'),
                                      ),
                                      DropdownMenuItem(
                                        value: '0602',
                                        child: Text('중기'),
                                      ),
                                      DropdownMenuItem(
                                        value: '0603',
                                        child: Text('장기'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      selPeriod(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                          TextButton(
                              onPressed: mergePlaninfo,
                              child: const Text('저장')),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //기업정보
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          '기업정보',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffEFEFEF),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffFCFCFC),
                                        border: Border(
                                          right: BorderSide(
                                              color: Color(0xffefefef),
                                              width: 1.5),
                                        ),
                                      ),
                                      child: const Text('주식수량'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      NumberFormat('#,###')
                                          .format(data.sharesAmount),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffFCFCFC),
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffefefef),
                                            width: 1.5,
                                          ),
                                          right: BorderSide(
                                              color: Color(0xffefefef),
                                              width: 1.5),
                                        ),
                                      ),
                                      child: const Text('시가총액'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      NumberFormat('#,###')
                                          .format(data.marketCapital),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 0,
                              color: Color(0xffEFEFEF),
                              thickness: 1.5,
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffFCFCFC),
                                        border: Border(
                                          right: BorderSide(
                                              color: Color(0xffefefef),
                                              width: 1.5),
                                        ),
                                      ),
                                      child: const Text('거래량'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      NumberFormat('#,###')
                                          .format(data.tradeVolume),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffFCFCFC),
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffefefef),
                                            width: 1.5,
                                          ),
                                          right: BorderSide(
                                            color: Color(0xffefefef),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: const Text('거래금액'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      NumberFormat('#,###')
                                          .format(data.tradeAmount),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      //성장성
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                '성장성',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '${data.geoStYear} ~ ${data.geoEdYear}',
                              style: const TextStyle(
                                color: Color(0xffa8a8a8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffEFEFEF),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffFCFCFC),
                                        border: Border(
                                          right: BorderSide(
                                              color: Color(0xffefefef),
                                              width: 1.5),
                                        ),
                                      ),
                                      child: const Text('매출'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${data.avgGrowthGeo1 == null ? '적자' : '연 ${data.avgGrowthGeo1} %'} ',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffFCFCFC),
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffefefef),
                                            width: 1.5,
                                          ),
                                          right: BorderSide(
                                              color: Color(0xffefefef),
                                              width: 1.5),
                                        ),
                                      ),
                                      child: const Text('영업이익'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${data.avgGrowthGeo2 == null ? '적자' : '연 ${data.avgGrowthGeo2} %'} ',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 0,
                              color: Color(0xffEFEFEF),
                              thickness: 1.5,
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffFCFCFC),
                                        border: Border(
                                          right: BorderSide(
                                              color: Color(0xffefefef),
                                              width: 1.5),
                                        ),
                                      ),
                                      child: const Text('순이익'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${data.avgGrowthGeo3 == null ? '적자' : '연 ${data.avgGrowthGeo3} %'} ',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffFCFCFC),
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffefefef),
                                            width: 1.5,
                                          ),
                                          right: BorderSide(
                                            color: Color(0xffefefef),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(''),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      // EPS & PER
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'EPS & PER',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      //추정 eps / 추정 per
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffe9e9e7),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: const Color(0xffF6F6F6),
                                      padding: const EdgeInsets.all(9),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              '추정 EPS',
                                              style: TextStyle(
                                                color: Color(0xffA7A7A7),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Color(0xffa7a7a7),
                                              size: 19,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        initialValue: data.estimateEps,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: '추정값',
                                          hintStyle: TextStyle(
                                            fontSize: 10,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal: 2,
                                          ),
                                        ),
                                        onSaved: (newValue) {
                                          _paramModel.estimateEps = newValue;
                                        },
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            _paramModel.estimateEps = value;
                                            var per = NumberFormat('###.##')
                                                .format(widget.befClsPrice /
                                                    int.parse(value));
                                            _paramModel.estimatePer = per;

                                            print('per : $per');
                                            _perEditController.text = per;
                                          }
                                        },
                                        onEditingComplete: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffe9e9e7),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: const Color(0xffF6F6F6),
                                      padding: const EdgeInsets.all(9),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              '추정 PER',
                                              style: TextStyle(
                                                color: Color(0xffA7A7A7),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Color(0xffa7a7a7),
                                              size: 19,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: TextFormField(
                                        controller: _perEditController,
                                        enabled: false,
                                        initialValue: data.estimatePer,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: '추정값',
                                          hintStyle: TextStyle(
                                            fontSize: 10,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal: 2,
                                          ),
                                        ),
                                        onSaved: (newValue) {
                                          _paramModel.estimatePer = newValue;
                                        },
                                        onChanged: (value) {
                                          _paramModel.estimatePer = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //eps & per
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffe9e9e7),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              color: const Color(0xffF6F6F6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Text('per'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: data.opinionAmount1,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: '추정값',
                                            hintStyle: TextStyle(
                                              fontSize: 10,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 2,
                                            ),
                                          ),
                                          onSaved: (newValue) {
                                            _paramModel.opinionAmount1 =
                                                newValue;
                                          },
                                          onChanged: (value) {
                                            _paramModel.opinionAmount1 = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: data.opinionAmount2,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: '추정값',
                                            hintStyle: TextStyle(
                                              fontSize: 10,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 2,
                                            ),
                                          ),
                                          onSaved: (newValue) {
                                            _paramModel.opinionAmount2 =
                                                newValue;
                                          },
                                          onChanged: (value) {
                                            _paramModel.opinionAmount2 = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: data.opinionAmount3,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: '추정값',
                                            hintStyle: TextStyle(
                                              fontSize: 10,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 2,
                                            ),
                                          ),
                                          onSaved: (newValue) {
                                            _paramModel.opinionAmount3 =
                                                newValue;
                                          },
                                          onChanged: (value) {
                                            _paramModel.opinionAmount3 = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: data.opinionAmount4,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: '추정값',
                                            hintStyle: TextStyle(
                                              fontSize: 10,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 2,
                                            ),
                                          ),
                                          onSaved: (newValue) {
                                            _paramModel.opinionAmount4 =
                                                newValue;
                                          },
                                          onChanged: (value) {
                                            _paramModel.opinionAmount4 = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: data.opinionAmount5,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: '추정값',
                                            hintStyle: TextStyle(
                                              fontSize: 10,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 2,
                                            ),
                                          ),
                                          onSaved: (newValue) {
                                            _paramModel.opinionAmount5 =
                                                newValue;
                                          },
                                          onChanged: (value) {
                                            _paramModel.opinionAmount5 = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 0,
                              color: Color(0xffe9e9e7),
                              thickness: 1.5,
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffF6F6F6),
                                      ),
                                      child: const Text('상태'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: const Text('매수'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: const Text('비중확대'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: const Text('중립'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: const Text('비중축소'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Color(0xffE9E9E7),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: const Text('매도'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }
}
