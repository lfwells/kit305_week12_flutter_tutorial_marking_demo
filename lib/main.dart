import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:kit305_week12_flutter_tutorial_marking_demo/add_grade.dart';
import 'package:kit305_week12_flutter_tutorial_marking_demo/grade.dart';
import 'package:kit305_week12_flutter_tutorial_marking_demo/grades_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'grades_list.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("\n\nConnected to Firebase App ${app.options.projectId}\n\n");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GradesProvider>(
      create: (_) => GradesProvider(),
      child:MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Tabs(),
      )
    );
  }
}


class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs>
{
  var currentWeek = 1;
  @override
  Widget build(BuildContext context) {

    //generate an array of 1..13
    var weeks = List<int>.generate(13, (i) => i + 1);

    return Scaffold(
      appBar: AppBar(
        title: Text("Week $currentWeek"),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: DefaultTabController(
        length: 13,
        child: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);
            tabController?.addListener(() {
              print("changed to tab ${tabController.index}");
              setState(() {
                currentWeek = tabController.index + 1;
              });
            });

            return TabBarView(
              children: weeks.map((week) => GradesList(week: week)).toList(),
            );
          }
        )
      ),
      floatingActionButton: Consumer<GradesProvider>(
        builder: (context, gradesModel, _) {
          return FloatingActionButton(
            onPressed: () {
              /*Get.to(
                  AddGradeScreen(week: currentWeek),
                  duration: Duration(seconds: 10),
                  transition: Transition.downToUp
              )*/
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddGradeScreen(week: currentWeek)));
            },
            child: gradesModel.addLoading ? const Text("...") : const Icon(Icons.add),
          );
        }
      ),
    );
  }
}
