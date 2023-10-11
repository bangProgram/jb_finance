import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "profile";
  static const String routeURL = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('프로필변경'),
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            child: Text('아이디'),
          ),
          Row(
            children: [
              Container(child: const Text('이름')),
              Expanded(child: TextFormField()),
            ],
          ),
          Row(
            children: [
              const Text('별명'),
              Expanded(child: TextFormField()),
            ],
          ),
          Row(
            children: [
              const Text('이메일'),
              Expanded(child: TextFormField()),
            ],
          ),
        ],
      ),
    );
  }
}
