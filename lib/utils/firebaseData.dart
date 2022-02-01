import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educircle/screens/resourcesPage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseData {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref();

  Future<List> courses() async {
    List nameOfTheCourses = [];
    QuerySnapshot<Map<String, dynamic>> data =
        await fireStore.collection('Courses').orderBy("name").get();
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

  Future<String> imageURL(String location, String imageName) async {
    String link = "";
    // print(imageName);
    link = await ref.child('images/$location/$imageName').getDownloadURL();
    return link;
  }

  Future<List> materialType() async {
    List materialTypeList = [];
    QuerySnapshot<Map<String, dynamic>> data =
        await fireStore.collection('MaterialType').orderBy("name").get();
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
              if (materialItem["name"] != "none") {
                allTheMaterial.add(materialItem.data());
              }
            }
          }
        }
      }
    }
    return allTheMaterial;
  }

  Future<List> eventsData(String whichTypeEvent) async {
    List allTheMaterial = [];

    QuerySnapshot<Map<String, dynamic>> eventData = await fireStore
        .collection('HomePage')
        .where("name", isEqualTo: whichTypeEvent)
        .get();

    for (var event in eventData.docs) {
      QuerySnapshot<Map<String, dynamic>> postsReference =
          await event.reference.collection("Posts").get();

      for (var post in postsReference.docs) {
        // if (post["name"] != "none") {
        allTheMaterial.add(post.data());
        // }
      }
    }
    // print(allTheMaterial);
    return allTheMaterial;
  }

  Future<List> aeccGESubjects(int sem, String aeccOrGE, bool fullData) async {
    List subjectList = [];
    //for returning AECC or GE subjects
    QuerySnapshot<Map<String, dynamic>> materialTypedata = await fireStore
        .collection('MaterialType')
        .where("name", isEqualTo: "Timetable")
        .get();
    try {
      for (var materialType in materialTypedata.docs) {
        QuerySnapshot<Map<String, dynamic>> semesterReference =
            await navigateIntoCollection(materialType, "semester", "sem$sem");
        for (var semester in semesterReference.docs) {
          QuerySnapshot<Map<String, dynamic>> subjectReference =
              await semester.reference.collection(aeccOrGE).get();
          for (var subject in subjectReference.docs) {
            if (subject["name"] != "none") {
              fullData
                  ? subjectList.add(subject.data())
                  : subjectList.add(subject["name"]);
            }
          }
        }
      }
    } on FirebaseException catch (e) {
      print(e.message);
    }
    return subjectList;
  }

  Future<List> aeccOrGEData(
    int sem,
    String aeccOrGE,
    String materialType,
    String subjectName,
  ) async {
    List materialList = [];
    QuerySnapshot<Map<String, dynamic>> materialTypedata = await fireStore
        .collection('MaterialType')
        .where("name", isEqualTo: materialType)
        .get();

    try {
      for (var material in materialTypedata.docs) {
        QuerySnapshot<Map<String, dynamic>> semesterReference =
            await navigateIntoCollection(material, "semester", "sem$sem");
        for (var semester in semesterReference.docs) {
          QuerySnapshot<Map<String, dynamic>> subjectReference =
              await navigateIntoCollection(semester, aeccOrGE, subjectName);
          for (var subject in subjectReference.docs) {
            QuerySnapshot<Map<String, dynamic>> materialReference =
                await subject.reference.collection("material").get();
            for (var material in materialReference.docs) {
              if (material["name"] != "none") {
                materialList.add(material.data());
              }
            }
          }
        }
      }
    } on FirebaseException catch (e) {
      print(e.message);
    }
    return materialList;
  }

  Future<List> newsData(bool initialOrWhole) async {
    //will load only some news in initial (intial == true)|(whole data == false)
    List allTheMaterial = [];

    QuerySnapshot<Map<String, dynamic>> eventData = await fireStore
        .collection('HomePage')
        .where("name", isEqualTo: "news")
        .get();

    for (var event in eventData.docs) {
      if (initialOrWhole) {
        QuerySnapshot<Map<String, dynamic>> postsReference =
            await event.reference.collection("Posts").limit(10).get();

        for (var post in postsReference.docs) {
          allTheMaterial.add(post.data());
        }
      } else {
        QuerySnapshot<Map<String, dynamic>> postsReference =
            await event.reference.collection("Posts").get();

        for (var post in postsReference.docs) {
          allTheMaterial.add(post.data());
        }
      }
    }
    return allTheMaterial;
  }

  Future<Map> otherData(String id) async {
    Map allTheMaterial = {};

    DocumentSnapshot<Map<String, dynamic>> otherData = await fireStore
        .collection('OtherData').doc(id).get();
        
    allTheMaterial = otherData.data()!;
    return allTheMaterial;
  }
}
