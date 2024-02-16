import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/collection_types/card_deck.dart';
import 'package:quizflow/provider/selected_deck_model.dart';

class CarddeckTile extends StatelessWidget {
  final Carddeck? item;
  final int noOfQuestions;
  const CarddeckTile(
      {super.key, required this.item, required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            onTap: () {
              if (item is Carddeck) {
                if (item!.flashcards!.isNotEmpty) {
                  context.read<SelectedDeck>().selectDeck(item!);
                  Navigator.of(context).pushNamed('/DisplayCards');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DisplayDeck()),
                  // );
                  // context.read<PageModel>().changePageIndex(1);
                } else {}
              }
            },
            onLongPress: () {},
            leading: const Icon(Icons.flip_to_front, size: 22),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(item!.title),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("$noOfQuestions")]),
            ),
            isThreeLine: true,
          ),
        ),
        const SizedBox(height: 12)
      ],
    );
  }
}
