import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/viewmodel/add_card_model.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.context,
    required this.label,
    required this.controller,
    required this.lines,
  });

  final BuildContext context;
  final String label;
  final TextEditingController controller;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18.sp,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context.read<AddCardModel>().importImage(controller);
                    },
                    icon: Icon(
                      Icons.image_outlined,
                      size: 26.w,
                    ))
              ],
            ),
          ),
          TextField(
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14.sp),
            minLines: lines,
            maxLines: 100,
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Type here',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0.0),
                ),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
