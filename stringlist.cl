(* 
   This is really just a linked list with a string at each node
*)

class LongString {
  str: String := "";
  bef: LongString;
  aft: LongString;
  
  
  
  append(left : LongString, right : LongString) : SELF_TYPE {
	if (left.getAfter()) = void then {
      if (right.getBefore()) = void then {
	    left.setAfter(right);
	    right.setBefore(left);
	    self;
	  }
	  append(left,right.getBefore());
	  self;
	}
	append(left.getAfter(), right);
	self;
  }
  
  
  
  setBefore(item : LongString) SELF_TYPE {
    bef := item;
	self;
  }
  setAfter(item : LongString) SELF_TYPE {
    aft := item;
	self;
  }
  
  getBefore() LongString {
    bef;
  }
  getAfter() LongString {
    aft;
  }
  
  next() LongString {
    getAfter();
  }
  last() LongString {
    getBefore();
  }
  
  setString(strIn : String) SELF_TYPE {
    str := strIn;
	self;
  }
  getString() String {
    str;
  }
}

class Main {
  main(): SELF_TYPE{
    longStrA := (new LongString);
	longStrB := (new LongString);
	longStrC := (new LongString);
	longStrD := (new LongString);
	
	a := "[Item 1]";
	b := "[Item 2]";
	c := "[Item 3]";
	d := "[Item 4]";
	
	longStrA.setString(a);
	longStrB.setString(b);
	longStrC.setString(c);
	longStrD.setString(d);
	
	longStrA.append(longStrA, longStrB);
	longStrA.append(longStrC, longStrD);
	longStrA.append(longStrA, longStrD);
	
	out_string(longStrA.getString());
	out_string(longStrA.next().getString());
	out_string(longStrA.next().next().getString());
	out_string(longStrA.next().next().next().getString());
	
	out_string(longStrB.getString());
	out_string(longStrB.next().getString());
	out_string(longStrB.next().next().getString());
  }

}