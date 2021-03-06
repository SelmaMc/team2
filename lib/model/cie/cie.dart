import 'package:quiver/core.dart';

class Cie {
  int id = -1;
  final String name;
  final double ects;
  final String lecturerName;
  final int department;

  Cie(this.name, this.department, this.lecturerName, this.ects, [this.id]);

  @override
  int get hashCode => hash4(name, ects, lecturerName, department);

  @override
  bool operator ==(o) =>
      o is Cie &&
      o.name == name &&
      o.ects == ects &&
      o.lecturerName == lecturerName &&
      o.department == department;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> tempMap = new Map();
    tempMap["id"] = this.id;
    tempMap["name"] = this.name;
    tempMap["department"] = this.department;
    tempMap["lecturerName"] = this.lecturerName;
    tempMap["ects"] = this.ects;
    return tempMap;
  }

  Map<String, dynamic> toMapNoId() {
    Map<String, dynamic> tempMap = new Map();
    tempMap["name"] = this.name;
    tempMap["department"] = this.department;
    tempMap["lecturerName"] = this.lecturerName;
    tempMap["ects"] = this.ects;
    return tempMap;
  }
}
