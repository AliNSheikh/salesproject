import 'dart:io';
import 'package:salesproject/admin_controller.dart';
import 'package:salesproject/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  var nameController = TextEditingController();
  var numberController = TextEditingController();
  var livingController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedValue = 'Coastal';
  bool isImageChosen = false;
  bool isAddLoading = false;
  File? userImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberController.text = AdminController.number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Name'),
                    subtitle: TextFormField(
                      controller: nameController,
                      onChanged: (value) {
                        nameController.text = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Number'),
                    subtitle: TextFormField(
                      enabled: false,
                      controller: numberController,
                    ),
                  ),
                  ListTile(
                    title: const Text('Living'),
                    subtitle: TextFormField(
                      controller: livingController,
                      onChanged: (value) {
                        livingController.text = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the living';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: TextFormField(
                      controller: emailController,
                      onChanged: (value) {
                        emailController.text = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the email';
                        } else if (!LoginController.isEmailValid(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Password'),
                    subtitle: TextFormField(
                      controller: passwordController,
                      onChanged: (value) {
                        passwordController.text = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the password';
                        } else if (value.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Region'),
                    subtitle: DropdownButton<String>(
                      value: selectedValue,
                      items: [
                        'Coastal',
                        'Northern',
                        'Eastern',
                        'Southern',
                        'Lebanon',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            isImageChosen
                ? Image(
              image: FileImage(userImage!),
              width: 150,
              height: 150,
            )
                : Image.asset('images/logo.jpg', width: 150, height: 150),
            ElevatedButton(
              onPressed: () async {
                await getUserImage();
              },
              child: const Text('Pick an image'),
            ),
            isAddLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isAddLoading = true;
                  });

                  print('1');
                  await AdminController.addUser(
                    name: nameController.text,
                    email: emailController.text,
                    living: livingController.text,
                    number: '${AdminController.number}',
                    region: selectedValue,
                    password: passwordController.text,
                    image: userImage,
                  );
                  setState(() {
                    isAddLoading = false;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserImage() async {
    var picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      userImage = File(pickedFile.path);
      setState(() {
        isImageChosen = true;
      });
    } else {
      print('No image selected.');
      isImageChosen = false;
    }
  }
}