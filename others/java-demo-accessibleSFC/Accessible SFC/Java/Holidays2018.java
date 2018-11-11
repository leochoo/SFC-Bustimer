import java.util.*;


public class Holidays2018{


 static Map<Integer, Integer> holidays2018 = new HashMap<Integer, Integer>();
 static
 {
     // {month, date}
	holidays2018.put(1, 1);
	holidays2018.put(1, 8);
	holidays2018.put(2, 11); //sunday holiday
	holidays2018.put(2, 12);
	holidays2018.put(3, 21);
	holidays2018.put(4, 29); // sunday holiday
	holidays2018.put(4, 30);
	holidays2018.put(5, 3);
	holidays2018.put(5, 4);
	holidays2018.put(5, 5);
	//no holiday in June
	holidays2018.put(7, 16);
	holidays2018.put(8, 11);
	holidays2018.put(9, 17);
	holidays2018.put(9, 23); //sunday holiday
	holidays2018.put(9, 24);
	holidays2018.put(10, 8);
	holidays2018.put(11, 3);
	holidays2018.put(11, 23);
	holidays2018.put(12, 23);
	holidays2018.put(12, 24);
 }

}
