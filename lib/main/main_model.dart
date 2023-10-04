class MainModel {
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;

  MainModel({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
  });

  MainModel.empty()
      : text1 = "",
        text2 = "",
        text3 = "",
        text4 = "",
        text5 = "";

  MainModel.fromJson(Map<String, dynamic> json)
      : text1 = json['text1'],
        text2 = json['text2'],
        text3 = json['text3'],
        text4 = json['text4'],
        text5 = json['text5'];

  Map<String, dynamic> toJson() {
    return {
      'text1': text1,
      'text2': text2,
      'text3': text3,
      'text4': text4,
      'text5': text5,
    };
  }
}
