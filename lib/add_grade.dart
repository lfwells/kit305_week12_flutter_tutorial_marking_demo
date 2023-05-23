import 'package:flutter/material.dart';
import 'package:kit305_week12_flutter_tutorial_marking_demo/grades_provider.dart';
import 'package:provider/provider.dart';

import 'package:get/get.dart';

import 'grade.dart';

class AddGradeScreen extends StatefulWidget {
  const AddGradeScreen({Key? key, required this.week}) : super(key: key);

  final int week;

  @override
  State<AddGradeScreen> createState() => _AddGradeScreenState();
}

class _AddGradeScreenState extends State<AddGradeScreen> 
{
  final _studentIDController = TextEditingController();
  final _gradeController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Grade for Week ${widget.week}")
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _studentIDController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Student ID",
              ),
            ),
            TextFormField(
              controller: _gradeController,
              decoration: const InputDecoration(
                labelText: "Grade"
              ),
            ),
            ElevatedButton(onPressed: () async
            {
              Grade newGrade = Grade(
                widget.week,
                _studentIDController.value.text,
                _gradeController.value.text,
                double.parse(_gradeController.value.text)/100.0
              );
              await Provider.of<GradesProvider>(context, listen: false).add(newGrade);
              Navigator.of(context).pop();
              /*Get.back(

              );*/
            }, child: const Text("Add Grade"))
          ],
        ),
      )
    );
  }
}
