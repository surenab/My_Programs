class Box2 {
	double w,h,d;
	void volume() {
		System.out.println("Vol = " + w*h*d);
	}
}
class BoxDemo13 {
	public static void main(String args[]) {
		Box2 m1 = new Box2();
		Box2 m2 = new Box2();
		m1.w = 10;m1.h = 15;m1.d = 20;
		m2.w = 3;m2.h = 6;m2.d = 9;
		m1.volume();
		m2.volume();
	}
}

class Box3 {
	double w,h,d;
	double volume() {
		return w*h*d;
	}
	void setDim(double ww,double hh,double dd) {
		w = ww;
		d = dd;
		h = hh;
	}
}
class BoxDemo23 {
	public static void main(String args[]) {
		Box3 m1 = new Box3();
		Box3 m2 = new Box3();
		m1.setDim(10,20,15);
		m2.setDim(3,6,9);
		System.out.println(m1.volume());
		System.out.println(m2.volume());
	}
}



class Box4 {
	double w,h,d;
	double volume() {
		return w*h*d;
	}
	Box4(double ww,double hh,double dd) {
		w = ww;
		d = dd;
		h = hh;
	}
class Box41 {
	double w,h,d;
	double volume() {
		return w*h*d;
	}
	Box4(double w,double h,double d) {
		this.w = w;
		this.d = d;
		this.h = h;
	}
}
class BoxDemo3 {
	public static void main(String args[]) {
		Box4 m1 = new Box4(10,20,15);
		Box4 m2 = new Box4(3,6,9);
		System.out.println(m1.volume());
		System.out.println(m2.volume());
	}
}
