class Main inherits IO {
	inStr : String;
	baseStr : String;
	
	main() : SELF_TYPE {
		out_string("Please enter your name: ");
		inStr <- in_string();
		baseStr <- "Hello ";
		baseStr.concat(inStr);
		out_string(baseStr);
	};
};