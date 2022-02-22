import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/screens/new_message_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home_tabs/calls.dart';
import 'home_tabs/camera_tab.dart';
import 'home_tabs/chats.dart';
import 'home_tabs/status_tab.dart';
import 'new_message_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentIndex = 0;
  bool _pinned = true;
  late PermissionStatus contactPermissionStatus;
  // late PermissionStatus cameraPermissionStatus;

  @override
  void initState() {
    super.initState();
    _askPermissions();

    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 1,
    );
    currentIndex = tabController.index;

    tabController.addListener(() {
      currentIndex = tabController.index;

      setState(() {
        currentIndex == 0 ? _pinned = false : _pinned = true;
      });
    });
  }

  void _askPermissions() async {
    contactPermissionStatus = await _getContactPermission();
    //  this.cameraPermissionStatus = await _getCameraPermission();
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.camera.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  @override
  Widget build(BuildContext context) {
    _askPermissions();
    List<Widget> fabIconList = [
      FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          if (contactPermissionStatus == PermissionStatus.granted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewMessageScreen()),
            );
          }
        },
        child: const Icon(Icons.chat),
      ),
      Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              left: 5.0,
              bottom: 10.0,
            ),
            child: FloatingActionButton.small(
              heroTag: "createStatus",
              onPressed: () {},
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.create,
                color: Colors.grey[700],
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: "toCameraScreen",
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () async {
              if (await Permission.camera.request().isGranted) {
                Navigator.pushNamed(context, "/camera_screen");
              }
            },
            child: const Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),
      FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {},
        child: const Icon(Icons.add_call),
      ),
    ];

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).primaryColor,
                pinned: _pinned,
                snap: true,
                floating: true,
                title: const Text(
                  "WhatsApp",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  controller: tabController,

                  //onTap: () {},
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const <Tab>[
                    Tab(
                      icon: Icon(Icons.camera_alt),
                    ),
                    Tab(
                      child: Text("CHATS"),
                    ),
                    Tab(
                      child: Text("STATUS"),
                    ),
                    Tab(
                      child: Text("CALLS"),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              CameraScreen(camera: widget.camera),
              const Chats(),
              const StatusTab(),
              const Calls(),
            ],
          )),
      floatingActionButton:
          currentIndex == 0 ? Container() : fabIconList[currentIndex - 1],
    );
  }
}
