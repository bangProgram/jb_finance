class PortfolioModel {
  final int depositAmount;
  final int investAmount;
  final int reserveAmount;
  final int evaluationProfit;
  final int evaluationAmount;

  PortfolioModel({
    required this.depositAmount,
    required this.investAmount,
    required this.reserveAmount,
    required this.evaluationProfit,
    required this.evaluationAmount,
  });

  PortfolioModel.fromJson(Map<String, dynamic> json)
      : depositAmount = json['depositAmount'],
        investAmount = json['investAmount'],
        reserveAmount = json['reserveAmount'],
        evaluationProfit = json['evaluationProfit'],
        evaluationAmount = json['evaluationAmount'];

  PortfolioModel.empty()
      : depositAmount = 0,
        investAmount = 0,
        reserveAmount = 0,
        evaluationProfit = 0,
        evaluationAmount = 0;

  Map<String, dynamic> toJson() {
    return {
      'depositAmount': depositAmount,
      'investAmount': investAmount,
      'reserveAmount': reserveAmount,
      'evaluationProfit': evaluationProfit,
      'evaluationAmount': evaluationAmount,
    };
  }
}
