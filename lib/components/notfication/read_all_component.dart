


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../providers/notification/notification_provider.dart';

class ReadALlComponent extends StatefulWidget {
  const ReadALlComponent({Key? key, required this.title}) : super(key: key);
  final title;

  @override
  State<ReadALlComponent> createState() => _ReadALlComponentState();
}

class _ReadALlComponentState extends State<ReadALlComponent> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: (){
          setState(() {
            readAllNoty();
          });
        },
        child: Container(
          height: 35,
          width: 140,
          decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(45)
          ),
          child: Center(child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.checklist_sharp, color: Colors.white,),
              const SizedBox(width: 5,),
              Text(widget.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),),
            ],
          )),
        ));
  }
}
