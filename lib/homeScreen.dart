import 'package:flutter/material.dart';
import 'package:instagram_clone/profile.dart';

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  var myItems = [
    {
      'name': 'Deekshith Raj Basa',
      'image_dp':
          'https://p16.muscdn.com/img/musically-maliva-obj/1616856337685525~c5_1080x1080.jpeg',
      'post': 'https://miro.medium.com/max/3200/1*73IgUxPfyXUKZAaIXgutrw.png',
      'post_description': 'Hey! my first flutter post.',
      'post_date': '26 september',
      'likes': 'random 1, random 2 and 130 others',
      'posts': '211',
      'followers': '211k',
      'following': '120',
      'bio': {
        'bio_quote': 'hey im user',
        'link': 'deekshithrajbasa.github.io',
      },
      'images': [
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/4/42/Shaqi_jrvej.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/4/42/Shaqi_jrvej.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
      ]
    },
    {
      'name': 'Devakalyan',
      'image_dp':
          'https://p16.muscdn.com/img/musically-maliva-obj/1616856337685525~c5_1080x1080.jpeg',
      'post': 'https://miro.medium.com/max/563/0*OZM3usTilxtCsKGG.jpg',
      'post_description': 'Yey my first flutter tutorial.',
      'post_date': '26 september',
      'likes': 'random 1, random 2 and 30 others',
      'posts': '21',
      'followers': '11k',
      'following': '10',
      'bio': {
        'bio_quote': 'hey im user',
        'link': 'deekshithrajbasa.github.io',
      },
      'images': [
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/4/42/Shaqi_jrvej.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/4/42/Shaqi_jrvej.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
      ]
    },
    {
      'name': 'raj',
      'image_dp':
          'https://p16.muscdn.com/img/musically-maliva-obj/1616856337685525~c5_1080x1080.jpeg',
      'post': 'https://miro.medium.com/max/2560/1*vgN2zojqiIYu23JPVuaSiA.jpeg',
      'post_description': 'Yey my first flutter tutorial.',
      'post_date': '26 september',
      'likes': 'random 1, random 2 and 30 others',
      'posts': '11',
      'followers': '12k',
      'following': '10',
      'bio': {
        'bio_quote': 'hey im user',
        'link': 'deekshithrajbasa.github.io',
      },
      'images': [
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/4/42/Shaqi_jrvej.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/4/42/Shaqi_jrvej.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
      ]
    },
    {
      'name': 'varshith',
      'image_dp':
          'https://p16.muscdn.com/img/musically-maliva-obj/1616856337685525~c5_1080x1080.jpeg',
      'post': 'https://miro.medium.com/max/2444/1*EzFXz-Bu9ZirsBQmHiyMgg.png',
      'post_description': 'Yey my first flutter tutorial.',
      'post_date': '26 september',
      'likes': 'random 1, random 2 and 30 others',
      'posts': '211',
      'followers': '211k',
      'following': '120',
      'bio': {
        'bio_quote': 'hey im user',
        'link': 'deekshithrajbasa.github.io',
      },
      'images': [
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/4/42/Shaqi_jrvej.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
        'https://img.etimg.com/thumb/msid-68721417,width-643,imgsize-1016106,resizemode-4/nature1_gettyimages.jpg',
        'https://content1.jdmagicbox.com/events/A179884/A179884_list_20180124151437.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/4/42/Shaqi_jrvej.jpg',
        'https://specials-images.forbesimg.com/imageserve/5d35eacaf1176b0008974b54/960x0.jpg?cropX1=790&cropX2=5350&cropY1=784&cropY2=3349',
        'https://ichef.bbci.co.uk/images/ic/720x405/p06mym7x.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/d/d1/Charminar-Pride_of_Hyderabad.jpg',
        'https://cdn-ep19.pressidium.com/wp-content/uploads/2018/02/what-is-a-DSLR-camera-canon.jpg',
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    // print(myItems[0]['name']);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white70,
        leading: Icon(
          Icons.camera_alt,
          color: Colors.black87,
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Instagram_logo.svg/1200px-Instagram_logo.svg.png'),
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
                            child: Image.network(
                              myItems[index]['image_dp'],
                              height: 35.0,
                              width: 35.0,
                              fit: BoxFit.fill,
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => profile(
                                          myprofile: myItems[index],
                                        )));
                          },
                          child: Text(
                            myItems[index]['name'],
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700),
                          ),
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
                  Image.network(
                    myItems[index]['post'],
                    width: MediaQuery.of(context).size.width,
                  ),
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
                      myItems[index]['likes'],
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
                          myItems[index]['name'],
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            myItems[index]['post_description'],
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
                      myItems[index]['post_date'],
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
