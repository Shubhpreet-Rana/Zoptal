import 'package:hive/hive.dart';
part 'contact_hive.g.dart';

@HiveType(typeId: 1)
class ContactHive {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String image;

  @HiveField(3)
  String phone;

  ContactHive({required this.id , required this.name , required this.image , required this.phone});


}