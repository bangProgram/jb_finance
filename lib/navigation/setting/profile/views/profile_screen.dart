import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/navigation/setting/profile/view_models/profile_vm.dart';
import 'package:jb_finance/utils.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = "profile";
  static const String routeURL = "/profile";

  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  Map<String, dynamic> updataForm = {};

  Future<void> uploadAvatar() async {
    final xFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 30);

    if (xFile != null) {
      final file = File(xFile.path);
      await ref.read(profileVMProvider.notifier).uploadAvatar(file);
    }
  }

  Future<void> updateMember() async {
    final formState = _globalKey.currentState;
    if (formState != null) {
      if (formState.validate()) {
        formState.save();
        print('memberData : $updataForm');
      }
    }
  }

  @override
  void dispose() {
    _picker.retrieveLostData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusOut(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('프로필변경'),
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: updateMember,
              icon: const FaIcon(FontAwesomeIcons.penToSquare),
            ),
          ],
        ),
        body: ref.watch(profileVMProvider).when(
              loading: () => Container(),
              error: (error, stackTrace) => Container(),
              data: (data) => SingleChildScrollView(
                child: Form(
                  key: _globalKey,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: uploadAvatar,
                          child: CircleAvatar(
                            radius:
                                MediaQuery.of(context).size.width / 2 * 0.33,
                            foregroundImage: data.fileName == ""
                                ? data.avatarUrl == ""
                                    ? null
                                    : NetworkImage(data.avatarUrl)
                                : NetworkImage(
                                    '${Consts.mainUrl}/appApi/member/downloadAvatar/${data.fileName}'),
                            child: Text(data.userId),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: const Text('이름*'),
                            ),
                            Expanded(
                              child: TextFormField(
                                initialValue: data.userName,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                ),
                                onSaved: (newValue) {
                                  updataForm['userName'] = newValue;
                                },
                                validator: (value) {
                                  if (value != null && value != '') {
                                    if (value.length < 2) {
                                      return '이름은 두글자 이상이여야 합니다';
                                    }
                                  } else {
                                    return '이름을 입력해주세요';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: const Text('닉네임*'),
                            ),
                            Expanded(
                              child: TextFormField(
                                  initialValue: data.userNick,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                  ),
                                  onSaved: (newValue) {
                                    updataForm['userNick'] = newValue;
                                  },
                                  validator: (value) {
                                    if (value != null && value != '') {
                                      if (value.length < 2) {
                                        return '닉네임은 두글자 이상이여야 합니다';
                                      }
                                    } else {
                                      return '닉네임을 입력해주세요';
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
