class Box {
	double w,h,d;
}
class BoxDemo {
	public static void main (String args[]) {
		Box m = new Box();
		m.w = 10;
		m.d = 20;
		m.h = 15;
		double vol = m.w * m.d * m.h;
		System.out.println("Vol = " + vol);
	}
}
