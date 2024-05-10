import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/viewmodel/add_card_model.dart';
import 'package:quizflow/widgets/add_screen_widgets/input_field.dart';

class AddCard extends StatelessWidget {
  AddCard({super.key});

  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int textFieldLines = 1.sh ~/ (1.sh * 0.15); //59
    if (context.read<AddCardModel>().getSelectedDeck == null) {
      return Center(
        child: Text("No Card Deck", style: TextStyle(fontSize: 30.sp)),
      );
    }
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 15.w, 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                    child: Text(
                      "Deck",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  DropdownMenu(
                      textStyle: TextStyle(fontSize: 14.sp),
                      onSelected: (deck) {
                        if (deck != null) {
                          context.read<AddCardModel>().selectDeck(deck);
                        }
                      },
                      initialSelection:
                          context.watch<AddCardModel>().getSelectedDeck,
                      width: 1.sw - 50,
                      dropdownMenuEntries: context
                          .watch<AddCardModel>()
                          .deckOptions
                          .map((carddeck) {
                        return DropdownMenuEntry(
                            value: carddeck,
                            label: carddeck.title,
                            style: ButtonStyle(
                                textStyle: MaterialStatePropertyAll(
                                    TextStyle(fontSize: 16.sp))));
                      }).toList()),
                ],
              ),
            ),
            InputField(
                context: context,
                label: "Front",
                controller: frontController,
                lines: textFieldLines),
            InputField(
                context: context,
                label: "Back",
                controller: backController,
                lines: textFieldLines),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
              child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<AddCardModel>()
                        .createCard(context, frontController, backController);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0.h, horizontal: 40.w),
                    child: const Text("Add"),
                  )),
            )
          ]),
        ),
      ),
    );
  }
}
