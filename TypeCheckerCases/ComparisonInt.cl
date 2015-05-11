(* This is a simple program that would raise one number to the power of another number *)
class Main inherits IO {
    main() : Object {
	(let c : Power <- (new Power).init() in
	    {	       
			out_string("\nFinished...\n");			
	    }
	)
    };
};

class Power inherits IO {
	
	b : Int;
    p : Int;
	res : Int;
	j : Int;
	k : Main;
	

    init() : Power {
	{
		out_string("Input the base: ");
		b <- in_int();
		out_string("Input the power: ");
		p <- in_int();
		res <- b;	
		j <- p;
		while 0 < (j-1) loop 
		{
			res <- res * b;
			j <- j - 1;			
		} 
		pool;
		out_string("The answer is: ");
		out_int(res);
	    self;
	}
    };
	
	test():Int{{
		 if b = k then 0
            else 1 fi;
	}};

    
};