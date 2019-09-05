import 'package:flutter/material.dart';

class BedmagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }


  Widget _buildBedmageListItem(BuildContext context, Map<String, dynamic> data) {
    final record = OnlinePlayer.fromMap(data);

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

}