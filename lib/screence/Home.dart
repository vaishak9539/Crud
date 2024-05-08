// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_ref/screence/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerActivity = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late String _taskIdForUpdate;

  var size, width, height;

  Future<void> floting() async {
    final adding =
        await FirebaseFirestore.instance.collection("AddingDetails").add({
      "Name": controllerName.text,
      "Activity": controllerActivity.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Crud"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ));
              },
              icon: Icon(Icons.person)),
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("AddingDetails").orderBy("Name").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var documentId = snapshot.data!.docs[index];
              return Card(
                color: Colors.blue[200],
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(documentId["Name"][0]),
                  ),
                  title: Text(documentId["Name"]),
                  subtitle: Text(documentId["Activity"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _taskIdForUpdate = documentId.id;
                          // controllerName.text = todo['Name'];
                          // controllerActivity.text = todo['Activity'];
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Edit Details'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 250,
                                        child: TextField(
                                          controller: controllerName,
                                          decoration: InputDecoration(
                                              hintText: 'Enter your Name',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: SizedBox(
                                            height: 50,
                                            width: 250,
                                            child: TextFormField(
                                              controller: controllerActivity,
                                              decoration: InputDecoration(
                                                  hintText: "Activity",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (controllerName.text.isNotEmpty) {
                                        FirebaseFirestore.instance
                                            .collection("AddingDetails")
                                            .doc(_taskIdForUpdate)
                                            .update({
                                          'Name': controllerName.text,
                                          'Activity': controllerActivity.text,
                                        });
                                        controllerName.clear();
                                        controllerActivity.clear();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text('Update'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("AddingDetails")
                                .doc(documentId.id)
                                .delete();
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text("Details"),
                  content: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                              height: 50,
                              width: 250,
                              child: TextFormField(
                                controller: controllerName,
                                decoration: InputDecoration(
                                    hintText: "Name",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                                height: 50,
                                width: 250,
                                child: TextFormField(
                                  controller: controllerActivity,
                                  decoration: InputDecoration(
                                      hintText: "Activity",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () {
                          if (controllerName.text.isNotEmpty &&
                              controllerActivity.text.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection("AddingDetails")
                                .add({
                              'Name': controllerName.text,
                              'Activity': controllerActivity.text,
                            });
                            controllerName.clear();
                            controllerActivity.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Save"))
                  ],
                );
              });
        },
        backgroundColor: Colors.blue[200],
        child: Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
