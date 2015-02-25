class ElseIf {
	public static void main (String args[]) {
		int m = 4;
		String season;
		if (m == 12 || m == 1 || m == 2)
			season = "dzmer";
		else if (m == 3 || m == 4 || m == 5)
			season = "garun";
		else if (m == 6 || m == 7 || m == 8) 			
			season = "amar";
		else 
			season = "ashun";
		System.out.println(season);
	}
}
