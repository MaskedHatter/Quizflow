// import 'package:flutter/material.dart';
// import 'expandable_ListScreen.dart';
// import 'list_item.dart';

// void main() {
//   List<ListItem> rootFolders = [
//     ListItem(
//       title: 'Folder 1',
//       folderLevel: 0,
//       isFolder: true,
//       subItems: [
//         ListItem(
//           title: 'Subfolder 1.1',
//           folderLevel: 1,
//           isFolder: true,
//           subItems: [
//             ListItem(
//                 title: 'Item 1.1.1',
//                 folderLevel: 2,
//                 isFolder: false,
//                 subItems: []),
//             ListItem(
//                 title: 'Item 1.1.2',
//                 folderLevel: 2,
//                 isFolder: false,
//                 subItems: []),
//           ],
//         ),
//       ],
//     ),
//   ];

//   runApp(MyApp(rootFolders: rootFolders));
// }

// class MyApp extends StatelessWidget {
//   final List<ListItem> rootFolders;

//   const MyApp({required this.rootFolders});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: ExpandableListScreen(rootFolders: rootFolders),
//     );
//   }
// }
