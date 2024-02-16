import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

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
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
          ),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 15, horizontal: 0)),
        ),
        onPressed: () {
          flipCardController.toggleCard();
        },
        child: isFront
            ? const Icon(
                Icons.loop_rounded, size: 30, //color: Colors.white
              )
            : const RotatedBox(
                quarterTurns: 1,
                //manualTrigger: true,
                child: Icon(
                  Icons.loop_rounded, size: 30, //color: Colors.white
                ),
              ));
  }
}
