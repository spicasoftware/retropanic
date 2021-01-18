String mercuryStatus (status) {
  if (status) {
    return "retrograde";
  } else {
    return "not retrograde";
  }
}

int dayDifference (nextChange) {
  var _currTime = new DateTime.now();
  var _difference = nextChange.difference(_currTime);
  return _difference.inDays;
}