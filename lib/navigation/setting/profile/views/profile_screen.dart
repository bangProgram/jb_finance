import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final ImagePicker _picker = ImagePicker();

  Future<void> uploadAvatar() async {
    final xFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 30);

    print('file upload 진입 : ${(xFile != null)}');
    if (xFile != null) {
      final file = File(xFile.path);
      print('file 확인 : ${file.path}');
      await ref.read(profileVMProvider.notifier).uploadAvatar(file);
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
        ),
        body: ref.watch(profileVMProvider).when(
              loading: () => Container(),
              error: (error, stackTrace) => Container(),
              data: (data) => Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: uploadAvatar,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 2 * 0.33,
                        foregroundImage: data.fileName == ""
                            ? null
                            : NetworkImage(
                                '${Consts.mainUrl}/appApi/member/downloadAvatar/${data.fileName}'),
                        child: Text(data.userId),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: const Text('이름'),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: const Text('별명'),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: const Text('이메일'),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
