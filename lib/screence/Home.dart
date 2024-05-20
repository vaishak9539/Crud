// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_ref/screence/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerphNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late String _taskIdForUpdate;

  var size, width, height;

  Future<void> floting() async {
    final adding =
        await FirebaseFirestore.instance.collection("AddingDetails").add({
      "Name": controllerName.text,
      "Activity": controllerphNumber.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Color(0xff0E1D3E),
      appBar: AppBar(
        backgroundColor: Color(0xff0E1D3E),
        title: Text("Crud",
            style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 23))),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 5),
                child: Text("Hi",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 12)),
              ),
              Text("Vaishak",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 18,
                  )),
              SizedBox(
                width: 210,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(),
                      ));
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile.png"),
                  radius: 18,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("AddingDetails")
                .orderBy("Name")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var documentId = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      color: const Color.fromARGB(255, 77, 181, 171),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(documentId["Name"][0]),
                        ),
                        title: Text(documentId["Name"]),
                        subtitle: Text(documentId["ph Number"]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
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
                                              child: TextFormField(
                                                controller: controllerName,
                                                decoration: InputDecoration(
                                                  hintText: 'Enter your Name',
                                                  // border:
                                                  //     OutlineInputBorder(
                                                  //         borderRadius:
                                                  //             BorderRadius
                                                  //                 .circular(
                                                  //                     10))
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: SizedBox(
                                                  height: 50,
                                                  width: 250,
                                                  child: TextFormField(
                                                    controller:
                                                        controllerphNumber,
                                                    decoration:
                                                        InputDecoration(
                                                      hintText: "ph Number",
                                                      // border: OutlineInputBorder(
                                                      //     borderRadius:
                                                      //         BorderRadius
                                                      //             .circular(
                                                      //                 10))
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
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
                                            if (controllerName
                                                .text.isNotEmpty) {
                                              FirebaseFirestore.instance
                                                  .collection("AddingDetails")
                                                  .doc(_taskIdForUpdate)
                                                  .update({
                                                'Name': controllerName.text,
                                                'ph Number':
                                                    controllerphNumber.text,
                                              });
                                              controllerName.clear();
                                              controllerphNumber.clear();
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
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
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
                              width: 230,
                              child: TextFormField(
                                controller: controllerName,
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  // border: OutlineInputBorder(
                                  //     borderRadius:
                                  //         BorderRadius.circular(10))
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                                height: 50,
                                width: 230,
                                child: TextFormField(
                                  controller: controllerphNumber,
                                  decoration: InputDecoration(
                                    hintText: "ph Number",
                                    // border: OutlineInputBorder(
                                    //     borderRadius:
                                    //         BorderRadius.circular(10))
                                  ),
                                  keyboardType: TextInputType.number,
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
                              controllerphNumber.text.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection("AddingDetails")
                                .add({
                              'Name': controllerName.text,
                              'ph Number': controllerphNumber.text,
                            });
                            controllerName.clear();
                            controllerphNumber.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Save"))
                  ],
                );
              });
        },
        backgroundColor: Color.fromARGB(255, 77, 181, 171),
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
