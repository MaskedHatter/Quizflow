import 'dart:developer';
import 'dart:io';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
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
            const SizedBox(
              child: Divider(height: 40),
            ),
            ...widget.card.cardBackcomponents
          ];

    double bottomTextMargin = widget.frontSide ? 75 : 120;

    return GestureDetector(
      onLongPress: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Card Interval: ${widget.card.currentInterval.inMinutes}"),
                const SizedBox(height: 15),
                Text("Ease Factor: ${widget.card.easeFactor}"),
                const SizedBox(height: 15),
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
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromARGB(255, 36, 36, 36),
        ),
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                        const BorderRadius.vertical(top: Radius.circular(15)),
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
                      padding:
                          EdgeInsets.fromLTRB(12, 12, 12, bottomTextMargin),
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
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
        padding: const EdgeInsets.all(8.0),
        child: Text(
          components,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

MaterialStateProperty<Size> buttonSize = MaterialStateProperty.all<Size>(
  const Size(400, 600),
);

List<Widget> componentOrganizer(List components) {
  return components.map((item) {
    if (item is Widget) {
      return item;
    }
    if (item.contains("</img/>")) {
      item = item.replaceFirst("</img/>", "");
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular((components.indexOf(item) == 0) ? 15 : 0)),
            child: Image(image: FileImage(File(item)))),
      );
    } else {
      log(item);
      var value = Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
        child: displayText(item),
      );
      return value;
    }
  }).toList();
}
