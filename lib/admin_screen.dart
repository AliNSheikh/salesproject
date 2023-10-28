import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salesproject/add_new_user.dart';
import 'package:salesproject/admin_controller.dart';
import 'package:salesproject/commition_screen.dart';
import 'package:salesproject/edit_user_screen.dart';
import 'package:salesproject/user_model.dart';

import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String? _selectedValue;
  var yearController = TextEditingController();
  var monthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // var users=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        leading: TextButton(
          onPressed: () {
            AdminController.logOut(context);
          },
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0

            ),

          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Image(
            image: AssetImage('images/logo.jpg'),
            height: 200,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, bottom: 20.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Year'),
                              subtitle: TextFormField(
                                controller: yearController,
                                onChanged: (value) {
                                  yearController.text = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter the year';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Month'),
                              subtitle: TextFormField(
                                controller: monthController,
                                onChanged: (value) {
                                  monthController.text = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter the month';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var user = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(_selectedValue)
                              .get();
                          UserModel selectedUser =
                          UserModel.fromMap(user.data()!);
                          Map<String, dynamic> userCommitions =
                          await AdminController.getUserCommition(
                            userNumber: selectedUser.number,
                            year: yearController.text,
                            month: monthController.text,
                          );

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommitionScreen(
                                    user: selectedUser,
                                    year: yearController.text,
                                    month: monthController.text,
                                    userCommitions: userCommitions,
                                  )));
                        }
                      },
                      child: const Text(
                        'Monthly commition',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              return Expanded(
                child: ListView(
                  children:
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: RadioListTile<String>(
                            title: Text(data['name']),
                            value: data['number'].toString(),
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value;
                              });
                            },

                          ),
                        ),
                        Expanded(
                          child: _selectedValue == data['number'].toString()
                              ? IconButton(
                            onPressed: () async {
                              var user = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_selectedValue)
                                  .get();
                              UserModel selectedUser =
                              UserModel.fromMap(user.data()!);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditUserScreen(
                                          userModel: selectedUser)));
                            },
                            icon: const Text('Edit'),
                          )
                              : Container(),
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: _selectedValue == data['number'].toString()
                              ? IconButton(
                            onPressed: () async {
                              await AdminController.deleteUser(_selectedValue);
                              setState(() {});
                            },
                            icon: const Text('Delete'),
                          )
                              : Container(),
                        ),
                        const SizedBox(width: 5.0),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              await AdminController.getNewUserNumber();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewUser(),
                  ));
            },
            child: const Text('Add new user'),
          ),
          //TODO

        ],
      ),
    );
  }
}
