import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/Groups/group_notes_list.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/members.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/new_note.dart';

import '../../UI Components/notes.dart';
import '../../UI Components/notes_expanded.dart';

class AssociatedMember extends StatelessWidget {
  const AssociatedMember({Key? key}) : super(key: key);
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
                      child: AnimatedNewNotice(),
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
                      child: MembersInfo(groupId: 1,),
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
              ),
              child: Text("User"),
            ),
            ListTile(
              title: const Text('Group 1'),
              subtitle: Text('role'),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text('Group 2'),
              subtitle: Text('role'),
              onTap: () {
              },
            ),
          ],
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
      body: GroupNotes(groupId: 1,),
    );
  }
}
