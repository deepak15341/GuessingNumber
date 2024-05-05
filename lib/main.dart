import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String name = 'Guess The Number';
    return MaterialApp(
      title: name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue[900],
      ),
      home: HomePage(
        title: name,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int numberOfTries = 0;
  int numberOfTimes = 5;
  int noOfTimesWon = 0;
  int noOfTimesLost = 0;

  final guessedNumber = TextEditingController();

  static Random ran = Random();
  int randomNumber = ran.nextInt(20) + 1;

  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ulBorder = const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.pink),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'No Of Times Lost = $noOfTimesLost',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                Text(
                  'No Of Times Won = $noOfTimesWon',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shadowColor: Colors.blueGrey,
              color: Colors.white,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'I\'m thinking of a number between 1 and 20. You only have  tries.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Can you guess it?',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Please enter a number'),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        controller: guessedNumber),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shadowColor: Colors.green,
                    backgroundColor: Colors.green,
                    minimumSize: const Size(200, 40),
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: guess,
                child: const Text(
                  "Guess",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              )),
        ],
      ),
    );
  }

  void guess() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (isEmpty()) {
      makeToast("You did not enter a number");
      return;
    }

    int guess = int.parse(guessedNumber.text);

    if (guess > 20 || guess < 1) {
      makeToast("Choose number between 1 and 20");
      guessedNumber.clear();
      return;
    }

    numberOfTries++;
    if (numberOfTries == numberOfTimes && guess != randomNumber) {
      setState(() {
        noOfTimesLost = noOfTimesLost + 1;
      });
      showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.slideFromBottom,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Center(
                  child: Text(
                'Game Over',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
              content: Text(
                'The Number That i have Guessed is $randomNumber',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.green,
                          backgroundColor: Colors.green,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width / 4, 40),
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text(
                        "Exit",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.green,
                          backgroundColor: Colors.green,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width / 4, 40),
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Retry",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
      numberOfTries = 0;
      randomNumber = ran.nextInt(20) + 1;
      guessedNumber.clear();
      return;
    }

    if (guess > randomNumber) {
      makeToast("Lower! Number of Tries is: $numberOfTries");
    } else if (guess < randomNumber) {
      makeToast("Higher! Number of Tries is: $numberOfTries");
    } else {
      setState(() {
        noOfTimesWon = noOfTimesWon + 1;
      });
      showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.slideFromBottom,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: _controller,
                    blastDirectionality: BlastDirectionality.explosive,
                    blastDirection: pi,
                    minBlastForce: 10,
                    maxBlastForce: 50,
                    particleDrag: 0.05,
                    emissionFrequency: 0.00,
                    numberOfParticles: 80,
                    gravity: 0.15,
                    shouldLoop: true,
                    colors: const [
                      Colors.red,
                      Colors.green,
                      Colors.blueAccent,
                      Colors.yellow,
                      Colors.pink
                    ],
                  ),
                )),
                AlertDialog(
                  title: const Center(
                      child: Text(
                    'Congratulations!',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
                  content: const Text(
                    'You Have Guessed the correct Number!',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.green,
                              backgroundColor: Colors.green,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width / 4, 40),
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text(
                            "Exit",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.green,
                              backgroundColor: Colors.green,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width / 4, 40),
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Play Again",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
      numberOfTries = 0;
      randomNumber = ran.nextInt(20) + 1;
    }
    guessedNumber.clear();
  }

  void makeToast(String feedback) {
    Fluttertoast.showToast(
        msg: feedback,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }

  bool isEmpty() {
    return guessedNumber.text.isEmpty;
  }
}
