(* 
    
    Hello world in Cool
   
    CIS 461 Spring 2015 UOregon 
 *)

class Main inherits IO {
  main() : Object {
    -- This is a line comment
    -- This program will count down from 3 I hope and then print hello world.
    out_int(3);
    out_string("\n");
    out_int(2);
    out_string("\n");
    out_int(1);
    out_string("Hello, world!\n");
  } ;
} ;
