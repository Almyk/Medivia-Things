import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medivia_things/bloc/blocs/vip_bloc.dart';
import 'package:medivia_things/bloc/event/vip_event.dart';
import 'package:medivia_things/bloc/state/vip_state.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/utils/drawer.dart';
import 'package:medivia_things/models/player.dart';

import '../bloc/blocs/navigation_bloc.dart';

class VipListPage extends StatelessWidget {
  VipListPage({Key key, this.title, this.navigationBloc, this.repository})
      : super(key: key);

  final String title;
  final NavigationBloc navigationBloc;
  final Repository repository;
  final VipBottomSheet vipBottomSheet = VipBottomSheet();

  @override
  Widget build(BuildContext context) {
    final vipBloc = BlocProvider.of<VipBloc>(context);
    return BlocBuilder(
        bloc: vipBloc,
        builder: (BuildContext context, VipState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Icon(Icons.add),
                    onTap: () =>
                        vipBottomSheet.mainBottomSheet(context, vipBloc),
                  ),
                )
              ],
            ),
            drawer: MyDrawer(
              repository: repository,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildVipListItems(context, repository.vipList),
              ],
            ),
          );
        });
  }

  Widget _buildVipListItems(BuildContext context, List<Player> players) {
    List<Widget> vipList = new List<Widget>();

    for (final player in players) {
      vipList.add(_buildVipListItem(context, player));
    }
    return Expanded(
      child: Scrollbar(
        child: ListView(
          children: vipList,
        ),
      ),
    );
  }

  Widget _buildVipListItem(BuildContext context, Player player) {
    return Padding(
      key: ValueKey(player.name),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
          leading: ClipOval(
            child: CachedNetworkImage(
              width: 50.0,
              height: 50.0,
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: player.logo,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(player.name),
          trailing: Text(
            player.status,
            style: TextStyle(
                color: player.status == "Online" ? Colors.green : Colors.black),
          ),
          subtitle: Text("Lv: " +
              player.level.toString() +
              ", ${player.profession}, ${player.world}"),
          onTap: () {
            player.printTypes();
          },
        ),
      ),
    );
  }
}

class VipBottomSheet {
  final nameController = TextEditingController();

  mainBottomSheet(BuildContext context, VipBloc vipBloc) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  left: 2.0,
                  right: 2.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _addVipWidget(context, vipBloc));
        });
  }

  Widget _addVipWidget(BuildContext context, VipBloc vipBloc) {
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
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _addVip(context, vipBloc),
          ),
        ),
        RaisedButton(
            padding: const EdgeInsets.all(0.0),
            elevation: 4.0,
            child: Text("ADD"),
            color: Theme.of(context).colorScheme.primaryVariant,
            onPressed: () {
              nameController.text.isNotEmpty
                  ? _addVip(context, vipBloc)
                  : Navigator.pop(context);
            })
      ],
    );
  }

  void _addVip(BuildContext context, VipBloc vipBloc) {
    Navigator.pop(context);
    print(nameController.text);
    vipBloc.dispatch(AddNewVip(name: nameController.text));
  }
}
