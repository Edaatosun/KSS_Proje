import 'package:project_kss/screens/mini_games/card_game/providers/match_provider.dart';
import 'package:project_kss/screens/mini_games/card_game/widgets/play_screen/item.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/image_q.dart';

class GridItem extends ConsumerStatefulWidget {
  const GridItem({super.key, required this.data});
  final List<ImageQ> data;

  @override
  ConsumerState<GridItem> createState() => _GridItemState();
}

class _GridItemState extends ConsumerState<GridItem> {
  late List<GlobalKey<FlipCardState>> cardKeys;
  List<int> flippedIndices = [];
  late List<bool> listFlipOnTouch;
  List<int> itemMatch = [];

  @override
  void initState() {
    super.initState();
    cardKeys = List.generate(
        widget.data.length, (index) => GlobalKey<FlipCardState>());
    listFlipOnTouch = List<bool>.filled(widget.data.length, true);
  }

  void process(int index) {
    if (flippedIndices.length < 2) {
      flippedIndices.add(index);
    }
    if (flippedIndices.length == 2) {
      setState(() {
        listFlipOnTouch[flippedIndices[0]] = true;
        listFlipOnTouch[flippedIndices[1]] = true;
        for (var i = 0; i < widget.data.length; i++) {
          if (i != flippedIndices[0] || i != flippedIndices[1]) {
            listFlipOnTouch[i] = false;
          }
        }
      });
    }
  }

  void check() {
    if (flippedIndices.length == 2) {
      String item1 = widget.data[flippedIndices[0]].id;
      String item2 = widget.data[flippedIndices[1]].id;
      setState(() {
        if (item1 == item2) {
          itemMatch.add(flippedIndices[0]);
          itemMatch.add(flippedIndices[1]);
          if (itemMatch.length == cardKeys.length) {
            ref.read(matchChecked.notifier).setStatus(true);
          }
          for (var i = 0; i < listFlipOnTouch.length; i++) {
            if (itemMatch.contains(i)) {
              listFlipOnTouch[i] = false;
            } else {
              listFlipOnTouch[i] = true;
            }
          }
          flippedIndices.clear();
        } else {
          Future.delayed(const Duration(milliseconds: 300), () {
            cardKeys[flippedIndices[0]].currentState!.toggleCard();
            cardKeys[flippedIndices[1]].currentState!.toggleCard();
          });
        }
      });
    }
  }

  void reMatch() {
    setState(() {
      for (var i = 0; i < listFlipOnTouch.length; i++) {
        if (itemMatch.contains(i)) {
          listFlipOnTouch[i] = false;
        } else {
          listFlipOnTouch[i] = true;
        }
      }
      flippedIndices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: widget.data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Item(
            image: widget.data[index],
            cardKey: cardKeys[index],
            flipOnTouch: listFlipOnTouch[index],
            onFlip: () {
              process(index);
            },
            onFlipB2FDone: check,
            onFlipF2BDone: reMatch,
          );
        },
      ),
    );
  }
}