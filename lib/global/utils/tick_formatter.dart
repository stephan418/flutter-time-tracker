class TickFormatter {
  /// Format ticks (seconds) into the format [hours]:minutes:seconds
  static String format(int ticks) {
    final seconds = '${ticks % 60}'.padLeft(2, '0');
    final minutes = '${ticks ~/ 60 % 60}'.padLeft(2, '0');
    final hours = ticks ~/ 3600;

    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}
