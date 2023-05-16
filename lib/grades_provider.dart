

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kit305_week12_flutter_tutorial_marking_demo/grade.dart';

class GradesProvider extends ChangeNotifier
{
  final _collection = FirebaseFirestore.instance.collection("grades");

  bool loading = true;
  bool addLoading = false;
  List<Grade> grades = [];

  GradesProvider()
  {
    fetch();
  }

  Future fetch() async
  {
    //get the collection
    var snapshot = await _collection.get();

    for (var doc in snapshot.docs)
    {
      var grade = Grade.fromJson(doc.data());
      grade.id = doc.id;
      grades.add(grade);
    }

    loading = false;
    notifyListeners();
  }

  Future add(Grade newGrade) async
  {
    addLoading = true;
    notifyListeners();

    await _collection.add(newGrade.toJson());

    grades.add(newGrade);
    addLoading = false;
    notifyListeners();
  }

  Future remove(Grade grade) async
  {
    await _collection.doc(grade.id).delete();

    grades.remove(grade);
    notifyListeners();
  }

  List<Grade> getGradesForWeek(int week)
  {
    return grades.where((element) => element.week == week).toList();
  }
}