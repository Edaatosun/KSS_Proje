import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/collection.dart';
import '../data/model/image_q.dart';

List<ImageQ> imageData = data.createQuiz().list;

final listCard = Provider((ref) => imageData);