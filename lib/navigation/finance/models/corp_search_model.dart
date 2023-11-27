class CorpSearchModel {
  final String? pCorpName;
  final String? pStYear;
  final String? pEdYear;
  final String? pStHalf;
  final String? pEdHalf;
  final bool? pAvgType1;
  final bool? pAvgType2;
  final bool? pAvgType3;
  final bool? pAvgType4;
  final int? pAvgValue;

  CorpSearchModel({
    this.pCorpName,
    this.pStYear,
    this.pEdYear,
    this.pStHalf,
    this.pEdHalf,
    this.pAvgType1,
    this.pAvgType2,
    this.pAvgType3,
    this.pAvgType4,
    this.pAvgValue,
  });

  CorpSearchModel.empty()
      : pCorpName = null,
        pStYear = null,
        pEdYear = null,
        pStHalf = null,
        pEdHalf = null,
        pAvgType1 = null,
        pAvgType2 = null,
        pAvgType3 = null,
        pAvgType4 = null,
        pAvgValue = null;

  CorpSearchModel.fromJson(Map<String, dynamic> json)
      : pCorpName = json['pCorpName'],
        pStYear = json['pStYear'],
        pEdYear = json['pEdYear'],
        pStHalf = json['pStHalf'],
        pEdHalf = json['pEdHalf'],
        pAvgType1 = json['pAvgType1'],
        pAvgType2 = json['pAvgType2'],
        pAvgType3 = json['pAvgType3'],
        pAvgType4 = json['pAvgType4'],
        pAvgValue = json['pAvgValue'];

  Map<String, dynamic> toJson() {
    return {
      'pCorpName': pCorpName,
      'pStYear': pStYear,
      'pEdYear': pEdYear,
      'pStHalf': pStHalf,
      'pEdHalf': pEdHalf,
      'pAvgType1': pAvgType1,
      'pAvgType2': pAvgType2,
      'pAvgType3': pAvgType3,
      'pAvgType4': pAvgType4,
      'pAvgValue': pAvgValue,
    };
  }
}
