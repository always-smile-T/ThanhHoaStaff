import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thanhhoa_garden_staff_app/components/button/dialog_button.dart';
import '../../components/profile/genderField.dart';
import '../../components/profile/infoField.dart';
import '../../components/profile/textField.dart';
import '../../constants/constants.dart';
import '../../models/authentication/user.dart';
import '../../utils/connection/utilsConnection.dart';


class ManagerProfileScreen extends StatefulWidget {
   ManagerProfileScreen({super.key, required this.user});
  User? user;

  @override
  _ManagerProfileScreenState createState() => _ManagerProfileScreenState();
}

class _ManagerProfileScreenState extends State<ManagerProfileScreen>
    with SingleTickerProviderStateMixin {
  bool COD = true;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
       COD = widget.user!.gender;
       _nameController = TextEditingController(text : widget.user!.fullName);
       _phoneNumberController = TextEditingController(text : widget.user!.phone);
       _addressController = TextEditingController(text : widget.user!.address);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 200,
                  color: barColor,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 35, 16, 0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back)
                            ),
                            const Text('Quản lý tài khoản', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                            const SizedBox(width: 35,)
                          ],
                        ),
                      ),
                      Positioned(
                        top: 108,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 3, color: Colors.white)),
                          width: 138,
                          height: 138,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: widget.user!.avatar! != null ? NetworkImage(widget.user!.avatar) : NetworkImage(getImageNoAvailableURL),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 80,
              ),
              Padding(padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [Text('Thông tin cá nhân', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),],
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                     // height: 400,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.all(Radius.circular(20),
                          )
                      ),
                      child: Column(
                        children: [
                          TextFieldBox(title: 'Tên', width: 300, height: 30, controller: _nameController, hintText: 'Nguyễn Thị Thu Thảo', readOnly: true,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InfoField(title: 'ID', des: widget.user!.userID.toString(), width: 120, height: 30,),
                              InfoField(title: 'Username', des: widget.user!.username, width: 120, height: 30,),
                            ],
                          ),
                          InfoField(title: 'Email', des: widget.user!.email, width: 300, height: 30,),
                          TextFieldBox(title: 'Số điện thoại', width: 300, height: 30, controller: _phoneNumberController, hintText: 'Nhập số điện thoại', readOnly: true),
                         TextFieldBox(title: 'Địa chỉ', width: 300, height: 30, controller: _addressController, hintText: 'Nhập địa chỉ', readOnly: false),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.resolveWith(getColor),
                                    value: COD,
                                    onChanged: (value) {
                                      setState(() {
                                        COD = value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text('Nam')
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.resolveWith(getColor),
                                    value: !COD,
                                    onChanged: (value) {
                                      setState(() {
                                        COD = !value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text('Nữ')
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConfirmButton(title: 'Lưu', width: 100.0),
                  const SizedBox(width: 40,)
                ],
              ),
              const SizedBox(height: 30,)
            ],
          ),
        ));
  }
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return buttonColor;
  }
}
