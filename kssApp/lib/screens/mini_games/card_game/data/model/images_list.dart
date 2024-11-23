import 'dart:math';

import 'package:project_kss/screens/mini_games/card_game/data/model/image_q.dart';

class ImagesList {
  List<ImageQ> list;

  ImagesList({required this.list});

  ImagesList createQuiz() {
    ImagesList quiz = ImagesList(list: [...list, ...list]);
    quiz.list.shuffle(Random());
    return quiz;
  }
}