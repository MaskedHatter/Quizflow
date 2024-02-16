import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizflow/provider/add_card_model.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.context,
    required this.label,
    required this.controller,
    required this.lines,
  });

  final BuildContext context;
  final String label;
  final TextEditingController controller;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context.read<AddCardModel>().importImage(controller);
                    },
                    icon: const Icon(
                      Icons.image_outlined,
                      size: 26,
                    ))
              ],
            ),
          ),
          TextField(
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 14),
            minLines: lines,
            maxLines: 100,
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Type here',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0.0),
                ),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
