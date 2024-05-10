import 'package:flutter/material.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/audio_control.dart';
import 'package:quizflow/viewmodel/selected_deck_model.dart';
import 'package:quizflow/widgets/display_screen_widgets/card_view.dart';
import '../collection_types/flashcard.dart';
//import 'package:animate_do/animate_do.dart';

class DisplayDeck extends StatelessWidget {
  final FlipCardController flipController = FlipCardController();
  final CardSwiperController cardSwiperController = CardSwiperController();

  DisplayDeck({super.key});

  List<Widget> _buildDisplayDeck(List<Flashcard> questions) {
    return questions.map<Widget>((question) {
      return FlipCard(
        //speed: 100,
        //fill: Fill.fillFront,
        //side: CardSide.FRONT,
        flipOnTouch: false,
        controller: flipController,

        front: CardView(
            card: question,
            frontSide: true,
            cardSwipeControl: cardSwiperController,
            flipController: flipController),
        back: CardView(
            card: question,
            frontSide: false,
            cardSwipeControl: cardSwiperController,
            flipController: flipController),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        //context.read<PageModel>().changePageIndex(0);
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
            )),
        body: Stack(
          children: [
            CardSwiper(
                //isLoop: false,
                threshold: 90,
                initialIndex: context.watch<SelectedDeck>().currentIndex,
                // allowedSwipeDirection:
                //     AllowedSwipeDirection.only(left: true, right: true),
                controller: cardSwiperController,
                duration: const Duration(milliseconds: 600),
                numberOfCardsDisplayed:
                    context.watch<SelectedDeck>().noOfQuestions == 1 ? 1 : 2,
                padding: EdgeInsets.fromLTRB(17.w, 21.h, 17.w, 17.h),
                backCardOffset: Offset.zero,
                onSwipe: (previousIndex, currentIndex, direction) {
                  if (!flipController.state!.isFront) {
                    flipController.toggleCardWithoutAnimation();
                  }
                  if (direction == CardSwiperDirection.right) {
                    playGoodSound();
                    context.read<SelectedDeck>().changeCorrectNo();
                  }
                  if (direction == CardSwiperDirection.left) {
                    playGoodSound();
                    context.read<SelectedDeck>().changeWrongNo();
                  }
                  context.read<SelectedDeck>().setCurrentIndex(currentIndex!);
                  return true;
                },
                scale: 0,
                cardsCount: context.watch<SelectedDeck>().noOfQuestions,
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) {
                  return _buildDisplayDeck(
                      context.watch<SelectedDeck>().selectedDeckCards)[index];
                }),
            Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.fromLTRB(0, 20.h, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check),
                        Text(
                          "   ${context.watch<SelectedDeck>().selectedDeck.noOfQuestionsCorrect}",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.close),
                        Text(
                          "   ${context.watch<SelectedDeck>().selectedDeck.noOfQuestionsWrong}",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.copy_all_rounded),
                        Text(
                          "   ${context.watch<SelectedDeck>().selectedDeck.noOfQuestions}",
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
