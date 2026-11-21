abstract final class GreetingHelper {
  static const int _morningStartHour = 5;
  static const int _afternoonStartHour = 12;
  static const int _eveningStartHour = 17;


  static String getGreeting(DateTime now) {
    final hour = now.hour;

    if (hour >= _eveningStartHour) return 'Good evening';

    if (hour >= _afternoonStartHour) return 'Good afternoon';

    if (hour >= _morningStartHour) return 'Good morning';

    return 'Hello';
  }
}
