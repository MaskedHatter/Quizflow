import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/functions/again.dart';
import 'package:quizflow/functions/easy.dart';
import 'package:quizflow/functions/good.dart';
import 'package:quizflow/functions/hard.dart';

class GradeButton extends StatelessWidget {
  final int isNo;
  final bool isFront;
  final Flashcard card;
  final CardSwiperController cardSwipeControl;
  const GradeButton(
      {super.key,
      required this.isNo,
      required this.isFront,
      required this.card,
      required this.cardSwipeControl});

  @override
  Widget build(BuildContext context) {
    // 1 is Again
    // 2 is Hard
    // 3 is Good
    // 4 is Easy
    return Expanded(
      child: ElevatedButton(
          onPressed: () {
            //Work is going on here
            // What happens when any of the 4 buttons are pressed
            if (isNo == 1) {
              // Again
              if (card.cardState == 0) {
                Again().newCard(card);
              } else if (card.cardState == 1) {
                Again().graduated(card);
              } else if (card.cardState == 2) {
                Again().lapsed(card);
              }
              card.setTimer();
              cardSwipeControl.swipeLeft();
            }
            if (isNo == 2) {
              // Hard
              if (card.cardState == 0) {
                Hard().newCard(card);
              } else if (card.cardState == 1) {
                Hard().graduated(card);
              } else if (card.cardState == 2) {
                Hard().lapsed(card);
              }
              card.setTimer();
              cardSwipeControl.swipeLeft();
            }
            if (isNo == 3) {
              // Hit Good
              if (card.cardState == 0) {
                Good().newCard(card);
              } else if (card.cardState == 1) {
                Good().graduated(card);
              } else if (card.cardState == 2) {
                Good().lapsed(card);
              }
              card.setTimer();
              cardSwipeControl.swipeRight();
            }
            if (isNo == 4) {
              // Easy
              if (card.cardState == 0) {
                Easy().newCard(card);
              } else if (card.cardState == 1) {
                Easy().graduated(card);
              } else if (card.cardState == 2) {
                Easy().lapsed(card);
              }
              card.setTimer();
              cardSwipeControl.swipeRight();
            }
          },
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(1),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero),
              ),
            ),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 15, horizontal: 0)),
          ),
          child: Text(
            isNo == 3
                ? "Good"
                : isNo == 1
                    ? "Again!"
                    : isNo == 4
                        ? "Easy"
                        : "Hard",
            style: TextStyle(
                color: isNo == 3
                    ? Color.fromARGB(198, 50, 248, 15)
                    : isNo == 1
                        ? Color.fromARGB(197, 245, 22, 22)
                        : isNo == 4
                            ? Colors.blue
                            : Colors.white),
          )),
    );
  }
}
