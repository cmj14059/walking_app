import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'main.dart';

//void main() {
  //runApp(const MyApp());
//}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Walking App 頑張るぞぉ",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'walking_app 頑張るそ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text("Walking App fight!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: const [
                Align(
                  alignment: Alignment(0,0),
                  child: Icon(
                    Icons.circle,
                    size: 300,
                    color: Colors.orange,
                  ),
                ),
                Align(
                  alignment: Alignment(0,0),
                  child: Text(
                    "2",
                    style: TextStyle(
                      fontSize: 200,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              //color: Colors.white,
              child: const Text('I am Takumi Koide',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),

            Container(
              //color: Colors.white,
              child: const Text(
                'make page1, use Stack and Align, BottomNavigationBar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  //unnko
                },
                child: const Text(
                    'うんこ',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            activeIcon: Icon(Icons.book_online),
            label: 'Book',
            tooltip: "This is a Book Page",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            activeIcon: Icon(Icons.business_center),
            label: 'Business',
            tooltip: "This is a Business Page",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            activeIcon: Icon(Icons.school_outlined),
            label: 'School',
            tooltip: "This is a School Page",
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
