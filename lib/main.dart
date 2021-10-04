import 'dart:convert';
import 'dart:math';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giphy_client/giphy_client.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyTriviaApp(),
      theme: ThemeData(
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: Colors.white,
          canvasColor: Colors.transparent),
    ));

class MyTriviaApp extends StatefulWidget {
  @override
  _MyTriviaAppState createState() => _MyTriviaAppState();
}

class _MyTriviaAppState extends State<MyTriviaApp> {
  TextEditingController _MytextController = TextEditingController();
  String query_val;
  int num;

  Future _fetchJson(BuildContext context) async {
    num = query_val == null ? Random().nextInt(100) : int.parse(query_val);
    final client = GiphyClient(apiKey: 'API_KEY');
    var url = 'http://numbersapi.com/$num?json';
    final a = await client.random(tag: 'amazed');
    print(a);
    final gif_id = a.id;
    var json_data = await http.get(url);
    var trivia_data = jsonDecode(json_data.body);
    var img_url = "https://media.giphy.com/media/$gif_id/giphy.gif";
    _showModulSheet(context, trivia_data['text'], img_url);
  }

  _showModulSheet(context, String text, String gif) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0))),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fact about $num',
                    style: TextStyle(fontSize: 30.0, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '$text',
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        decoration: BoxDecoration(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: Image(
                            height: 150.0,
                            image: NetworkImage(gif),
                          ),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000051),
        elevation: 0.0,
        title:
            Text('Number Trivia', style: TextStyle(fontFamily: 'Montserrat')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250.0,
              decoration: BoxDecoration(
                  color: Color(0xFF000051),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0))),
              child: Stack(
//              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 15.0, top: 80.0, bottom: 0.0),
                    child: Text(
                      'Bored ?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 60.0),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 15.0, top: 160.0, bottom: 0.0),
                    child: Text(
                      'Try this random number trivia and get amazed 😉 ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0),
              width: double.infinity,
              height: 50.0,
              child: ClipRRect(
                child: TextField(
                  controller: _MytextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15.0),
                      fillColor: Color(0xFFffffff),
                      hintText: "Enter any number",
                      hintStyle: TextStyle(
                        fontSize: 20.0,
                      )),
                  onSubmitted: (val) {
                    setState(() {
                      query_val = val;
                    });
                    _fetchJson(context);
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'Or',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              width: double.infinity,
              height: 50.0,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF0C35B1)),
                  ),
                  onPressed: () {
                    if (query_val != null) {
                      setState(() {
                        query_val = null;
                        Future.delayed(Duration(seconds: 10)).then((onValue) {
                          print("PR status  ${pr.isShowing()}");
                          if (pr.isShowing()) pr.hide();
                          print("PR status  ${pr.isShowing()}");
                        });
                      });
                    }
                    _fetchJson(context);
                  },
                  child: Text(
                    'Get a random number trivia',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              width: 300.0,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(),
              child: Image(
                image: AssetImage('assets/images/numbers.jpg'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
