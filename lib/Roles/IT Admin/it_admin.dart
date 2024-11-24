import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rbac_vrv_security_by_kshitiz/Mock%20Backend/mock_backend.dart';

class ITAdmin extends StatefulWidget {
  const ITAdmin({Key? key}) : super(key: key);

  @override
  State<ITAdmin> createState() => _ITAdminState();
}

class _ITAdminState extends State<ITAdmin> {
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: flag ? Text("All Users") : Text("All Groups")),
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
      body: flag ? UserList() : GroupsList(),
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
  Mock_API mock_api=Mock_API();
  List<Map<String, dynamic>> allusers = [];
  bool isLoading = true;

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return Mock_Backend.users;
  }
  void fetch(){
    getAllUsers().then((users) {
      setState(() {
        allusers = users;
        isLoading = false;
      });
    });
  }
  void removeuser(int id,String name,String role,String status,List<dynamic> groups) async {
    try {
      await mock_api.removeFromAllGroups(groups,id);
      await mock_api.removeUser(id,name,role,status,groups);
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
                IconButton(onPressed: (){
                  return WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Name: "),
                                    Flexible(child: TextField()),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text("Role: "),
                                    Flexible(child: TextField()),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text("Add in Groups: "),
                                    Flexible(child: TextField()),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("Done")),
                              ],
                            ),
                          ),
                        ),
                      )
                    );
                  });
                }, icon: Icon(Icons.add)),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                  itemCount: allusers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(allusers[index]['name']),
                          Text(allusers[index]['status']),
                          IconButton(onPressed: (){removeuser(allusers[index]['id'],allusers[index]['name'],allusers[index]['role'],allusers[index]['status'],allusers[index]['groups']);}, icon: Icon(Icons.remove))
                        ],
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
  const GroupsList({Key? key}) : super(key: key);

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
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(allgroups[index]['name']),
                    Text("${allgroups[index]['members'].length}")
                  ],
                ),
              );
            }),
      );
    }
  }
}
