(* This is a simple program that would raise one number to the power of another number *)
class Main inherits IO {
    main() : SELF_TYPE {
	(let c : String <-0, d: Int <- "Hasi" in
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

    
};