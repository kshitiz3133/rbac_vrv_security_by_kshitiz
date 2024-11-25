import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rbac_vrv_security_by_kshitiz/Roles/Associated%20Member/associated_member.dart';
import 'package:rbac_vrv_security_by_kshitiz/Roles/IT%20Admin/it_admin.dart';
import 'package:rbac_vrv_security_by_kshitiz/current_user_data.dart';

import '../../Mock Backend/mock_backend.dart';

class RoleSelector extends StatefulWidget {
  const RoleSelector({Key? key}) : super(key: key);

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  bool isLoading = true;
  List<Map<String, dynamic>> allUsers = [];

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return Mock_Backend.users; // Mock backend data
  }

  void loadUsers() async {
    // Simulate loading delay and fetch users
    List<Map<String, dynamic>> users = await getAllUsers();
    await Future.delayed(Duration(seconds: 1)); // Simulated delay
    setState(() {
      allUsers = users;
      isLoading = false;
    });
  }
  Future<void> changeRole(Map<String, dynamic> user) async {
    CurrentUser.userdata['id']=user['id'];
    CurrentUser.userdata['name']=user['name'];
    CurrentUser.userdata['email']=user['email'];
    CurrentUser.userdata['role']=user['role'];
    CurrentUser.userdata['status']=user['status'];
    CurrentUser.userdata['groups']=user['groups'];
  }

  void roleselection(Map<String, dynamic> user)async{
    await changeRole(user);
    print(CurrentUser.userdata);
    if(user['role']=="ITAdmin"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ITAdmin()));
    }
    else if(user['role']=="User"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AssociatedMember(groupId: user['groups'][0])));
    }
  }

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Role Selector"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    mainAxisExtent: 120,
                  ),
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) {
                    final user = allUsers[index];
                    return InkWell(
                      onTap: (){
                        roleselection(user);
                      },
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user['name'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "Role: ${user['role']}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                user['email'],
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Text("Thank You VRV Security for providing me this amazing opportunity. I learned multiple new things and enjoyed representing my creativity and skills,"),
            Text("Hope you like my work. Please tell me what things I should take care of, if in case you thought I missed something"),
            Text("Assessment by Kshitiz Agarwal")
          ],
        ),
      );
    }
  }
}

