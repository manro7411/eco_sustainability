// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:navigate/Navigate/navigation.dart';
import 'package:navigate/pages/Homepage/homepage.dart';

class DetailPage extends StatelessWidget {
  final String item;
  final String item2;
  final String item3;
  final int item4;
  final int item5;
  final String item6;

  DetailPage(
      {required this.item,
      required this.item2,
      required this.item3,
      required this.item4,
      required this.item5,
      required this.item6});

  // Rest of the code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 45,
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: 350,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 128, 203, 196),
                image: DecorationImage(
                  image: NetworkImage(item6),
                  //fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
              top: 45,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BottomNavigationBarExampleApp()),
                      );
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
          Positioned(
            top: 350,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    item,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  //Product Name will be in the middle

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Category: " + (item2 != null ? item2 : ''),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  //Product Description will be in the left side

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Material: " + (item3 != null ? item3 : ''),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Average Price: \$" +
                          (item4 != null ? item4.toString() : ''),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Average Decomposition Time: " +
                          (item5 != null ? item5.toString() : '') +
                          " year(s)",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('Detail Page'),
    //   ),
    //   body: Center(
    //     child: Text(
    //       item,
    //       style: TextStyle(fontSize: 24),
    //     ),
    //   ),
    // );
  }
}
