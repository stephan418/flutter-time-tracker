class Ticker {
  const Ticker();

  Stream<int> tick() {
    return Stream.periodic(const Duration(seconds: 1), (i) => i + 1);
  }
}
