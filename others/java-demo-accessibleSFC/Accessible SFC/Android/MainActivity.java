package org.androidtown.hello0111;

import android.os.Bundle;
import android.speech.tts.TextToSpeech;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import static android.speech.tts.TextToSpeech.ERROR;

import static org.androidtown.hello0111.Main.lastBusLeft;

public class MainActivity extends AppCompatActivity {

    private TextToSpeech tts; // Declare TTS object

    private TextView textView; // this is where the timer gets displayed
    private TextView textView2; // this is where the timer gets displayed
    //private int staticOrigin = 1;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        textView = (TextView)findViewById(R.id.textView);
        textView2 = (TextView)findViewById(R.id.textView2);

        // Generate TTS instance
        tts = new TextToSpeech(this, new TextToSpeech.OnInitListener() {
            @Override
            public void onInit(int status) {
                if(status != ERROR) {
                    // Select language
                    tts.setLanguage(Locale.US);
                }
            }
        });


        Thread t = new Thread() {

            @Override
            public void run() {
                try {
                    while (!isInterrupted()) {
                        Thread.sleep(1000);
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                // update TextView here!
                                updateTime(textView);
                                updateTime2(textView2);
                            }
                        });
                    }
                } catch (InterruptedException e) {
                }
            }
        };

        t.start();


    }

    public void readText(View v){
        //위 화면에서 글 가져와서 읽기
        tts.setSpeechRate(1.0f);
        tts.speak(" Departing From Shonandai.", TextToSpeech.QUEUE_FLUSH, null);
        tts.speak(textView.getText().toString(),TextToSpeech.QUEUE_ADD, null);
    }
    public void readText2(View v){
        //위 화면에서 글 가져와서 읽기
        tts.setSpeechRate(1.0f);
        tts.speak(" Departing From SFC.", TextToSpeech.QUEUE_FLUSH, null);
        tts.speak(textView2.getText().toString(),TextToSpeech.QUEUE_ADD, null);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // TTS 객체가 남아있다면 실행을 중지하고 메모리에서 제거한다.
        // If TTS object is alive, stop it and remove it from the memory.
        if(tts != null){
            tts.stop();
            tts.shutdown();
            tts = null;
        }
    }

//    public int switchOrigin(int origin){
//        // 1: Shonandai -> SFC
//        if(origin == 1){
//            staticOrigin = 2;
//        }
//        else{//2: SFC -> Shonandai
//            staticOrigin = 1;
//        }
//        return origin;
//    }

    public void updateTime(View v){

            int origin = 1; // TEST ORIGIN

            Calendar currentTime = Calendar.getInstance();
            currentTime.setTimeInMillis(System.currentTimeMillis());
            int YEAR = currentTime.get(Calendar.YEAR);
            int MONTH = currentTime.get(Calendar.MONTH)+1; // January now becomes 1
            int DATE = currentTime.get(Calendar.DATE);
            int DAY_OF_WEEK = currentTime.get(Calendar.DAY_OF_WEEK); //1: Sunday, 2: Monday ...
            int HOUR = currentTime.get(Calendar.HOUR_OF_DAY); // 24 hour clock
            int MINUTE = currentTime.get(Calendar.MINUTE);
            int SECOND = currentTime.get(Calendar.SECOND);

            Bus nextBus = getNextBus(currentTime, MONTH, DATE, origin);
            displayTime(currentTime, nextBus, R.id.textView);

    }
    public void updateTime2(View v){

        int origin = 2; // TEST ORIGIN

        Calendar currentTime = Calendar.getInstance();
        currentTime.setTimeInMillis(System.currentTimeMillis());
        int YEAR = currentTime.get(Calendar.YEAR);
        int MONTH = currentTime.get(Calendar.MONTH)+1; // January now becomes 1
        int DATE = currentTime.get(Calendar.DATE);
        int DAY_OF_WEEK = currentTime.get(Calendar.DAY_OF_WEEK); //1: Sunday, 2: Monday ...
        int HOUR = currentTime.get(Calendar.HOUR_OF_DAY); // 24 hour clock
        int MINUTE = currentTime.get(Calendar.MINUTE);
        int SECOND = currentTime.get(Calendar.SECOND);

        Bus nextBus = getNextBus(currentTime, MONTH, DATE, origin);
        displayTime(currentTime, nextBus, R.id.textView2);


    }

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

    public void displayTime(Calendar currentTime, Bus nextBus, int display){
        String newTime = "";

        newTime += "Time Left until the next bus is  ";
        long diff = busTimeToMillisec(nextBus) - currentTime.getTimeInMillis();
        long diffSeconds = diff / 1000 % 60;
        long diffMinutes = diff / (60 * 1000) % 60;
        long diffHours = diff / (60 * 60 * 1000) % 24;
        newTime += diffHours + " hours, ";
        newTime += diffMinutes + " minutes, ";
        newTime += diffSeconds + " seconds.";
        newTime += "\nThe next bus is "+ nextBus.busNum + ".";
        newTime += "\nThe next bus leaves at "+ formatTime2(busTimeToMillisec(nextBus))+ ".";
        newTime += "\nCurrent Time is " + formatTime2(currentTime.getTimeInMillis())+ ".";


        TextView tv = (TextView)findViewById(display);
        tv.setText(newTime);
    }

    public static String formatTime2(long diff){

        Date difference = new Date(diff);
        //return a formatted number
        return new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").format(difference); //may need to switch for formatting

    }



}

