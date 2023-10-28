import 'package:salesproject/user_model.dart';
import 'package:flutter/material.dart';



class CommitionScreen extends StatelessWidget {
  UserModel user;
  String year;
  String month;
  Map<String, dynamic> userCommitions;
  CommitionScreen({super.key,
  required this.user,
  required this.year,
  required this.month,
  required this.userCommitions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Commition'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20.0),
        crossAxisCount: 2,
        childAspectRatio: 3,
        children: <Widget>[
          const Text('Number:'),
          Text(user.number?.toString() ?? 'N/A'),
          const Text('Name:'),
          Text(user.name ?? 'N/A'),
          const Text('Year:'),
          Text(year ?? 'N/A'),
          const Text('Month:'),
          Text(month ?? 'N/A'),
          const Text('Registration Date:'),
          Text(user.date ?? 'N/A'),
          const Text('Southern region:'),
          Text('${userCommitions['southernRegion']}SYP' ?? 'N/A'),
          const Text('Coastal region:'),
          Text('${userCommitions['coastalRegion']}SYP' ?? 'N/A'),
          const Text('Northern Region:'),
          Text('${userCommitions['northernRegion']}SYP' ?? 'N/A'),
          const Text('Eastern Region:'),
          Text('${userCommitions['easternRegion']}SYP' ?? 'N/A'),
          const Text('Lebanon:'),
          Text('${userCommitions['lebanonRegion']}SYP' ?? 'N/A'),
          const Text('Monthly commission:'),
          Text('${userCommitions['totalCommition']}SYP' ?? 'N/A'),



        ],
      ),
    );
  }
}
