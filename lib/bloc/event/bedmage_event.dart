import 'package:equatable/equatable.dart';

abstract class BedmageEvent extends Equatable {}

class BedmagesUpdated extends BedmageEvent {
  @override
  toString() => "BedmagesUpdated";
}