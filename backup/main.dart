import 'package:flutter/material.dart';
//import 'deck.dart';
//import 'draw_deck.dart';
//import 'package:blur/blur.dart';

var deckRam = {};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //showDeckNameDialogue
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Homepage(),
    );
  }
}

//HOMEPAGE STATEFUL WIDGET
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

//HOMEPAGE STATE
// contains
class _HomepageState extends State<Homepage> {
  List dashBoard = [];

  //EXTRACTION OF TEXT FROM DIALOGUE
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  //SHOWS THE DIALOGUE FOR GIVING DECKS NAMES
  Future<String?> showDeckNameDialogue(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("New Deck"),
              content: TextField(
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(hintText: "Enter Name"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(_controller.text);
                      _controller.clear();
                    },
                    child: const Text("Submit"))
              ],
            ));
  }

  //DRAWS THE DECKS
  Widget drawItems(List dashBoard) {
    if (dashBoard.isEmpty) {
      return const Center(
          child: Text("add card",
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 18,
              )));
    }
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
            onPressed: () => {
              setState(() {
                dashBoard.replaceRange(
                    0, dashBoard.length, deckRam[deckRam.keys.toList()[index]]);
                print(dashBoard);
              })
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 0, 0, 0), //Color.fromARGB(255, 57, 57, 57),
                  border: BorderDirectional(
                      bottom: BorderSide(
                          color: Color.fromARGB(32, 255, 255, 255)))),
              height: 70,
              width: 400,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              padding: const EdgeInsets.all(12),
              child: Text(
                dashBoard[index],
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 1,
            child: Divider(color: Color.fromARGB(32, 255, 255, 255))),
        itemCount: dashBoard.length);
  }

  // HOMEPAGE BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("QuizFlow",
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: "Exo",
                color: Color.fromARGB(255, 255, 255, 255),
              )),
          backgroundColor: Colors.black,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 15, 15, 15),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                child: Row(
                  children: [
                    Text("Desk",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "Exo",
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
              //width: 100,
              child: Divider(
                color: Colors.white,
              ),
            ),
            Expanded(child: drawItems(dashBoard)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final name = await showDeckNameDialogue(context);

            setState(() {
              dashBoard.add(name);
              deckRam[name] = [];
              print("Debug Log${dashBoard.join(",")}");
            });
          },
          backgroundColor: Colors.grey[900],
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/*

              Blur(
                blur: 2.5,
                blurColor: Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 104, 104, 104),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                  ),
                  height: 250,
                  width: 180,
                  child: FloatingActionButton(
                    onPressed: (() => print('hey')),
                    child: Text("+"),
                    ),
                  //margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                  //color: Colors.green,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                ),
                height: 250,
                width: 180,
                //margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                //color: Colors.green,
              ),

 */

/*

ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.black),
      ),
      onPressed: () => {},
      onLongPress: () async {
        final name = await showDeckNameDialogue(context);
        setState(() {
          print(name);
          print(dashBoard);
          Deck newDeck = Deck(deck.deckName, name);
          deck.addSubDeck(newDeck);
          //dashBoard.add(drawDeck(newDeck));
        });
      },
      child: Column(
        children: [
          
        ],
      ),
    );


onPressed: () => {},
            onLongPress: () async {
              final name = await showDeckNameDialogue(context); //
              setState(() {
                print(name);
                print(dashBoard);
                //dashBoard.add(Deck("", name));
                dashBoard[index].addSubDeck(Deck("", name));
              });
            },

            
*/ 


/* 

ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
            onPressed: () => {},
            onLongPress: () async {
              final name = await showDeckNameDialogue(context); //
              setState(() {
                print(name);
                print(dashBoard);
                //dashBoard.add(Deck("", name));
                dashBoard[index].addSubDeck(Deck("", name));
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 0, 0, 0), //Color.fromARGB(255, 57, 57, 57),
                  border: BorderDirectional(
                      bottom: BorderSide(
                          color: Color.fromARGB(32, 255, 255, 255)))),
              //height: 170,
              width: 400,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 8, 8, 8),
                child: ExpansionTile(
                  title: Text(
                    dashBoard[index].deckName,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  children: [
                    //drawDeck([...dashBoard[index].subDecks])
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(height: 1, child: const Divider(color: Colors.white)),
        itemCount: dashBoard.length);

*/