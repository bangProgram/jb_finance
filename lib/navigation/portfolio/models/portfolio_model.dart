class PortfolioModel {
  final int depositAmount;
  final int investAmount;
  final int reserveAmount;

  PortfolioModel({
    required this.depositAmount,
    required this.investAmount,
    required this.reserveAmount,
  });

  PortfolioModel.fromJson(Map<String, dynamic> json)
      : depositAmount = json['DEPOSIT_AMOUNT'],
        investAmount = json['CORP_INVEST_AMOUNT'],
        reserveAmount = json['RESERVE_AMOUNT'];

  PortfolioModel.empty()
      : depositAmount = 0,
        investAmount = 0,
        reserveAmount = 0;

  Map<String, dynamic> toJson() {
    return {
      'depositAmount': depositAmount,
      'investAmount': investAmount,
      'reserveAmount': reserveAmount,
    };
  }
}
