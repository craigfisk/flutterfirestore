import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Band Name Survey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}  // remove??
/*
class MockBandInfo {
  const MockBandInfo({this.name, this.votes});
  final String name;
  final int votes;
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  static List<MockBandInfo> _bandList = [
    const MockBandInfo(name: "Name 1", votes: 1),
    const MockBandInfo(name: "Name 2", votes: 2),
    const MockBandInfo(name: "Name 3", votes: 3),
    const MockBandInfo(name: "Name 4", votes: 4),
  ];
*/
class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  //@override
  //_MyHomePageState createState() => _MyHomePageState();
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) { //}MockBandInfo bandInfo) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['name'], //bandInfo.name,
              style: Theme.of(context).textTheme.headline5, // headline,
            ),
          ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xffddddff),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            document['votes'].toString(),
            style: Theme.of(context).textTheme.headline4, //display1,
            ),
            ),
          ],
        ),
        onTap: () {
          //print("Should increase votes here.");
//          document.reference.updateData({
//            'votes': document['votes'] + 1
//          });
            Firestore.instance.runTransaction((transaction) async {
            DocumentSnapshot freshSnap =
                await transaction.get(document.reference);
            await transaction.update(freshSnap.reference, {
              'votes': freshSnap['votes'] + 1,
            });
          });
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('bandname').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length, //_bandList.length,
            itemBuilder: (context, index) =>
              _buildListItem(context, snapshot.data.documents[index]), //_bandList[index]),
          );
        }),
    );
  }
}
