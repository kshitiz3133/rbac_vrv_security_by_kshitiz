import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rbac_vrv_security_by_kshitiz/Mock%20Backend/mock_backend.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/Groups/group_notes_list.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/members.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/new_note.dart';

import '../../UI Components/Role Selector/role_selector.dart';
import '../../UI Components/notes.dart';
import '../../UI Components/notes_expanded.dart';
import '../../current_user_data.dart';

class AssociatedMember extends StatefulWidget {
  final int groupId;
  const AssociatedMember({Key? key, required this.groupId}) : super(key: key);

  @override
  State<AssociatedMember> createState() => _AssociatedMemberState();
}

class _AssociatedMemberState extends State<AssociatedMember> {
  late List<Map<String, dynamic>> groups=[];
  Mock_API mock_api= Mock_API();
  static int gid=0;
  int reloadKey=0;
  void reload(){
    setState(() {
      reloadKey++;
      print('reloaded');
    });
  }
  Future<void> getusergroups() async {
    var data=await mock_api.getUserGroups(CurrentUser.userdata['id']);
    print("groups: $data");

    setState(() {
      groups=data;
    });
  }
  void getgroups() async{
    await getusergroups();
  }
  @override
  void initState() {
    // TODO: implement initState
    gid=widget.groupId;
    getgroups();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => Dialog(
                      backgroundColor: Color(0xffCDC6F2),
                      child: AnimatedNewNotice(groupId: gid,reload:reload),
                    ),
                  );
                });
              },
              child: Icon(Icons.add),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => Dialog(
                      backgroundColor: Color(0xffCDC6F2),
                      child: MembersInfo(groupId: gid,),
                    ),
                  );
                });
              },
              child: Icon(Icons.people),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: CurrentUser.userdata['groups'].length + 1, // Include one extra for the header
          itemBuilder: (context, index) {
            if (index == 0) {
              // Drawer Header
              return DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                ),
                child: Text(CurrentUser.userdata['role']),
              );
            } else {
              // ListTile for groups
              final group = groups[index - 1]; // Adjust for the header
              return ListTile(
                title: Text(group['groupName']),
                subtitle: Text(group['role']),
                onTap: () {
                  setState(() {
                    gid=group['groupId'];
                    reload();
                  });
                },
              );
            }
          },
        ),
      ),
        appBar: AppBar(
        title: Text("Your Notice Board"),
        actions: [
          PopupMenuButton<int>(
            offset: Offset(0, 55),
            icon: CircleAvatar(
              radius: 20,
              child: Icon(Icons.person),
            ),
            onSelected: (value) {
              if (value == 0) {
                print("prof");
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        child:Container(
                          height: 0.4.sh,
                          width: 0.3.sw, // 80% of the screen width
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.deepPurple, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Information',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              Divider(color: Colors.deepPurple, thickness: 1.5),
                              ...CurrentUser.userdata.entries.map((entry) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${entry.key}: ',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          entry.value.toString(),
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                    )
                );
              } else if (value == 1) {
                print("Logout clicked");
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child:Container(height: 200,
                          width: 500,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Are you Sure?"),
                                SizedBox(height: 80,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(onPressed: (){
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RoleSelector()));
                                    }, child: Text("Yes")),
                                    ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("No")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                    )
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text("User Info"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: GroupNotes(key: ValueKey(reloadKey),groupId: gid),
    );
  }
}
