import 'package:flutter/material.dart';

class AssetmanageRecordPage extends StatefulWidget {
  const AssetmanageRecordPage({
    super.key,
  });

  @override
  State<AssetmanageRecordPage> createState() => _AssetmanageRecordPageState();
}

class _AssetmanageRecordPageState extends State<AssetmanageRecordPage> {
  final test = [
    {'gubn': '0101', 'date': '2023-01-01'},
    {'gubn': '0101', 'date': '2023-01-01'},
    {'gubn': '0102', 'date': '2023-01-01'},
    {'gubn': '0102', 'date': '2023-01-02'},
    {'gubn': '0102', 'date': '2023-01-02'},
    {'gubn': '0101', 'date': '2023-01-03'},
    {'gubn': '0102', 'date': '2023-01-03'},
    {'gubn': '0101', 'date': '2023-01-03'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Divider(
            color: Color(0xffEFEFEF),
            thickness: 1,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: test.length,
              itemBuilder: (context, index) {
                final data = test[index];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 27,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffEFEFEF),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: data['gubn'] == '0101'
                                    ? const Color(0xffFFDADE)
                                    : const Color.fromARGB(255, 213, 227, 255),
                                child: Text(
                                  data['gubn'] == '0101' ? '매수' : '매도',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: data['gubn'] == '0101'
                                          ? Colors.red
                                          : Colors.blue),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Expanded(
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '삼성전자',
                                            style: TextStyle(
                                              color: Color(0xff333333),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '76,000원 · 2주',
                                            style: TextStyle(
                                              color: Color(0xffC4C4C4),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        '+152,000원',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
