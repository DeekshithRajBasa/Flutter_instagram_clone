import 'package:flutter/material.dart';


class textsample extends StatefulWidget {
  textsample({Key key}) : super(key: key);

  _textsampleState createState() => _textsampleState();
}

class _textsampleState extends State<textsample> {

  List dee = new List();
  String valueS =  "";
  @override
  Widget build(BuildContext context) {
    print(dee);
    return Container(
       child: Scaffold(appBar: AppBar(title: Text("Text sample"),actions: <Widget>[Icon(Icons.favorite)],),
       
       drawer: Drawer(

       ),
       body: Container(
         child: Column(
           children: <Widget>[


            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Enter Email",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Email cannot be empty";
                        }else{
                          print(val);
                          valueS = val;
                            
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                               
            )
             ,
             FlatButton(
               child: Text("append text"),
               onPressed: (){
                 setState(() {
                      print(valueS);
                  dee.add(valueS); 
                   dee.add(valueS);
                 });
               },

             ),
           ],
         ),),
       ),
    );
  }
}