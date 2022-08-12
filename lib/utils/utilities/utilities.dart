int createUniqueId() {
  return DateTime.now().microsecondsSinceEpoch.remainder(100000);
}

int createUniqueIdTimesUp() {
  return DateTime.now().microsecondsSinceEpoch.remainder(100000);
}
