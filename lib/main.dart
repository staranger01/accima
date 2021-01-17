/// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bubble/bubble.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Chat',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Color(0xfff2f5f7);
    return Scaffold(

      appBar: PreferredSize(
          preferredSize: Size.fromHeight(175.0), // here the desired height
          child: AppBar(
            flexibleSpace: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 30, left: 20),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/disney-2.png',
                              height: 150,
                              width: 150,
                            ),
                          )),
                      SizedBox(height: 50),
                      Text("Hi there!",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black, letterSpacing: .5),
                              color: Color(0xff59595a),
                              fontSize: 19)),
                      Expanded(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "Welcome to Disney, how can we help you today?",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14))))),
                    ])),
            backgroundColor: mainColor,

            // ...
          )),
      body:  Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 40, left:15),
          child: CircleAvatar( radius: 40.0,  backgroundImage: AssetImage('assets/girl.jpg', )),

        ),  Bubble(

          color: Color.fromARGB(255, 212, 234, 244),

          margin: BubbleEdges.only(top: 8.0),
          child: Text('TODAY', style: TextStyle(fontSize: 10)),
        ),
        Bubble(
          margin: BubbleEdges.only(top: 20),
          child: Text('Hi Anna Hustle! We got your video resume and wanted to talk to you more, do you have availability this week for a chat?'),
        ),
        Bubble(
          margin: BubbleEdges.only(top: 20, left: 40),
          alignment: Alignment.topRight,
          nip: BubbleNip.rightTop,
          color: Color.fromRGBO(225, 255, 199, 1.0),
          child: Text('Hi Sarah, Thank you so much for getting back to me! My availability dates/times are: Monday - Wednesday: After 6pm EST. Friday: After 5PM EST.', textAlign: TextAlign.right),
        ),
        Bubble(
          margin: BubbleEdges.only(top: 20),
          child: Text('Anna, we have availability on Friday at 5:30pm for an initial interview over video call. It will last approximately an hour. Please let me know if you have anymore questions, hope you have a good afternoon! ', textAlign: TextAlign.right),
        ),

        Container(

            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,

              border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),

          )
        )

      ]),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
