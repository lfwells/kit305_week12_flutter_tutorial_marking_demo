import 'package:flutter/material.dart';
import 'package:kit305_week12_flutter_tutorial_marking_demo/grade.dart';
import 'package:kit305_week12_flutter_tutorial_marking_demo/grades_provider.dart';
import 'package:provider/provider.dart';

class GradesList extends StatefulWidget {
  const GradesList({Key? key, required this.week}) : super(key: key);

  final int week;

  @override
  State<GradesList> createState() => _GradesListState();
}

class _GradesListState extends State<GradesList> {

  @override
  Widget build(BuildContext context) {
    return Consumer<GradesProvider>(
      builder: (context, gradesModel, _) {
        if (gradesModel.loading)
        {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var thisWeeksGrades = gradesModel.getGradesForWeek(widget.week);

        return TheGradesList(thisWeeksGrades: thisWeeksGrades);
      }
    );
  }
}

class TheGradesList extends StatefulWidget {
  const TheGradesList({
    Key? key,
    required this.thisWeeksGrades,
  }) : super(key: key);

  final List<Grade> thisWeeksGrades;

  @override
  State<TheGradesList> createState() => _TheGradesListState();
}

class _TheGradesListState extends State<TheGradesList> {
  late List<Grade> filteredGrades;

  @override
  void initState() {
    super.initState();
    filteredGrades = widget.thisWeeksGrades;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Student ID",
            ),
            onFieldSubmitted: (value) async {
              //filter the list to only show the searched student id
              if (value.isEmpty) {
                setState(() => filteredGrades = widget.thisWeeksGrades );
              } else {
                setState(() => filteredGrades = widget.thisWeeksGrades.where((element) => element.studentID.toLowerCase().contains(value.toLowerCase())).toList() );
              }
            },
          )
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredGrades.length,
             itemBuilder: (context, i) {
              var grade = filteredGrades[i];
              return Dismissible(
                key: Key(grade.id),
                onDismissed: (direction) {
                  var gradesModel = Provider.of<GradesProvider>(context, listen: false);
                  gradesModel.remove(grade);
                },
                background: Container(color: Colors.red),
                child: ListTile(
                 title: Text(grade.studentID),
                 subtitle: Text(grade.displayGrade),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
