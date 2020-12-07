import 'package:SeeThroughMe/home.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String name = "";
  String phone1 = "";
  String phone2 = "";
  String code1 = "";
  String code2 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Form"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        children: [
          buildNameField(),
          SizedBox(height: 20),
          buildContactField('Contact 1'),
          SizedBox(height: 20),
          buildContactField('Contact 2'),
          SizedBox(height: 20),
          buildSubmitButton()
        ],
      ),
    );
  }

  buildSubmitButton() {
    return Container(
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 15),
        onPressed: () {
          phone1 = code1 + phone1;
          phone2 = code2 + phone2;
          print("Name: $name");
          List<String> phoneNumbers = [phone1, phone2];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        phoneNos: phoneNumbers,
                      )));
        },
        child: Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        color: Colors.blue,
      ),
    );
  }

  buildNameField() {
    return TextFormField(
      onChanged: (val) {
        name = val.trim();
      },
      style: TextStyle(fontSize: 20),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  buildContactField(String labelText) {
    return Row(
      children: [
        CountryCodePicker(
          initialSelection: 'IN',
          onInit: (countryCode) {
            if (labelText == 'Contact 1')
              code1 = countryCode.dialCode;
            else
              code2 = countryCode.dialCode;
          },
          onChanged: (countryCode) {
            if (labelText == 'Contact 1')
              code1 = countryCode.dialCode;
            else
              code2 = countryCode.dialCode;
          },
        ),
        SizedBox(width: 20),
        Expanded(
          child: TextFormField(
            onChanged: (val) {
              if (labelText == 'Contact 1')
                phone1 = val.trim();
              else
                phone2 = val.trim();
            },
            style: TextStyle(fontSize: 15),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: labelText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
