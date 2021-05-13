// BT19CSE082 Yashpal Singh Baghel
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'config.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      print('Changes');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Startup Name Generator',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme.currentTheme(),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  RandomWords({Key key}) : super(key : key);
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[]; 
  final _biggerFont = TextStyle(fontSize: 18.0);

  TextEditingController textFieldController = TextEditingController();

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              heroTag: 'brightness_high',
              onPressed: () {
                currentTheme.switchTheme();
              },
              label: Text('Switch Theme'),
              icon: Icon(Icons.brightness_high),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 50.0,
            child: FloatingActionButton(
              heroTag: 'next',
              onPressed: () {
                int length = _saved.length;
                if(length != 4)
                {
                  showAlertDialog(context); 
                }
                else
                {    
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute(text: _saved)),
                  );
                }
              },
              child: Icon(Icons.arrow_forward_sharp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Attention !!!"),
      content: Text("Please select exactly 4 favourites"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, //...to here.
      ),
    );
  }
}
/*
class RandomWords extends StatefulWidget {
  RandomWords({Key key}) : super(key : key);
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
*/
class SecondRoute extends StatelessWidget {
  // This widget is the root of your application.
  final text;
  SecondRoute({Key key, @required this.text}) : super(key : key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flipping Tiles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Center(
            child: Text(
              'Flutter GridView',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        body: Column(children: <Widget>[
          Row(
            //ROW 1
            children: [
              getContainer1(),
              getContainer2(),
            ],
          ),
          Row(//ROW 2
              children: [
            getContainer3(),
            getContainer4(),
          ]),
          Container(
              child: FloatingActionButton(
              heroTag: 'next',
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_rounded),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
            
        ]),
      ),
    );
  }

  Widget getContainer1() {
    return Container(
      height: 200,
      width: 200,
      margin: EdgeInsets.all(25.0),

      child: WidgetFlipper(
              frontWidget: Container(
                color: Colors.transparent,
                child: Image.asset(
                  'lion1.jpg', 
                  fit:BoxFit.fill,
                  ),
              ),

              backWidget: Container(
                color: Colors.red[300],
                child: Center(
                  child: Text(
                    text[0].asPascalCase.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),

    );
  }

  Widget getContainer2() {
    return Container(
      height: 200,
      width: 200,
      margin: EdgeInsets.all(25.0),

      child: WidgetFlipper(
              frontWidget: Container(
                color: Colors.transparent,
                child: Image.asset(
                  'tiger1.jpg', 
                  fit:BoxFit.fill,
                  ),
              ),

              backWidget: Container(
                color: Colors.blue[300],
                child: Center(
                  child: Text(
                    text[1].asPascalCase.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),

    );
  }

  Widget getContainer3() {
    return Container(
      height: 200,
      width: 200,
      margin: EdgeInsets.all(25.0),

      child: WidgetFlipper(
              frontWidget: Container(
                color: Colors.transparent,
                child: Image.asset(
                  'lion2.jpg', 
                  fit:BoxFit.fill,
                  ),
              ),

              backWidget: Container(
                color: Colors.yellow[300],
                child: Center(
                  child: Text(
                    text[2].asPascalCase.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),

    );
  }

  Widget getContainer4() {
    return Container(
      height: 200,
      width: 200,
      margin: EdgeInsets.all(25.0),
      
      child: WidgetFlipper(
              frontWidget: Container(
                color: Colors.transparent,
                child: Image.asset(
                  'tiger2.jpg', 
                  fit:BoxFit.fill,
                ),
              ),

              backWidget: Container(
                color: Colors.green[300],
                child: Center(
                  child: Text(
                    text[3].asPascalCase.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),

    );
  }
}

class WidgetFlipper extends StatefulWidget {
  WidgetFlipper({
    Key key,
    this.frontWidget,
    this.backWidget,
  }) : super(key: key);

  final Widget frontWidget;
  final Widget backWidget;

  @override
  _WidgetFlipperState createState() => _WidgetFlipperState();
}

class _WidgetFlipperState extends State<WidgetFlipper> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  bool isFrontVisible = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2).chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0).chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedCard(
          animation: _backRotation,
          child: widget.backWidget,
        ),
        AnimatedCard(
          animation: _frontRotation,
          child: widget.frontWidget,
        ),
        _tapDetectionControls(),
      ],
    );
  }

  Widget _tapDetectionControls() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        GestureDetector(
          onTap: _leftRotation,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        GestureDetector(
          onTap: _rightRotation,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  void _leftRotation() {
    _toggleSide();
  }

  void _rightRotation() {
    _toggleSide();
  }

  void _toggleSide() {
    if (isFrontVisible) {
      controller.forward();
      isFrontVisible = false;
    } else {
      controller.reverse();
      isFrontVisible = true;
    }
  }
}

class AnimatedCard extends StatelessWidget {
  AnimatedCard({
    this.child,
    this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        transform.rotateY(animation.value);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}