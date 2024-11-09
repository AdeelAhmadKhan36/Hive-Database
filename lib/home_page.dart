import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/model/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Hive Database",
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.indigo,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10, top: 5),
                            child: Row(
                              children: [
                                Text(
                                  data[index].title.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Spacer(),
                                InkWell(
                                    onTap: () {
                                      _delete(data[index]);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      _editdialog(
                                          data[index],
                                          data[index].title.toString(),
                                          data[index].description.toString());
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                          Text(data[index].description.toString())
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          })
      // body: Column(

      //   children: [
      //     //Here We will get the values that stored in hive data base
      //    FutureBuilder(
      //      //Refrerence of data you want to show
      //        future:Hive.openBox('Hive Dataabase') ,
      //        builder: (context, snapshot){
      //
      //          return Column(
      //            children: [
      //              Text(snapshot.data!.get('Name').toString()),
      //              Text(snapshot.data!.get('Age').toString()),
      //            ],
      //
      //
      //
      //          );
      //        }),
      //     FutureBuilder(future: Hive.openBox('Department'), builder: (context,snapshot){
      //
      //       return Column(
      //         children: [
      //           Text(snapshot.data!.get('department').toString()),
      //         ],
      //       );
      //     })
      //
      //
      //
      //
      // ],),
      // floatingActionButton: FloatingActionButton(
      //   child:Icon(Icons.add) ,
      //     onPressed: ()async{
      //   var box= await Hive.openBox('Hive Dataabase');
      //   var box2=await Hive.openBox('Department')  ;      box.put('Name', 'Adeel Ahmad');
      //   box.put('Age', '25');
      //   box2.put('department', 'Computer Science');
      //
      //
      //   debugPrint(box.get('Name'));
      //   debugPrint(box.get('Age'));
      //   debugPrint(box.get('department'));
      //
      //
      // }),

      ,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            _showdialog();
          }),
    );
  }

  void _delete(NotesModel _notesmodel) async {
    await _notesmodel.delete();
  }

  Future<void> _editdialog(
      NotesModel notesmodel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(onPressed: ()async{

                notesmodel.title=titleController.text.toString();
                notesmodel.description=descriptionController.text.toString();
                await notesmodel.save();

                Navigator.pop(context);

              }, child: const Text("Edit"))
            ],
          );
        });
  }

  Future<void> _showdialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    //Add Data or Store Data
                    final data = NotesModel(
                        title: titleController.text,
                        description: descriptionController.text);
                    final box = Boxes.getData();
                    box.add(data);
                    data.save();
                    print(box);
                    //Where?
                  },
                  child: const Text("Add"))
            ],
          );
        });
  }
}
