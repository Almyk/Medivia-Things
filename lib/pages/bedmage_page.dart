import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medivia_things/bloc/blocs/bedmage_bloc.dart';
import 'package:medivia_things/bloc/event/bedmage_event.dart';
import 'package:medivia_things/bloc/state/bedmage_state.dart';
import 'package:medivia_things/models/bedmage.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/utils/drawer.dart';

class BedmagePage extends StatelessWidget {
  final String title;
  final Repository repository;
  final BedmageBottomSheet bedmageBottomSheet = BedmageBottomSheet();

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
                  onTap: () =>
                      bedmageBottomSheet.mainBottomSheet(context, bedmageBloc),
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
    String _timeLeft = "Time Left: ${bedmage.timeLeft} min";
    if (bedmage.timeLeft == 0) {
      _timeLeft = "Time Left: Due";
    } else if (bedmage.timeLeft == -1) {
      _timeLeft = "Time Left: ${bedmage.interval} min";
    }
    return Padding(
      key: ValueKey(bedmage.name),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
          title: Text(bedmage.name),
          trailing: Text("$_timeLeft"),
          onTap: () {
            print(bedmage.toString());
          },
        ),
      ),
    );
  }
}

class BedmageBottomSheet {
  final nameController = TextEditingController();
  final intervalController = TextEditingController();

  mainBottomSheet(BuildContext context, BedmageBloc bedmageBloc) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 2.0,
            right: 2.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _addBedmageWidget(context, bedmageBloc),
        );
      },
    );
  }

  Widget _addBedmageWidget(BuildContext context, BedmageBloc bedmageBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: 'player name'),
            controller: nameController,
          ),
        ),
        Expanded(
          child: TextField(
            autofocus: false,
            decoration: InputDecoration(labelText: 'interval (min)'),
            controller: intervalController,
            keyboardType: TextInputType.number,
          ),
        ),
        RaisedButton(
          padding: const EdgeInsets.all(0.0),
          elevation: 4.0,
          child: Text("ADD"),
          color: Theme.of(context).colorScheme.primaryVariant,
          onPressed: () {
            nameController.text.isNotEmpty
                ? _addBedmage(context, bedmageBloc)
                : Navigator.pop(context);
          },
        )
      ],
    );
  }

  void _addBedmage(BuildContext context, BedmageBloc bedmageBloc) {
    final name = nameController.text;
    final interval = int.tryParse(intervalController.text);
    Navigator.pop(context);
    nameController.clear();
    intervalController.clear();
    bedmageBloc.dispatch(AddBedmage(name: name, interval: interval));
  }
}
