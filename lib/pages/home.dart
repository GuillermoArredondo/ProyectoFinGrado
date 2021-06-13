import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/pages/feed_nav.dart';
import 'package:forumdroid/pages/post_nav.dart';
import 'package:forumdroid/pages/profile_nav.dart';
import 'package:forumdroid/pages/search_nav.dart';
import 'package:forumdroid/theme/app_theme.dart';


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TabBarView(children: <Widget>[
        new Feed(), new Search(), new Post(false), new Profile(false)
      ], controller: controller,),
      bottomNavigationBar: new Material(
        child: new TabBar(
          tabs: <Tab>[
            new Tab(
              icon: new Icon(FontAwesomeIcons.bars),
            ),
            new Tab(
              icon: new Icon(FontAwesomeIcons.search),
            ),
            new Tab(
              icon: new Icon(FontAwesomeIcons.plusCircle),
            ),
            new Tab(
              icon: new Icon(FontAwesomeIcons.user),
            )
          ],
          controller: controller,
          
        ),
        color: app_theme.primaryColor,
      ),
    );
  }
}