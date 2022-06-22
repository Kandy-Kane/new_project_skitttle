import 'package:flutter/material.dart';
import 'test.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  //==================================================================//
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  )..repeat(reverse: false);

  late final AnimationController imageController = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  )..repeat(reverse: false);

  //=====================================================================//
  late AnimationController sizeController;
  late Animation sizeAnimation;

  late AnimationController dialogSizeController;
  late Animation dialogSizeAnimation;

  //==========================================================//
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(5.5, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(0.0, 0.20, curve: Curves.ease),
  ));

  //=========================================================//

  late final Animation<Offset> _offsetAnimation2 = Tween<Offset>(
    begin: Offset(5.5, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
      parent: _controller, curve: Interval(0.20, 0.40, curve: Curves.easeOut)));

//==========================================================================//
  late final Animation<Offset> _offsetAnimation3 = Tween<Offset>(
    begin: Offset(0.0, 5.5),
    end: Offset.zero,
  ).animate(CurvedAnimation(
      parent: _controller, curve: Interval(0.40, 0.50, curve: Curves.easeOut)));

  //========================================================================//
  late final Animation<Offset> _offsetAnimation4 = Tween<Offset>(
    begin: Offset(0.0, 5.5),
    end: Offset.zero,
  ).animate(CurvedAnimation(
      parent: _controller, curve: Interval(0.60, 0.80, curve: Curves.easeOut)));
  //=========================================================================//

  @override
  void initState() {
    super.initState();
    // _controller2.forward();
    sizeController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    dialogSizeController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    sizeAnimation =
        Tween<double>(begin: 50, end: 100.0).animate(sizeController);
    sizeController.addListener(() {
      setState(() {});
    });

    // Repeat the animation after finish
    sizeController.repeat(reverse: true);

    dialogSizeAnimation =
        Tween<double>(begin: 0, end: 250.0).animate(dialogSizeController);
    dialogSizeController.addListener(() {
      setState(() {});
    });
    repeatOnce();
  }

  void repeatOnce() async {
    await _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: 100,
          height: 100,
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await pickImage('camera');
                      Navigator.of(context).pop();
                      _scaleImage();
                      // await imageController.forward();
                    },
                    child: Text('Camera')),
                ElevatedButton(
                    onPressed: () async {
                      await pickImage('gallery');
                      Navigator.of(context).pop();
                    },
                    child: Text('Gallery'))
              ],
            ),
          )),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _imageHolder(BuildContext context) {
    return Container(
        child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(imageController),
            child: GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
              },
              child: Image.file(_imageFile),
            )));
  }

  void _scaleImage() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _imageHolder(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  //YO THIS IS SUPER IMPORTANT FOR ANIMATING DIALOG TRANSITIONS

  void _scaleDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  final picker = ImagePicker();
  File _imageFile = File('');

  Future pickImage(choice) async {
    if (choice == 'gallery') {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = File(pickedFile!.path);
      });
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        _imageFile = File(pickedFile!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: colorAnimation.value,
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/personaBackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _offsetAnimation,
                    child: Container(
                      width: 200,
                      height: 150,
                      // padding: EdgeInsets.all(0.0),
                      child: Image.asset('images/personaText.png'),
                    ),
                  ),

                  //====================================================================//

                  SlideTransition(
                    position: _offsetAnimation2,
                    child: Container(
                      width: 150,
                      height: 150,
                      // padding: EdgeInsets.only(left: 8.0),
                      child: Image.asset('images/spinText.png'),
                    ),
                  ),
                  //===================================================================//
                ],
              ),
              SlideTransition(
                position: _offsetAnimation3,
                child: Container(
                  // padding: EdgeInsets.only(left: 8.0),
                  child: Image.asset('images/wouldYouLikeToSpinText.png'),
                ),
              ),

              //==================================================================//
              SlideTransition(
                position: _offsetAnimation4,
                child: Container(
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    width: 100,
                    height: 100,
                    // padding: EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                        onTap: () {
                          _scaleDialog();
                        },
                        child: Icon(
                          Icons.camera_alt,
                          size: sizeAnimation.value,
                        ))),

                //=================================================================//
              ),
              Container(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                    child: Text("next")),
              )
            ])));
  }
}
