import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  String course;

  @HiveField(1)
  String category;

  @HiveField(2)
  DateTime dateTime; // Store DateTime directly

  @HiveField(3)
  String description;

  Event({
    required this.course,
    required this.category,
    required this.dateTime,
    required this.description,
  });
}
