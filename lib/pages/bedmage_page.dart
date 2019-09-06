import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medivia_things/bloc/blocs/bedmage_bloc.dart';
import 'package:medivia_things/bloc/state/bedmage_state.dart';
import 'package:medivia_things/models/bedmage.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/utils/drawer.dart';

class BedmagePage extends StatelessWidget {
  final String title;
  final Repository repository;

  BedmagePage({@required this.title, @required this.repository});

  @override
  Widget build(BuildContext context) {
    final bedmageBloc = BlocProvider.of<BedmageBloc>(context);
    return BlocBuilder(
      bloc: bedmageBloc,
      builder: (BuildContext context, BedmageState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  onTap: () => print("action tappin"), // TODO: bottomsheet to add bedmage
                ),
              )
            ],
          ),
          drawer: MyDrawer(
            repository: repository,
          ),
          body: ListView.builder(
            itemCount: repository.bedmageList.length,
            itemBuilder: (context, i) =>
                _buildBedmageListItem(context, repository.bedmageList[i]),
          ),
        );
      },
    );
  }

  Widget _buildBedmageListItem(BuildContext context, Bedmage bedmage) {
    return Padding(
      key: ValueKey(bedmage.name),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
          title: Text(bedmage.name),
          trailing: Text(bedmage.timeLeft.toString()),
          onTap: () {
            print(bedmage.toString());
          },
        ),
      ),
    );
  }
}
