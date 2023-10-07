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
        title: const Text('프로필설정'),
      ),
    );
  }
}
