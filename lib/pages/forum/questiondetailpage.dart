// ignore_for_file: prefer_const_constructorsbutton

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionDetailsPage extends StatefulWidget {
  final Map<String, dynamic> question;
  final int indexNumber;
  final String? firstName;
  final String? lastName;

  const QuestionDetailsPage({
    Key? key,
    required this.question,
    required this.indexNumber,
    this.firstName,
    this.lastName,
  }) : super(key: key);

  @override
  _QuestionDetailsPageState createState() => _QuestionDetailsPageState();
}

class _QuestionDetailsPageState extends State<QuestionDetailsPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  String _firstName = '';
  String _lastName = '';
  List<Map<String, dynamic>> filedata = [];

  void _add() async {
    final String comment = _commentController.text;
    final String index = widget.indexNumber.toString();

    final Map<String, dynamic> data = {
      'comment': comment,
      'index': index,
      'firstName': _firstName,
      'lastName': _lastName,
    };

    final Uri uri = Uri.parse('http://10.0.2.2:3000/comments');
    final http.Response response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Registration successful
      print('Upload successful');
      _fetchComments();
    } else {
      // Registration failed
      print('Upload failed');
    }
  }

  Future<String?> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('token');
    return stringValue;
  }

  Future<void> _getFirstNameAndLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firstName = prefs.getString('firstName');
    String? lastName = prefs.getString('lastName');

    setState(() {
      _firstName = firstName ?? '';
      _lastName = lastName ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _getFirstNameAndLastName();
    _fetchComments();
  }

  Future<List<Map<String, dynamic>>> fetchComments(int indexNumber) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/comments/$indexNumber'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      final List<Map<String, dynamic>> comments = List.from(responseData);
      return comments;
    } else {
      throw Exception('Failed to fetch comments');
    }
  }

  Future<void> _fetchComments() async {
    try {
      final comments = await fetchComments(widget.indexNumber);
      setState(() {
        filedata = comments;
      });
    } catch (error) {
      print('Error fetching comments: $error');
    }
  }
var interactions = Container(
        padding: const EdgeInsets.fromLTRB(6, 34, 16, 32),
        child: Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    ),
                    Text("10 likes")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: VerticalDivider(
                  color: Color.fromARGB(255, 221, 221, 221),
                  thickness: 3,
                  width: 10,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 3, 3, 2),
                    child: Icon(
                      Icons.comment,
                      color: Color.fromARGB(255, 244, 156, 5),
                    ),
                  ),
                  Text("20 comments")
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: VerticalDivider(
                  color: Color.fromARGB(255, 209, 209, 209),
                  thickness: 3,
                  width: 10,
                ),
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 3, 3, 2),
                    child: Icon(
                      Icons.remove_red_eye_sharp,
                      color: Color.fromARGB(255, 30, 164, 110),
                    ),
                  ),
                  Text("30 views")
                ],
              )
            ],
          ),
        ));
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal[200],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Color.fromARGB(255, 255, 255, 255),
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 5,
                                        5), // Adjust the padding values as needed
                                    child: Icon(
                                      Icons.close,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  )),
                            ),
                          ),
                          Text(
                            'Author: ${widget.firstName} ${widget.lastName}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Question: ${widget.question['question']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          interactions,
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.teal[200],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              height: 50,
                              width: 220,
                              child: Center(
                                child: Text(
                                  'COMMENT SECTION!',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 290, 0, 0),
                      child: CommentBox(
                        userImage: CommentBox.commentImageParser(
                          imageURLorPath: "assets/images/userpic.png",
                        ),
                        child: commentChild(),
                        labelText: 'Write a comment...',
                        errorText: 'Comment cannot be blank',
                        withBorder: false,
                        sendButtonMethod: () async {
                          if (formKey.currentState!.validate()) {
                            final stringValue = await getStringValuesSF();
                            if (stringValue != null) {
                              setState(() {
                                _add();
                              });
                              _commentController.clear();
                              FocusScope.of(context).unfocus();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'Please log in before posting a comment.'),
                                    actions: [
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        formKey: formKey,
                        commentController: _commentController,
                        backgroundColor: Colors.pink,
                        textColor: const Color.fromARGB(255, 0, 0, 0),
                        sendWidget: Icon(Icons.send_sharp,
                            size: 30, color: Colors.teal[200]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget commentChild() {
    return ListView.builder(
      itemCount: filedata.length,
      itemBuilder: (context, index) {
        final comment = filedata[index]['comments'] ?? 'rr';
        final firstname = filedata[index]['firstname'] ?? 'rr';
        final lastname = filedata[index]['lastname'] ?? 'rr';

        return Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/userpic.png'),
            ),
            title: Text(
              '$firstname $lastname',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            subtitle: Text(comment),
            trailing: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite,
                size: 16,
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}
