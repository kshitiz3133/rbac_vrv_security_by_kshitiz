import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rbac_vrv_security_by_kshitiz/Mock%20Backend/mock_backend.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/Groups/group_notes_list.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/members.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/new_note.dart';

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
    setState(() {
      groups=data;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    gid=widget.groupId;
    getusergroups();
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
                child: Text("User"),
              );
            } else {
              // ListTile for groups
              final group = groups[index - 1]; // Adjust for the header
              return ListTile(
                title: Text(group['groupName']),
                subtitle: Text(group['role']),
                onTap: () {
                  print("Selected Group: ");
                  // Add navigation or actions here
                },
              );
            }
          },
        ),
      ),
        appBar: AppBar(
        title: Text("Your Notice Board"),
        actions: [
          Icon(
            (Icons.notifications),
            size: 28,
          ),
          SizedBox(
            width: 10,
          ),
          PopupMenuButton<int>(
            offset: Offset(0, 55),
            icon: CircleAvatar(
              radius: 20,
            ),
            onSelected: (value) {
              if (value == 0) {
                print("prof");
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
                                    ElevatedButton(onPressed: (){}, child: Text("Yes")),
                                    ElevatedButton(onPressed: (){}, child: Text("No")),
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
                    Text("Profile"),
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
