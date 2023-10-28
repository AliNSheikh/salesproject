import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salesproject/login_controller.dart';


class UserController {
  static addMonthAmounts({
    required cA,
    required sA,
    required nA,
    required eA,
    required lA,
  }) async {
    var userNumber = LoginController.loggedUser!.number;
    var userRegion = LoginController.loggedUser!.region;
    Map<String, dynamic> regionsAmounts = {
      'Coastal': cA,
      'Northern': nA,
      'Southern': sA,
      'Eastern': eA,
      'Lebanon': lA,
    };
    double commition;
    Map<String, dynamic> dataToInsert = {};
    regionsAmounts.forEach((key, value) {
      if (key == userRegion) {
        if (value <= 1000000) {
          commition = 0.05 * value;
        } else {
          commition = 0.07 * (value - 1000000) + 50000;
        }
      } else {
        if (value < 1000000) {
          commition = 0.03 * value;
        } else {
          commition = 0.04 * (value - 1000000) + 30000;
        }
      }
      dataToInsert['${key.toLowerCase()}Region'] = commition;
    });
    dataToInsert['number'] = userNumber;
    dataToInsert['year'] = DateTime.now().year;
    dataToInsert['month'] = DateTime.now().month;
    print(dataToInsert);
    await FirebaseFirestore.instance
        .collection('sellsCommition')
        .doc()
        .set(dataToInsert);
  }
}
