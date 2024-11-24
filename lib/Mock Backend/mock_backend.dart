class Mock_Backend{
  List<Map<String, dynamic>> users = [
    {'id': 1, 'name': 'John Doe', 'role': 'ITAdmin', 'status': 'Active'},
    {'id': 2, 'name': 'Jane Smith', 'role': 'User','status': 'Active'},
    {'id': 3, 'name': 'Alice Brown', 'role': 'User', 'status': 'Active'},
  ];
  List<Map<String, dynamic>> groups = [
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
}

class Mock_API extends Mock_Backend{
  void addUser(int id,String name,String role,String status){
    super.users.add({
      'id':id,
      'name':name,
      'role': role,
    'status': status
    });
  }
  Future<void> addGroupMember(int groupId, int userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final groupIndex = groups.indexWhere((group) => group['id'] == groupId);
    if (groupIndex != -1 && !groups[groupIndex]['members'].contains(userId)) {
      groups[groupIndex]['members'].add(userId);
    } else {
      throw Exception('User already in the group or group not found');
    }
  }

  Future<void> removeGroupMember(int groupId, int userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final groupIndex = groups.indexWhere((group) => group['id'] == groupId);
    if (groupIndex != -1) {
      groups[groupIndex]['members'].remove(userId);
    } else {
      throw Exception('Group not found');
    }
  }
  Future<String?> getGroupRole(int groupId, int userId) async {
    // Find the group by ID
    var group = groups.firstWhere((group) => group['id'] == groupId, orElse: () => {});

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

    for (var group in groups) {
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
}