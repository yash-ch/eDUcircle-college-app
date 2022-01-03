import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educircle/screens/resources.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseData {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref();

  Future<List> courses() async {
    List nameOfTheCourses = [];
    QuerySnapshot<Map<String, dynamic>> data = await fireStore
        .collection('Courses')
        .where("active", isEqualTo: true)
        .get();
    for (var item in data.docs) {
      nameOfTheCourses.add(item["name"]);
    }
    return nameOfTheCourses;
  }

  Future<String> svgLink(String imageName) async {
    String link = "";
    // print(imageName);
    link = await ref.child('svg/$imageName.svg').getDownloadURL();
    return link;
  }

  Future<List> materialType() async {
    List materialTypeList = [];
    QuerySnapshot<Map<String, dynamic>> data =
        await fireStore.collection('MaterialType').get();
    for (var item in data.docs) {
      materialTypeList.add(item["name"]);
    }
    return materialTypeList;
  }

  Future<List> subjectOfCourse(String courseName, int sem) async {
    List rawSubjectList = [];
    List subjectList = [];
    QuerySnapshot<Map<String, dynamic>> courseData = await fireStore
        .collection('Courses')
        .where("name", isEqualTo: courseName)
        .get();
    for (var item in courseData.docs) {
      rawSubjectList = item["sem$sem"];
    }
    for (var item in rawSubjectList) {
      if (item != "") {
        subjectList.add(item);
      }
    }
    return subjectList;
  }

  navigateIntoCollection(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot,
      String title,
      String equalToName) {
    return documentSnapshot.reference
        .collection(title)
        .where("name", isEqualTo: equalToName)
        .get();
  }

  Future<List> materialData(
      String materialType, String subjectName, int sem) async {
    List allTheMaterial = [];

    QuerySnapshot<Map<String, dynamic>> materialTypedata = await fireStore
        .collection('MaterialType')
        .where("name", isEqualTo: materialType)
        .get();

    for (var material in materialTypedata.docs) {
      QuerySnapshot<Map<String, dynamic>> semesterReference =
          await navigateIntoCollection(material, "semester", "sem$sem");

      for (var semester in semesterReference.docs) {
        QuerySnapshot<Map<String, dynamic>> courseReference =
            await navigateIntoCollection(semester, "course", courseName);

        for (var course in courseReference.docs) {
          QuerySnapshot<Map<String, dynamic>> subjectReference =
              await navigateIntoCollection(course, "subject", subjectName);

          for (var subject in subjectReference.docs) {
            QuerySnapshot<Map<String, dynamic>> materialReference =
                await subject.reference.collection("material").get();
            for (var materialItem in materialReference.docs) {
              allTheMaterial.add(materialItem.data());
            }
          }
        }
      }
    }
    print(allTheMaterial);
    return allTheMaterial;
  }
}
