import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rbac_vrv_security_by_kshitiz/Mock%20Backend/mock_backend.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/Groups/group_notes_list.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/Role%20Selector/role_selector.dart';

import '../../UI Components/members.dart';
import '../../current_user_data.dart';

class ITAdmin extends StatefulWidget {
  const ITAdmin({Key? key}) : super(key: key);

  @override
  State<ITAdmin> createState() => _ITAdminState();
}

class _ITAdminState extends State<ITAdmin> {
  bool flag = true;
  int reloadKey = 0;

  void reload() {
    setState(() {
      reloadKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: flag ? Text("All Users") : Text("All Groups"),
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
                          child: Container(
                            height: 0.4.sh,
                            width: 0.3.sw,
                            // 80% of the screen width
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                  color: Colors.deepPurple, width: 2),
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
                                Divider(
                                    color: Colors.deepPurple, thickness: 1.5),
                                ...CurrentUser.userdata.entries.map((entry) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                        ));
              } else if (value == 1) {
                print("Logout clicked");
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                            child: Container(
                          height: 200,
                          width: 500,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Are you Sure?"),
                                SizedBox(
                                  height: 80,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RoleSelector()));
                                        }, child: Text("Yes")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )));
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
              ),
              child: Text("IT Admin"),
            ),
            ListTile(
              title: const Text("All Users"),
              onTap: () {
                setState(() {
                  flag = true;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: const Text("All Groups"),
              onTap: () {
                setState(() {
                  flag = false;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      body: flag
          ? UserList(
              key: ValueKey(reloadKey),
            )
          : GroupsList(
              key: ValueKey(reloadKey),
              reload: reload,
            ),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Mock_Backend mockdb = Mock_Backend();
  Mock_API mock_api = Mock_API();
  List<Map<String, dynamic>> allusers = [];
  bool isLoading = true;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController role = TextEditingController();

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return Mock_Backend.users;
  }

  void fetch() {
    getAllUsers().then((users) {
      setState(() {
        allusers = users;
        isLoading = false;
      });
    });
  }

  Future<void> adduser(
      String name, String email, String role, String status) async {
    await mock_api.addUser(name, email, role, status);
    fetch();
  }

  void removeuser(int id, String name, String role, String status,
      List<dynamic> groups) async {
    try {
      await mock_api.removeFromAllGroups(groups, id);
      await mock_api.removeUser(id, name, role, status, groups);
      setState(() {
        fetch();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed User')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove user: $e')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Name"),
                Text("Status"),
                ElevatedButton(
                    onPressed: () {
                      return WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("Name: "),
                                              Flexible(
                                                  child: TextField(
                                                controller: name,
                                              )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text("Email: "),
                                              Flexible(
                                                  child: TextField(
                                                controller: email,
                                              )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text("Role: "),
                                              Flexible(
                                                  child: TextField(
                                                controller: role,
                                              )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                await adduser(
                                                    name.text,
                                                    email.text,
                                                    role.text,
                                                    "Active");
                                                Navigator.pop(context);
                                                print(Mock_Backend.users);
                                              },
                                              child: Text("Done")),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      });
                    },
                    child: Text("Add a user")),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                  itemCount: allusers.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        title: Text(allusers[index]['name']),
                                      ),
                                      body: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: allusers[index]
                                                .entries
                                                .map((entry) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(entry.key,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(entry.value
                                                          .toString()),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                removeuser(
                                                    allusers[index]['id'],
                                                    allusers[index]['name'],
                                                    allusers[index]['role'],
                                                    allusers[index]['status'],
                                                    allusers[index]['groups']);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Remove")),
                                        ],
                                      ),
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(allusers[index]['name']),
                            Text(allusers[index]['status']),
                            TextButton(
                                onPressed: () {
                                  removeuser(
                                      allusers[index]['id'],
                                      allusers[index]['name'],
                                      allusers[index]['role'],
                                      allusers[index]['status'],
                                      allusers[index]['groups']);
                                },
                                child: Text("Remove")),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      );
    }
  }
}

class GroupsList extends StatefulWidget {
  final VoidCallback reload;

  const GroupsList({Key? key, required this.reload}) : super(key: key);

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  Mock_Backend mockdb = Mock_Backend();
  List<Map<String, dynamic>> allgroups = [];
  bool isLoading = true;

  Future<List<Map<String, dynamic>>> getAllGroups() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return Mock_Backend.groups;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllGroups().then((groups) {
      setState(() {
        allgroups = groups;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        child: ListView.builder(
            itemCount: allgroups.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                              floatingActionButton: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FloatingActionButton(
                                  onPressed: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => Dialog(
                                          backgroundColor: Color(0xffCDC6F2),
                                          child: MembersInfo(
                                            groupId: allgroups[index]['id'],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  child: Icon(Icons.people),
                                ),
                              ),
                              appBar: AppBar(
                                leading: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.reload();
                                  },
                                  icon: Icon(Icons.arrow_back),
                                ),
                                title: Text(allgroups[index]['name'] +
                                    " Group's Notes"),
                              ),
                              body: GroupNotes(
                                  groupId: allgroups[index]['id']))));
                },
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(allgroups[index]['name']),
                      Text("${allgroups[index]['members'].length}")
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
