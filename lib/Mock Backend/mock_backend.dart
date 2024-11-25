class Mock_Backend {
  static List<Map<String, dynamic>> users = [
    {'id': 1, 'name': 'John Doe', 'email': 'john.doe@example.com', 'role': 'ITAdmin', 'status': 'Active', 'groups': []},
    {'id': 2, 'name': 'Jane Smith', 'email': 'jane.smith@example.com', 'role': 'User', 'status': 'Active', 'groups': [1, 2]},
    {'id': 3, 'name': 'Alice Brown', 'email': 'alice.brown@example.com', 'role': 'User', 'status': 'Active', 'groups': [4]},
    {'id': 4, 'name': 'Mark Lee', 'email': 'mark.lee@example.com', 'role': 'User', 'status': 'Active', 'groups': [2,4]},
    {'id': 5, 'name': 'Emma Watson', 'email': 'emma.watson@example.com', 'role': 'User', 'status': 'Inactive', 'groups': [3]},
    {'id': 6, 'name': 'Sophia Turner', 'email': 'sophia.turner@example.com', 'role': 'User', 'status': 'Active', 'groups': [4]},
    {'id': 7, 'name': 'Oliver White', 'email': 'oliver.white@example.com', 'role': 'ITAdmin', 'status': 'Active', 'groups': []},
    {'id': 8, 'name': 'Liam Johnson', 'email': 'liam.johnson@example.com', 'role': 'User', 'status': 'Active', 'groups': [4]},
  ];

  static List<Map<String, dynamic>> groups = [
    {
      'id': 1,
      'name': 'Developers',
      'admin': [2],
      'members': [2],
    },
    {
      'id': 2,
      'name': 'Managers',
      'admin': [2],
      'members': [2, 4],
    },
    {
      'id': 3,
      'name': 'Designers',
      'admin': [5],
      'members': [5],
    },
    {
      'id': 4,
      'name': 'Support Team',
      'admin': [4],
      'members': [3,4,6,8],
    },
  ];

  static List<Map<String, dynamic>> notes = [
    {
      'id': 1,
      'group_id': 1,
      'editors': [2],
      'date': "19 May 2024",
      'message': "I am feeling good",
    },
    {
      'id': 2,
      'group_id': 2,
      'editors': [2],
      'date': "21 May 2024",
      'message': "Manager meeting scheduled for 22 May.",
    },
    {
      'id': 3,
      'group_id': 1,
      'editors': [2],
      'date': "22 May 2024",
      'message': "Completed the project sprint for week 4.",
    },
    {
      'id': 4,
      'group_id': 3,
      'editors': [5],
      'date': "23 May 2024",
      'message': "Design team will review the latest mockups tomorrow.",
    },
    {
      'id': 5,
      'group_id': 4,
      'editors': [4],
      'date': "24 May 2024",
      'message': "Support team training scheduled on 26 May.",
    },
    {
      'id': 6,
      'group_id': 4,
      'editors': [6],
      'date': "23 May 2024",
      'message': "New Note Testing.",
    },
  ];
}


class Mock_API extends Mock_Backend{
  Future<void> addUser(String name, String email, String role, String status) async {
    await Future.delayed(Duration(milliseconds: 500));
    bool userExists = Mock_Backend.users.any((user) => user['email'] == email);

    if (userExists) {
      print("User already exists with Email $email");
      throw Exception("User already exists with Email $email");
    }
    int newId = Mock_Backend.users.isNotEmpty
        ? Mock_Backend.users.last['id'] + 1
        : 1;
    Mock_Backend.users.add({
      'id': newId,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'groups': [],
    });

    print("User added successfully with ID $newId: $name");
  }


  Future<void> addGroupMember(int groupId, int userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final groupIndex = Mock_Backend.groups.indexWhere((group) => group['id'] == groupId);
    final userIndex = Mock_Backend.users.indexWhere((user) => user['id'] == userId);
    if (groupIndex != -1 && !Mock_Backend.groups[groupIndex]['members'].contains(userId)) {
      Mock_Backend.groups[groupIndex]['members'].add(userId);
      Mock_Backend.users[userIndex]['groups'].add(groupId);
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
    final userIndex = Mock_Backend.users.indexWhere((user) => user['id']==userId);
    if (groupIndex != -1) {
      Mock_Backend.groups[groupIndex]['members'].remove(userId);
      Mock_Backend.groups[groupIndex]['admin'].remove(userId);
      Mock_Backend.users[userIndex]['groups'].remove(groupId);
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
  Future<void> updateMessageOfGroup(String message, int groupId, int noteId) async {
    // Find the index of the note using both groupId and noteId
    final noteIndex = Mock_Backend.notes.indexWhere(
            (note) => note['group_id'] == groupId && note['id'] == noteId);

    if (noteIndex != -1) {
      // If the note exists, update the message
      Mock_Backend.notes[noteIndex]['message'] = message;

      // Optionally, show feedback to the user after updating the message
      print("Message updated for group ID $groupId and note ID $noteId");
    } else {
      // If no note is found matching both groupId and noteId
      throw Exception("No notes found for group ID $groupId and note ID $noteId");
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
    print(Mock_Backend.notes);
  }
  Future<void> deleteNoteById(int noteId, int groupId) async {
    // Find the index of the note using both noteId and groupId
    final noteIndex = Mock_Backend.notes.indexWhere(
            (note) => note['id'] == noteId && note['group_id'] == groupId);

    if (noteIndex != -1) {
      // If the note exists, remove it
      Mock_Backend.notes.removeAt(noteIndex);

      // Provide feedback or log the action
      print("Note with ID $noteId from group ID $groupId has been deleted.");
    } else {
      // If no matching note is found, throw an exception
      throw Exception("No note found with ID $noteId in group ID $groupId.");
    }
  }
  Future<bool> isUserAuthorized(int userId, int groupId, int noteId) async {
    final note = Mock_Backend.notes.firstWhere(
          (note) => note['id'] == noteId && note['group_id'] == groupId,
      orElse: () => {},
    );
    if (note.isEmpty) {
      throw Exception("Note not found for the given ID and group.");
    }
    if (note['editors'].contains(userId)) {
      return true; // User is authorized as an editor
    }
    final group = Mock_Backend.groups.firstWhere(
          (group) => group['id'] == groupId,
      orElse: () => {},
    );

    if (group.isEmpty) {
      throw Exception("Group not found for the given ID.");
    }
    if (group['admin'].contains(userId)) {
      return true; // User is authorized as an admin
    }
    return false;
  }

  Future<bool> isUserAuthorizedtoEdit(int userId, int groupId, int noteId) async {
    final note = Mock_Backend.notes.firstWhere(
          (note) => note['id'] == noteId && note['group_id'] == groupId,
      orElse: () => {},
    );
    if (note.isEmpty) {
      throw Exception("Note not found for the given ID and group.");
    }
    if (note['editors'][0]==userId) {
      return true; // User is authorized as an editor
    }
    final user=Mock_Backend.users.firstWhere((user) => user['id']==userId);
    if(user['role']=='ITAdmin'){
      return true;
    }
    return false;
  }
  Future<void> addEditorToNote(int noteId,int groupId,int userId,) async {
    final noteIndex = Mock_Backend.notes.indexWhere(
          (note) => note['id'] == noteId && note['group_id'] == groupId,
    );

    if (noteIndex == -1) {
      throw Exception("Note not found for the given ID and group.");
    }

    // Check if the user exists
    final userIndex = Mock_Backend.users.indexWhere((user) => user['id'] == userId);
    if (userIndex == -1) {
      throw Exception("User not found for the given ID.");
    }

    // Add the user to the editors list if not already present
    final editors = Mock_Backend.notes[noteIndex]['editors'] as List<int>;
    if (!editors.contains(userId)) {
      editors.add(userId);
      print("User ID $userId added as an editor to note ID $noteId.");
    } else {
      print("User ID $userId is already an editor for note ID $noteId.");
    }
  }

  Future<void> removeEditorFromNote(int noteId, int groupId, int userId) async {
    final note = Mock_Backend.notes.firstWhere(
          (note) => note['id'] == noteId && note['group_id'] == groupId,
      orElse: () => {},
    );

    if (note.isEmpty) {
      throw Exception("Note not found for the given ID and group.");
    }

    final editors = List<int>.from(note['editors']);
    if (!editors.contains(userId)) {
      throw Exception("User is not an editor of this note.");
    }

    editors.remove(userId);
    note['editors'] = editors; // Update the note
  }



}