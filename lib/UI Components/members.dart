import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rbac_vrv_security_by_kshitiz/Mock%20Backend/mock_backend.dart';
import 'package:rbac_vrv_security_by_kshitiz/current_user_data.dart';

class MembersInfo extends StatefulWidget {
  final groupId;
  const MembersInfo({Key? key, this.groupId}) : super(key: key);

  @override
  State<MembersInfo> createState() => _MembersInfoState();
}

class _MembersInfoState extends State<MembersInfo> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  TextEditingController textController=TextEditingController();
  var _overlaycontroller = OverlayPortalController();
  Mock_API mock_api = Mock_API();
  late List<Map<int,String>> members=[];
  late List<String> names=[];
  late List<Map<String, dynamic>> nonGroupMembers = [];
  List<int> selectedMemberIds = [];
  final formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());


  Future<bool> checkremoveuseraccess() async {
    var data = await mock_api.getGroupRole(widget.groupId, CurrentUser.userdata['id']);
    if(data=='Admin'||CurrentUser.userdata['role']=='ITAdmin'){
      return true;
    }
    return false;
  }
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return Mock_Backend.users;
  }
  Future<List<Map<String, dynamic>>> getNonGroupMembers() async {
    // Get all users from the backend
    List<Map<String, dynamic>> allUsers = await getAllUsers();

    // Extract the IDs of members in the group
    List<int> memberIds = members.map((member) => member.keys.first).toList();

    // Filter users who are not in the group
    List<Map<String, dynamic>> nonGroupUsers = allUsers.where((user) {
      return !memberIds.contains(user['id']);
    }).toList();

    return nonGroupUsers;
  }
  Future<void> fetchNonGroupMembers() async {
    try {
      List<Map<String, dynamic>> result = await getNonGroupMembers();
      setState(() {
        nonGroupMembers = result;
      });
      print("members: $members");
      print("Non-group members: $nonGroupMembers");
    } catch (error) {
      print("Error fetching non-group members: $error");
    }
  }




  Future<void> fetchmembers() async {
    var data= await mock_api.getMembersFromGroup(widget.groupId);
    var mem= await mock_api.getNamesByIds(data);
    setState(() {
      members=mem;
      fetchNonGroupMembers();
      getNamesSeparatedByCommas();
    });
  }
  Future<void> getNamesSeparatedByCommas() async {
    setState(() {
      names = members.map((map) => map.values.first).toList();
    });
  }


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100), // Set your desired duration
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1,
    ).animate(_controller);

    _controller.forward(); // Start the animation
    fetchmembers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlaycontroller,
      overlayChildBuilder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(onTap: (){_overlaycontroller.toggle();},child: Scaffold(backgroundColor: Colors.white.withOpacity(0.5),)),
            Center(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFF9C8FB7)),
                height: 500,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child:Column(
                    children: [
                      Text(
                        "Add Member",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: nonGroupMembers.isEmpty
                            ? Center(child: Text("No members available to add."))
                            : ListView.builder(
                          itemCount: nonGroupMembers.length,
                          itemBuilder: (context, index) {
                            final member = nonGroupMembers[index];
                            final isSelected = selectedMemberIds.contains(member['id']);

                            return ListTile(
                              title: Text(member['name']),
                              subtitle: Text(member['email']),
                              trailing: Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedMemberIds.add(member['id']);
                                    } else {
                                      selectedMemberIds.remove(member['id']);
                                    }
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedMemberIds.remove(member['id']);
                                  } else {
                                    selectedMemberIds.add(member['id']);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if(await checkremoveuseraccess()){
                            print("members from add: $selectedMemberIds");
                            // Call API to add selected members to the group
                            for (int memberId in selectedMemberIds) {
                              await mock_api.addGroupMember(widget.groupId, memberId);
                            }

                            // Refresh the member lists
                            await fetchmembers();
                            await fetchNonGroupMembers();

                            // Clear selected members
                            setState(() {
                              selectedMemberIds.clear();
                            });
                            print("all users: ${Mock_Backend.users}");

                            // Optionally close the overlay
                            _overlaycontroller.toggle();
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("You don't have the access for this action")),);
                          }
                        },
                        child: Text("Add (${selectedMemberIds.length})"),
                      ),
                    ],
                  )

                ),
              ),
            ),
          ],
        );
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: child,
          );
        },
        child: Transform.translate(
          offset: Offset(0, 25),
          child: Container(
            height: 825.h,
            width: 1400.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffCDC6F2),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 20, 14, 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 173.h,
                          width: 340.w,
                          child: Icon(Icons.people,size: 80,),
                        ),
                      ),
                      SizedBox(
                          width: 316.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Members',
                                textScaler: TextScaler.linear(1),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 25.sp),
                              ),
                              Text("${members.length}"),
                            ],
                          )),
                      SizedBox(height: 10,),
                      Container(
                        color: Colors.transparent,
                        height: 210,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 100,
                            crossAxisCount: 6,
                          ),
                          itemCount: members.length,
                          itemBuilder: (BuildContext context, int index) {
                            final memberId = members[index].keys.first;
                            final memberName = members[index].values.first;

                            return Card(
                              color: Colors.deepPurple,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    memberName,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  IconButton(
                                    icon: Icon(Icons.remove, color: Colors.red),
                                    onPressed: () async {
                                      // Remove member using the Mock API
                                      if(await checkremoveuseraccess()){
                                        await mock_api.removeGroupMember(widget.groupId, memberId);

                                        // Update the member lists
                                        await fetchmembers();
                                        await fetchNonGroupMembers();

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('$memberName removed from group.')),
                                        );
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("You don't have the access for this action")),);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formattedDate,style: TextStyle(color: Colors.black.withOpacity(0.2)),),
                      IconButton(onPressed: ()async{
                        if(await checkremoveuseraccess()){
                          _overlaycontroller.toggle();
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("You don't have the access for this action")),);
                        }
                      }, icon: Row(
                        children: [
                          Container(child: Icon(Icons.add)),
                          Container(child: Icon(Icons.people)),
                        ],
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}