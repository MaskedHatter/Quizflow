import 'package:animate_do/animate_do.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/collection_types/folder.dart';
import 'package:quizflow/viewmodel/root_folder_viewmodel.dart';

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
                  .read<RootFolderViewModel>()
                  .setExpansionforFolder(widget.item, expanded);
            },
            leading: Padding(
              padding: EdgeInsets.fromLTRB(
                  0 + (10.w * widget.item.folderLevel), 0, 0, 0),
              child: widget.item.isExpanded
                  ? const Icon(Icons.keyboard_arrow_down_rounded)
                  : const Icon(Icons.keyboard_arrow_right_rounded),
            ),
            trailing: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(31.0.w, 33.0.h),
                  ),
                ),
                onPressed: () {
                  if (deleteMode) {
                    context.read<RootFolderViewModel>().removeItem(widget.item);
                    // setState(() {
                    //   deleteMode = false;
                    // });
                  } else {
                    context.read<RootFolderViewModel>().showTypeDialogue(false,
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
              SizedBox(
                height: 10.h,
                // child: Divider(
                //   thickness: 3,
                // ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
            // child: Divider(
            //   thickness: 3,
            // ),
          )
        ],
      ),
    );
  }
}
