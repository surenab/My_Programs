class ForEach {
	public static void main (String args[]) {
		int nums[] = {1,2,3,4,5,6,7,8};
		int sum = 0;
		for (int x:nums) {
			sum+=x;
		}
		System.out.println("sum = " + sum);
	}
}
