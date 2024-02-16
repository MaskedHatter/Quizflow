import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/provider/add_card_model.dart';
import 'package:quizflow/widgets/add_screen_widgets/input_field.dart';

class AddCard extends StatelessWidget {
  AddCard({super.key});

  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int textFieldLines = (MediaQuery.of(context).size.width ~/ 53); //59
    if (context.read<AddCardModel>().getSelectedDeck == null) {
      return const Center(
        child: Text("No Card Deck", style: TextStyle(fontSize: 30)),
      );
    }
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Text(
                      "Deck",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DropdownMenu(
                      textStyle: const TextStyle(fontSize: 14),
                      onSelected: (deck) {
                        if (deck != null) {
                          context.read<AddCardModel>().selectDeck(deck);
                        }
                      },
                      initialSelection:
                          context.watch<AddCardModel>().getSelectedDeck,
                      width: MediaQuery.of(context).size.width - 50,
                      dropdownMenuEntries: context
                          .watch<AddCardModel>()
                          .deckOptions
                          .map((carddeck) {
                        return DropdownMenuEntry(
                            value: carddeck,
                            label: carddeck.title,
                            style: const ButtonStyle(
                                textStyle: MaterialStatePropertyAll(
                                    TextStyle(fontSize: 16))));
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
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<AddCardModel>()
                        .createCard(context, frontController, backController);
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 40),
                    child: Text("Add"),
                  )),
            )
          ]),
        ),
      ),
    );
  }
}
