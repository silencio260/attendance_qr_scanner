import 'package:hive/hive.dart';

part 'attendace_model.g.dart';

@HiveType(typeId: 1)
class Attendace {
  Attendace({this.name, this.attendace});
  @HiveField(0)
  String name;

  @HiveField(1)
  List attendace;
}
