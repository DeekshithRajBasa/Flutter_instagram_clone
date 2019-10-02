import 'package:instagram_clone/singleimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  profile({@required this.myprofile});
  Map myprofile = new Map();
  @override
  _profileState createState() => _profileState(myProfileData: myprofile);
}

class _profileState extends State<profile> {
  _profileState({@required this.myProfileData});

  Map myProfileData = new Map();
  List images = new List();

  @override
  Widget build(BuildContext context) {
//    print(myProfileData['images'][0]);
    images = myProfileData['images'];
//    print(images);
    var height = MediaQuery.of(context).size.height;
    var heightfactor = height / height;
    print(height);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0.0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
            )),
        title: Text(
          '${myProfileData['name']}',
          style: TextStyle(color: Colors.black87),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => singleimage(
                                  link: myProfileData['image_dp'],
                                )));
                  },
                  child: Material(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(60.0),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60.0),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.0),
                            child: Image.network(
                              myProfileData['image_dp'],
                              height: 90.0,
                              width: 90.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(myProfileData['posts'],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w700)),
                            Text('posts',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                )),
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          children: <Widget>[
                            Text(myProfileData['followers'],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w700)),
                            Text('followers',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                )),
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          children: <Widget>[
                            Text(myProfileData['following'],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w700)),
                            Text('following',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                )),
                          ],
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                color: Color(0xffDBDBDB),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0, horizontal: 30.0),
                                      child: Center(
                                        child: Text(
                                          'MESSAGE',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Color(0xffDBDBDB),
                              child: Padding(
                                padding: const EdgeInsets.all(1.5),
                                child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 5.0),
                                      child: Icon(Icons.group_add)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Color(0xffDBDBDB),
                              child: Padding(
                                padding: const EdgeInsets.all(1.5),
                                child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 5.0),
                                      child: Icon(Icons.arrow_drop_down)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 15.0, bottom: 5.0),
            child: Text(myProfileData['name'],
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 15.0, bottom: 5.0),
            child: Text(
              myProfileData['bio']['bio_quote'],
              style: TextStyle(color: Colors.black87, fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 15.0, bottom: 5.0),
            child: Text(
              myProfileData['bio']['link'],
              style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),
            ),
          ),

          //=============  container ===============
          Container(
            height: 110.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 8.0),
                    child: Material(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(60.0),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60.0),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
                              child: Image.network(
                                images[index],
                                height: 70.0,
                                width: 70.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          //=============  container ===============
          Divider(),
          Container(
            width: double.infinity,
            height: height - 0.50,
            child: GridView.builder(
                physics: FixedExtentScrollPhysics(),
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext cotext, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Material(
                      child: Container(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => singleimage(
                                          link: images[index],
                                        )));
                          },
                          child: Image.network(
                            images[index],
                          ),
                        ),
                      ),
                      color: Colors.white,
                    ),
                  );
                }),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            title: Text(''),
            activeIcon: Icon(
              Icons.home,
              color: Colors.black87,
            ),
          ),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.search,
                color: Colors.black87,
              ),
              icon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              title: Text('')),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.add_circle,
                color: Colors.black87,
              ),
              icon: Icon(
                Icons.add_circle,
                color: Colors.grey,
              ),
              title: Text('')),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.favorite,
                color: Colors.black87,
              ),
              icon: Icon(
                Icons.favorite,
                color: Colors.grey,
              ),
              title: Text('')),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.account_circle,
                color: Colors.black87,
              ),
              icon: Icon(
                Icons.account_circle,
                color: Colors.grey,
              ),
              title: Text('')),
        ],
      ),
    );
  }
}
