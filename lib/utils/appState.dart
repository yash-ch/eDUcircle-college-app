import 'package:hive/hive.dart';

class AppState {
  AppState._internal();

  static final AppState _instance = AppState._internal();
  factory AppState() {
    return _instance;
  }

  Box<dynamic>? settingsBox;
  Future init() async {
    settingsBox = await Hive.openBox("settings");
  }

  void putSetting(key, value) {
    settingsBox?.put(key, value);
  }

  dynamic getSetting(key, defaultVal) {
    return settingsBox?.get(key, defaultValue: defaultVal);
  }

  void setCourse(String course) {
    putSetting("Course", course);
  }

  String getCourse() {
    return getSetting("Course", "B.Sc. (H) Computer Science");
  }
  
  void setSemester(String semester) {
    putSetting("Semester", semester);
  }

  String getSemester() {
    return getSetting("Semester", "Semester 1");
  }

    void setGE(String course) {
    putSetting("GE", course);
  }

  String getGE() {
    return getSetting("GE", "Select GE");
  }
}
