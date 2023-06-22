import 'package:comment_box/comment/test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navigate/pages/forum/questiondetailpage.dart';
import 'dart:convert';

import 'package:navigate/pages/forum/questionpage.dart';
import 'package:navigate/pages/forum/test_com.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<dynamic> questions = [];
  List<dynamic> number = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions().then((data) {
      setState(() {
        questions = data;
      });
    }).catchError((error) {
      // Handle error
      print('Error: $error');
    });
  }

  void _goToQuestionPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuestionForm()),
    );
  }

  Future<List<dynamic>> fetchQuestions() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/questions'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  Future<String?> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Return String
    String? stringValue = prefs.getString('token');
    return stringValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(184, 5, 185, 173),
                Color.fromARGB(255, 255, 255, 255),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          FutureBuilder<String?>(
            future: getStringValuesSF(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Column(
                  children: [
                    IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _goToQuestionPage(context);
                      },
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final firstName = question['firstName'];
          final lastName = question['lastName'];
          final indexNumber = question['index_number'];

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: GestureDetector(
              onTap: () {
                // print('Selected question index: $index');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionDetailsPage(
                      question: question,
                      firstName: firstName,
                      lastName: lastName,
                      indexNumber: indexNumber,
                    ),
                  ),
                );
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$firstName $lastName',
                      style:
                          TextStyle(fontSize: 20), // Set the desired font size
                    ),
                  ),
                  subtitle: Text(question['question']),
                  // trailing: Text('Index: $indexNumber'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
