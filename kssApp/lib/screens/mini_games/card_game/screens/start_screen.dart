import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_kss/screens/mini_games/mini_games.dart';

import '../providers/match_provider.dart';

class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({super.key});

  @override
  ConsumerState<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 48).animate(_controller)
      ..addListener(() {
        if (_animation.value >= 48) {
          _controller.stop();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top:MediaQuery.of(context).size.width/1.3),
            child: Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => TextButton(
                  onPressed: () {
                    ref.read(matchChecked.notifier).setStatus(false);
                    Navigator.pushNamed(context, '/play_screen');
                  },
                  child: Text(
                    'Oyna!',
                    style: TextStyle(
                      fontSize: _animation.value,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:50.0),
            child: Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => TextButton(
                  onPressed: () {
                    ref.read(matchChecked.notifier).setStatus(false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MiniGames(),
                      ),
                    );
                  },
                  child: Text(
                    'Çıkış',
                    style: TextStyle(
                      fontSize: _animation.value/2,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}