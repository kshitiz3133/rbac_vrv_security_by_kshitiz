import 'package:flutter/material.dart';
class ITAdmin extends StatelessWidget {
  const ITAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IT Admin"),
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
              },
            ),
            ListTile(
              title: const Text("All Groups"),
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
