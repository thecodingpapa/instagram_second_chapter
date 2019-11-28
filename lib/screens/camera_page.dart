import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/constants/size.dart';
import 'package:instagram_thecodingpapa/data/user.dart';
import 'package:instagram_thecodingpapa/screens/share_post_page.dart';
import 'package:instagram_thecodingpapa/widgets/my_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  final User user;

  const CameraPage({Key key, @required this.camera, @required this.user})
      : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int _selectedIndex = 1;
  var _pageController = PageController(initialPage: 1);
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Photo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          _gellaryPage(),
          _takePhotoPage(),
          _takeVideoPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.grey[400],
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[50],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/grid.png")),
            title: Text('GALLERY'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/actionbar_camera.png")),
            title: Text('PHOTO'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/actionbar_camera.png")),
            title: Text('VIDEO'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Widget _gellaryPage() {
    return Container(
      color: Colors.green,
    );
  }

  Widget _takePhotoPage() {
    return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Column(
              children: <Widget>[
                Container(
                  width: size.width,
                  height: size.width,
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.topCenter,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          width: size.width,
                          height: size.width / _controller.value.aspectRatio,
                          child: CameraPreview(
                              _controller), // this is my CameraPreview
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _attemptTakePhoto(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(
                                side: BorderSide(
                                    color: Colors.grey[300], width: 20)),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          return MyProgressIndicator();
        });
  }

  Widget _takeVideoPage() {
    return Container(
      color: Colors.deepOrange,
    );
  }

  void _attemptTakePhoto(BuildContext context) async {
    try {
      await _initializeControllerFuture;
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}_${widget.user.username}.png',
      );

      await _controller.takePicture(path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SharePostPage(
            imgFile: File(path),
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
