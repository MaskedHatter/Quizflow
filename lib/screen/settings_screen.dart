import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});
  final double verticalSpace = 40;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Settings"),
            ),
            bottom: const TabBar(tabs: [
              Tab(
                child: Text("New Cards"),
              ),
              Tab(
                child: Text("Reviews"),
              ),
              Tab(
                child: Text("Lapses"),
              ),
              // Tab(
              //   child: Text("Reviewer"),
              // )
            ]),
          ),
          body: TabBarView(children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  settingOption("Steps  (mins)", "1 10"),
                  settingOption("New cards/day", "9999"),
                  settingOption("Graduating Interval  (days)", "1"),
                  settingOption("Easy Interval  (days)", "4"),
                  settingOption("Starting Ease%", "250"),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  settingOption("Max Reviews per Day", "100"),
                  settingOption("Interval Modifier", "1"),
                  settingOption("Easy Bonus", "140"),
                  settingOption("Maximum Interval", "365"),
                  settingOption("Hard Interval", "120"),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  settingOption("Steps  (mins)", "20 1440"),
                  settingOption("New Interval (%)", "10"),
                  settingOption("Minimum Interval  (days)", "3"),
                  settingOption("Leech threshold  (lapses)", "8"),
                ],
              ),
            )
          ]),
        ));
  }
}

Widget settingOption(String label, String defaultValue) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
    child: Column(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // ignore: avoid_unnecessary_containers
          Container(
            child: TextField(
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: defaultValue,
                border: const OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 0.3,
                  ),
                ),
              ),
            ),
          )
        ]),
      ],
    ),
  );
}
