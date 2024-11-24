import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AnimatedNotice extends StatefulWidget {
  @override
  _AnimatedNoticeState createState() => _AnimatedNoticeState();
}

class _AnimatedNoticeState extends State<AnimatedNotice>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  TextEditingController textController=TextEditingController(text: "Bill");
  bool edit=false;

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
                          'Owner',
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
                    Text('19 May 24',style: TextStyle(color: Colors.black.withOpacity(0.2)),),
                    edit?Row(
                        children:[
                          IconButton(onPressed:(){},icon:Icon(Icons.delete_outline)),
                          IconButton(onPressed:(){setState(() {
                            edit=!edit;
                          });},icon:Icon(Icons.check)),
                        ]
                    )
                        :IconButton(onPressed: (){setState(() {
                      edit=!edit;
                    });}, icon: Icon(Icons.edit))
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
