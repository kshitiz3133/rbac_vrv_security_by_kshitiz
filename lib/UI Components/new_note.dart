import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rbac_vrv_security_by_kshitiz/Mock%20Backend/mock_backend.dart';
import 'package:rbac_vrv_security_by_kshitiz/UI%20Components/Groups/group_notes_list.dart';
import 'package:rbac_vrv_security_by_kshitiz/current_user_data.dart';
class AnimatedNewNotice extends StatefulWidget {
  final int groupId;
  final VoidCallback reload;
  const AnimatedNewNotice({super.key, required this.groupId, required this.reload});


  @override
  _AnimatedNewNoticeState createState() => _AnimatedNewNoticeState();
}

class _AnimatedNewNoticeState extends State<AnimatedNewNotice>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  TextEditingController textController=TextEditingController();
  Mock_API mock_api = Mock_API();

  void newnote(int groupId, List<int> editors, String date, String message)async{
    await mock_api.addNote(groupId,editors,date,message);
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
                          CurrentUser.userdata['name'],
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
                        maxLines: 8,
                        style: TextStyle(color: Colors.black.withOpacity(0.4),fontSize: 20.sp),
                        cursorColor: Colors.black,
                        textAlign: TextAlign.left,
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
                              color: Colors.black,
                              width: 2.0.w,
                            ),
                          ),
                          hintText: 'Write your message',
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.4),fontSize: 20.sp),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('19 May 24',style: TextStyle(color: Colors.black.withOpacity(0.2)),),
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          GroupNotes gn = GroupNotes(groupId: widget.groupId);
                          newnote(widget.groupId, [CurrentUser.userdata['id']], "19 May 2024", textController.text);
                          widget.reload();
                          Navigator.pop(context);
                        }, icon: Icon(Icons.check)),
                      ],
                    )
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
