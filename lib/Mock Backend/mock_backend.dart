class Mock_Backend{
  static List<Map<String, dynamic>> users = [
    {'id': 1, 'name': 'John Doe','email': 'john.doe@example.com', 'role': 'ITAdmin', 'status': 'Active','groups':[1]},
    {'id': 2, 'name': 'Jane Smith','email': 'jane.smith@example.com', 'role': 'User','status': 'Active','groups':[1,2]},
    {'id': 3, 'name': 'Alice Brown','email': 'alice.brown@example.com', 'role': 'User', 'status': 'Active','groups':[]},
  ];
  static List<Map<String, dynamic>> groups = [
    {
      'id': 1,
      'name': 'Developers',
      'admin': [1],
      'members': [1, 2]
    },
    {
      'id': 2,
      'name': 'Managers',
      'admin': [2],
      'members': [2],
    },
  ];
  static List<Map<String, dynamic>> notes=[
    {
      'id':1,
      'group_id':1,
      'editors':[1],
      'date':"19 May 2024",
      'message':"I am feeling good",
    }
  ];
}

class Mock_API extends Mock_Backend{
  void addUser(int id,String name,String email,String role,String status){
    Mock_Backend.users.add({
      'id':id,
      'name':name,
      'email':email,
      'role': role,
    'status': status
    });
  }
  Future<void> addGroupMember(int groupId, int userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final groupIndex = Mock_Backend.groups.indexWhere((group) => group['id'] == groupId);
    if (groupIndex != -1 && !Mock_Backend.groups[groupIndex]['members'].contains(userId)) {
      Mock_Backend.groups[groupIndex]['members'].add(userId);
    } else {
      throw Exception('User already in the group or group not found');
    }
  }


  Future<String?> getGroupRole(int groupId, int userId) async {
    // Find the group by ID
    var group = Mock_Backend.groups.firstWhere((group) => group['id'] == groupId, orElse: () => {});

    if (group.isNotEmpty) {
      if (group['admin'].contains(userId)) {
        return "Admin"; // User is an admin in this group
      } else if (group['members'].contains(userId)) {
        return "Member"; // User is a member in this group
      }
    }
    return null; // User is not in the group
  }

  // Fetch all groups a user belongs to with their roles
  Future<List<Map<String, dynamic>>> getUserGroups(int userId) async {
    List<Map<String, dynamic>> userGroups = [];

    for (var group in Mock_Backend.groups) {
      String? role = await getGroupRole(group['id'], userId);
      if (role != null) {
        userGroups.add({
          'groupId': group['id'],
          'groupName': group['name'],
          'role': role,
        });
      }
    }
    return userGroups;
  }
  Future<void> removeUser(int id, String name, String role, String status, List<dynamic> groups) async {
    // Find the user in the list by their ID
    final userIndex = Mock_Backend.users.indexWhere((user) => user['id'] == id);
    if (userIndex != -1) {
      Mock_Backend.users.removeAt(userIndex);
      print("After removing: ${Mock_Backend.users}");
    } else {
      print("User not found");
    }
  }
  Future<void> removeGroupMember(int groupId, int userId) async {
    final groupIndex = Mock_Backend.groups.indexWhere((group) => group['id'] == groupId);
    if (groupIndex != -1) {
      Mock_Backend.groups[groupIndex]['members'].remove(userId);
      Mock_Backend.groups[groupIndex]['admin'].remove(userId);
      print("After removing: ${Mock_Backend.groups}");
    } else {
      throw Exception('Group not found');
    }
    print(Mock_Backend.groups);
  }

  Future<void> removeFromAllGroups(List<dynamic> groups,int userid)async {
    for(var a in groups){
      await removeGroupMember(a, userid);
    }
  }
  Future<List<Map<String, dynamic>>> getNotesByGroupId(int groupId) async {
    // Filter notes by group_id
    return Mock_Backend.notes.where((note) => note['group_id'] == groupId).toList();
  }
  Future<List<int>> getMembersFromGroup(int groupId) async {
    // Find the group with the given ID
    final group = Mock_Backend.groups.firstWhere(
          (group) => group['id'] == groupId,
      orElse: () => {},
    );

    // Check if the group was found and return the members, otherwise return an empty list
    return group.isNotEmpty ? List<int>.from(group['members']) : [];
  }
  Future<void> updateMessageOfGroup(String message, int groupId) async {
    // Find the index of the note related to the groupId in the notes list
    final noteIndex = Mock_Backend.notes.indexWhere((note) => note['group_id'] == groupId);

    if (noteIndex != -1) {
      // If the note exists, update the message
      Mock_Backend.notes[noteIndex]['message'] = message;

      // Optionally, show feedback to the user after updating the message
      print("Message updated for group ID $groupId");

      // If needed, you can also trigger some UI update here or return a success message
    } else {
      // If no note is found for the given groupId
      throw Exception("No notes found for group ID $groupId");
    }
  }
  Future<List<Map<int, String>>> getNamesByIds(List<int> ids) async {
    List<Map<int, String>> result = [];
    for (int id in ids) {
      // Find the user by ID
      final user = Mock_Backend.users.firstWhere(
            (user) => user['id'] == id,
        orElse: () => {},
      );
      // If user exists, add it to the result
      if (user != {}) {
        result.add({id: user['name']});
      }
    }
    return result;
  }
  Future<void> addNote(int groupId, List<int> editors, String date, String message) async {
    // Generate a new note ID (in this case, we're assuming the ID is the last note's ID + 1)
    int newNoteId = Mock_Backend.notes.isEmpty
        ? 1
        : Mock_Backend.notes.last['id'] + 1;

    // Add the new note to the list of notes
    Mock_Backend.notes.add({
      'id': newNoteId,
      'group_id': groupId,
      'editors': editors,
      'date': date,
      'message': message,
    });

    print("Note added successfully: $message");
  }

}