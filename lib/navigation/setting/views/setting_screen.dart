import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/member/login/view_models/login_vm.dart';
import 'package:jb_finance/navigation/setting/profile/view_models/profile_vm.dart';
import 'package:jb_finance/navigation/setting/profile/views/profile_screen.dart';

class SettingScreen extends ConsumerStatefulWidget {
  static const String routeName = "setting";
  static const String routeURL = "/setting";

  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  void memberLogout() async {
    await ref.read(loginVMProvider.notifier).memberLogout(context);
  }

  void goProfileScreen() {
    print('페이지이동');
    context.pushNamed(ProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('설정'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          ref.watch(profileVMProvider).when(
                loading: () => ListTile(
                  leading: const CircleAvatar(
                    radius: 25,
                    child: CircularProgressIndicator(),
                  ),
                  title: const Text('사용자명'),
                  subtitle: const Text('사용자 아이디'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.userGear,
                      size: 20,
                    ),
                  ),
                ),
                error: (error, stackTrace) => ListTile(
                  leading: const CircleAvatar(
                    radius: 25,
                  ),
                  title: const Text('사용자 가져오지 못함'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.userGear,
                      size: 20,
                    ),
                  ),
                ),
                data: (data) => ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    foregroundImage: data.fileName == ""
                        ? null
                        : NetworkImage(
                            '${Consts.mainUrl}/appApi/member/downloadAvatar/${data.fileName}'),
                    child: Text(
                      data.userId,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  title: Text(data.userNick),
                  subtitle: Text(data.email),
                  trailing: IconButton(
                    onPressed: goProfileScreen,
                    icon: const FaIcon(
                      FontAwesomeIcons.userGear,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.userLargeSlash,
              size: 20,
            ),
            title: const Text('회원탈퇴'),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text('탈퇴된ID는 가입이 제한됩니다.'),
                  title: const Text('회원탈퇴 하시겠습니까?'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: TextButton(
                              onPressed: memberLogout,
                              child: const Text(
                                '회원탈퇴',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('취소'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.circleInfo,
                size: 20,
              ),
              title: const Text('JB_Finance About..'),
              onTap: () => showDialog(
                    context: context,
                    builder: (context) => const AboutDialog(
                      children: [
                        Text('Version: 0.1.0 : with flutter.'),
                      ],
                    ),
                  )),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 20,
            ),
            title: const Text('로그아웃'),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text('로그아웃 하시겠습니까?'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: TextButton(
                              onPressed: memberLogout,
                              child: const Text(
                                '로그아웃',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('취소'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
