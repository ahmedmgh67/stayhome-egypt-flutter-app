import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: MyHomePage(),
        top: false,
        bottom: false,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var decoded;
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    network();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("StayHome Egypt"),
        title: Image.asset("assets/logo.png"),
      ),
      endDrawer: Drawer(
        child: Container(
          color: Colors.blue,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  'ساعدنا فى نشر المبادرة:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                title: Wrap(
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.shareAlt,
                      color: Colors.white,
                    ),
                    Text(
                      '    مشاركة  ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                onTap: () => Share.share(
                    "مبادرة StayHome \n Website: https://staysafeegypt.com \n Application: "),
              ),
              ListTile(
                title: Text(
                  ' تصميم وبرمجة:  ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                // onTap: ()=>launch("https://ahmedgamal.ga"),
                title: Wrap(
                  children: <Widget>[
                    InkWell(
                        onTap: () => launch("https://internetplus.biz"),
                        child: Image.network(
                            "https://stayhomeegypt.com/img/logo-ip-rtl.png")),
                    SizedBox(
                      width: 6,
                    ),
                    InkWell(
                        onTap: () => launch("https://ahmedgamal.ga"),
                        child: Text(
                          ' احمد محمد جمال ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                          textDirection: TextDirection.rtl,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: !loaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: 20,
              itemBuilder: (context, i) {
                return _buildListItem(
                    context: context,
                    name: decoded[i]['title'],
                    image: decoded[i]['img'],
                    link: decoded[i]['href']);
              },
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  Widget _buildListItem({BuildContext context, image, name, link}) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => CategoryPage(link))),
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        height: 170.0,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 5.0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      // "Mebina Nepal",
                      name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    // SizedBox(
                    //   height: 5.0,
                    // ),
                    // Text("UI/UX designer | Foodie | Kathmandu"),
                    // SizedBox(
                    //   height: 16.0,
                    // ),
                    Container(
                      height: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  // padding: EdgeInsets.all(40),
                  child: Material(
                    elevation: 5.0,
                    shape: CircleBorder(),
                    child: Container(
                      width: 80,
                      // margin: EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        // child: Image.network(
                        //   image,
                        // ),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          placeholder: (_, s) => Image.asset("assets/logo.png"),
                        ),
                      ),
                      // radius: 40.0,
                      // maxRadius: 30,

                      // minRadius: 10,
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle
                          // backgroundImage:
                          //     NetworkImage(image, scale: 0.5)),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void network() async {
    var request =
        await http.get("https://staysafe-egypt.herokuapp.com/api/v1/feed");
    print(request.body);
    decoded = jsonDecode(request.body);
    setState(() {
      loaded = true;
    });
  }
}

class CategoryPage extends StatefulWidget {
  final link;
  CategoryPage(this.link);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool loaded = false;
  var decoded;
  @override
  void initState() {
    super.initState();
    network();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png"),
      ),
      body: !loaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: decoded.length,
              itemBuilder: (context, i) {
                return _buildListItem(
                  context: context,
                  name: decoded[i]['title'],
                  image: decoded[i]['img'],
                  nameo: decoded[i]['links'][0]['name'],
                  hro: decoded[i]['links'][0]['link'],
                  typeo: decoded[i]['links'][0]['type'],
                  namet: decoded[i]['links'][1]['name'],
                  hrt: decoded[i]['links'][1]['link'],
                  typet: decoded[i]['links'][1]['type'],
                  nameth: decoded[i]['links'][2]['name'],
                  hrth: decoded[i]['links'][2]['link'],
                  typeth: decoded[i]['links'][2]['type'],
                );
              },
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  Container _buildListItem(
      {BuildContext context,
      image,
      name,
      links,
      nameo,
      hro,
      typeo,
      namet,
      hrt,
      typet,
      nameth,
      typeth,
      hrth}) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: 240.0,
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: 40.0, left: 0.0, right: 0.0, bottom: 10.0),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 5.0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      // "Mebina Nepal",
                      name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    buildSocialLinks(context: context, hro: hro, hrt: hrt, hrth: hrth, nameo: nameo,namet: namet,nameth: nameth,typeo: typeo, typet: typet,typeth: typeth)
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Material(
                  elevation: 5.0,
                  shape: CircleBorder(),
                  child: Container(
                    width: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        placeholder: (_, s) => Image.asset("assets/logo.png"),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSocialLinks({BuildContext context,
      nameo,
      hro,
      typeo,
      namet,
      hrt,
      typet,
      nameth,
      typeth,
      hrth}) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListTile(
              onTap: () => launch(hro),
              trailing: icon(typeo),
              contentPadding: EdgeInsets.all(4),
              title: Text(
                // "302",
                nameo.toString().replaceAll(" ", ''),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.all(4),
              onTap: () => launch(hrt),
              trailing: icon(typet),
              title: Text(
                namet.replaceAll(" ", ''),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.all(4),
              trailing: icon(typeth),
              onTap: () => launch(hrth),
              title: Text(
                // "120",
                nameth!= null?nameth.replaceAll(" ", ''):"",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // subtitle: Text("Following".toUpperCase(),
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 12.0)),
            ),
          ),
        ],
      ),
    );
  }

  void network() async {
    var request = await http
        .get("https://staysafe-egypt.herokuapp.com/api/v1/" + widget.link);
    print(request.body);
    decoded = jsonDecode(request.body);
    setState(() {
      loaded = true;
    });
  }

  FaIcon icon(type) {
    if (type == "web-btn")
      return FaIcon(FontAwesomeIcons.globe);
    else if (type == "face-btn")
      return FaIcon(FontAwesomeIcons.facebook);
    else if (type == "insta-btn")
      return FaIcon(FontAwesomeIcons.instagram);
    else if (type == "whats-btn")
      return FaIcon(FontAwesomeIcons.whatsapp);
    else if (type == "android-btn")
      return FaIcon(FontAwesomeIcons.googlePlay);
    else if (type == "apple-btn")
      return FaIcon(FontAwesomeIcons.appStore);
    else if (type == "call-btn")
      return FaIcon(FontAwesomeIcons.phone);
    else
      return FaIcon(FontAwesomeIcons.globe);
  }
}
