public class Converter {
public static String getName(int id){
switch (id) {
case 23: return("INHERITS");
case 43: return("STRINGLIT");
case 39: return("POOL");
case 33: return("CASE");
case 10: return("LPAREN");
case 4: return("SEMI");
case 16: return("MINUS");
case 11: return("RPAREN");
case 20: return("NOT");
case 45: return("TYPEID");
case 42: return("INTLIT");
case 18: return("LT");
case 32: return("IN");
case 7: return("COMMA");
case 22: return("CLASS");
case 27: return("FI");
case 14: return("DIV");
case 38: return("LOOP");
case 15: return("PLUS");
case 6: return("ASSIGN");
case 24: return("IF");
case 44: return("ID");
case 8: return("DOT");
case 34: return("OF");
case 0: return("EOF");
case 30: return("OD");
case 40: return("TRUE");
case 36: return("NEW");
case 1: return("error");
case 37: return("ISVOID");
case 19: return("EQ");
case 13: return("TIMES");
case 5: return("COLON");
case 12: return("NEG");
case 2: return("LBRACE");
case 26: return("ELSE");
case 28: return("WHILE");
case 35: return("ESAC");
case 31: return("LET");
case 25: return("THEN");
case 3: return("RBRACE");
case 17: return("LEQ");
case 21: return("RIGHTARROW");
case 9: return("AT");
case 41: return("FALSE");
case 29: return("DO");
case 501: return("LIST");
case 502: return("METHOD_BLOCK");
case 503: return("ID_TYPE");
case 504: return("ITEMS");
case 505: return("ATTRIBUTE");
case 506: return("INVOKE");
default: return("");
}
}
}
