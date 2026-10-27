import 'package:flutter/material.dart';


class textsample extends StatefulWidget {
  const textsample({super.key});

  @override
  _textsampleState createState() => _textsampleState();
}

class _textsampleState extends State<textsample> {
  List<String> dee = [];
  String valueS = "";

  @override
  Widget build(BuildContext context) {
    print(dee);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Text sample"),
          actions: <Widget>[Icon(Icons.favorite)],
        ),
        drawer: Drawer(),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Enter Email",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Email cannot be empty";
                    } else {
                      print(val);
                      valueS = val;
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              TextButton(
                child: Text("append text"),
                onPressed: () {
                  setState(() {
                    print(valueS);
                    dee.add(valueS);
                    dee.add(valueS);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}