class OverloadDemo {
	void test() {
		System.out.println("empaty");
	}
	void test(int a) {
		System.out.println(a);
	}
	void test(int a,int b) {
		System.out.println("a= "+a+" b= "+b);
	}
}
class Overload {
	public static void main(String args[]) {
		OverloadDemo ob = new OverloadDemo();
		ob.test();
		ob.test(6);
		ob.test(4,7);
	}
}
