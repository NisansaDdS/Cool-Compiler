class mathStuff{

    var : Int := 0;
    value() : Int { var };

    set_var(num : Int) : SELF_TYPE {
    	 {
           var := num;
       	   self;
         }
    };

    increment(num : Int) : SELF_TYPE {
     
    (let x : Int in
        {
          x := num + 1;
          var := x;
        }
     )

    }
}

class Main inherits IO {

    number: Int := 0;
    flag: Bool := true;
    incrementer : mathStuff; 

    main() : Object {
    
     incrementer := (new mathStuff);
     
     while flag do 
     {
      incrementer := (new mathStuff).increment(incrementer.value());
      if incrementer.value() > 10 then 
       {
        flag := false
       } 
      
      number := incrementer.value();
     }   
     od;
     out_string("incrementing complete");

    };

};
