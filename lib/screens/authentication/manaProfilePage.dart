import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  bool _setState = true;

  String? selectedIndexCategory = 'Nữ';
  List<String> listOfCategory = ['Nam','Nữ'];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _dayOfBirth = TextEditingController();
  TextEditingController _monthOfBirth = TextEditingController();
  TextEditingController _yearOfBirth = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? dropdownNames;
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
                            backgroundImage: /*widget.user!.avatar! != null ? NetworkImage(widget.user!.avatar) : */NetworkImage(getImageNoAvailableURL),
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
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.all(Radius.circular(20),
                          )
                      ),
                      child: Column(
                        children: [
                          TextFieldBox(title: 'Tên', width: 300, height: 30, controller: _nameController, hintText: 'Nguyễn Thị Thu Thảo'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFieldBox(title: 'ID', width: 120, height: 30, controller: _firstName, hintText: '16'),
                              TextFieldBox(title: 'Store ID', width: 120, height: 30, controller: _lastName, hintText: 'S005'),
                            ],
                          ),
                          InfoField(title: 'Email', des: 'thuhao121401@gmail.com', width: 300, height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFieldBox(title: 'Ngày', width: 70, height: 30, controller: _dayOfBirth, hintText: _dayOfBirth.text),
                              TextFieldBox(title: 'Tháng', width: 70, height: 30, controller: _monthOfBirth, hintText: _monthOfBirth.text),
                              TextFieldBox(title: 'Năm', width: 70, height: 30, controller: _yearOfBirth, hintText: _yearOfBirth.text),
                            ],
                          ),
                          TextFieldBox(title: 'Số điện thoại', width: 300, height: 30, controller: _phoneNumberController, hintText: '0868282998'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileGender(gen: 'Nữ'),
                              const InfoField(title: 'Ngày Đăng Ký', des: '07/08/2023', width: 160, height: 30,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),)
            ],
          ),
        ));
  }
}
