import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskit/Model/Variables.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Views/TaskView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime date = DateTime(2022, 08, 02);
  DateTime? staringdate = null;
  TextEditingController _titleTextEditingcontroller = TextEditingController();
  TextEditingController _descriptionTextEditingController =
      TextEditingController();

  void createTask() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Tasks").doc(TaskDetails.title);

    Map<String, String> tasklistFormat = {
      "task_title": TaskDetails.title,
      "task_description": TaskDetails.description,
      "task_date": TaskDetails.date,
      "dueDate": TaskDetails.dueDate,
      "category": TaskDetails.category,
    };
    documentReference.set(tasklistFormat).whenComplete(() => {
          Fluttertoast.showToast(
              msg: TaskDetails.title.toString() + " task is added",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0),
        });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TaskView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
              ),
              builder: (context) {
                return  DraggableScrollableSheet(
                  minChildSize: 0.75,
                  initialChildSize: 1,
                  builder: ((context, scrollController) => SingleChildScrollView(
                    child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Title",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      TextStyle(color: Colors.grey[800]),
                                  hintText: "Example: go for jogging ",
                                  fillColor: Colors.white70),
                              onChanged: (String value) {
                                TaskDetails.title = value;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Description",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      TextStyle(color: Colors.grey[800]),
                                  hintText: "Example : I will run for 2km ",
                                  fillColor: Colors.white70),
                              onChanged: (String value) {
                                TaskDetails.description = value;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Starting date",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)),
                                  child: Text(
                                      '${date.year}/${date.month}/${date.day}'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    staringdate = await showDatePicker(
                                        context: context,
                                        initialDate: date,
                                        firstDate:
                                            DateTime(DateTime.now().year),
                                        lastDate: DateTime(2040));
                                    if (staringdate == null)
                                      return;
                                    else {
                                      setState(() {
                                        date = staringdate!;
                                        TaskDetails.date=date.toString();
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.date_range),
                                  label: const Text(
                                    "Choose date",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Description",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            
                            TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      TextStyle(color: Colors.grey[800]),
                                  hintText: "add some category",
                                  fillColor: Colors.white70),
                              onChanged: (String value) {
                                TaskDetails.category = value;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    createTask();
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text("Add Task")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ));
                }),
                  )),
                );
              });

          print("hello");
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
