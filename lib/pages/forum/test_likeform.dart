import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:navigate/pages/forum/questiondetailpage.dart';
import 'package:navigate/pages/forum/questionpage.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<dynamic> questions = [];
  List<bool> likedStates = []; // Declare the likedStates list

  @override
  void initState() {
    super.initState();
    fetchQuestions().then((data) {
      setState(() {
        questions = data;
        likedStates = List.filled(
            questions.length,     
                false); // Initialize likedStates when questions are fetched
      });
    }).catchError((error) {
      // Handle error
      print('Error: $error');
    });
  }

  // Questions part
  void _goToQuestionPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuestionForm()),
    );
  }

  Future<List<dynamic>> fetchQuestions() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000//questions/:indexNumber/likeCount'));

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

  Future<void> likeQuestion(int index) async {
    final question = questions[index];
    final questionId =
        question['index_number']; // Assuming 'index_number' is the question ID

    final isLiked = question['question_like'] == 1;

    final updatedLikeValue =
        isLiked ? question['question_like'] + 1 : question['question_like'] - 1;

    final response = await http.post(
      Uri.parse(
          'http://localhost:3000/questions/$questionId/like'), // Replace with your API endpoint to handle the like
      body: jsonEncode({
        'question_like': updatedLikeValue
      }), // Pass the updated like value in the request body
      headers: {'Content-Type': 'application/json'},

      // Add any required headers or body parameters for your API
    );

    if (response.statusCode == 200) {
      // Question liked successfully, update UI if needed
      final updatedQuestion = jsonDecode(response.body);
      setState(() {
        questions[index] = updatedQuestion;
      });
    } else {
      // Handle error
      print('Error liking question');
    }
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
          final questionLike = question['question_like'];

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: GestureDetector(
              onTap: () {
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
                ) ; 
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
                child: Column(
                  children: [
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$firstName $lastName',
                          style: const TextStyle(
                              fontSize: 21), // Set the desired font size
                        ),
                      ),
                      subtitle: Text(question['question']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [


                          Text('Likes: $questionLike'),
                          IconButton(
                            icon: Icon(
                              Icons.thumb_up,
                              color: likedStates[index]
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                likedStates[index] = !likedStates[index];
                                likeQuestion(index);
                              });
                            },
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
