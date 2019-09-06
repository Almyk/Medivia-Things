import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class BedmageEvent extends Equatable {}

class BedmagesUpdated extends BedmageEvent {
  @override
  toString() => "BedmagesUpdated";
}

class AddBedmage extends BedmageEvent {
  final String name;
  final int interval;

  AddBedmage({@required this.name, @required this.interval});

  @override
  toString() => "AddBedmage <$name:$interval>";
}
