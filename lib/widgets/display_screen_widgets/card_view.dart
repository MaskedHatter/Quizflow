import 'dart:developer';
import 'dart:io';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizflow/collection_types/flashcard.dart';
import 'package:quizflow/widgets/display_screen_widgets/row_of_buttons.dart';

class CardView extends StatefulWidget {
  final Flashcard card;
  final bool frontSide;
  final CardSwiperController cardSwipeControl;
  final FlipCardController flipController;

  const CardView(
      {super.key,
      required this.card,
      required this.frontSide,
      required this.cardSwipeControl,
      required this.flipController});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List componentDisplay = widget.frontSide
        ? widget.card.cardFrontComponents
        : [
            ...widget.card.cardFrontComponents,
            SizedBox(
              child: Divider(height: 40.h),
            ),
            ...widget.card.cardBackcomponents
          ];

    double bottomTextMargin = widget.frontSide ? 75.h : 120.h;

    return GestureDetector(
      onLongPress: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          content: Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Card Interval: ${widget.card.currentInterval.inMinutes}"),
                SizedBox(height: 15.h),
                Text("Ease Factor: ${widget.card.easeFactor}"),
                SizedBox(height: 15.h),
                Text("Card State: ${widget.card.cardState}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          color: const Color.fromARGB(255, 36, 36, 36),
        ),
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(0, 40.h, 0, 0),
        child: Stack(children: [
          (componentDisplay.any((item) {
            if (item is String) {
              bool img = item.contains("</img/>");
              //item.replaceFirst("</img/>", "");
              return img;
            }
            return false;
          }))
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, bottomTextMargin),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15.r)),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...componentOrganizer(componentDisplay),
                        ],
                      ),
                    ),
                  ),
                )
              : componentDisplay.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(
                          12.w, 12.h, 12.w, bottomTextMargin),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [...displayText(componentDisplay)]),
                      ),
                    )
                  : const SizedBox(),
          RowOfButtons(
              isFront: widget.frontSide,
              flipCardController: widget.flipController,
              cardSwipeControl: widget.cardSwipeControl,
              card: widget.card)
        ]),
      ),
    );
  }
}

displayText(components) {
  if (components is List) {
    return components.map<Widget>((text) {
      //log(text);
      if (text is String) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
              ),
            ),
          ),
        );
      } else {
        return text;
      }
    }).toList();
  } else {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Text(
          components,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17.sp,
          ),
        ),
      ),
    );
  }
}

MaterialStateProperty<Size> buttonSize = MaterialStateProperty.all<Size>(
  Size(400.w, 600.h),
);

List<Widget> componentOrganizer(List components) {
  return components.map((item) {
    if (item is Widget) {
      return item;
    }
    if (item.contains("</img/>")) {
      item = item.replaceFirst("</img/>", "");
      return ClipRRect(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular((components.indexOf(item) == 0) ? 15.r : 0)),
          child: Image(image: FileImage(File(item))));
    } else {
      log(item);
      var value = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 8.w),
        child: displayText(item),
      );
      return value;
    }
  }).toList();
}
