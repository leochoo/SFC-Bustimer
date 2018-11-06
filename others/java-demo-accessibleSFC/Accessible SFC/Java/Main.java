
import java.text.SimpleDateFormat;
import java.util.*;

public class Main{

  static Boolean lastBusLeft = false;
  public static void main(String[] args) {

      // Get user input - if user input is not 1 or 2, loop it.
      int origin = 0;
      do{
        Scanner user_input = new Scanner(System.in);
        System.out.print("Please enter an integer.  1.FromShonandai 2.FromSFC: ");
        if(user_input.hasNextInt()){
             origin = user_input.nextInt();
        }else{
           System.out.println("Please input only a number.");
           continue;
        }

        System.out.println("Your input: "+ origin);
        if(!(origin == 1 || origin == 2)){
          System.out.println("Invalid number. Please try again.");
          continue;
        }
        user_input.close();
      }while(!(origin == 1 || origin == 2));


      // Main Bus timer
      for (int i=0;i<3600;i++ ) {
          // Instantiate currentTime
          Calendar currentTime = Calendar.getInstance();
          currentTime.setTimeInMillis(System.currentTimeMillis());
              int YEAR = currentTime.get(Calendar.YEAR);
              int MONTH = currentTime.get(Calendar.MONTH)+1; // January now becomes 1
              int DATE = currentTime.get(Calendar.DATE);
              int DAY_OF_WEEK = currentTime.get(Calendar.DAY_OF_WEEK); //1: Sunday, 2: Monday ...
              int HOUR = currentTime.get(Calendar.HOUR_OF_DAY); // 24 hour clock
              int MINUTE = currentTime.get(Calendar.MINUTE);
              int SECOND = currentTime.get(Calendar.SECOND);


          // Fetch the bus based on currentTime and origin
          Bus nextBus = getNextBus(currentTime, MONTH, DATE, origin); //일단 nextBus와 origin은 non-static 으로 해보자

          //Display time
          displayTime(currentTime, nextBus);

          try{     Thread.sleep(1000);    } // updates every 1 second
          catch(InterruptedException e){}

          }
  }//end of Main



  public static Bus getNextBus(Calendar currentTime, int month, int date, int origin){
        Bus[] todaySchedule = getSchedule(currentTime, month, date, origin);
        Bus nextBus = new Bus();
        long diff = 0;
        lastBusLeft = false;
        for(int i = 0; i < todaySchedule.length; i++){
          diff = busTimeToMillisec(todaySchedule[i]) - currentTime.getTimeInMillis();
          if( diff>= 0){
            //System.out.println("Bus after current time: "+todaySchedule[i]);
            nextBus = todaySchedule[i];
            break;
          }
        }
        //오늘걸로 끝까지 체크했는데도 버스가 없다 그러면
        //if(  currentTime.getTimeInMillis() >= busTimeToMillisec(todaySchedule[todaySchedule.length-1]) ){ //if today's last bus left or just left
        if( diff < 0 ){ // diff < 0 when last bus left
          //increase the DATE 날짜 늘리고
          Calendar nextDay = Calendar.getInstance();
          nextDay.setTimeInMillis(System.currentTimeMillis());
          nextDay.set(Calendar.DAY_OF_YEAR, nextDay.get(Calendar.DAY_OF_YEAR) + 1); // Add 1 to today 근데 그냥 날짜를 더하면 의미가 있을까? 시간이 그대로면 다음 날로 넘어가는거 아닌가
          int newMonth = nextDay.get(Calendar.MONTH)+1;// make sure Jan = 1
          int newDate = nextDay.get(Calendar.DATE);
          // 오늘 스케쥴을 내일 스케쥴로 바꿔준다
          System.out.println("Last bus has left. Getting the next day's schedule.");
          Bus[] tomorrowSchedule = getSchedule( nextDay, newMonth, newDate, origin );
          //그리고 다시 내일스케쥴 안에서 첫 버스를 찾아서 돌려준다.
          nextBus = tomorrowSchedule[0];
          lastBusLeft = true;

        }

    return nextBus;
  }

  public static Bus[] getSchedule(Calendar currentTime, int month, int date, int origin){
      int dayOfWeek = currentTime.get(Calendar.DAY_OF_WEEK);
      Bus[] todaySchedule = {};
        Boolean isHoliday = false;
        // Check if today is holiday
        if(Holidays2018.holidays2018.containsKey(month) && Holidays2018.holidays2018.get(month) == date){
          isHoliday = true;
        }

        if(origin == 1) {
              //Shonandai -> SFC
              if(isHoliday){ todaySchedule = FromShonandai.holidayTT; }
              else{
                  if(dayOfWeek == 7 ){ // Saturday
                    todaySchedule = FromShonandai.saturdayTT;
                  } else if(dayOfWeek == 1 ){ // Sunday
                    todaySchedule = FromShonandai.holidayTT; //Sunday and Holiday share the same time table
                  } else {
                    todaySchedule = FromShonandai.weekdayTT;
                  }
              }
        }

        else if(origin == 2) {
              // SFC -> Shonandai
              if(isHoliday){ todaySchedule = FromSFC.holidayTT; }
              else{
                  if(dayOfWeek == 7){ // Saturday
                    todaySchedule = FromSFC.saturdayTT;
                  } else if(dayOfWeek == 1){ // Sunday
                    todaySchedule = FromSFC.holidayTT; //Sunday and Holiday share the same time table
                  } else {
                    todaySchedule = FromSFC.weekdayTT;
                  }
              }
        }
    return todaySchedule;
  }



  public static long busTimeToMillisec(Bus bus){

    Calendar busTime = Calendar.getInstance();
    busTime.setTimeInMillis(System.currentTimeMillis());
    busTime.set(Calendar.MILLISECOND, 0);
    busTime.set(Calendar.SECOND, bus.second);
    busTime.set(Calendar.MINUTE, bus.minute);
    busTime.set(Calendar.HOUR_OF_DAY, bus.hour);
    if(lastBusLeft){
      busTime.set(Calendar.DAY_OF_YEAR, busTime.get(Calendar.DAY_OF_YEAR) + 1);
    }
    return busTime.getTimeInMillis();
  }

  public static void timeLeft(Calendar currentTime, Bus nextBus){

    long diff = busTimeToMillisec(nextBus) - currentTime.getTimeInMillis();
      long diffSeconds = diff / 1000 % 60;
      long diffMinutes = diff / (60 * 1000) % 60;
      long diffHours = diff / (60 * 60 * 1000) % 24;
      System.out.print(diffHours + " hours, ");
      System.out.print(diffMinutes + " minutes, ");
      System.out.print(diffSeconds + " seconds.");
      System.out.println();
  }

  public static void displayTime(Calendar currentTime, Bus nextBus){

    System.out.println("Current Time: " + formatTime2(currentTime.getTimeInMillis()));
    System.out.println("The next bus is "+ nextBus.busNum);
    System.out.println("The next leaves at "+ formatTime2(busTimeToMillisec(nextBus)));
    System.out.print("Time Left:  ");
    timeLeft(currentTime, nextBus);
    System.out.println();
  }
  public static String formatTime2(long diff){

      Date difference = new Date(diff);
      String timeleft = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").format(difference); //may need to switch for formatting
      return timeleft;
    }


}
