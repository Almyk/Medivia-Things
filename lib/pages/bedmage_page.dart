import 'package:flutter/material.dart';
import 'package:medivia_things/models/bedmage.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/utils/drawer.dart';

class BedmagePage extends StatelessWidget {
  var data = {'name': 'test_name', 'time_left': '50 minutes'};
  final String title;
  final Repository repository;

  BedmagePage({@required this.title, @required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: MyDrawer(repository: repository,),
      body: _buildBedmageListItem(context, data),
    );
  }


  Widget _buildBedmageListItem(BuildContext context, Map<String, dynamic> data) {
    final record = Bedmage.fromMap(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.timeLeft),
          onTap: () {
            print(record.toString());
          },
        ),
      ),
    );
  }

}