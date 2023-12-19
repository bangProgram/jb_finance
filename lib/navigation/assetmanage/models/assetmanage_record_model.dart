class AssetmanageRecordModel {
  final int seq;
  final String corpCode;
  final String corpName;
  final String stockCode;
  final String userId;
  final String gubn;
  final String? memo;
  final int buyQuantity;
  final int sellQuantity;
  final int buyAmount;
  final int sellAmount;
  final int returnAmount;
  final int tradePrice;
  final int tradeDate;
  final String changeId;
  final int changeDate;

  AssetmanageRecordModel({
    required this.seq,
    required this.corpCode,
    required this.corpName,
    required this.stockCode,
    required this.userId,
    required this.gubn,
    this.memo,
    required this.buyQuantity,
    required this.sellQuantity,
    required this.buyAmount,
    required this.sellAmount,
    required this.returnAmount,
    required this.tradePrice,
    required this.tradeDate,
    required this.changeId,
    required this.changeDate,
  });

  AssetmanageRecordModel.fromJson(Map<String, dynamic> json)
      : seq = json['seq'],
        corpCode = json['corpCode'],
        corpName = json['corpName'],
        stockCode = json['stockCode'],
        userId = json['userId'],
        gubn = json['gubn'],
        memo = json['memo'],
        buyQuantity = json['buyQuantity'],
        sellQuantity = json['sellQuantity'],
        buyAmount = json['buyAmount'],
        sellAmount = json['sellAmount'],
        returnAmount = json['returnAmount'],
        tradePrice = json['tradePrice'],
        tradeDate = json['tradeDate'],
        changeId = json['changeId'],
        changeDate = json['changeDate'];

  AssetmanageRecordModel.empty()
      : seq = 0,
        corpCode = "",
        corpName = "",
        stockCode = "",
        userId = "",
        gubn = "",
        memo = "",
        buyQuantity = 0,
        sellQuantity = 0,
        buyAmount = 0,
        sellAmount = 0,
        returnAmount = 0,
        tradePrice = 0,
        tradeDate = 0,
        changeId = "",
        changeDate = 0;

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'corpCode': corpCode,
      'corpName': corpName,
      'stockCode': stockCode,
      'userId': userId,
      'gubn': gubn,
      'memo': memo,
      'buyQuantity': buyQuantity,
      'sellQuantity': sellQuantity,
      'buyAmount': buyAmount,
      'sellAmount': sellAmount,
      'returnAmount': returnAmount,
      'tradePrice': tradePrice,
      'tradeDate': tradeDate,
      'changeId': changeId,
      'changeDate': changeDate,
    };
  }
}
