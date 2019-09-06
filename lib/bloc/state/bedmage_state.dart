import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class BedmageState extends Equatable {
  List props;
  BedmageState([this.props]) : super(props);
}

class ShowBedmages extends BedmageState {
  ShowBedmages({@required props}) : super(props);

  @override
  toString() => "ShowBedmages";
}

class UpdatingBedmages extends BedmageState {
  @override
  toString() => "UpdatingBedmages";
}
