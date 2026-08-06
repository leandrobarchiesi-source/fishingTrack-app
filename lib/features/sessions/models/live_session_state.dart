class LiveSessionState {
  int casts = 1;

  Duration lastCastTime = Duration.zero;

  Duration lastCatchTime = Duration.zero;

  Map<int, int> counters = {};
}