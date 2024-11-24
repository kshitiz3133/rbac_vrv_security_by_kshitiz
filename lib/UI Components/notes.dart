import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rbac_vrv_security_by_kshitiz/Mock%20Backend/mock_backend.dart';
class buildNotice extends StatefulWidget {
  final List<Map<String,dynamic>> notesofgroup;
  final int index;
  const buildNotice({Key? key, required this.notesofgroup, required this.index}) : super(key: key);

  @override
  State<buildNotice> createState() => _buildNoticeState();
}

class _buildNoticeState extends State<buildNotice> {
  late List<Map<String,dynamic>> notesofgroup;
  late int index;
  late List<Map<int,String>> names=[];
  Mock_API mock_api=Mock_API();
  late String result="";

  void getNamesById() async {
    var data=await mock_api.getNamesByIds(widget.notesofgroup[index]['editors']);
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notesofgroup=widget.notesofgroup;
    index=widget.index;
    getNamesById();
    getNamesSeparatedByCommas();
  }
  @override
  Widget build(BuildContext context) {
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
                    result,
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
                    notesofgroup[index]["message"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  notesofgroup[index]["date"],
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
}
