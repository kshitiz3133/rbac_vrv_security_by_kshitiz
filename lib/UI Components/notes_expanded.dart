import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/notes.dart';
import 'package:rbac_vrv_security_by_kshitiz/current_user_data.dart';

import '../Mock Backend/mock_backend.dart';
class AnimatedNotice extends StatefulWidget {
  final Map<String,dynamic> note;
  final VoidCallback reload;

  const AnimatedNotice({super.key, required this.note, required this.reload});

  @override
  _AnimatedNoticeState createState() => _AnimatedNoticeState();
}

class _AnimatedNoticeState extends State<AnimatedNotice>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late TextEditingController textController=TextEditingController(text: "");
  bool edit=false;
  late List<Map<int,String>> names=[];
  Mock_API mock_api=Mock_API();
  late String result="";

  void getNamesById() async {
    var data=await mock_api.getNamesByIds(widget.note['editors']);
    setState(() {
      names=data;
    });
    await getNamesSeparatedByCommas();
  }
  Future<void> getNamesSeparatedByCommas() async {
    setState(() {
      result = names.map((map) => map.values.first).join(', ');
    });
  }

  Future<bool> checkeditaccess() async{
    bool check= await mock_api.isUserAuthorized(CurrentUser.userdata['id'], widget.note['group_id'], widget.note['id']);
    if(check) {
      return true;
    }
    else{
      return false;
    }
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
    getNamesById();
    textController=TextEditingController(text: widget.note['message']);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
                        child: Icon(Icons.book_outlined,size: 80,),
                      ),
                    ),
                    SizedBox(
                        width: 316.w,
                        child: Text(
                          result,
                          textScaler: TextScaler.linear(1),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 25.sp),
                        )),
                    SizedBox(height: 10,),

                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
                      child: TextField(
                        controller: textController,
                        style: TextStyle(color: Colors.black.withOpacity(0.4),fontSize: 20.sp),
                        enabled: edit,
                        cursorColor: Colors.black,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical(y: -1),
                        decoration: InputDecoration(

                          contentPadding:
                          EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w,bottom: 90.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 5.w,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: edit? Colors.grey:Colors.black,
                              width: 2.0.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.note['date'],style: TextStyle(color: Colors.black.withOpacity(0.2)),),
                    edit?Row(
                        children:[
                          IconButton(onPressed:() async {
                            await mock_api.deleteNoteById(widget.note['id'], widget.note['group_id']);
                            widget.reload();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Removed')),
                            );
                          }, icon:Icon(Icons.delete_outline)),
                          IconButton(onPressed:() async{
                            await mock_api.updateMessageOfGroup(textController.text, widget.note['group_id'],widget.note['id']);
                            setState(() {
                              edit=!edit;
                          });
                            widget.reload();
                            },icon:Icon(Icons.check)),
                        ]
                    )
                        :IconButton(onPressed: ()async{
                          if(await checkeditaccess()){
                            setState(() {
                              edit=!edit;
                            });
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Edit access not granted')),
                            );
                          }
                    }, icon: Icon(Icons.edit))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
