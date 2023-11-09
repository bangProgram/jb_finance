import 'package:flutter/material.dart';
import 'package:jb_finance/navigation/finance/widgets/select_account_widget.dart';
import 'package:jb_finance/navigation/finance/widgets/select_date_widget.dart';

class FinanceCorpScreen extends StatefulWidget {
  const FinanceCorpScreen({super.key});

  @override
  State<FinanceCorpScreen> createState() => _FinanceCorpScreenState();
}

class _FinanceCorpScreenState extends State<FinanceCorpScreen> {
  int stYear = 2023;
  late int edYear;
  int diffYear = 0;

  List<String> accountList = [];

  void _selectDate(int diff) async {
    setState(() {
      if (diffYear != diff) {
        diffYear = diff;
      } else {
        diffYear = 0;
      }
    });
  }

  void _selectAccount(String account) {
    setState(() {
      if (!accountList.contains(account)) {
        accountList.add(account);
      } else {
        accountList.remove(account);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 14,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '기간',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _selectDate(3),
                              child: SelectDateWidget(
                                  thisYear: 3, diffYear: diffYear),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(5),
                              child: SelectDateWidget(
                                  thisYear: 5, diffYear: diffYear),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(7),
                              child: SelectDateWidget(
                                  thisYear: 7, diffYear: diffYear),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(9),
                              child: SelectDateWidget(
                                  thisYear: 9, diffYear: diffYear),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(10),
                              child: SelectDateWidget(
                                  thisYear: 10, diffYear: diffYear),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 13,
                ),
                Row(
                  children: [
                    Container(
                      width: 50,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '구분',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _selectAccount('매출액'),
                              child: SelectAccountWidget(
                                thisAccount: '매출액',
                                accountList: accountList,
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () => _selectAccount('영업이익'),
                              child: SelectAccountWidget(
                                thisAccount: '영업이익',
                                accountList: accountList,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () => _selectAccount('순이익'),
                              child: SelectAccountWidget(
                                thisAccount: '순이익',
                                accountList: accountList,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 13,
                ),
                Row(
                  children: [
                    Container(
                      width: 50,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '성장률',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '직접입력(%)',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '이상',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 23,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '조회',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (diffYear != 0)
                      Text(
                        '* 최근 $diffYear년 기준',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: 14,
                        ),
                      )
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  child: const Center(
                    child: Text(
                      'test',
                      style: TextStyle(fontSize: 66),
                    ),
                  ),
                ),
                Container(
                  child: const Center(
                    child: Text(
                      'test',
                      style: TextStyle(fontSize: 66),
                    ),
                  ),
                ),
                Container(
                  child: const Center(
                    child: Text(
                      'test',
                      style: TextStyle(fontSize: 66),
                    ),
                  ),
                ),
                Container(
                  child: const Center(
                    child: Text(
                      'test',
                      style: TextStyle(fontSize: 66),
                    ),
                  ),
                ),
                Container(
                  child: const Center(
                    child: Text(
                      'test',
                      style: TextStyle(fontSize: 66),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
