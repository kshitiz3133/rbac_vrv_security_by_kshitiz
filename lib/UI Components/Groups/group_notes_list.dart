import 'package:flutter/material.dart';
import 'package:rbac_vrv_security_by_kshitiz/Mock%20Backend/mock_backend.dart';

import '../notes.dart';
import '../notes_expanded.dart';

class GroupNotes extends StatefulWidget {
  final int groupId;
  const GroupNotes({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupNotes> createState() => _GroupNotesState();
}

class _GroupNotesState extends State<GroupNotes> {
  Mock_API mock_api = Mock_API();
  late List<Map<String,dynamic>> notesofgroup;

  void getlist()async {
    var data = await mock_api.getNotesByGroupId(widget.groupId);
    setState(() {
      notesofgroup = data;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlist();
  }
  void reloadnotes(){
    getlist();
    print("reloaded");
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData().copyWith(textScaler: TextScaler.linear(1.2)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
          ),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            var _overlaycontroller = OverlayPortalController();
            return GestureDetector(
              onTap: () {
                _overlaycontroller.toggle();
                print("note opened $index");
              },
              child: OverlayPortal(
                controller: _overlaycontroller,
                overlayChildBuilder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      _overlaycontroller.toggle();
                    },
                    child: Stack(
                      children: [
                        Scaffold(
                          backgroundColor: Colors.white.withOpacity(0.5),
                        ),
                        Center(
                          child: AnimatedNotice(note: notesofgroup[index],reload:reloadnotes),
                        ),
                      ],
                    ),
                  );
                },
                child: buildNotice(notesofgroup: notesofgroup,index: index),
              ),
            );
          },
        ),
      ),
    );
  }
}
