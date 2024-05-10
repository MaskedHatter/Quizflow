import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlipCardButton extends StatelessWidget {
  final bool isFront;
  final FlipCardController flipCardController;
  const FlipCardButton(
      {super.key, required this.isFront, required this.flipCardController});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(3),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r)),
            ),
          ),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 15.h, horizontal: 0)),
        ),
        onPressed: () {
          flipCardController.toggleCard();
        },
        child: isFront
            ? Icon(
                Icons.loop_rounded, size: 30.w, //color: Colors.white
              )
            : RotatedBox(
                quarterTurns: 1,
                //manualTrigger: true,
                child: Icon(
                  Icons.loop_rounded, size: 30.w, //color: Colors.white
                ),
              ));
  }
}
