import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Widget buildNotice() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 170.h,
      width: 170.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xffCDC6F2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 10, 2.5),
              child: Container(
                  height: 64.h,
                  width: 60.w,
                  child:Icon(Icons.book_outlined,size: 40,)
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2.5, 10, 5),
              child: SizedBox(
                width: 139.69.w,
                height: 60.h,
                child: Text(
                  "Owner",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2.5, 10, 0),
              child: SizedBox(
                width: 139.69.w,
                height: 60.h,
                child: Text(
                  "Main Body",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                "19 May 24",
                style: TextStyle(
                    fontSize: 14.sp, color: Colors.black.withOpacity(0.2)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}