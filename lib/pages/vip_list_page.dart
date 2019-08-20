import 'package:flutter/material.dart';
import 'package:medivia_things/repository/repository.dart';
import 'package:medivia_things/utils/drawer.dart';

import '../bloc/blocs/navigation_bloc.dart';

class VipListPage extends StatelessWidget {
  VipListPage({Key key, this.title, this.navigationBloc, this.repository}) : super(key: key);

  final String title;
  final NavigationBloc navigationBloc;
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Center(child: Text("Vip List Page"),),
      drawer: MyDrawer(repository: repository,),
    );
  }
}