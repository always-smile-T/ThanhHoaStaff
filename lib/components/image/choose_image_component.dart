import 'package:flutter/material.dart';

import '../../constants/constants.dart';


class ChooseImageComponent extends StatefulWidget {
  const ChooseImageComponent({Key? key, required this.image, required this.listIMG}) : super(key: key);
  final image;
  final listIMG;

  @override
  State<ChooseImageComponent> createState() => _ChooseImageComponentState();
}

class _ChooseImageComponentState extends State<ChooseImageComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: Stack(
        children: [
          Center(
            child: Container(
                decoration: BoxDecoration(
                  //shape: BoxShape.circle,
                    border: Border.all(
                        width: 3, color: Colors.white)),
                width: 120,
                height: 120,
                child: Image.network(widget.image.toString(), fit: BoxFit.fill,)
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: (){
                  setState(() {
                    widget.listIMG[0].clear();
                  });
                },
                icon: Icon(Icons.cancel, color: buttonColor, size: 30,),
              ))
        ],
      ),
    );
  }
}
