import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  var myItems = [
    {
      "name": "Deekshith Raj Basa",
      "image_dp":
          "https://images.unsplash.com/profile-1505896116223-c60402aa89aa?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32",
      "post": "https://miro.medium.com/max/3200/1*73IgUxPfyXUKZAaIXgutrw.png",
      "post_description": "Hey! my first flutter post.",
      "post_date": "26 september",
      "likes": "random 1, random 2 and 130 others",
    },
    {
      "name": "Devakalyan",
      "image_dp":
          "https://images.unsplash.com/profile-1505896116223-c60402aa89aa?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32",
      "post": "https://miro.medium.com/max/563/0*OZM3usTilxtCsKGG.jpg",
      "post_description": "Yey my first flutter tutorial.",
      "post_date": "26 september",
      "likes": "random 1, random 2 and 30 others",
    },
    {
      "name": "Devakalyan",
      "image_dp":
          "https://images.unsplash.com/profile-1505896116223-c60402aa89aa?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32",
      "post": "https://miro.medium.com/max/2560/1*vgN2zojqiIYu23JPVuaSiA.jpeg",
      "post_description": "Yey my first flutter tutorial.",
      "post_date": "26 september",
      "likes": "random 1, random 2 and 30 others",
    },
    {
      "name": "Devakalyan",
      "image_dp":
          "https://images.unsplash.com/profile-1505896116223-c60402aa89aa?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32",
      "post": "https://miro.medium.com/max/2444/1*EzFXz-Bu9ZirsBQmHiyMgg.png",
      "post_description": "Yey my first flutter tutorial.",
      "post_date": "26 september",
      "likes": "random 1, random 2 and 30 others",
    },
  ];

  @override
  Widget build(BuildContext context) {
    print(myItems[0]["name"]);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white70,
        leading: Icon(
          Icons.camera_alt,
          color: Colors.black87,
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Instagram_logo.svg/1200px-Instagram_logo.svg.png"),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.live_tv, color: Colors.black87),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.send, color: Colors.black87),
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: myItems.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(myItems[index]["image_dp"])),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          myItems[index]["name"],
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.black87,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Image.network(myItems[index]["post"]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.favorite_border),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.comment),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.send),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.bookmark_border),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                    child: Text(
                      myItems[index]["likes"],
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          myItems[index]["name"],
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            myItems[index]["post_description"],
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                    child: Text(
                      myItems[index]["post_date"],
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
