import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rbac_vrv_security_by_kshitiz/Roles/Associated%20Member/associated_member.dart';
import 'package:rbac_vrv_security_by_kshitiz/Roles/IT%20Admin/it_admin.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/Role%20Selector/role_selector.dart';
import 'package:rbac_vrv_security_by_kshitiz/current_user_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1920, 1080),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
              useMaterial3: true,
          ),
          home: //ITAdmin()
           //AssociatedMember(groupId: CurrentUser.userdata['groups'].first,),
          RoleSelector()
        ));
  }
}

