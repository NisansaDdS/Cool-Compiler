--This is supposed to check how calling conventions works, by passing what would be simple or complex data types in java, and then having a function that modifies them in different ways.

class A{
	a : Int;
	b : String;
	c : B;
	d : B;

	init() : A {
		{
			a <- 1;
			b <- "1";
			c <- (new B).init(1);
			d <- (new C).init(1);
			self;
		}
	}

	runTest(): A{
		{
			checkCallingConventions(a, b, c, d);
			io : IO <- new IO();
			io.out_int(a);
			io.out_string(b);
			io.out_int(c.get());
			io.out_int(d.get());
		}

	checkCallingConventions(a_: Int, b_: String, c_: B, d_: B) : A {
		{
			a_ <- 0;
			b_ <- "0";
			c_.modify(0);
			d <- (new D).init(0);
		}
	}
};

class B{
	value: int;
	init(value_ : Int) : B{
		{
			value < value_;
			self;
		}
	}
	modify(value_ : Int) : B{
		{
			value < value_;
		}
	}
	get() : Int{value;}
};

class Main{
	main() : Main {
		a : A <- (new A).init();
		a.runTest();
	}
}
