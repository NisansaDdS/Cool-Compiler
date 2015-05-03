(*
 *	Chris Harmon
 *	CIS 461
 *  This program should hopefully do some simple arithmetic operations and check that they work properly.
 *  It will then display the results for each method.
 *  The operations tested are +, -, *, and /.
 *)

class Main inherits IO {

	i : Int := 2;
	main() : Object {
	
		out_string("\nAddition: 2 + 1 = ");
		out_int(add(i);
		
		out_string("\nSubtraction: 2 - 1 = ");
		out_int(subtract(i);
		
		out_string("\nMultiplication: 2 * 2 = ");
		out_int(multi(i);
		
		out_string("\nDivision: 2 / 2 = ");
		out_int(divide(i);
		
	};
	
	add(i: Int): Int {
		i+1
	};
	
	subtract(i: Int): Int {
		i-1
	};
	
	multi(i: Int): Int {
		i*2
	};
	
	divide(i: Int): Int {
		i/2
	};
};