import 'dart:io';
import 'package:salesproject/admin_controller.dart';
import 'package:salesproject/login_controller.dart';
import 'package:salesproject/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel userModel;

  const EditUserScreen({super.key, required this.userModel});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  var nameController = TextEditingController();
  var numberController = TextEditingController();
  var livingController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  bool isImageChosen = false;
  bool isAddLoading = false;
  late UserModel user;
  File? userImage;
  ImageProvider<Object>? img;

  @override
  void initState() {
    user = widget.userModel;
    numberController.text = user.number.toString();
    nameController.text = user.name!;
    livingController.text = user.living!;
    emailController.text = user.email!;
    passwordController.text = user.password!;
    selectedValue = user.region;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isImageChosen) {
      img = FileImage(userImage!);
    } else {
      img = NetworkImage(user.image!);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: img!,
                width: 150,
                height: 150,
              ),
              ElevatedButton(
                onPressed: () async {
                  await getUserImage();
                },
                child: const Text('Pick an image'),
              ),
              ListTile(
                title: const Text('Name'),
                subtitle: TextFormField(
                  controller: nameController,
                  onChanged: (value) {
                    nameController.text = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter the name';
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
                      return 'please enter the living';
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
                      return 'please enter the email';
                    } else if (!LoginController.isEmailValid(value)) {
                      return 'please enter a valid email';
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
                      return 'please enter the password';
                    } else if (value.length < 6) {
                      return 'password should be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedValue,
                items: const [
                  DropdownMenuItem(value: 'Coastal', child: Text('Coastal')),
                  DropdownMenuItem(value: 'Northern', child: Text('Northern')),
                  DropdownMenuItem(value: 'Eastern', child: Text('Eastern')),
                  DropdownMenuItem(value: 'Southern', child: Text('Southern')),
                  DropdownMenuItem(value: 'Lebanon', child: Text('Lebanon')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
              ),
              isAddLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isAddLoading = true;
                    });

                    await AdminController.editUser(
                      name: nameController.text,
                      email: emailController.text,
                      living: livingController.text,
                      number: user.number,
                      region: selectedValue,
                      password: passwordController.text,
                      image: userImage,
                      isImageEdited: isImageChosen,
                    );
                    setState(() {
                      isAddLoading = false;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Edit'),
              ),
            ],
          ),
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