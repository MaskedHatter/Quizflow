part of 'package:quizflow/viewmodel/root_folder_viewmodel.dart';

extension DialogueService on RootFolderViewModel {
  Future<String?> showDeckNameDialogue(
      GlobalKey widgetKey, TextEditingController controller) {
    BuildContext context = widgetKey.currentContext!;
    return showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("New Deck"),
              content: TextField(
                autofocus: true,
                controller: controller,
                decoration: const InputDecoration(hintText: "Enter Name"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(controller.text);
                      controller.clear();
                    },
                    child: const Text("Submit"))
              ],
            ));
  }

  Future<void> showTypeDialogue(
      bool root, GlobalKey widgetKey, TextEditingController controller,
      [parentFolder]) async {
    BuildContext context = widgetKey.currentContext!;
    rootOptions(root) {
      Widget option = root
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 3);
                },
                child: const Text('Import Deck'),
              ),
            )
          : Container();
      return option;
    }

    switch (await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text("Add What?"),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 1);
                    },
                    child: const Text('Card'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 2);
                    },
                    child: const Text('Subdeck'),
                  ),
                ),
                rootOptions(root)
              ],
            ))) {
      case 1:
        if (parentFolder == null) {
          addCollectionToCollectionRoot(widgetKey, controller, false);
          break;
        }
        addCollectionToCollectionSubcollection(
            parentFolder, widgetKey, controller, false);
        break;
      case 2:
        if (parentFolder == null) {
          addCollectionToCollectionRoot(widgetKey, controller, true);
          break;
        }
        addCollectionToCollectionSubcollection(
            parentFolder, widgetKey, controller, true);
        break;
      case 3:
        importFile();
        break;
      case null:
        break;
    }
  }
}
