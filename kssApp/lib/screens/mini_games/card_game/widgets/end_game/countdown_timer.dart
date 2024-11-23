import 'dart:async';

import 'package:project_kss/screens/mini_games/card_game/providers/match_provider.dart';
import 'package:project_kss/screens/mini_games/card_game/widgets/end_game/timeout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountdownTimer extends ConsumerStatefulWidget {
  const CountdownTimer({Key? key, required this.start}) : super(key: key);
  final int start;

  @override
  ConsumerState<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends ConsumerState<CountdownTimer> {
  late Timer _timer;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _seconds = widget.start;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) => setState(
            () {
          if (ref.watch(matchChecked)) {
            timer.cancel();
            showDialog(
              context: context,
              barrierDismissible:
              false,
              barrierColor: Colors.black87,
              builder: (BuildContext context) {
                return const TimeOutDialog(
                  title: 'Tebrikler!!',
                  content:
                  'Oyunu kazandın! Tekrar oynamak için "Tekrar Oyna" tuşuna tıkla!',
                );
              },
            );
          }
          if (_seconds < 1) {
            timer.cancel();
            showDialog(
              context: context,
              barrierDismissible:
              false,
              barrierColor: Colors.black87,
              builder: (BuildContext context) {
                return const TimeOutDialog(
                  title: 'Süre Bitti!',
                  content:
                  "Üzgünüz, süre bitti. Tekrar Oynamak İçin Butona Tıkla!",
                );
              },
            );
          } else {
            --_seconds;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom:14.0),
          child: Text('Kalan Zaman: $_seconds',style: TextStyle(fontSize: 20),),
        ),
      ],
    );
  }
}