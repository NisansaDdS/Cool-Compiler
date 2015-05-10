import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by Nisansa on 15/05/09.
 */
public class Support {

    public HashMap<String, CoolClass> classes = new HashMap<String, CoolClass>();

    public Support() {
        System.out.println("Support started....");

        CoolClass object=new CoolClass("Object",null,true);
        addClass(object);

        CoolClass io = new CoolClass("IO", object,true);
        addClass(io);

        CoolClass integer = new CoolClass("Int", object,true);
        addClass(integer);

        CoolClass string = new CoolClass("String", object,true);
        addClass(string);

        CoolClass bool = new CoolClass("Bool", object,true);
        addClass(bool);


        //Built in methods for Object (Page 13)
        CoolMethod abort = new CoolMethod("abort", object);
        CoolMethod typeName = new CoolMethod("type_name", string);
        CoolMethod copy = new CoolMethod("copy", object);  //Resolve Self_type
        object.addMethod(abort);
        object.addMethod(typeName);
        object.addMethod(copy);

        //Built in methods for IO (Page 14)
        CoolMethod outString = new CoolMethod("out_string", object); //Resolve Self_type
        outString.parametres.add(new CoolAttribute("x", string));
        CoolMethod outInt = new CoolMethod("out_int", object); //Resolve Self_type
        outInt.parametres.add(new CoolAttribute("x", integer));
        CoolMethod inString = new CoolMethod("in_string", string);
        CoolMethod inInt = new CoolMethod("in_int", integer);
        io.addMethod(outString);
        io.addMethod(outInt);
        io.addMethod(inString);
        io.addMethod(inInt);

        //Built in methods for String (Page 14)
        CoolMethod length = new CoolMethod("length", integer);
        CoolMethod concat = new CoolMethod("concat", string);
        concat.parametres.add(new CoolAttribute("s", string));
        CoolMethod substr = new CoolMethod("substr", string);
        substr.parametres.add(new CoolAttribute("i", integer));
        substr.parametres.add(new CoolAttribute("l", integer));
        string.addMethod(length);
        string.addMethod(concat);
        string.addMethod(substr);

        System.out.println("Support ready....");

    }

    public void addClass(CoolClass c)  {
        if (classes.containsKey(c.name)) {
            System.out.println("Class '"+c.name+"' is already defined");

        }
        else {
            classes.put(c.name, c);
        }
    }




    public static class CoolClass {
        public String name;
        public CoolClass parent;
        public ASTnode node;
        public boolean basic=false;
        public HashMap<String, CoolAttribute> attributes = new HashMap<String, CoolAttribute>();
        public HashMap<String, CoolMethod> methodList = new HashMap<String, CoolMethod>();

        public CoolClass(String name, CoolClass parent, boolean basic) {
            this.name = name;
            this.parent = parent;
            this.basic = basic;
        }

        public CoolClass(String name, CoolClass parent) {
            this(name,  parent, false);
        }

        public CoolClass(String name) {
            this(name,null);
        }

        public void addMethod(CoolMethod m){
            if(methodList.containsKey(m.name)){
                System.out.println("Class '"+name+"' already has a method named '"+m.name+"' defined");
            }
            else {
                //Now climb up the tree to see if it is in a parent

                m.setParent(this);
                methodList.put(m.name,m);
            }
        }
    }

    public static class CoolAttribute {
        public String name;
        public CoolClass type;
        private ASTnode node;
        private CoolClass parent;

        public CoolAttribute(String name, CoolClass type) {
            this.name = name;
            this.type = type;
        }

        public ASTnode getNode() {
            return node;
        }

        public void setNode(ASTnode node) {
            this.node = node;
        }

        public CoolClass getParent() {
            return parent;
        }

        public void setParent(CoolClass parent) {
            this.parent = parent;
        }

        public String toString(){
            return type.name+" "+name;
        }
    }

    public static class CoolMethod {
        public String name;
        public CoolClass type;
        public ArrayList<CoolAttribute> parametres = new ArrayList<CoolAttribute>();
        private ASTnode node;
        private CoolClass parent;

        public CoolMethod(String name, CoolClass type) {
            this.name = name;
            this.type = type;
        }

        public ASTnode getNode() {
            return node;
        }

        public void setNode(ASTnode node) {
            this.node = node;
        }

        public CoolClass getParent() {
            return parent;
        }

        public void setParent(CoolClass parent) {
            this.parent = parent;
        }

        public String toString(){
            return type.name+" "+name;
        }
    }
}
