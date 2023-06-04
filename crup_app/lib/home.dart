import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // write, read, delete, update

  TextEditingController _titleController = TextEditingController();
  TextEditingController _desController = TextEditingController();
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  progressDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  writeData(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Container(
              height: 300,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.title_outlined,
                      ),
                      hintText: 'Title',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _desController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.title_outlined,
                      ),
                      hintText: 'Description',
                    ),
                  ),
                  Expanded(
                    child: image == null
                        ? Center(
                            child: IconButton(
                              onPressed: () async {
                                image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {});
                              },
                              icon: Icon(Icons.add_a_photo),
                            ),
                          )
                        : Image.file(
                            File(
                              (image!.path),
                            ),
                            fit: BoxFit.contain,
                          ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.purple.shade100;
                        return Colors.purple;
                      })),
                      onPressed: () async {
                        try {
                          // show the loading indicator
                          progressDialog();
                          File imgFile = File(image!.path);
                          // upload to stroage
                          UploadTask _uploadTask = storage
                              .ref('images')
                              .child(image!.name)
                              .putFile(imgFile);

                          TaskSnapshot snapshot = await _uploadTask;
                          // get the image download link
                          var imageUrl = await snapshot.ref.getDownloadURL();
                          // store the image & name to our database
                          firestore.collection('tasks').add(
                            {
                              'title': _titleController.text,
                              'description': _desController.text,
                              'icon': imageUrl,
                            },
                          ).whenComplete(
                            () {
                              // after adding data to the database
                              Fluttertoast.showToast(msg: 'Added Successfully');
                              _titleController.clear();
                              _desController.clear();
                              image = null;
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                            },
                          );
                        } catch (e) {
                          // if try block doesn't work
                          print(e);
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                        }
                      },
                      child: Text('Add Task'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  updateData(context, documentID) async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Container(
              height: 300,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.title_outlined,
                      ),
                      hintText: 'Title',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _desController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.title_outlined,
                      ),
                      hintText: 'Description',
                    ),
                  ),
                  Expanded(
                    child: image == null
                        ? Center(
                            child: IconButton(
                              onPressed: () async {
                                image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {});
                              },
                              icon: Icon(Icons.add_a_photo),
                            ),
                          )
                        : Image.file(
                            File(
                              (image!.path),
                            ),
                            fit: BoxFit.contain,
                          ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.purple.shade100;
                        return Colors.purple;
                      })),
                      onPressed: () async {
                        try {
                          // show the loading indicator
                          progressDialog();
                          File imgFile = File(image!.path);
                          // upload to stroage
                          UploadTask _uploadTask = storage
                              .ref('images')
                              .child(image!.name)
                              .putFile(imgFile);

                          TaskSnapshot snapshot = await _uploadTask;
                          // get the image download link
                          var imageUrl = await snapshot.ref.getDownloadURL();
                          // store the image & name to our database
                          firestore.collection('tasks').doc(documentID).update(
                            {
                              'title': _titleController.text,
                              'description': _desController.text,
                              'icon': imageUrl,
                            },
                          ).whenComplete(
                            () {
                              // after adding data to the database
                              Fluttertoast.showToast(
                                  msg: 'updated Successfully');
                              _titleController.clear();
                              _desController.clear();
                              image = null;
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                            },
                          );
                        } catch (e) {
                          // if try block doesn't work
                          print(e);
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                        }
                      },
                      child: Text('Update Data'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  final Stream<QuerySnapshot> _taskStream =
      FirebaseFirestore.instance.collection('tasks').snapshots();

  @override
  Widget build(BuildContext context) {
    Future<void> sslCommerzGeneralCall() async {
      Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          currency: SSLCurrencyType.BDT,
          product_category: "Food",
          sdkType: SSLCSdkType.TESTBOX,
          store_id: 'biplo647c06b6121d0',
          store_passwd: 'biplo647c06b6121d0@ssl',
          total_amount: 500.0,
          tran_id: '12124',
        ),
      );
      try {
        SSLCTransactionInfoModel result = await sslcommerz.payNow();

        if (result.status!.toLowerCase() == "failed") {
          Fluttertoast.showToast(
            msg: "Transaction is Failed....",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else if (result.status!.toLowerCase() == "closed") {
          Fluttertoast.showToast(
            msg: "SDK Closed by User",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          Fluttertoast.showToast(
              msg:
                  "Transaction is ${result.status} and Amount is ${result.amount}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Todo App',
            style: TextStyle(color: Color.fromRGBO(200, 3, 235, 1)),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => writeData(context),
          child: Icon(
            Icons.add,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _taskStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading"));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Stack(
                  children: [
                    Card(
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(data['icon']),
                              ),
                              title: Text(
                                data['title'],
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                data['description'],
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        right: 0,
                        child: Container(
                          color: Colors.grey,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      updateData(context, document.id),
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    firestore
                                        .collection('tasks')
                                        .doc(document.id)
                                        .delete()
                                        .then((value) => Fluttertoast.showToast(
                                            msg: 'deleted successfully.'))
                                        .catchError((error) =>
                                            Fluttertoast.showToast(msg: error));
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 100, left: 100),
                      child: ElevatedButton(
                          onPressed: () => sslCommerzGeneralCall(),
                          child: Text('Pay Now')),
                    )
                  ],
                );
              }).toList(),
            );
          },
        ));
  }
}
