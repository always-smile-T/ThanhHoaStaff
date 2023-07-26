import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  final String title, des;
  final Function? customFunction;
  final double height, width;

  const InfoField({Key? key, required this.title, required this.des, this.customFunction, required this.width, required this.height})
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
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: Colors.black26,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10,),
              Text(des, style: const TextStyle(
                fontSize: 12, color: Colors.black,))
            ],
          ),)
      ],
    );
  }
}
