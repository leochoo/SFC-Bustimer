import java.util.*;

public class FromSFC{

//SFC -> Shonandai

	public static final Bus[] weekdayTT =
	{
		new Bus(7,0,25), new Bus(7,5,24), new Bus(7,15,25), new Bus(7,28,23), new Bus(7,32,25), new Bus(7,35,23), new Bus(7,40,25), new Bus(7,45,25),
		new Bus(7,47,24), new Bus(7,55,25),

		new Bus(8,2,24), new Bus(8,8,23), new Bus(8,12,25), new Bus(8,18,23), new Bus(8,22,25), new Bus(8,24,24), new Bus(8,32,25), new Bus(8,37,23),
		new Bus(8,42,25), new Bus(8,50,23), new Bus(8,55,25),

		new Bus(9,0,24), new Bus(9,10,25), new Bus(9,20,23), new Bus(9,30,25), new Bus(9,35,24), new Bus(9,50,25),

		new Bus(10,0,25), new Bus(10,7,24), new Bus(10,20,23), new Bus(10,27,24), new Bus(10,40,23), new Bus(10,50,23),

		new Bus(11,0,23), new Bus(11,7,24), new Bus(11,20,23), new Bus(11,30,23), new Bus(11,40,25), new Bus(11,50,23),

		new Bus(12,0,23), new Bus(12,10,24), new Bus(12,20,25), new Bus(12,30,24), new Bus(12,40,25), new Bus(12,50,23),

		new Bus(13,0,23), new Bus(13,10,23), new Bus(13,20,23), new Bus(13,30,25), new Bus(13,40,23), new Bus(13,50,23),

		new Bus(14,0,23), new Bus(14,10,23), new Bus(14,20,23), new Bus(14,30,23), new Bus(14,38,23), new Bus(14,46,23), new Bus(14,54,23),

		new Bus(15,2,23), new Bus(15,9,23), new Bus(15,17,23), new Bus(15,22,25), new Bus(15,25,23), new Bus(15,32,23), new Bus(15,39,25), new Bus(15,44,23),
		new Bus(15,52,25), new Bus(15,57,23),

		new Bus(16,4,25), new Bus(16,9,23), new Bus(16,14,23), new Bus(16,21,25), new Bus(16,26,23), new Bus(16,34,25), new Bus(16,39,23), new Bus(16,46,25),
		new Bus(16,51,23), new Bus(16,59,25),

		new Bus(17,6,25), new Bus(17,11,23), new Bus(17,19,25), new Bus(17,24,23), new Bus(17,31,25), new Bus(17,36,23), new Bus(17,44,25), new Bus(17,49,23),
		new Bus(17,56,23),

		new Bus(18,4,25), new Bus(18,9,23), new Bus(18,17,25), new Bus(18,21,23), new Bus(18,29,25), new Bus(18,36,25), new Bus(18,41,23), new Bus(18,48,23),
		new Bus(18,56,25),


		new Bus(19,2,25), new Bus(19,8,23), new Bus(19,16,25), new Bus(19,21,23), new Bus(19,31,23), new Bus(19,41,23), new Bus(19,51,23),

		new Bus(20,1,23), new Bus(20,11,23), new Bus(20,21,23), new Bus(20,31,23), new Bus(20,41,23), new Bus(20,51,23),

		new Bus(21,1,23), new Bus(21,16,23), new Bus(21,31,23), new Bus(21,51,23),


		new Bus(22,11,23), new Bus(22,31,23), new Bus(22,51,23)


	};
	public static final Bus[] saturdayTT =
	{
		new Bus(7,0,25), new Bus(7,5,24), new Bus(7,15,25), new Bus(7,28,23), new Bus(7,32,25), new Bus(7,35,23), new Bus(7,40,25), new Bus(7,45,25),
		new Bus(7,47,24), new Bus(7,55,25),

		new Bus(8,2,24), new Bus(8,8,23), new Bus(8,12,25), new Bus(8,18,23), new Bus(8,22,25), new Bus(8,27,23), new Bus(8,32,25), new Bus(8,33,24),
		new Bus(8,42,25), new Bus(8,50,23), new Bus(8,55,25),

		new Bus(9,0,23), new Bus(9,10,25), new Bus(9,20,24), new Bus(9,30,25), new Bus(9,37,24), new Bus(9,50,25),

		new Bus(10,0,23), new Bus(10,10,24), new Bus(10,24,23), new Bus(10,36,23), new Bus(10,48,23),

		new Bus(11,0,23), new Bus(11,10,24), new Bus(11,24,23), new Bus(11,36,23), new Bus(11,48,23), new Bus(11,58,25),


		new Bus(12,10,23), new Bus(12,20,24), new Bus(12,30,23), new Bus(12,40,23), new Bus(12,49,25), new Bus(12,56,25),

		new Bus(13,0,23), new Bus(13,8,25), new Bus(13,10,23), new Bus(13,16,25), new Bus(13,20,23), new Bus(13,29,25), new Bus(13,37,25), new Bus(13,51,25),

		new Bus(14,1,25), new Bus(14,11,23), new Bus(14,21,23), new Bus(14,31,23), new Bus(14,41,25), new Bus(14,51,23),


		new Bus(15,1,23), new Bus(15,11,23), new Bus(15,21,23), new Bus(15,31,23), new Bus(15,41,23), new Bus(15,51,23),

		new Bus(16,1,23), new Bus(16,11,23), new Bus(16,21,23), new Bus(16,31,23), new Bus(16,41,23), new Bus(16,51,23),

		new Bus(17,1,25), new Bus(17,11,23), new Bus(17,21,23), new Bus(17,31,23), new Bus(17,41,23),new Bus(17,51,25),


		new Bus(18,1,23), new Bus(18,11,25), new Bus(18,21,23), new Bus(18,31,23), new Bus(18,41,25), new Bus(18,51,23),

		new Bus(19,1,25), new Bus(19,11,23), new Bus(19,21,23), new Bus(19,31,23), new Bus(19,41,23), new Bus(19,51,23),

		new Bus(20,1,23), new Bus(20,11,23), new Bus(20,31,23)




	};
	public static final Bus[] holidayTT =
	{
		new Bus(8,10,24), new Bus(8,25,23), new Bus(8,40,23),

		new Bus(9,10,24), new Bus(9,40,23),

		new Bus(10,10,24), new Bus(10,25,23), new Bus(10,40,23),

		new Bus(11,10,24), new Bus(11,40,23),

		new Bus(12,10,24), new Bus(12,25,23), new Bus(12,40,23),

		new Bus(13,10,24), new Bus(13,30,23), new Bus(13,45,23),

		new Bus(14,0,23), new Bus(14,15,23), new Bus(14,30,23), new Bus(14,45,23),

		new Bus(15,0,23), new Bus(15,15,23), new Bus(15,30,23), new Bus(15,45,23),

		new Bus(16,0,23), new Bus(16,15,23), new Bus(16,30,23), new Bus(16,45,23),

		new Bus(17,0,23), new Bus(17,15,23), new Bus(17,30,23), new Bus(17,45,23),

		new Bus(18,15,23), new Bus(18,45,23),

		new Bus(19,45,23)


	};

}
