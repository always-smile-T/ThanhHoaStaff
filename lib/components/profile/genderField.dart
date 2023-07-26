import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';
class ProfileGender extends StatefulWidget {
  ProfileGender({Key? key, required this.gen}) : super(key: key);
  String gen;

  @override
  State<ProfileGender> createState() => _ProfileGenderState();
}



List<String> listOfCategory = ['Nam','Nữ'];
String selectedIndexCategory = 'Nam';

class _ProfileGenderState extends State<ProfileGender> {

  @override
  Widget build(BuildContext context) {
    String selectedIndexCategory = widget.gen;
    return Column(
      children: [
        Container(
            height: 30,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
            alignment: Alignment.bottomLeft,
            child: Text('Giới tính', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),textAlign: TextAlign.start,)
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            height: 30,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
            ),
            child: DropdownButton(
              isExpanded: true,
              dropdownColor: Colors.white,
              value: selectedIndexCategory,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              underline: SizedBox.shrink(),
              onChanged: (dynamic newValue) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('gender', newValue.toString());
                setState(() {
                  selectedIndexCategory = newValue;
                });
              },
              items: listOfCategory.map((category) {
                return DropdownMenuItem(
                  child: Text(category),
                  value: category,
                );
              }).toList(),
            )),
      ],
    );
  }
}
