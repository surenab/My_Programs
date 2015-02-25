class Average {
	public static void main (String args[]) {
		double nums[] = {10.1,10.2,10.3,10.5};
		double result = 0;
		int i;
		for(i=0;i<4;i++) {
			result = result + nums[i];
		}
		System.out.println(result/4);
	}
}
