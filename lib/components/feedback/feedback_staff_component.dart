/*
import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:popup_banner/popup_banner.dart';

import '../../constants/constants.dart';
import '../../models/feedback/feedback_staff.dart';

class FeedbackTab extends StatelessWidget {
  const FeedbackTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          // height: 200,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(feedback.imgurl))),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width - 125,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 145,
                            child: AutoSizeText(
                              feedback.name_creater,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: darkText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ),
                          const Spacer(),
                          for (int i = 0; i < int.parse(feedback.rating); i++)
                            const Icon(Icons.star, color: Colors.yellow),
                          for (int i = 0;
                          i < 5 - int.parse(feedback.rating);
                          i++)
                            const Icon(Icons.star_border_outlined,
                                color: Colors.yellow),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: size.width - 125,
                          child: AutoSizeText(
                            feedback.description.toString().substring(
                                0,
                                (feedback.description.toString().length >= 100)
                                    ? 100
                                    : feedback.description.toString().length),
                            maxLines: 3,
                            style: const TextStyle(
                                color: darkText, fontSize: 17, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    (feedback.listImg!.isEmpty)
                        ? Container()
                        : Container(
                        width: size.width - 125,
                        child: SingleChildScrollView(
                          // shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(children: <Widget>[
                            for (int i = 0;
                            i < feedback.listImg!.length;
                            i++)
                              GestureDetector(
                                onTap: () {
                                  PopupBanner(
                                    fit: BoxFit.cover,
                                    height: size.width,
                                    context: context,
                                    images: [
                                      for (int i = 0;
                                      i < feedback.listImg!.length;
                                      i++)
                                        feedback.listImg![i].url
                                    ],
                                    autoSlide: false,
                                    dotsAlignment: Alignment.bottomCenter,
                                    dotsColorActive: buttonColor,
                                    dotsColorInactive:
                                    Colors.grey.withOpacity(0.5),
                                    onClick: (index) {
                                      debugPrint("CLICKED $index");
                                    },
                                  ).show();
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    height: (size.width / 5) - 20,
                                    width: (size.width / 5) - 20,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              feedback.listImg![i].url)),
                                    )),
                              ),
                          ]),
                        )),
                    Row(
                      children: [
                        Text(
                          feedback.create_date,
                          maxLines: 1,
                          style: const TextStyle(
                              color: darkText,
                              // fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )),
        Center(
          child: Container(
            // margin: const EdgeInsets.all(8),
            height: 1.5,
            width: size.width,
            decoration: const BoxDecoration(color: divince),
          ),
        ),
      ],
    );
  }
}
*/
