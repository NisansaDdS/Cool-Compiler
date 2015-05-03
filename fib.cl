class Main inherits IO {
  main(): Object {{
    out_string("Give an integer between 0 and 20: ");
    let input: Int <- in_int() in
      if 20 < input then
          out_string("please enter a number which is less than 20\n")
      else {
          if input < 0 then
              out_string("please enter a number which is greater than 10\n")
              else {
                  out_string("The fibonacci of ").out_int(input);
                  out_string(" is ").out_int(fib(input));
                  out_string("\n");
              }fi;
      }fi;
  }};

    fib(num: Int): Int {
        if num = 0 then 0
            else
                if num = 1 then 1
                    else
                        fib(num-1)+fib(num-2) fi fi
    };
    

    
  
    
    
};
