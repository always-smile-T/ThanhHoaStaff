import 'package:flutter/material.dart';

class TextFieldBox extends StatelessWidget {
  final String title, hintText;
  final TextEditingController controller;
  final Function? customFunction;
  final double height, width;
  final readOnly;

  const TextFieldBox({Key? key, required this.title, this.customFunction, required this.width, required this.height, required this.controller, required this.hintText, required this.readOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 30,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
            alignment: Alignment.bottomLeft,
            child: Text(title, style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),textAlign: TextAlign.start,)
        ),
        Row(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
               // height: height,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                child: TextField(
                  autofocus: false,
                  readOnly: readOnly,
                  textAlignVertical: TextAlignVertical.bottom,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black),
                  controller: controller,
                  decoration: InputDecoration(

                    border: const  OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: hintText,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
            ),
          ],
        ),
      ],
    );
  }
}