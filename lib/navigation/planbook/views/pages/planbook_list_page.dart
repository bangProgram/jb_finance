import 'package:flutter/material.dart';

class PlanbookListPage extends StatefulWidget {
  final int index;
  const PlanbookListPage({super.key, required this.index});

  @override
  State<PlanbookListPage> createState() => _PlanbookListPageState();
}

class _PlanbookListPageState extends State<PlanbookListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 18,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffE4E4E4),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    '삼성전자',
                    style: TextStyle(
                      color: Color(0xffa8a8a8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      '75,000원',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '23. 07. 08',
                    style: TextStyle(
                      color: Color(0xffa8a8a8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFE0DE),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      '매수',
                      style: TextStyle(
                        color: Color(0xffe84a41),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    '7만원대 올라서면 매수하기 👍',
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
