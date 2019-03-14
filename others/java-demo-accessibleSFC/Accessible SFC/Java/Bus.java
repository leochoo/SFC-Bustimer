public class Bus{
	int hour;
	int minute;
	int second;
	int busNum;

  Bus(int hh, int mm, int number ){ // static constructor
  	this.hour = hh;
  	this.minute = mm;
  	this.busNum = number;
  	this.second = 0;
  }

  Bus() {		// empty constructor
		this.hour = 0;
		this.minute = 0;
		this.busNum = 0;
		this.second = 0;
	}

  public int toDecimal(){ //easy comparison of two different times in absolute value
		return this.hour*10000 + this.minute*100 + this.second; //second is 00
	}
}
