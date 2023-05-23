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
        print("rebuild the list?? ${ gradesModel.grades.length.toString()}");
        if (gradesModel.loading)
        {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var thisWeeksGrades = gradesModel.getGradesForWeek(widget.week);
        print("rebuild the list?? ${ thisWeeksGrades.length.toString()}");

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
  void didUpdateWidget(TheGradesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    filteredGrades = widget.thisWeeksGrades;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
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
                confirmDismiss: (direction) async {
                  var gradesModel = Provider.of<GradesProvider>(context, listen: false);
                  //could have a "popup are you sure?"

                  var confirmedDelete = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
                    title: const Text("Delete this grade?"),
                    content: const Text("Are you sure? This can't be undone"),
                    actions: [
                      TextButton(child: const Text("Yes", style:const TextStyle(color: Colors.red)), onPressed: () { return Navigator.pop(context, true);},),
                      TextButton(child: const Text("No"), onPressed: () { return Navigator.pop(context, false); }),
                    ],
                  ));
                  if (confirmedDelete ?? false)
                  {
                    await gradesModel.remove(grade);
                  }
                  return confirmedDelete ?? false;
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Total grade: "+filteredGrades
              .map((grade)=>grade.doubleGrade)
              .reduce((value, element) => value+element).toString()),
        )
      ],
    );
  }
}
