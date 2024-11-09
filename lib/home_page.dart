import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Hive Database",style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.indigo,

      ),

      body: Column(
        children: [
          //Here We will get the values that stored in hive data base
         FutureBuilder(
           //Refrerence of data you want to show
             future:Hive.openBox('Hive Dataabase') ,
             builder: (context, snapshot){

               return Column(
                 children: [
                   Text(snapshot.data!.get('Name').toString()),
                   Text(snapshot.data!.get('Age').toString()),
                 ],



               );
             }),
          FutureBuilder(future: Hive.openBox('Department'), builder: (context,snapshot){

            return Column(
              children: [
                Text(snapshot.data!.get('department').toString()),
              ],
            );
          })




      ],),
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add) ,
          onPressed: ()async{
        var box= await Hive.openBox('Hive Dataabase');
        var box2=await Hive.openBox('Department')  ;      box.put('Name', 'Adeel Ahmad');
        box.put('Age', '25');
        box2.put('department', 'Computer Science');


        debugPrint(box.get('Name'));
        debugPrint(box.get('Age'));
        debugPrint(box.get('department'));


      }),
    );
  }
}

