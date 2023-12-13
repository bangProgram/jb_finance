class AssetmanageProportionModel {
  final String indutyCode;
  final String indutyName;
  final int totalAmount;
  final double amountRate;

  AssetmanageProportionModel({
    required this.indutyCode,
    required this.indutyName,
    required this.totalAmount,
    required this.amountRate,
  });

  AssetmanageProportionModel.fromJson(Map<String, dynamic> json)
      : indutyCode = json['indutyCode'],
        indutyName = json['indutyName'],
        totalAmount = json['totalAmount'],
        amountRate = json['amountRate'];

  AssetmanageProportionModel.empty()
      : indutyCode = "",
        indutyName = "",
        totalAmount = 0,
        amountRate = 0;

  Map<String, dynamic> toJson() {
    return {
      'indutyCode': indutyCode,
      'indutyName': indutyName,
      'totalAmount': totalAmount,
      'amountRate': amountRate,
    };
  }
}
