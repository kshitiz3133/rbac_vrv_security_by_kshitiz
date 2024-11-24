import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rbac_vrv_security_by_kshitiz/Mock%20Backend/mock_backend.dart';

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

  Future<void> fetchmembers() async {
    var data= await mock_api.getMembersFromGroup(widget.groupId);
    var mem= await mock_api.getNamesByIds(data);
    setState(() {
      members=mem;
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
                  child: Column(
                    children: [
                      Text("Add Member"),
                      SizedBox(height: 10,),
                      Flexible(child: TextField()),
                      SizedBox(height: 40,),
                      ElevatedButton(onPressed: (){}, child: Text("Add")),
                    ],
                  ),
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
                                return Card(
                                  color: Colors.deepPurple ,
                                  child: Center(child: Text(names[index])),
                                );
                              }
                          ),
                      ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('19 May 24',style: TextStyle(color: Colors.black.withOpacity(0.2)),),
                      IconButton(onPressed: (){
                        _overlaycontroller.toggle();
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