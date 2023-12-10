class DetailInfoParamModel {
  String corpCode;
  String? opinionAmount1;
  String? opinionAmount2;
  String? opinionAmount3;
  String? opinionAmount4;
  String? opinionAmount5;
  String? initPeriodGubn;
  String? periodGubn;
  String? estimateEps;
  String? estimatePer;

  DetailInfoParamModel({
    required this.corpCode,
    required this.opinionAmount1,
    required this.opinionAmount2,
    required this.opinionAmount3,
    required this.opinionAmount4,
    required this.opinionAmount5,
    required this.initPeriodGubn,
    required this.periodGubn,
    required this.estimateEps,
    required this.estimatePer,
  });

  DetailInfoParamModel.empty()
      : corpCode = '',
        opinionAmount1 = null,
        opinionAmount2 = null,
        opinionAmount3 = null,
        opinionAmount4 = null,
        opinionAmount5 = null,
        initPeriodGubn = null,
        periodGubn = null,
        estimateEps = null,
        estimatePer = null;

  DetailInfoParamModel.fromJson(Map<String, dynamic> json)
      : corpCode = json['corpCode'],
        opinionAmount1 = json['opinionAmount1'],
        opinionAmount2 = json['opinionAmount2'],
        opinionAmount3 = json['opinionAmount3'],
        opinionAmount4 = json['opinionAmount4'],
        opinionAmount5 = json['opinionAmount5'],
        initPeriodGubn = json['initPeriodGubn'],
        periodGubn = json['periodGubn'],
        estimateEps = json['estimateEps'],
        estimatePer = json['estimatePer'];

  Map<String, dynamic> toJson() {
    return {
      'corpCode': corpCode,
      'opinionAmount1': opinionAmount1,
      'opinionAmount2': opinionAmount2,
      'opinionAmount3': opinionAmount3,
      'opinionAmount4': opinionAmount4,
      'opinionAmount5': opinionAmount5,
      'initPeriodGubn': initPeriodGubn,
      'periodGubn': periodGubn,
      'estimateEps': estimateEps,
      'estimatePer': estimatePer,
    };
  }
}
