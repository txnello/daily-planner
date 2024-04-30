class DateTimeManager {
  int year = 0;
  int month = 0;
  int day = 0;
  int hour = 0;
  int minutes = 0;

  split(String date, String time) {
    List<String> dateParts = date.split("-");
    List<String> timeParts = time.split(":");
    
    this.year = int.parse(dateParts[0]);
    this.month = int.parse(dateParts[1]);
    this.day = int.parse(dateParts[2]);
    this.hour = int.parse(timeParts[0]);
    this.minutes = int.parse(timeParts[1]);
  }
}
