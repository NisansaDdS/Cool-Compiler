class Main inherits IO {
  main(): Object {{
    out_string("Enter a non-negative integer: ");

    let input: Int <- in_int() in
      if input < 0 then
        out_string("ERROR: Number must be greater-than or equal-to 0\n")
      else {
        out_string("You can't tell, but ").out_int(input);
        out_string(" is now represented internally as a string like so: ").out_string(toString(input));
      }
      fi;
  }};

  modulo(num1: Int, num2: Int): Int {
    let diff: Int <- num1 - num2 in
      if diff <= 0 then
        num1
      else
        modulo(diff, num2)
      fi;
  };
  toString(num: Int): String {
    let retStr: String <- "" in
      let digit: Int <- num in
        let postDiv: Int <- num in
	  while postDiv > 0 loop{
	    digit <- modulo(postDiv, 10);
	    postDiv <- postDiv / 10;
            if digit = 0 then
              retStr <- retStr.concat("0");
            else{
	      if digit = 1 then
	        retStr <- retStr.concat("1");
              else{
	        if digit = 2 then
	          retStr <- retStr.concat("2");	    
                else{
	          if digit = 3 then
	            retStr <- retStr.concat("3");
                  else{
	            if digit = 4 then
	              retStr <- retStr.concat("4");	    
                    else{
	              if digit = 5 then
	                retStr <- retStr.concat("5");	    
                      else{
	                if digit = 6 then
	                  retStr <- retStr.concat("6");	    
                        else{
	                  if digit = 7 then
	                    retStr <- retStr.concat("7");	    
                          else{
	                    if digit = 8 then
	                      retStr <- retStr.concat("8");	    
                            else{
	                      if digit = 9 then
	                        retStr <- retStr.concat("9");	    
                              else{
	                        retStr <- retStr.concat("?");				     
	    }}}}}}}}}}}pool;
	  retStr   
  }
};
