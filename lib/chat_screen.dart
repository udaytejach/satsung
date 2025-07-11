import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror/sidemenu/custom_appbar.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, String>> messages = [
    {"sender": "mirror", "text": "Hello! How can I assist you today?"},
    {"sender": "user", "text": "Hi, Mirror!"},
  ];

  TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) {
    setState(() {
      messages.add({"sender": "user", "text": text});
      messages.add({
        "sender": "mirror",
        "text": "Got it! Let me help."
      }); // Example response
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff345998),
      appBar: const CustomAppbar(title: 'Lets Reflect'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/bg_one.jpeg"), // Replace with your image path
            fit: BoxFit.cover, // Adjust as needed
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message["sender"] == "user";

                  return Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isUser) // Display Mirror's icon on the left
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                AssetImage("assets/satsunglogo.png"),
                          ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color:
                                isUser ? Colors.blue[100] : Colors.green[100],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: isUser
                                  ? Radius.circular(10)
                                  : Radius.circular(0),
                              bottomRight: isUser
                                  ? Radius.circular(0)
                                  : Radius.circular(10),
                            ),
                          ),
                          child: Text(message["text"]!,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                fontFamily: 'poppins',
                                color: Colors.black,
                                fontSize: 14,
                                // fontWeight: fontWeight,
                              ))),
                        ),
                        if (isUser) // Display user's icon on the right
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 18,
                                // backgroundColor: Colors.blu,
                                child: ClipRect(
                                    child: Center(
                                        child: Text('U',
                                            textAlign: TextAlign.center))),
                              ),
                            ],
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textAlignVertical: TextAlignVertical.center,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Ask True Mirror",
                        labelText: "Ask True Mirror",
                        labelStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        hintStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.fromLTRB(12, 12, 10, 15),
                          child: Icon(Icons.question_answer,
                              size: 22, color: Colors.white),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(12, 12, 10, 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xff4e77ba))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xff4e77ba))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xff4e77ba))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xff4e77ba))),
                      ),
                    ),

                    // TextField(
                    //   controller: _controller,
                    //   decoration: InputDecoration(hintText: "Ask True Mirror"),
                    // ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _sendMessage(_controller.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
