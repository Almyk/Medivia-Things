import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const destiny = 0;
const legacy = 1;
const pendulum = 2;
const prophecy = 3;
const strife = 4;

const serverNames = ['Destiny', 'Legacy', 'Pendulum', 'Prophecy', 'Strife'];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medivia Things',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Medivia Things'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _server = pendulum;
  List<int> _onlineCounts = [0, 0, 0, 0, 0];

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) => test());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void test() async{
    var url = 'http://almy.iptime.org:5000/medivia/online/';
    List<Map<String, dynamic>> onlineLists = new List(5);
    for(int i = 0; i < 5; i++) {
      var response = await http.get(url + serverNames[i].toLowerCase());
      Map onlineList = json.decode(response.body);
      onlineLists[i] = onlineList;
      print(serverNames[i] + ": ${onlineList['players'].length}");
      print(onlineList);
    }
  }

  Stream<List<Map<String, dynamic>>> getOnlineLists() async*{
    var url = 'http://almy.iptime.org:5000/medivia/online/';
    List<Map<String, dynamic>> onlineLists = new List(5);
    while (true) {
      for(int i = 0; i < 5; i++) {
        var response = await http.get(url + serverNames[i].toLowerCase());
        Map onlineList = json.decode(response.body);
        onlineLists[i] = onlineList;
        print(serverNames[i] + ": ${onlineList.length}");
        print(onlineList);
      }
      yield onlineLists;
      await Future.delayed(const Duration(minutes: 1));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Container(
              child: Text(widget.title),
              padding: EdgeInsets.symmetric(vertical: 4.0),
            ),
            Text(
              serverNames[_server] + ' (${_onlineCounts[_server].toString()})',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      body: _buildBody(context),
      drawer: _createDrawer(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(child: _buildOnline(context));
  }

  Widget _buildOnline(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('online').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildOnlineList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildOnlineList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    bool dataChanged = false;
    for (var i = 0; i < 5; i++) {
      int temp = snapshot[i].data['players'].length;
      if (temp != _onlineCounts[i]) {
        _onlineCounts[i] = temp;
        dataChanged = true;
      }
    }

    if (dataChanged) {
      SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
    }

    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      children: _buildOnlineListItems(context, snapshot[_server]),
    );
  }

  List<Widget> _buildOnlineListItems(
      BuildContext context, DocumentSnapshot data) {
    List<dynamic> players = data.data['players'];
    List<Widget> onlineList = new List<Widget>();

    for (final player in players) {
      onlineList.add(
          _buildOnlineListItem(context, Map<String, dynamic>.from(player)));
    }
    return onlineList;
  }

  Widget _buildOnlineListItem(BuildContext context, Map<String, dynamic> data) {
    final record = Record.fromMap(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.login),
          subtitle:
              Text("Lv: " + record.level.toString() + ", " + record.vocation),
          onTap: () {
            print(record.toString());
          },
        ),
      ),
    );
  }

  Widget _createDrawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Medivia Things'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Destiny' + ' (${_onlineCounts[destiny]})'),
            onTap: () {
              setState(() {
                _server = destiny;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Legacy' + ' (${_onlineCounts[legacy]})'),
            onTap: () {
              setState(() {
                _server = legacy;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Pendulum' + ' (${_onlineCounts[pendulum]})'),
            onTap: () {
              setState(() {
                _server = pendulum;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Prophecy' + ' (${_onlineCounts[prophecy]})'),
            onTap: () {
              setState(() {
                _server = prophecy;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Strife' + ' (${_onlineCounts[strife]})'),
            onTap: () {
              setState(() {
                _server = strife;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class Record {
  final String name;
  final int level;
  final String vocation;
  final String login;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['level'] != null),
        assert(map['vocation'] != null),
        assert(map['login'] != null),
        name = map['name'],
        level = map['level'],
        vocation = map['vocation'],
        login = map['login'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$level:$vocation:$login>";
}
