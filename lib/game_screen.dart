import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double ballX = 0;
  double ballY = 0;
  int score = 0;
  int timeLeft = 30;
  bool gameStarted = false;
  Timer? _gameTimer;
  final Random random = Random();

  void startGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      gameStarted = true;
    });

    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          gameStarted = false;
        });
        showGameOverDialog();
      }
    });

    moveBall();
  }

  void moveBall() {
    if (!gameStarted) return;
    setState(() {
      ballX = random.nextDouble();
      ballY = random.nextDouble();
    });
  }

  void tapBall() {
    if (!gameStarted) return;
    setState(() {
      score++;
    });
    moveBall();
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Game Over!"),
        content: Text("Your Score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
            child: const Text("Play Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    const ballSize = 60.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("🎯 Tap The Ball Game"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              "Score: $score",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              "Time: $timeLeft s",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (gameStarted)
            Positioned(
              left: ballX * (screenW - ballSize),
              top: ballY * (screenH - ballSize - 150),
              child: GestureDetector(
                onTap: tapBall,
                child: Container(
                  width: ballSize,
                  height: ballSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text("🎯", style: TextStyle(fontSize: 24)),
                  ),
                ),
              ),
            ),
          if (!gameStarted)
            Center(
              child: ElevatedButton(
                onPressed: startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Start Game"),
              ),
            ),
        ],
      ),
    );
  }
}
