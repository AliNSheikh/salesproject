import 'package:flutter/material.dart';

class HorizontalRadioButtons extends StatefulWidget {
  const HorizontalRadioButtons({super.key});

  @override
  _HorizontalRadioButtonsState createState() => _HorizontalRadioButtonsState();
}

class _HorizontalRadioButtonsState extends State<HorizontalRadioButtons> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildRadioButton('Value 1'),
        buildRadioButton('Value 2'),
        buildRadioButton('Value 3'),
        buildRadioButton('Value 4'),
        buildRadioButton('Value 5'),
      ],
    );
  }

  Widget buildRadioButton(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
        ),
        Text(value),
      ],
    );
  }
}