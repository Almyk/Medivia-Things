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

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vipBloc = BlocProvider.of<VipBloc>(context);
    return BlocBuilder(
        bloc: vipBloc,
        builder: (BuildContext context, VipState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            drawer: MyDrawer(
              repository: repository,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'player name'),
                          controller: nameController,
                        ),
                      ),
                      RaisedButton(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 4.0,
                        child: Text("ADD"),
                        color: Colors.blue,
                        onPressed: () => state is ShowingVipList
                            ? vipBloc
                                .dispatch(AddNewVip(name: nameController.text))
                            : null,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: _buildVipListItems(context, repository.vipList),
                )
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
    return Scrollbar(
      child: ListView(
        children: vipList,
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
          leading: CachedNetworkImage(
            width: 50.0,
            height: 50.0,
            placeholder: (context, url) => CircularProgressIndicator(),
            imageUrl: player.logo,
            ),
          title: Text(player.name),
          trailing: Text(
              player.status,
              style: TextStyle(color: player.status == "Online" ? Colors.green : Colors.black),
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
