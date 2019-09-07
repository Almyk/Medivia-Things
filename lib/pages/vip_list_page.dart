import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final PlayerBottomSheet playerBottomSheet = PlayerBottomSheet();

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
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onTap: () =>
                        vipBottomSheet.mainBottomSheet(context, vipBloc),
                  ),
                )
              ],
            ),
            drawer: MyDrawer(
              repository: repository,
            ),
            body: _buildVipListItems(context, repository.vipList),
          );
        });
  }

  Widget _buildVipListItems(BuildContext context, List<Player> players) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: players.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildVipListItem(context, players[index]);
        },
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
          borderRadius: BorderRadius.circular(5.0),
        ),
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
          onTap: () => playerBottomSheet.mainBottomSheet(context, player),
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
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _addVipWidget(context, vipBloc),
        );
      },
    );
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
          },
        )
      ],
    );
  }

  void _addVip(BuildContext context, VipBloc vipBloc) {
    final name = nameController.text;
    Fluttertoast.showToast(
      msg: "Add new vip: $name",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
    );
    Navigator.pop(context);
    nameController.clear();
    vipBloc.dispatch(AddNewVip(name: name));
  }
}

class PlayerBottomSheet {
  BuildContext _context;
  VipBloc _vipBloc;
  mainBottomSheet(BuildContext context, Player player) {
    _vipBloc = BlocProvider.of<VipBloc>(context);
    _context = context;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return _buildPlayerInfo(player);
      },
    );
  }

  Widget _buildPlayerInfo(Player player) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _iconRow(player),
          ),
          Container(
            child: Expanded(
              child: Scrollbar(
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: _buildTiles(player),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTiles(Player player) {
    List<Widget> tiles = [];

    var playerMap = player.toMap(db: false);
    playerMap.forEach(
      (key, value) {
        if (key != "logo") {
          Widget row;
          if (["latestdeaths", "latestkills", "tasklist"]
                  .indexOf(key.toLowerCase()) !=
              -1) {
            List<dynamic> values = value;
            row = ListTile(
              title: Container(
                constraints: BoxConstraints(
                  minHeight: 30.0,
                  maxHeight: 200.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                height: 68.0 * values.length,
                child: Scrollbar(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView(
                      children: values.length > 0
                          ? _listStringToListWidget(value)
                          : [
                              Center(
                                child: Text("-"),
                              ),
                            ],
                    ),
                  ),
                ),
              ),
              trailing: Text(
                key.toUpperCase(),
                // style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          } else {
            row = ListTile(
              title: Text(
                value.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                key.toUpperCase(),
                // style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
          tiles.add(row);
        }
      },
    );
    return tiles;
  }

  Widget _iconRow(Player player) {
    Widget icons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Icon(
            Icons.delete,
            size: 35.0,
          ),
          onTap: () {
            Navigator.pop(_context);
            _vipBloc.dispatch(
              DeleteVip(name: player.name),
            );
          },
        ),
        Row(
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.sync,
                color: Colors.blue,
                size: 35.0,
              ),
              onTap: () {
                Navigator.pop(_context);
                var repository = Repository();
                repository.updateVipByName(player.name);
              },
            ),
            GestureDetector(
              child: Icon(
                Icons.close,
                color: Colors.red,
                size: 35.0,
              ),
              onTap: () => Navigator.pop(_context),
            ),
          ],
        )
      ],
    );
    return icons;
  }

  List<Widget> _listStringToListWidget(List<dynamic> list) {
    List<Widget> newList = [];
    list.forEach(
      (entry) => newList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(entry),
        ),
      ),
    );
    return newList;
  }
}
