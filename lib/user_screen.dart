import 'package:salesproject/admin_controller.dart';
import 'package:salesproject/user_controller.dart';
import 'package:salesproject/user_model.dart';
import 'package:flutter/material.dart';

import 'login_controller.dart';

class UserScreen extends StatelessWidget {
  var coastalAmountController = TextEditingController();
  var northAmountController = TextEditingController();
  var southAmountController = TextEditingController();
  var eastAmountController = TextEditingController();
  var lebanonAmountController = TextEditingController();
  var fKey = GlobalKey<FormState>();
  UserModel? user = LoginController.loggedUser;

  UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name: ${user!.name}'),
        actions: [
          TextButton(
            onPressed: () {
              AdminController.logOut(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: fKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Image.asset('images/logo.jpg', height: 200),
                  ),
                ],
              ),
              Text('Your Region is ${user!.region}'),

              // Replace TextFormField with TextField in Containers
              buildBorderedTextField(
                controller: coastalAmountController,
                labelText: 'Coastal Amount',
              ),
              const SizedBox(height: 10.0),

              buildBorderedTextField(
                controller: eastAmountController,
                labelText: 'East Amount',
              ),
              const SizedBox(height: 10.0),

              buildBorderedTextField(
                controller: northAmountController,
                labelText: 'North Amount',
              ),
              const SizedBox(height: 10.0),

              buildBorderedTextField(
                controller: southAmountController,
                labelText: 'South Amount',
              ),
              const SizedBox(height: 10.0),

              buildBorderedTextField(
                controller: lebanonAmountController,
                labelText: 'Lebanon Amount',
              ),
              const SizedBox(height: 10.0),

              ElevatedButton(
                onPressed: () async {
                  if (fKey.currentState!.validate()) {
                    print('#############');
                    await UserController.addMonthAmounts(
                      cA: double.parse(coastalAmountController.text),
                      sA: double.parse(southAmountController.text),
                      nA: double.parse(northAmountController.text),
                      eA: double.parse(eastAmountController.text),
                      lA: double.parse(lebanonAmountController.text),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'The Amounts have been added',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create a bordered TextField
  Widget buildBorderedTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an Amount';
          }
          return null;
        },
      ),
    );
  }
}