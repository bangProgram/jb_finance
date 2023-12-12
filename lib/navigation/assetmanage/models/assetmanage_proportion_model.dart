class AssetmanageProportionModel {
  final String indutyCode;
  final String indutyName;
  final int totalAmount;

  AssetmanageProportionModel(
      {required this.indutyCode,
      required this.indutyName,
      required this.totalAmount});

  AssetmanageProportionModel.fromJson(Map<String, dynamic> json)
      : indutyCode = json['indutyCode'],
        indutyName = json['indutyName'],
        totalAmount = json['totalAmount'];

  AssetmanageProportionModel.empty()
      : indutyCode = "",
        indutyName = "",
        totalAmount = 0;

  Map<String, dynamic> toJson() {
    return {
      'indutyCode': indutyCode,
      'indutyName': indutyName,
      'totalAmount            ': totalAmount,
    };
  }
}
