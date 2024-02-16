import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/widgets/display_screen_widgets/flip_card_button.dart';
import 'package:quizflow/widgets/display_screen_widgets/grade_buttons.dart';

class RowOfButtons extends StatelessWidget {
  final bool isFront;
  final FlipCardController flipCardController;
  final CardSwiperController cardSwipeControl;
  final Flashcard card;
  const RowOfButtons(
      {super.key,
      required this.isFront,
      required this.flipCardController,
      required this.cardSwipeControl,
      required this.card});

  @override
  Widget build(BuildContext context) {
    return !isFront
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // const Divider(
              //   thickness: 3,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradeButton(
                      isNo: 1,
                      isFront: false,
                      card: card,
                      cardSwipeControl: cardSwipeControl),
                  GradeButton(
                      isNo: 2,
                      isFront: false,
                      card: card,
                      cardSwipeControl: cardSwipeControl),
                  GradeButton(
                      isNo: 3,
                      isFront: false,
                      card: card,
                      cardSwipeControl: cardSwipeControl),
                  GradeButton(
                      isNo: 4,
                      isFront: false,
                      card: card,
                      cardSwipeControl: cardSwipeControl)
                ],
              ),
              //Divider(),
              FlipCardButton(
                  isFront: isFront, flipCardController: flipCardController)
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // const Divider(
              //   thickness: 3,
              // ),
              FlipCardButton(
                  isFront: isFront, flipCardController: flipCardController)
            ],
          );
  }
}
