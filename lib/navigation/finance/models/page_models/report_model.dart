class ReportModel {
  final String reportNm;
  final String reportDt;
  final String flrNm;
  final String reportNo;
  final String corpNm;
  final int seq;

  ReportModel({
    required this.reportNm,
    required this.reportDt,
    required this.flrNm,
    required this.reportNo,
    required this.corpNm,
    required this.seq,
  });

  ReportModel.fromJson(Map<String, dynamic> json)
      : reportNm = json['reportNm'],
        reportDt = json['reportDt'],
        flrNm = json['flrNm'],
        reportNo = json['reportNo'],
        corpNm = json['corpNm'],
        seq = json['seq'];

  ReportModel.empty()
      : reportNm = "",
        reportDt = "",
        flrNm = "",
        reportNo = "",
        corpNm = "",
        seq = 0;

  Map<String, dynamic> toJson() {
    return {
      'reportNm': reportNm,
      'reportDt': reportDt,
      'flrNm': flrNm,
      'reportNo': reportNo,
      'corpNm': corpNm,
      'seq': seq,
    };
  }
}
