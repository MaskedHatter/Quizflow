import 'package:animate_do/animate_do.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/collection_types/folder.dart';
import 'package:quizflow/provider/root_folder_model.dart';

class FolderTile extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final TextEditingController textController;
  final Folder item;
  final Function buildListItems;
  const FolderTile(
      {super.key,
      required this.scaffoldKey,
      required this.textController,
      required this.item,
      required this.buildListItems});

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool deleteMode = false;

  UniqueKey cardKey = UniqueKey();
  @override
  void initState() {
    super.initState();
    //animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (deleteMode == false) {
          animationController.forward();
          setState(() {
            deleteMode = true;
          });
        } else {
          animationController.reverse();
          setState(() {
            deleteMode = false;
          });
        }
      },
      child: Column(
        children: [
          ExpansionTileCard(
            baseColor: widget.item.getFolderColor(),
            expandedColor: widget.item
                .getFolderColor(), //Color.fromARGB(255 - i * 5, 83 - i, 80 - i, 164 - i),
            expandedTextColor: Colors.white,
            elevation: 0,
            animateTrailing: true,
            initiallyExpanded: widget.item.isExpanded,

            onExpansionChanged: (bool expanded) {
              context
                  .read<RootFolder>()
                  .setExpansionforFolder(widget.item, expanded);
            },
            leading: Padding(
              padding: EdgeInsets.fromLTRB(
                  0 + (10 * widget.item.folderLevel), 0, 0, 0),
              child: widget.item.isExpanded
                  ? const Icon(Icons.keyboard_arrow_down_rounded)
                  : const Icon(Icons.keyboard_arrow_right_rounded),
            ),
            trailing: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(35.0, 35.0),
                  ),
                ),
                onPressed: () {
                  if (deleteMode) {
                    context.read<RootFolder>().removeItem(widget.item);
                    // setState(() {
                    //   deleteMode = false;
                    // });
                  } else {
                    context.read<RootFolder>().showTypeDialogue(false,
                        widget.scaffoldKey, widget.textController, widget.item);
                  }
                },
                onLongPress: () {
                  //_controller.repeat();
                },
                child: Spin(
                    manualTrigger: true,
                    duration: Duration(milliseconds: 600),
                    spins: 0.625,
                    delay: Duration(milliseconds: 300),
                    controller: (controller) {
                      animationController = controller;
                    },
                    child: Icon(
                      Icons.add,
                      color: deleteMode ? Colors.red : null,
                    ))),
            title: Text(widget.item.title),
            //controlAffinity: ListTileControlAffinity.leading,
            children: <Widget>[
              ...widget.buildListItems(context, widget.item.subItems),
              const SizedBox(
                height: 10,
                // child: Divider(
                //   thickness: 3,
                // ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
            // child: Divider(
            //   thickness: 3,
            // ),
          )
        ],
      ),
    );
  }
}
