class Mock_Backend{
  List<Map<String, dynamic>> users = [
    {'id': 1, 'name': 'John Doe', 'role': 'Admin', 'status': 'Active'},
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
}