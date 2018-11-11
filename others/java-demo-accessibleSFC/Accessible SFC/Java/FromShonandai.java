import java.util.*;

public class FromShonandai{

//Shonandai -> SFC

	public static final Bus[] weekdayTT =
	{
		new Bus(7,10,23), new Bus(7,17,23), new Bus(7,24,25), new Bus(7,30,23), new Bus(7,35,25), new Bus(7,40,23), new Bus(7,44,23), new Bus(7,48,23),
		new Bus(7,53,25), new Bus(7,56,23),

		new Bus(8,1,25), new Bus(8,4,23), new Bus(8,9,25), new Bus(8,12,23), new Bus(8,17,25), new Bus(8,20,23), new Bus(8,24,23), new Bus(8,28,23),
		new Bus(8,35,25), new Bus(8,40,23), new Bus(8,45,25), new Bus(8,49,23), new Bus(8,55,25), new Bus(8,59,23),

		new Bus(9,4,25), new Bus(9,8,23), new Bus(9,12,23), new Bus(9,16,23), new Bus(9,22,25), new Bus(9,26,23), new Bus(9,32,25), new Bus(9,36,23),
		new Bus(9,40,23), new Bus(9,50,25), new Bus(9,55,23),

		new Bus(10,0,23), new Bus(10,5,23), new Bus(10,12,25), new Bus(10,17,23), new Bus(10,25,25), new Bus(10,30,23), new Bus(10,35,23), new Bus(10,40,23),
		new Bus(10,45,23), new Bus(10,55,23),

		new Bus(11,0,23), new Bus(11,5,23), new Bus(11,10,23), new Bus(11,15,23), new Bus(11,20,23), new Bus(11,30,23), new Bus(11,40,23), new Bus(11,50,23),

		new Bus(12,0,25), new Bus(12,10,23), new Bus(12,20,23), new Bus(12,25,23), new Bus(12,30,23), new Bus(12,35,23), new Bus(12,40,23), new Bus(12,45,25),
		new Bus(12,50,23), new Bus(12,55,23),

		new Bus(13,5,25), new Bus(13,15,24), new Bus(13,25,23), new Bus(13,35,23), new Bus(13,45,24), new Bus(13,55,25),

		new Bus(14,5,23), new Bus(14,15,24), new Bus(14,20,23), new Bus(14,25,23), new Bus(14,35,23), new Bus(14,45,24), new Bus(14,55,23),

		new Bus(15,5,23), new Bus(15,15,24), new Bus(15,25,23), new Bus(15,35,23), new Bus(15,40,25), new Bus(15,45,24), new Bus(15,52,23),

		new Bus(16,0,25), new Bus(16,5,23), new Bus(16,10,25), new Bus(16,15,24), new Bus(16,21,25), new Bus(16,27,23), new Bus(16,33,23), new Bus(16,39,25),
		new Bus(16,45,24), new Bus(16,52,25),

		new Bus(17,0,23), new Bus(17,8,25), new Bus(17,15,24), new Bus(17,21,25), new Bus(17,27,25), new Bus(17,33,23), new Bus(17,39,25), new Bus(17,45,24),
		new Bus(17,50,25), new Bus(17,57,23),

		new Bus(18,5,25), new Bus(18,15,24), new Bus(18,23,25), new Bus(18,30,23), new Bus(18,35,25), new Bus(18,42,24), new Bus(19,45,24), new Bus(18,47,25),
		new Bus(18,54,25),

		new Bus(19,3,23), new Bus(19,13,25), new Bus(19,17,24), new Bus(19,21,25), new Bus(19,27,23), new Bus(19,33,25), new Bus(19,39,23), new Bus(19,55,23),

		new Bus(20,5,23), new Bus(20,25,23), new Bus(20,35,23), new Bus(20,50,24),

		new Bus(21,5,23), new Bus(20,15,24), new Bus(21,20,24), new Bus(21,35,23), new Bus(21,50,24)



	};
	//Saturday time table
	public static final Bus[] saturdayTT =
	{

		new Bus(7,15,23), new Bus(7,24,25), new Bus(7,30,23), new Bus(7,35,25), new Bus(7,40,23), new Bus(7,44,23), new Bus(7,48,23), new Bus(7,53,25),
		new Bus(7,56,23),

		new Bus(8,1,25), new Bus(8,9,25), new Bus(8,4,23), new Bus(8,12,23), new Bus(8,17,25), new Bus(8,20,23), new Bus(8,25,23), new Bus(8,32,25),
		new Bus(8,37,23), new Bus(8,45,25), new Bus(8,50,23), new Bus(8,57,25),

		new Bus(9,2,23), new Bus(9,10,25), new Bus(9,15,23), new Bus(9,22,25), new Bus(9,28,23), new Bus(9,37,25), new Bus(9,43,23), new Bus(9,52,25),

		new Bus(10,0,23), new Bus(10,12,25), new Bus(10,24,23), new Bus(10,36,23), new Bus(10,48,23),

		new Bus(11,0,23), new Bus(11,12,23), new Bus(11,24,23), new Bus(11,36,23), new Bus(11,50,23),

		new Bus(12,0,23), new Bus(12,10,23), new Bus(12,20,25), new Bus(12,30,23), new Bus(12,40,23), new Bus(12,50,23),

		new Bus(13,0,24), new Bus(13,7,25), new Bus(13,15,25), new Bus(13,21,23), new Bus(13,29,25), new Bus(13,37,25), new Bus(13,43,24), new Bus(13,51,25),

		new Bus(14,0,25), new Bus(14,6,23), new Bus(14,15,25), new Bus(14,25,25), new Bus(14,35,23), new Bus(14,45,24), new Bus(14,55,23),

		new Bus(15,5,25), new Bus(15,15,24), new Bus(15,25,23), new Bus(15,35,23), new Bus(15,45,24), new Bus(15,55,23),

		new Bus(16,5,23), new Bus(16,15,24), new Bus(16,25,23), new Bus(16,35,23), new Bus(16,45,24), new Bus(16,55,23),

		new Bus(17,5,23), new Bus(17,15,24), new Bus(17,25,25), new Bus(17,35,23), new Bus(17,45,24), new Bus(17,55,23),

		new Bus(18,05,24), new Bus(18,15,25), new Bus(18,25,23), new Bus(18,35,25), new Bus(18,45,24), new Bus(18,55,23),

		new Bus(19,5,25), new Bus(19,15,24), new Bus(19,25,25), new Bus(19,35,23), new Bus(19,45,24), new Bus(19,55,23),

		new Bus(20,10,23)



	};
	//Holiday & Sunday time table
	public static final Bus[] holidayTT =
	{

		new Bus(7,35,23), new Bus(7,50,23),

		new Bus(8,5,23), new Bus(8,20,23), new Bus(8,35,23), new Bus(8,50,23),

		new Bus(9,5,23), new Bus(9,20,23), new Bus(9,35,23), new Bus(9,50,23),

		new Bus(10,5,23), new Bus(10,20,23), new Bus(10,35,23), new Bus(10,50,23),

		new Bus(11,5,23), new Bus(11,20,23), new Bus(11,35,23), new Bus(11,50,23),

		new Bus(12,5,23), new Bus(12,20,23), new Bus(12,50,23),

		new Bus(13,20,23), new Bus(13,50,24),

		new Bus(14,20,23), new Bus(14,35,23), new Bus(14,50,24),

		new Bus(15,20,23), new Bus(15,50,24),

		new Bus(16,5,23), new Bus(16,20,23), new Bus(16,50,24),

		new Bus(17,20,23), new Bus(17,50,24),

		new Bus(18,20,23), new Bus(18,50,24),

		new Bus(19,20,23), new Bus(19,50,24)

	};
}
