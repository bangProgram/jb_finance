class CandleModel {
// -stck_clpr	주식 종가	String	Y	10	주식 종가
// -stck_oprc	주식 시가	String	Y	10	주식 시가
// -stck_hgpr	주식 최고가	String	Y	10	주식 최고가
// -stck_lwpr	주식 최저가	String	Y	10	주식 최저가
// -acml_vol	누적 거래량	String	Y	18	누적 거래량
// -acml_tr_pbmn	누적 거래 대금	String	Y	18	누적 거래 대금
// -flng_cls_code	락 구분 코드	String	Y	2	00:해당사항없음(락이 발생안한 경우)
// 01:권리락
// 02:배당락
// 03:분배락
// 04:권배락
// 05:중간(분기)배당락
// 06:권리중간배당락
// 07:권리분기배당락

  final DateTime date;
  final double open;
  final double close;
  final double high;
  final double low;

  CandleModel(
      {required this.date,
      required this.low,
      required this.high,
      required this.open,
      required this.close});

  CandleModel.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        open = json['open'],
        close = json['close'],
        high = json['high'],
        low = json['low'];

  CandleModel.empty()
      : date = DateTime.now(),
        open = 0,
        close = 0,
        high = 0,
        low = 0;

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'open': open,
      'close': close,
      'high': high,
      'low': low,
    };
  }
}
