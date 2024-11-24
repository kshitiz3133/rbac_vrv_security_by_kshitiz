import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: flag? Text("All Users"):Text("All Groups")
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
              title: const Text("All Users"),
              onTap: () {
                setState(() {
                  flag =true;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: const Text("All Groups"),
              onTap: () {
                setState(() {
                  flag =false;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      body: flag?UserList():GroupsList(),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Mock_Backend mockdb=Mock_Backend();
  List<Map<String, dynamic>> allusers = [];
  bool isLoading = true;

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return mockdb.users;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers().then((users) {
      setState(() {
        allusers = users;
        isLoading=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Center(child: CircularProgressIndicator());
    }
    else{
      return Container(
        child: ListView.builder(itemCount: allusers.length ,itemBuilder: (context,index){return ListTile(
          title: Text(allusers[index]['name']),
        );}),
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
  Mock_Backend mockdb=Mock_Backend();
  List<Map<String, dynamic>> allgroups = [];
  bool isLoading = true;

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return mockdb.groups;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers().then((groups) {
      setState(() {
        allgroups = groups;
        isLoading=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Center(child: CircularProgressIndicator());
    }
    else{
      return Container(
        child: ListView.builder(itemCount: allgroups.length ,itemBuilder: (context,index){return ListTile(
          title: Text(allgroups[index]['name']),
        );}),
      );
    }
  }
}
