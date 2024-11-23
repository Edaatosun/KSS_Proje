import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchCheckedNotifier extends StateNotifier<bool> {
  MatchCheckedNotifier() : super(false);

  void setStatus(bool check) {
    state = check;
  }
}

final matchChecked = StateNotifierProvider<MatchCheckedNotifier, bool>(
        (ref) => MatchCheckedNotifier());